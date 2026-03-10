using System.Collections.Generic;
using System.Threading.Tasks;
using FoodApp;
using FoodApp.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace FoodApi
{
#nullable enable
    [Route("[controller]")]
    [ApiController]
    public class FoodController : ControllerBase
    {
        private readonly IFoodCatalogService _foodService;
        private readonly FoodConfig _cfg;

        public FoodController(IFoodCatalogService foodService, IConfiguration config)
        {
            _foodService = foodService;
            _cfg = config.Get<FoodConfig>();
        }

        [HttpGet()]
        public async Task<IEnumerable<FoodItem>> GetFood()
        {
            return await _foodService.GetAllFoodItemsAsync();
        }

        [HttpGet("byname")]
        public async Task<ActionResult<IEnumerable<FoodItem>>> GetFoodByName([FromQuery] string name)
        {
            if (string.IsNullOrWhiteSpace(name))
                return BadRequest("Name parameter is required.");
            var items = await _foodService.GetFoodItemsByNameAsync(name);
            if (items.Count == 0)
                return NotFound();
            return Ok(items);
        }

        [HttpGet("{id}")]
        public async Task<FoodItem?> GetById(int id)
        {
            return await _foodService.GetFoodItemByIdAsync(id);
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
            return await _foodService.AddFoodItemAsync(foodItem);
        }

        [HttpPut()]
        public async Task<FoodItem> UpdateFood(FoodItem item)
        {
            await _foodService.UpdateFoodItemAsync(item);
            return item;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            await _foodService.DeleteFoodItemAsync(id);
            return Ok();
        }

        [HttpPatch("{id}/update-stock")]
        public async Task<ActionResult<FoodItem>> UpdateInStock(int id, [FromQuery] int amount)
        {
            var item = await _foodService.GetFoodItemByIdAsync(id);
            if (item == null)
                return NotFound();
            await _foodService.UpdateFoodItemStockAsync(id, amount);
            return Ok(item);
        }
    }
#nullable restore
}