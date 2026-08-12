using Microsoft.EntityFrameworkCore;

namespace FoodApi
{
    public static class DatabaseInitializer
    {
        public static void EnsureSchema(FoodDBContext ctx)
        {
            ctx.Database.EnsureCreated();
        }
    }
}