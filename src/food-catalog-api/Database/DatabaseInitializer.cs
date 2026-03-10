using Microsoft.EntityFrameworkCore;

namespace FoodApi
{
    public static class DatabaseInitializer
    {
        public static void EnsureSchema(FoodDBContext ctx)
        {
            const string createTableSql = @"
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Food]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Food](
        [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Name] [nvarchar](200) NOT NULL,
        [Price] [decimal](18,2) NOT NULL,
        [InStock] [int] NOT NULL,
        [MinStock] [int] NOT NULL,
        [PictureUrl] [nvarchar](500) NULL,
        [Description] [nvarchar](1000) NULL
    );
END
";

            ctx.Database.ExecuteSqlRaw(createTableSql);
        }
    }
}