using System.Text.Json;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace PartsInventoryConnector.Data;

public class ApplianceDbContext : DbContext
{
    public DbSet<AppliancePart> Parts => Set<AppliancePart>();

    public void EnsureDatabase()
    {
        if (Database.EnsureCreated() || !Parts.Any())
        {

            var parts = CsvDataLoader.LoadPartsFromCsv("ApplianceParts.csv");
            Parts.AddRange(parts);
            SaveChanges();
        }
    }

    protected override void OnConfiguring(DbContextOptionsBuilder options)
    {
        options.UseSqlite("Data Source=parts.db");
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {

        modelBuilder.Entity<AppliancePart>()
            .Property(ap => ap.Appliances)
            .HasConversion(
                v => JsonSerializer.Serialize(v, JsonSerializerOptions.Default),
                v => JsonSerializer.Deserialize<List<string>>(v, JsonSerializerOptions.Default)
            );

        modelBuilder.Entity<AppliancePart>()
            .Property<DateTime>("LastUpdated")
            .HasDefaultValueSql("datetime()")
            .ValueGeneratedOnAddOrUpdate();
        modelBuilder.Entity<AppliancePart>()
            .Property<bool>("IsDeleted")
            .IsRequired()
            .HasDefaultValue(false);

        modelBuilder.Entity<AppliancePart>()
            .HasQueryFilter(a => !EF.Property<bool>(a, "IsDeleted"));
    }

    public override int SaveChanges()
    {

        foreach(var entry in ChangeTracker.Entries()
            .Where(e => e.State == EntityState.Deleted))
        {
            if (entry.Entity.GetType() == typeof(AppliancePart))
            {
                SoftDelete(entry);
            }

        }

        return base.SaveChanges();
    }

    private void SoftDelete(EntityEntry entry)
    {
        var partNumber = new SqliteParameter("@partNumber",
            entry.OriginalValues["PartNumber"]);

        Database.ExecuteSqlRaw(
            "UPDATE Parts SET IsDeleted = 1 WHERE PartNumber = @partNumber",
            partNumber);

        entry.State = EntityState.Detached;
    }
}
