# Designing, Implementing & Maintaining Low-Code Agents using Copilot Studio

# General Repository Instructions

This repository provides low-code and code-first solutions for designing, implementing, and maintaining intelligent agents using **Copilot Studio** (and **Agent Builder** for lightweight scenarios) for agent design, with **Microsoft 365 Agents Toolkit** for code-first development and integrations.

## Key Principles

- **Low-Code First**: Prioritize low-code solutions and visually designed agents when possible, using code-first approaches for advanced scenarios.
- **Modular Design**: Build reusable agent components, skills, and connectors that can be composed together.
- **Production Ready**: All agents and implementations should follow enterprise best practices, including error handling, monitoring, and documentation.
- **Accessibility First**: Follow WCAG 2.2 Level AA standards for all user-facing interfaces.

## Repository Structure

- **`demos/`**: Incremental demonstrations showcasing agent capabilities from basics to advanced patterns.
- **`labs/`**: Hands-on learning materials and exercises for different skill levels.
- **`src/`**: Production-ready source code including:
  - ASP.NET Core APIs (e.g., food-catalog-api, purchasing-service)
  - Angular frontend applications (e.g., food-shop)
  - MCP servers (e.g., hr-mcp-server)
  - Custom connectors for Microsoft 365
- **`infra/`**: Infrastructure as Code (Bicep) for Azure deployment.

## Building Agents with Copilot Studio & Agent Builder

### Design Phase (Low-Code)

- Use **Copilot Studio** or **Agent Builder** to design agents with a visual, low-code interface.
- Define agent intent, capabilities, and knowledge sources.
- Configure conversation flows and escalation paths.
- Map required plugins and integrations without code.

### Implementation Phase (Code-First)

- Create or extend **MCP (Model Context Protocol) servers** for backend logic and integrations.
- Implement **custom connectors** for Microsoft 365 and external APIs.
- Use **Microsoft 365 Agents Toolkit** for scaffolding Teams apps and advanced extensibility.
- Deploy agents through Copilot Studio or Agent Builder with MCP server backends.
- Cache OpenAPI schemas and frequently accessed data for performance.

### Maintenance & Monitoring

- Monitor agent performance using Application Insights.
- Version agent definitions and code changes together.
- Update agent capabilities when underlying services change.
- Maintain backward compatibility in agent APIs and MCP interfaces.

## Tool Usage Guidelines

### Low-Code Agent Design

- Use **Copilot Studio** for full-featured agent design with AI orchestration, complex flows, and knowledge management.
- Use **Agent Builder** (Copilot Studio Light) for simple, policy-driven agent scenarios requiring minimal setup.

### Code-First Development

- Use **Microsoft 365 Agents Toolkit CLI** (command: `atk`) for scaffolding Teams apps and building agent infrastructure.
- Create and manage **MCP servers** to extend agent capabilities with backend logic and integrations.
- Configuration is managed via `m365agents.yml` (never check secrets into source control).

### Agent Patterns

- Leverage **declarative agents** in Copilot Studio for predefined, policy-driven scenarios.
- Use **custom engine agents** in Copilot Studio for complex multi-turn conversations requiring dynamic state management.

# Instructions for Copilot

- Apps and agents for Microsoft 365 or Microsoft 365 Copilot refers to applications for products in Microsoft 365, agents for Microsoft 365 Copilot, including Teams app, Office addin, declarative agent, custom engine agent, etc.
- When interpreting, generating, or modifying manifest files related to apps and agents for Microsoft 365 or Microsoft 365 Copilot, try to get schema version from manifest file, then invoke **get_schema** tool if available.
- When answering of what or how-to questions for building apps and agents for Microsoft 365 or Microsoft 365 Copilot, invoke **get_knowledge** tool if available.
- Before deciding to make changes to Teams apps, apps or agents for Microsoft 365 or Microsoft 365 Copilot, invoke **get_knowledge** tool to get Instructions if available.
- When troubleshooting issues, invoke **troubleshoot** tool if available.
- Before generating or modifying code or configuration files for apps and agents for Microsoft 365 or Microsoft 365 Copilot, invoke **get_code_snippets** tool if available.
- Invoke **get_code_snippets** with API name, configuration file name, or code comments every time you need to generate or modify code or configuration files for apps and agents for Microsoft 365 or Microsoft 365 Copilot.
