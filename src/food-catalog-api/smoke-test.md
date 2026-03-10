# Food Catalog API Smoke Test

## Run the API locally

```powershell
dotnet run
```

The API will start on `http://localhost:5000` by default.

## Smoke Test

Verify the Food Catalog API deployment is operational in both local and Azure environments.

### Prerequisites

- **Local**: API running on `http://localhost:5000`
- **Azure**: Deployed to `https://food-catalog-api-pl7008.azurewebsites.net`

### Test Procedure

#### 1. Verify API Health

First, confirm the API is accessible:

**Local:**

```powershell
curl http://localhost:5000/food
```

**Azure:**

```powershell
curl https://food-catalog-api-pl7008.azurewebsites.net/food
```

Expected: HTTP 200 response with JSON array of food items.

#### 2. Validate Core Endpoints

Confirm all **5 core CRUD endpoints** are accessible:

- **GET /food** – Retrieves all food items (should return seeded data)
- **GET /food/{id}** – Retrieves a single food item by ID
- **GET /food/byname?name={name}** – Searches food items by name
- **POST /food** – Creates a new food item
- **PUT /food** – Updates an existing food item
- **DELETE /food/{id}** – Deletes a food item

#### 3. Test GET /food (List All Items)

**Request:**

```powershell
curl http://localhost:5000/food
# OR for Azure:
curl https://food-catalog-api-pl7008.azurewebsites.net/food
```

**Expected Response:**

- Status: `200 OK`
- Content-Type: `application/json`
- Body: JSON array with seeded food items
- Each item should have:
  - `id` (integer)
  - `name` (string)
  - `price` (decimal)
  - `inStock` (integer)
  - `pictureUrl` (string URL)
  - `description` (string)

**Example Response:**

```json
[
  {
    "id": 1,
    "name": "Butter Chicken",
    "price": 12.5,
    "inStock": 10,
    "pictureUrl": "https://storagepl7008.blob.core.windows.net/food/butter-chicken.jpg",
    "description": "Creamy tomato-based curry with tender chicken pieces"
  },
  {
    "id": 2,
    "name": "Pad Thai",
    "price": 10.0,
    "inStock": 15,
    "pictureUrl": "https://storagepl7008.blob.core.windows.net/food/pad-thai.jpg",
    "description": "Classic Thai stir-fried noodles with peanuts and lime"
  }
]
```

#### 4. Test GET /food/{id} (Get Single Item)

**Request:**

```powershell
curl http://localhost:5000/food/1
```

**Expected Response:**

- Status: `200 OK`
- Body: Single `FoodItem` JSON object with ID=1

#### 5. Test GET /food/byname (Search by Name)

**Request:**

```powershell
curl "http://localhost:5000/food/byname?name=Butter"
```

**Expected Response:**

- Status: `200 OK`
- Body: Array of items containing "Butter" in their name

**Invalid Request (missing name):**

```powershell
curl "http://localhost:5000/food/byname"
```

**Expected Response:**

- Status: `400 Bad Request`
- Message: "Name parameter is required."

#### 6. Test POST /food (Create New Item)

**Request:**

```powershell
curl -X POST http://localhost:5000/food `
  -H "Content-Type: application/json" `
  -d '{
    "name": "Test Dish",
    "price": 9.99,
    "inStock": 5,
    "pictureUrl": "https://example.com/test.jpg",
    "description": "A test menu item"
  }'
```

**Expected Response:**

- Status: `200 OK`
- Body: Created `FoodItem` with auto-generated `id`

#### 7. Verify Data Persistence

After creating an item in step 6, retrieve all items again:

```powershell
curl http://localhost:5000/food
```

**Expected:** The newly created "Test Dish" should appear in the list.

#### 8. Verify Azure-Specific Features (Azure deployment only)

**Application Insights Integration:**

- Check that `APPLICATIONINSIGHTS_CONNECTION_STRING` is configured
- Verify telemetry is being sent (check Azure portal)

**Database Connection:**

- Confirm `ConnectionStrings:DefaultDatabase` is set
- Verify data persists across restarts

**CORS Configuration:**

- Confirm wildcard CORS is enabled for frontend access

### Health Check Criteria

✅ **Deployment is healthy if:**

1. All 5 core endpoints are accessible
2. `GET /food` returns seeded data with proper JSON structure
3. `GET /food/1` returns a single valid item
4. `GET /food/byname?name=X` filters correctly
5. `POST /food` creates new items successfully
6. Data structure matches expected schema (id, name, price, inStock, pictureUrl, description)

❌ **Deployment has issues if:**

- Any endpoint returns 500 Internal Server Error
- `GET /food` returns empty array (database seeding failed)
- Response JSON schema doesn't match expected structure
- CORS errors when accessing from different origin
- Azure deployment returns 503 Service Unavailable

### Automated Testing (for SmokeTester Agent)

The SmokeTester agent can execute this smoke test automatically using:

1. **REST API calls** via `curl` or PowerShell's `Invoke-RestMethod`
2. **JSON validation** to verify response structure
3. **Status code checking** to confirm endpoint health
4. **Data integrity validation** to ensure seeded data exists

**Example automated test script:**

```powershell
# Set base URL based on environment
$baseUrl = "http://localhost:5000"  # or Azure URL

# Test 1: Get all items
$response = Invoke-RestMethod -Uri "$baseUrl/food" -Method Get
if ($response.Count -eq 0) {
  Write-Error "FAIL: No food items returned (seeding may have failed)"
  exit 1
}
Write-Host "✓ GET /food returned $($response.Count) items"

# Test 2: Validate schema
$firstItem = $response[0]
$requiredFields = @('id', 'name', 'price', 'inStock', 'pictureUrl', 'description')
foreach ($field in $requiredFields) {
  if ($null -eq $firstItem.$field) {
    Write-Error "FAIL: Missing required field '$field'"
    exit 1
  }
}
Write-Host "✓ Response schema is valid"

# Test 3: Get single item
$singleItem = Invoke-RestMethod -Uri "$baseUrl/food/1" -Method Get
if ($singleItem.id -ne 1) {
  Write-Error "FAIL: GET /food/1 returned incorrect item"
  exit 1
}
Write-Host "✓ GET /food/1 returned correct item"

# Test 4: Search by name
$searchResults = Invoke-RestMethod -Uri "$baseUrl/food/byname?name=Butter" -Method Get
if ($searchResults.Count -eq 0) {
  Write-Warning "WARNING: Search returned no results for 'Butter'"
}
Write-Host "✓ GET /food/byname search completed"

Write-Host "`n✅ All smoke tests passed - Food Catalog API is healthy"
```

### Troubleshooting

**No items returned:**

- Check database connection string
- Verify `FoodSeeder` ran during startup
- Check logs for Entity Framework errors

**CORS errors:**

- Run: `az webapp cors show -n food-catalog-api-pl7008 -g rg-pl7008`
- Should include wildcard `*` in allowed origins

**500 errors:**

- Check Application Insights logs
- Review Azure App Service logs: `az webapp log tail -n food-catalog-api-pl7008 -g rg-pl7008`

**Connection timeout:**

- Verify App Service is running: `az webapp show -n food-catalog-api-pl7008 -g rg-pl7008 --query state`
- Restart if needed: `az webapp restart -n food-catalog-api-pl7008 -g rg-pl7008`
