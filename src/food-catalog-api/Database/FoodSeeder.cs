using System.Collections.Generic;
using System.Linq;

namespace FoodApi
{
    public static class FoodSeeder
    {
        public static void SeedIfEmpty(FoodDBContext ctx, string imgBaseUrl)
        {
            if (ctx.Food.Any())
            {
                return;
            }

            var list = new List<FoodItem>
            {
                new FoodItem
                {
                    Name = "Wiener Schnitzel",
                    InStock = 30,
                    MinStock = 6,
                    Price = 18m,
                    Description = "A paper-thin veal cutlet, breaded and fried until golden; served with lemon.",
                    PictureUrl = imgBaseUrl + "wiener-schnitzel.jpg"
                },
                new FoodItem
                {
                    Name = "Germknoedel",
                    InStock = 26,
                    MinStock = 6,
                    Price = 7m,
                    Description = "A steamed yeast dumpling filled with sweet plum jam, served with melted butter and poppy seeds.",
                    PictureUrl = imgBaseUrl + "germknoedel.jpg"
                },
                new FoodItem
                {
                    Name = "Kaiserschmarrn",
                    InStock = 22,
                    MinStock = 5,
                    Price = 9m,
                    Description = "Fluffy shredded pancake, caramelized and served with fruit compote — a classic Austrian dessert.",
                    PictureUrl = imgBaseUrl + "blind-image.jpg"
                },
                new FoodItem
                {
                    Name = "Weißwurst mit Brezn",
                    InStock = 20,
                    MinStock = 5,
                    Price = 10m,
                    Description = "Bavarian white sausages with pretzel and sweet mustard — a regional breakfast favorite.",
                    PictureUrl = imgBaseUrl + "blind-image.jpg"
                },
                new FoodItem
                {
                    Name = "Schweinshaxe mit Kraut",
                    InStock = 12,
                    MinStock = 3,
                    Price = 19m,
                    Description = "Roasted pork knuckle with dumplings and sauerkraut — rich, crispy and traditional.",
                    PictureUrl = imgBaseUrl + "blind-image.jpg"
                },
                new FoodItem
                {
                    Name = "Pizza Napoli",
                    InStock = 28,
                    MinStock = 6,
                    Price = 9m,
                    Description = "Classic Neapolitan pizza with simple tomato, mozzarella and fresh basil.",
                    PictureUrl = imgBaseUrl + "blind-image.jpg"
                },
                new FoodItem
                {
                    Name = "Arancini Napoletana",
                    InStock = 15,
                    MinStock = 4,
                    Price = 7m,
                    Description = "Crispy fried rice balls filled with ragu, peas and mozzarella — a Sicilian snack.",
                    PictureUrl = imgBaseUrl + "blind-image.jpg"
                },
                new FoodItem
                {
                    Name = "Pad Ka Prao",
                    InStock = 18,
                    MinStock = 4,
                    Price = 10m,
                    Description = "A spicy Thai stir-fry with holy basil, garlic and chilies; often served with a fried egg.",
                    PictureUrl = imgBaseUrl + "pad-ka-prao.jpg"
                },
                new FoodItem
                {
                    Name = "Green Curry",
                    InStock = 17,
                    MinStock = 4,
                    Price = 13m,
                    Description = "Fragrant Thai green curry with fresh herbs, chilies and coconut milk.",
                    PictureUrl = imgBaseUrl + "blind-image.jpg"
                }
            };

            ctx.Food.AddRange(list);
            ctx.SaveChanges();
        }
    }
}