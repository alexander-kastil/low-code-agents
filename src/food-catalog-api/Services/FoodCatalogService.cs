using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using FoodApi;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace FoodApp.Services
{
#nullable enable

    public interface IFoodCatalogService
    {
        Task<List<FoodItem>> GetAllFoodItemsAsync();
        Task<List<FoodItem>> GetFoodItemsByNameAsync(string name);
        Task<FoodItem?> GetFoodItemByIdAsync(int id);
        Task<FoodItem> AddFoodItemAsync(FoodItem item);
        Task<bool> UpdateFoodItemAsync(FoodItem item);
        Task<bool> DeleteFoodItemAsync(int id);
        Task<bool> UpdateFoodItemStockAsync(int id, int amount);
    }

    public class FoodCatalogService : IFoodCatalogService
    {
        private readonly FoodDBContext _db;
        private readonly ILogger<FoodCatalogService> _logger;

        public FoodCatalogService(FoodDBContext db, ILogger<FoodCatalogService> logger)
        {
            _db = db;
            _logger = logger;
        }

        public async Task<List<FoodItem>> GetAllFoodItemsAsync()
        {
            _logger.LogInformation("GetAllFoodItems called");
            return await _db.Food.ToListAsync();
        }

        public async Task<List<FoodItem>> GetFoodItemsByNameAsync(string name)
        {
            _logger.LogInformation("GetFoodItemsByName called with name={Name}", name);
            return await _db.Food
                .Where(f => f.Name.Contains(name))
                .ToListAsync();
        }

        public async Task<FoodItem?> GetFoodItemByIdAsync(int id)
        {
            _logger.LogInformation("GetFoodItemById called with id={Id}", id);
            return await _db.Food.FirstOrDefaultAsync(f => f.ID == id);
        }

        public async Task<FoodItem> AddFoodItemAsync(FoodItem item)
        {
            _db.Food.Add(item);
            await _db.SaveChangesAsync();
            _logger.LogInformation("AddFoodItem added id={Id}", item.ID);
            return item;
        }

        public async Task<bool> UpdateFoodItemAsync(FoodItem item)
        {
            _db.Food.Attach(item);
            _db.Entry(item).State = EntityState.Modified;
            await _db.SaveChangesAsync();
            _logger.LogInformation("UpdateFoodItem updated id={Id}", item.ID);
            return true;
        }

        public async Task<bool> DeleteFoodItemAsync(int id)
        {
            var item = await _db.Food.FirstOrDefaultAsync(f => f.ID == id);
            if (item == null)
                return false;

            _db.Food.Remove(item);
            await _db.SaveChangesAsync();
            _logger.LogInformation("DeleteFoodItem deleted id={Id}", id);
            return true;
        }

        public async Task<bool> UpdateFoodItemStockAsync(int id, int amount)
        {
            var item = await _db.Food.FirstOrDefaultAsync(f => f.ID == id);
            if (item == null)
                return false;

            item.InStock += amount;
            await _db.SaveChangesAsync();
            _logger.LogInformation("UpdateFoodItemStock id={Id} newStock={Stock}", id, item.InStock);
            return true;
        }
    }

#nullable restore
}
