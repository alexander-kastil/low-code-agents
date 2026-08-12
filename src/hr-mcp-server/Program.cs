using HRMCPServer.Data;
using HRMCPServer.Services;
using Microsoft.EntityFrameworkCore;
using ModelContextProtocol.Server;

var builder = WebApplication.CreateBuilder(args);

var connectionString = SqliteDatabase.ResolveConnectionString(
    builder.Configuration.GetConnectionString("EmployeeDatabase")!,
    builder.Environment.ContentRootPath);

builder.Services.AddDbContext<EmployeeDbContext>(options => options.UseSqlite(connectionString));

builder.Services.AddScoped<IEmployeeService, EmployeeService>();

builder.Services.AddMcpServer()
    .WithHttpTransport(options => options.Stateless = true)
    .WithToolsFromAssembly();

var app = builder.Build();

await EmployeeDbInitializer.InitializeAsync(app.Services);

app.MapMcp();

app.Run();
