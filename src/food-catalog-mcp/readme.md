# Food Catalog API

## Why this project exists

The Food Catalog API is a .NET 10 minimal Web API that exposes CRUD endpoints for curated menu items. It demonstrates how to combine Entity Framework Core with Azure integrations such as Application Insights, Event Grid, Key Vault, and Microsoft Entra ID (via `Microsoft.Identity.Web`). The service ships with seeded data, a Scalar API reference UI for self-service exploration, and feature flags to toggle optional integrations.

## Architecture at a glance

- **Entry point (`Program.cs`)** – wires up configuration binding (`FoodConfig`), dependency injection, the Entity Framework Core SQLite provider, OpenAPI document generation, the Scalar API reference UI, CORS, authentication/authorization, and optional Application Insights telemetry.
- **Database location (`Database/SqliteDatabase.cs`)** – resolves the `Data Source` file name from `ConnectionStrings:DefaultDatabase` into a writable folder: `App_Data/` next to the app locally, `/home/data/` on Azure App Service so the file survives restarts and redeployments.
- **Controllers**
  - `FoodController` – RESTful CRUD endpoints for `FoodItem` entities. Publishes placeholder events when `FeatureManagement.PublishEvents` is enabled.
  - `ConfigController` – diagnostic endpoints that expose the bound configuration and environment variables (development use only).
- **Data access (`Database/FoodDBContext.cs`)** – EF Core `DbContext` that ensures the database exists, configures decimal precision, and seeds demo menu items.
- **Repository (`Data/FoodRepository.cs`)** – `IFoodRepository` is the only type that touches EF Core: queries, tracking and `SaveChanges`.
- **Service (`Services/FoodCatalogService.cs`)** – `IFoodCatalogService` sits on the repository and owns the logic and logging. Both `FoodController` and the MCP `FoodCatalogTools` consume this one service, so the REST API and the MCP tools share the same behaviour.
- **Models (`Model/FoodItem.cs`, `Shared/Delivery.cs`)** – domain objects and helper classes.
- **Azure integrations (`AppInsights/*`, `EventGrid/*`)** – helpers for telemetry and Event Grid publishing driven by feature flags.
- **Configuration (`Config/FoodConfig.cs`, `appsettings*.json`)** – strongly typed options record Azure settings, feature toggles, logging, and connection strings.

## API surface

| Method   | Route               | Description                                                                |
| -------- | ------------------- | -------------------------------------------------------------------------- |
| `GET`    | `/food`             | Returns all food items. Requires `access_as_user` scope when auth enabled. |
| `GET`    | `/food/{id}`        | Returns a single item by identifier.                                       |
| `POST`   | `/food`             | Inserts a new item (expects `FoodItem` in body).                           |
| `PUT`    | `/food`             | Updates an existing item. Ensure `ID` is set.                              |
| `DELETE` | `/food/{id}`        | Removes an item.                                                           |
| `GET`    | `/config`           | Returns the bound configuration (development diagnostics).                 |
| `GET`    | `/config/getAllEnv` | Dumps environment variables (development diagnostics).                     |

All endpoints are attributed with `[ApiController]` conventions for automatic model validation.

## API documentation

`Microsoft.AspNetCore.OpenApi` generates the OpenAPI document and `Scalar.AspNetCore` renders it.

| Route              | Purpose                                                              |
| ------------------ | -------------------------------------------------------------------- |
| `/`                | The Scalar API reference UI, with a built-in request client.         |
| `/openapi/v1.json` | The generated OpenAPI 3.0 document.                                  |

Power Platform custom connectors require Swagger 2.0, so the document at `/openapi/v1.json` cannot be imported directly. Use the prepared Swagger 2.0 equivalent at [`src/assets/food-api-swagger.json`](../assets/food-api-swagger.json).

## Food Catalog MCP Smoke Test

### Run the server

```powershell
dotnet run --launch-profile catalog_api
```

### Connect with MCP Inspector

1. Start the server (see above).
2. Launch the inspector with the provided config:

```powershell
npx @modelcontextprotocol/inspector --config inspector.config.json --server food-catalog-mcp
```

The config at `inspector.config.json` tells the inspector to use the Food Catalog MCP server's Streamable HTTP URL `http://localhost:5000/api/mcp`, matching the endpoint that `app.MapMcp("/api/mcp")` exposes. This satisfies the newer CLI requirement that `--server` reference an entry in a config file.

#### Remote (Azure) deployment

```powershell
npx @modelcontextprotocol/inspector --config inspector.config.json --server food-catalog-mcp-azure-dev
```

This reuses the same inspector config but selects the `food-catalog-mcp-azure-dev` entry, which points at `https://food-catalog-api.azurewebsites.net/api/mcp`. Make sure the Azure app is running and reachable before launching the inspector.

## Authentication and authorization

- Toggle `App.AuthEnabled` to `true` to enforce Microsoft Entra ID authentication.
- `Program.cs` wires `AddMicrosoftIdentityWebApi` and applies a global authorization policy requiring authenticated users.
- `FoodController` checks the `access_as_user` scope via `HttpContext.VerifyUserHasAnyAcceptedScope`.
- When disabled, the API runs anonymously—intended for local debugging only.

## Observability & integrations

- **Application Insights** – If `UseApplicationInsights` is enabled and a connection string is present, telemetry is forwarded with a custom role name (`net-food-api`). `AILogger` simplifies custom event emission.
- **Azure Key Vault** – When `UseKeyVaultWithMI` is `true`, the app requests the `DefaultDatabase` secret via `DefaultAzureCredential`. Requires managed identity access to the vault.
- **Azure Event Grid** – `EventGridPublisher` assembles `CloudEvent<FoodItem>` payloads and posts them to the configured Event Grid topic. The sample controller currently writes to console; integrate the publisher and error handling as needed.
- **Health checks** – The flag exists but no endpoints are registered yet. Consider adding `builder.Services.AddHealthChecks()` and `app.MapHealthChecks()`.
