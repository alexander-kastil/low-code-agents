#nullable enable
using System.Collections.Generic;
using System.ComponentModel;
using System.Threading.Tasks;
using FoodApi;
using FoodApp.Services;
using Microsoft.Extensions.Logging;
using ModelContextProtocol.Server;

namespace FoodCatalogMcp
{
    [McpServerToolType]
    internal class FoodCatalogTools
    {
        private readonly IFoodCatalogService _foodService;
        private readonly ILogger<FoodCatalogTools> _logger;

        public FoodCatalogTools(IFoodCatalogService foodService, ILogger<FoodCatalogTools> logger)
        {
            _foodService = foodService;
            _logger = logger;
        }

        [McpServerTool]
        [Description("Returns the full list of food items in the catalog")]
        public async Task<List<FoodItem>> GetAllFoodItems()
        {
            return await _foodService.GetAllFoodItemsAsync();
        }

        [McpServerTool]
        [Description("Searches food items by name (partial match)")]
        public async Task<List<FoodItem>> GetFoodItemsByName(
            [Description("Name or partial name to search for")] string name)
        {
            return await _foodService.GetFoodItemsByNameAsync(name);
        }

        [McpServerTool]
        [Description("Returns a single food item by its numeric ID")]
        public async Task<FoodItem?> GetFoodItemById(
            [Description("The numeric ID of the food item")] int id)
        {
            return await _foodService.GetFoodItemByIdAsync(id);
        }

        [McpServerTool]
        [Description("Adds a new food item to the catalog")]
        public async Task<FoodItem> AddFoodItem(
            [Description("Name of the food item")] string name,
            [Description("Price of the food item")] decimal price,
            [Description("Current stock quantity")] int inStock,
            [Description("Minimum stock threshold")] int minStock,
            [Description("URL of the food item picture")] string pictureUrl,
            [Description("Short description of the food item")] string description)
        {
            var item = new FoodItem
            {
                Name = name,
                Price = price,
                InStock = inStock,
                MinStock = minStock,
                PictureUrl = pictureUrl,
                Description = description
            };
            return await _foodService.AddFoodItemAsync(item);
        }

        [McpServerTool]
        [Description("Updates an existing food item. Only supplied fields are changed.")]
        public async Task<string> UpdateFoodItem(
            [Description("ID of the food item to update")] int id,
            [Description("New name (optional)")] string? name = null,
            [Description("New price (optional)")] decimal? price = null,
            [Description("New stock quantity (optional)")] int? inStock = null,
            [Description("New minimum stock threshold (optional)")] int? minStock = null,
            [Description("New picture URL (optional)")] string? pictureUrl = null,
            [Description("New description (optional)")] string? description = null)
        {
            var item = await _foodService.GetFoodItemByIdAsync(id);
            if (item == null)
                return $"Food item with ID {id} was not found.";

            if (name != null) item.Name = name;
            if (price.HasValue) item.Price = price.Value;
            if (inStock.HasValue) item.InStock = inStock.Value;
            if (minStock.HasValue) item.MinStock = minStock.Value;
            if (pictureUrl != null) item.PictureUrl = pictureUrl;
            if (description != null) item.Description = description;

            await _foodService.UpdateFoodItemAsync(item);
            return $"Food item '{item.Name}' (ID {id}) updated successfully.";
        }

        [McpServerTool]
        [Description("Deletes a food item from the catalog by ID")]
        public async Task<string> DeleteFoodItem(
            [Description("ID of the food item to delete")] int id)
        {
            var item = await _foodService.GetFoodItemByIdAsync(id);
            if (item == null)
                return $"Food item with ID {id} was not found.";

            await _foodService.DeleteFoodItemAsync(id);
            return $"Food item '{item.Name}' (ID {id}) deleted successfully.";
        }

        [McpServerTool]
        [Description("Adjusts the stock level of a food item by a positive or negative amount")]
        public async Task<string> UpdateFoodItemStock(
            [Description("ID of the food item")] int id,
            [Description("Amount to add (positive) or subtract (negative) from current stock")] int amount)
        {
            var item = await _foodService.GetFoodItemByIdAsync(id);
            if (item == null)
                return $"Food item with ID {id} was not found.";

            await _foodService.UpdateFoodItemStockAsync(id, amount);
            return $"Stock for '{item.Name}' (ID {id}) updated to {item.InStock + amount}.";
        }
    }
}
