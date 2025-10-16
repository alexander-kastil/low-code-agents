# Labs

- Introduction to Developing AI Agents and Copilots for Microsoft 365
- Extend Microsoft Copilot for Microsoft 365 with Copilot Studio
- Pro-Code Extensibility Fundamentals, Copilot Connectors & Copilot API Capabilities
- Implementing Pro-Code Declarative- & Custom Engine Agents for Microsoft 365 Copilot

## Getting Started

### 1.1 Fork the Repository

Before you start, please fork this repository to your GitHub account by clicking the `Fork` button in the upper right corner of the repository's main screen (or follow the [documentation](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo#forking-a-repository)). This will allow you to make changes to the repository and save your progress.

### 1.2 Spin up Development Environment

GitHub Codespaces is a cloud-based development environment that allows you to code from anywhere. It provides a fully configured environment that can be launched directly from any GitHub repository, saving you from lengthy setup times. You can access Codespaces from your browser, Visual Studio Code, or the GitHub CLI, making it easy to work from virtually any device.

To open GitHub Codespaces, click on the button below:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=master&repo=alexander-kastil%2Fm365-copilot)

![devcontainer](/_images/open-in-devcontainer.png)

> Note: You can also use this dev container locally with VS Code and Docker. Read [Develop inside a DevContainer](https://code.visualstudio.com/docs/devcontainers/containers) for instructions.

### 1.3 Provision the REST Services and MCP Infrastructure - Optional - Used for Demos

1. Install [Azure Developer CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)

2. Login to Azure:

   ```bash
   azd auth login
   ```

3. Initialize and provision:
   ```bash
   azd init
   azd provision
   ```

### 1.4 CI/CD with GitHub Actions - Optional - Used for Demos

Deploy services used in demos and labs using GitHub Actions. The following workflows are available in the `.github/workflows` folder:

- `food-catalog-api-ci-cd.yml` - Food Catalog API
- `hr-mcp-server-ci-cd.yml` - HR MCP Server
- `purchasing-service-ci-cd.yml` - Purchasing Service
- `food-shop-ci-cd.yml` - Food Shop UI



