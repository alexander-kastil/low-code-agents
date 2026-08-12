using System;
using System.Threading.Tasks;
using FoodApi;
using FoodApp;
using FoodApp.Data;
using FoodApp.Services;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.OpenApi;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

IConfiguration Configuration = builder.Configuration;
builder.Services.AddSingleton<IConfiguration>(Configuration);
var cfg = Configuration.Get<FoodConfig>();

var connectionString = cfg.ConnectionStrings?.DefaultDatabase;

if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException("Connection string 'DefaultDatabase' is not configured.");
}

connectionString = SqliteDatabase.ResolveConnectionString(connectionString, builder.Environment.ContentRootPath);

builder.Services.AddDbContext<FoodDBContext>(options => options.UseSqlite(connectionString));
builder.Services.AddScoped<IFoodRepository, FoodRepository>();
builder.Services.AddScoped<IFoodCatalogService, FoodCatalogService>();
builder.Services.AddControllers();

builder.Services.AddMcpServer()
    .WithHttpTransport(options => options.Stateless = true)
    .WithToolsFromAssembly();

builder.Services.AddOpenApi(options =>
{
    options.OpenApiVersion = OpenApiSpecVersion.OpenApi3_0;
    options.AddDocumentTransformer((document, context, cancellationToken) =>
    {
        document.Info = new OpenApiInfo { Title = "Food-Inventory", Version = "v1" };
        return Task.CompletedTask;
    });
});

builder.Services.AddCors(o => o.AddPolicy("NoCORS", builder =>
{
    builder
        .SetIsOriginAllowed(host => true)
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials();
}));

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var logger = scope.ServiceProvider.GetRequiredService<ILoggerFactory>().CreateLogger("Startup");
    try
    {
        var db = scope.ServiceProvider.GetRequiredService<FoodDBContext>();

        DatabaseInitializer.EnsureSchema(db);
        FoodSeeder.SeedIfEmpty(db, cfg.App?.ImgBaseUrl ?? string.Empty);
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Failed to ensure database and seed data.");
    }
}

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.MapOpenApi();
app.MapScalarApiReference("/", options => options.WithTitle(cfg.App.Title));

app.UseCors("NoCORS");

app.MapControllers();

app.MapMcp("/api/mcp");

app.Run();
