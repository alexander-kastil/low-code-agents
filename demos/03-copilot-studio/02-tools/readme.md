# Extending Copilot Studio Agents Tools

- Prompt Actions,
- Integrate Enterprise data using Connectors
- Using Dataverse & Integrating Data
- AI Builder & Managed Agents: Document Processor
- Understanding & using Model Context Protocol (MCP)
- Integrating Enterprise Data and Processes using REST Api’s
- Automating Visual Tasks using Computer Use

## Links & Resources

[Managed Agents in Copilot Studio](https://learn.microsoft.com/en-us/microsoft-copilot-studio/authoring-install-agent)

### Create Tables in Dataverse

Create two related tables in Dataverse:

1. Table: OfferRequests

Primary Name Column: requestId (Text)
Columns:

id (GUID, Primary Key)
requestId: (String)
supplierId (Whole Number)
transportationCost (Currency)
timestamp (DateTime)

2. Table: OfferRequestDetails

Primary Name Column: productName (Text)
Columns:

basePrice (Currency)
offeredPrice (Currency)
requestedAmount (Whole Number)
offeredAmount (Whole Number)
deliveryDurationDays (Whole Number)
isAvailable (Boolean)
offerId (Lookup to Offers table)

Relationship:

Create a one-to-many relationship from OfferRequests to OfferRequestDetails using the offerId lookup field.
