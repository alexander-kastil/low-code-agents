using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FoodApi;
using Microsoft.EntityFrameworkCore;

namespace FoodApp.Data
{
#nullable enable

    public interface IFoodRepository
    {
        Task<List<FoodItem>> GetAllAsync();
        Task<List<FoodItem>> GetByNameAsync(string name);
        Task<FoodItem?> GetByIdAsync(int id);
        Task<FoodItem> AddAsync(FoodItem item);
        Task UpdateAsync(FoodItem item);
        Task DeleteAsync(FoodItem item);
        Task SaveChangesAsync();
    }

    public class FoodRepository(FoodDBContext db) : IFoodRepository
    {
        public async Task<List<FoodItem>> GetAllAsync()
        {
            return await db.Food.ToListAsync();
        }

        public async Task<List<FoodItem>> GetByNameAsync(string name)
        {
            return await db.Food
                .Where(f => f.Name.Contains(name))
                .ToListAsync();
        }

        public async Task<FoodItem?> GetByIdAsync(int id)
        {
            return await db.Food.FirstOrDefaultAsync(f => f.ID == id);
        }

        public async Task<FoodItem> AddAsync(FoodItem item)
        {
            db.Food.Add(item);
            await db.SaveChangesAsync();
            return item;
        }

        public async Task UpdateAsync(FoodItem item)
        {
            db.Food.Attach(item);
            db.Entry(item).State = EntityState.Modified;
            await db.SaveChangesAsync();
        }

        public async Task DeleteAsync(FoodItem item)
        {
            db.Food.Remove(item);
            await db.SaveChangesAsync();
        }

        public async Task SaveChangesAsync()
        {
            await db.SaveChangesAsync();
        }
    }

#nullable restore
}