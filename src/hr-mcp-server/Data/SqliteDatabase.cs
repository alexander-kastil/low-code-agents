using Microsoft.Data.Sqlite;

namespace HRMCPServer.Data;

public static class SqliteDatabase
{
    public static string ResolveConnectionString(string connectionString, string contentRootPath)
    {
        var builder = new SqliteConnectionStringBuilder(connectionString);
        var directory = ResolveDirectory(contentRootPath);
        Directory.CreateDirectory(directory);
        builder.DataSource = Path.Combine(directory, Path.GetFileName(builder.DataSource));
        return builder.ConnectionString;
    }

    private static string ResolveDirectory(string contentRootPath)
    {
        var home = Environment.GetEnvironmentVariable("HOME");
        var runsOnAppService = Environment.GetEnvironmentVariable("WEBSITE_INSTANCE_ID") is not null;

        return runsOnAppService && !string.IsNullOrWhiteSpace(home)
            ? Path.Combine(home, "data")
            : Path.Combine(contentRootPath, "App_Data");
    }
}