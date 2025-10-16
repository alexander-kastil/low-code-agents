# Infrastructure Architecture

This document describes the Azure infrastructure architecture deployed by the azd configuration.

## Overview

The infrastructure deploys a microservices architecture with three .NET 9.0 APIs, one Angular static web application, and supporting Azure services.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      Azure Subscription                          │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ├──────────────────────────────────┐
                              │   Resource Group                  │
                              │   rg-{environment-name}           │
                              └──────────────────────────────────┘
                                            │
              ┌─────────────────────────────┼─────────────────────────────┐
              │                             │                             │
    ┌─────────▼──────────┐       ┌─────────▼──────────┐       ┌─────────▼──────────┐
    │  Storage Account   │       │  App Service Plan  │       │  Static Web App    │
    │  m365copilot{...}  │       │  plan-{...}        │       │  food-shop-{...}   │
    │                    │       │                    │       │                    │
    │  SKU: Standard_LRS │       │  OS: Linux         │       │  SKU: Free         │
    │  Kind: StorageV2   │       │  SKU: B1 (Basic)   │       │                    │
    └────────────────────┘       └────────────────────┘       └────────────────────┘
            │                              │                             │
            │                    ┌─────────┼─────────┐                  │
            │                    │         │         │                  │
    ┌───────▼────────┐  ┌────────▼───┐ ┌──▼──────┐ ┌▼────────────┐    │
    │  Blob Service  │  │ Web App 1  │ │ Web App 2│ │ Web App 3   │    │
    │                │  │            │ │          │ │             │    │
    │ Container:     │  │ food-      │ │ hr-mcp-  │ │ purchasing- │    │
    │   - food       │  │ catalog-   │ │ server-  │ │ service-    │    │
    │                │  │ api-{...}  │ │ {...}    │ │ {...}       │    │
    └────────────────┘  └────────────┘ └──────────┘ └─────────────┘    │
                              │              │             │             │
                              │              │             │             │
                        ┌─────▼──────────────▼─────────────▼─────────────▼──┐
                        │                 Internet                           │
                        │     (HTTPS Only - Enforced on all services)        │
                        └────────────────────────────────────────────────────┘
```

## Resource Breakdown

### Resource Group
- **Name Pattern**: `rg-{environmentName}`
- **Purpose**: Logical container for all resources
- **Tags**: 
  - `azd-env-name`: Environment identifier

### Storage Account
- **Name Pattern**: `m365copilot{uniqueToken}`
- **SKU**: Standard_LRS (Locally Redundant Storage)
- **Kind**: StorageV2
- **Features**:
  - TLS 1.2 minimum
  - HTTPS traffic only
  - Hot access tier
  - Blob public access enabled
  - One blob container: `food` (for images)

### App Service Plan
- **Name Pattern**: `plan-{uniqueToken}`
- **OS**: Linux
- **SKU**: B1 (Basic)
  - 1 vCPU
  - 1.75 GB RAM
  - 10 GB storage
- **Purpose**: Hosts all three .NET API applications

### Web Apps (App Services)

#### 1. Food Catalog API
- **Name Pattern**: `food-catalog-api-{uniqueToken}`
- **Runtime**: .NET 9.0
- **Tags**: `azd-service-name: food-catalog-api`
- **Features**:
  - CORS enabled (wildcard)
  - HTTPS only
  - FTPS disabled
  - Connection to storage account

#### 2. HR MCP Server
- **Name Pattern**: `hr-mcp-server-{uniqueToken}`
- **Runtime**: .NET 9.0
- **Tags**: `azd-service-name: hr-mcp-server`
- **Features**:
  - CORS enabled (wildcard)
  - HTTPS only
  - FTPS disabled
  - Model Context Protocol support

#### 3. Purchasing Service
- **Name Pattern**: `purchasing-service-{uniqueToken}`
- **Runtime**: .NET 9.0
- **Tags**: `azd-service-name: purchasing-service`
- **Features**:
  - CORS enabled (wildcard)
  - HTTPS only
  - FTPS disabled

### Static Web App
- **Name Pattern**: `food-shop-{uniqueToken}`
- **SKU**: Free
- **Tags**: `azd-service-name: food-shop`
- **Purpose**: Hosts Angular frontend application
- **Features**:
  - Global CDN distribution
  - Automatic HTTPS
  - Staging environments enabled
  - Config file updates allowed

## Network Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Internet                              │
└─────────────────────────────────────────────────────────────┘
                         │ HTTPS
              ┌──────────┼──────────┐
              │          │          │
         ┌────▼────┐ ┌───▼───┐ ┌───▼───────┐
         │  API 1  │ │ API 2 │ │   API 3   │
         │  :443   │ │ :443  │ │   :443    │
         └────┬────┘ └───────┘ └───────────┘
              │
         ┌────▼──────────────┐
         │  Storage Account  │
         │  Blob Service     │
         └───────────────────┘
```

### Security Configuration
- **All traffic**: HTTPS only (HTTP redirected)
- **CORS**: Currently configured for wildcard (*) - should be restricted in production
- **FTPS**: Disabled
- **TLS**: Version 1.2 minimum
- **Authentication**: Currently none - should be added for production

## Deployment Flow

```
Developer
    │
    ├── git push
    │
    ▼
GitHub Actions
    │
    ├── Build .NET Projects
    ├── Build Angular App
    │
    ▼
Azure Web Apps
    │
    └── Running Services
```

### Deployment Methods

1. **Local Development (azd)**
   ```bash
   azd up
   ```
   - Provisions infrastructure
   - Builds all services
   - Deploys to Azure

2. **CI/CD (GitHub Actions)**
   - Triggered on push to master
   - Builds specific service
   - Deploys using Azure credentials

## Naming Convention

All resources use a consistent naming pattern:

```
{service-type}-{service-name}-{unique-token}

Examples:
- food-catalog-api-abc123xyz
- hr-mcp-server-abc123xyz
- purchasing-service-abc123xyz
- food-shop-abc123xyz
```

The unique token is generated using:
```bicep
toLower(uniqueString(subscription().id, environmentName, location))
```

This ensures:
- Globally unique names
- Consistent across deployments
- Reproducible for same parameters

## Cost Estimate

| Resource | SKU | Estimated Monthly Cost |
|----------|-----|------------------------|
| App Service Plan | B1 | ~$13.00 |
| Storage Account | Standard LRS | ~$0.05/GB |
| Static Web App | Free | $0.00 |
| **Total** | | **~$13-15/month** |

**Note**: Costs vary by region and usage. Free tier options available for development:
- App Service Plan: F1 (Free) - 1 hour/day compute
- Storage: First 5 GB free

## Scalability

### Horizontal Scaling
- App Service Plan supports scale out to multiple instances
- Current: 1 instance (B1 tier)
- Can scale up to 3 instances on Basic tier
- Premium tier required for auto-scaling

### Vertical Scaling
Available SKUs:
- **F1** (Free): 1 GB RAM, shared compute
- **B1** (Basic): 1.75 GB RAM, dedicated compute (current)
- **S1** (Standard): 1.75 GB RAM, auto-scale, staging slots
- **P1V2** (Premium): 3.5 GB RAM, advanced features

## High Availability

Current Configuration:
- **Single region**: West Europe (default)
- **No redundancy**: Basic tier doesn't support zone redundancy
- **No failover**: No secondary region configured

Production Recommendations:
- Use Premium tier for zone redundancy
- Deploy to multiple regions
- Use Traffic Manager for global load balancing
- Configure Azure Front Door for CDN and DDoS protection

## Monitoring and Observability

To be implemented:
- [ ] Application Insights integration
- [ ] Log Analytics workspace
- [ ] Azure Monitor alerts
- [ ] Diagnostic settings on all resources
- [ ] Custom metrics and dashboards

## Security Hardening

Current Security Measures:
- ✅ HTTPS only
- ✅ TLS 1.2 minimum
- ✅ FTPS disabled
- ✅ Storage account access keys secured

Additional Recommendations:
- [ ] Add Azure Key Vault for secrets
- [ ] Enable Managed Identities
- [ ] Restrict CORS to specific origins
- [ ] Add authentication (Azure AD, API keys)
- [ ] Enable Azure DDoS Protection
- [ ] Configure private endpoints for storage
- [ ] Add WAF (Web Application Firewall)
- [ ] Implement Azure Front Door
- [ ] Enable diagnostic logs

## Disaster Recovery

Current State:
- Storage: LRS (3 copies in single datacenter)
- No backup configuration
- No cross-region replication

Production Recommendations:
- [ ] Use GRS (Geo-Redundant Storage)
- [ ] Configure backup schedules
- [ ] Document recovery procedures
- [ ] Test disaster recovery plan
- [ ] Implement Azure Site Recovery

## Maintenance Windows

Recommended schedule:
- **Updates**: Automatic (managed by Azure)
- **Maintenance**: Sunday 2:00-4:00 AM UTC
- **Backups**: Daily at 1:00 AM UTC

## Compliance and Governance

Azure Policies to Consider:
- Require tags on resources
- Enforce naming conventions
- Restrict resource types
- Enforce encryption
- Require HTTPS
- Limit VM SKUs
- Geographic restrictions

## References

- [Azure App Service Documentation](https://learn.microsoft.com/en-us/azure/app-service/)
- [Azure Storage Documentation](https://learn.microsoft.com/en-us/azure/storage/)
- [Azure Static Web Apps Documentation](https://learn.microsoft.com/en-us/azure/static-web-apps/)
- [Azure Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
