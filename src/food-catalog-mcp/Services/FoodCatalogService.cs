using System.Collections.Generic;
using System.Threading.Tasks;
using FoodApi;
using FoodApp.Data;
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

    public class FoodCatalogService(IFoodRepository repository, ILogger<FoodCatalogService> logger) : IFoodCatalogService
    {
        public async Task<List<FoodItem>> GetAllFoodItemsAsync()
        {
            logger.LogInformation("GetAllFoodItems called");
            return await repository.GetAllAsync();
        }

        public async Task<List<FoodItem>> GetFoodItemsByNameAsync(string name)
        {
            logger.LogInformation("GetFoodItemsByName called with name={Name}", name);
            return await repository.GetByNameAsync(name);
        }

        public async Task<FoodItem?> GetFoodItemByIdAsync(int id)
        {
            logger.LogInformation("GetFoodItemById called with id={Id}", id);
            return await repository.GetByIdAsync(id);
        }

        public async Task<FoodItem> AddFoodItemAsync(FoodItem item)
        {
            await repository.AddAsync(item);
            logger.LogInformation("AddFoodItem added id={Id}", item.ID);
            return item;
        }

        public async Task<bool> UpdateFoodItemAsync(FoodItem item)
        {
            await repository.UpdateAsync(item);
            logger.LogInformation("UpdateFoodItem updated id={Id}", item.ID);
            return true;
        }

        public async Task<bool> DeleteFoodItemAsync(int id)
        {
            var item = await repository.GetByIdAsync(id);
            if (item == null)
                return false;

            await repository.DeleteAsync(item);
            logger.LogInformation("DeleteFoodItem deleted id={Id}", id);
            return true;
        }

        public async Task<bool> UpdateFoodItemStockAsync(int id, int amount)
        {
            var item = await repository.GetByIdAsync(id);
            if (item == null)
                return false;

            item.InStock += amount;
            await repository.SaveChangesAsync();
            logger.LogInformation("UpdateFoodItemStock id={Id} newStock={Stock}", id, item.InStock);
            return true;
        }
    }

#nullable restore
}