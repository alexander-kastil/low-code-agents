using System;
using FoodApi;
using FoodApp;
using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
IConfiguration Configuration = builder.Configuration;
builder.Services.AddSingleton<IConfiguration>(Configuration);
var cfg = Configuration.Get<FoodConfig>();

//Database
var connectionString = cfg.ConnectionStrings?.DefaultDatabase;

if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException("Connection string 'DefaultDatabase' is not configured.");
}

builder.Services.AddDbContext<FoodDBContext>(options => options.UseSqlServer(connectionString));
builder.Services.AddControllers();

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Food-Inventory", Version = "v1" });
});

// Cors
builder.Services.AddCors(o => o.AddPolicy("NoCORS", builder =>
{
    builder
        .SetIsOriginAllowed(host => true)
        .AllowAnyMethod()
        .AllowAnyHeader()
        .AllowCredentials();
}));

var app = builder.Build();

// Ensure database exists and seed baseline data on startup.
using (var scope = app.Services.CreateScope())
{
    var logger = scope.ServiceProvider.GetRequiredService<ILoggerFactory>().CreateLogger("Startup");
    try
    {
        var db = scope.ServiceProvider.GetRequiredService<FoodDBContext>();
        // Use raw SQL to create the Food table if missing (works even when migrations are absent).
        DatabaseInitializer.EnsureSchema(db);
        FoodSeeder.SeedIfEmpty(db, cfg.App?.ImgBaseUrl ?? string.Empty);
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Failed to ensure database and seed data.");
    }
}

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

// Swagger
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", cfg.App.Title);
    c.RoutePrefix = string.Empty;
});

//Cors and Routing
app.UseCors("NoCORS");

app.MapControllers();
app.Run();