using System.Collections.Generic;
using System.Threading.Tasks;
using FoodApp;
using FoodApp.Services;
using Microsoft.AspNetCore.Mvc;

namespace FoodApi
{
#nullable enable
    [Route("[controller]")]
    [ApiController]
    public class FoodController(IFoodCatalogService foodService) : ControllerBase
    {
        [HttpGet()]
        public async Task<IEnumerable<FoodItem>> GetFood()
        {
            return await foodService.GetAllFoodItemsAsync();
        }

        [HttpGet("byname")]
        public async Task<ActionResult<IEnumerable<FoodItem>>> GetFoodByName([FromQuery] string name)
        {
            if (string.IsNullOrWhiteSpace(name))
                return BadRequest("Name parameter is required.");
            var items = await foodService.GetFoodItemsByNameAsync(name);
            if (items.Count == 0)
                return NotFound();
            return Ok(items);
        }

        [HttpGet("{id}")]
        public async Task<FoodItem?> GetById(int id)
        {
            return await foodService.GetFoodItemByIdAsync(id);
        }

        [HttpPost()]
        public async Task<FoodItem> InsertFood(FoodDTO item)
        {
            var foodItem = new FoodItem
            {
                Name = item.Name,
                Price = item.Price,
                InStock = item.InStock,
                PictureUrl = item.PictureUrl,
                Description = item.Description
            };
            return await foodService.AddFoodItemAsync(foodItem);
        }

        [HttpPut()]
        public async Task<FoodItem> UpdateFood(FoodItem item)
        {
            await foodService.UpdateFoodItemAsync(item);
            return item;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await foodService.DeleteFoodItemAsync(id);
            return Ok();
        }

        [HttpPatch("{id}/update-stock")]
        public async Task<ActionResult<FoodItem>> UpdateInStock(int id, [FromQuery] int amount)
        {
            var item = await foodService.GetFoodItemByIdAsync(id);
            if (item == null)
                return NotFound();
            await foodService.UpdateFoodItemStockAsync(id, amount);
            return Ok(item);
        }
    }
#nullable restore
}