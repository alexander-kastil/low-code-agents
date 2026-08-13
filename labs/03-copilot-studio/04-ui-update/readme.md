# The New Copilot Studio Experience: Labs

Hands-on labs for the new Copilot Studio experience. Each lab belongs to a topic in the matching module, [The New Copilot Studio Experience](../../../demos/03-copilot-studio/04-ui-update/readme.md), and assumes you have read that topic's guide first.

Work them in order: the first four each isolate one surface (the toggle, the Build tabs, Evaluate, Skills), and the fifth pulls all of them together into a capstone agent.

## Labs

| Topic | Lab | Focus |
|-------|-----|-------|
| [The Two Copilot Studio Experiences](../../../demos/03-copilot-studio/04-ui-update/01-new-experience-overview/readme.md) | [Compare the Classic and New Copilot Studio Experiences Side by Side](01-new-experience-overview/lab-01-compare-classic-and-new.md) | Stand up a minimal Northwind assistant in the new experience and contrast it against classic: the toggle, coexistence, navigation tells, and the one-way conversion rule |
| [The Unified Build Surface and the New Orchestrator](../../../demos/03-copilot-studio/04-ui-update/02-unified-build-and-orchestrator/readme.md) | [Build, Evaluate, and Monitor a Northwind Sales Assistant](02-unified-build-and-orchestrator/lab-01-evaluate-and-monitor-agent.md) | Work all four Build-surface tabs, then build a test set in Evaluate and review runs in Monitor |
| [Test and Evaluate Copilot Studio Agents](../../../demos/03-copilot-studio/04-ui-update/03-evaluations/readme.md) | [Evaluate a New-Experience Agent with Test Sets](03-evaluations/lab-01-evaluate-with-test-sets.md) | Fill a conversation test set three ways, run a baseline, diagnose each failure into a component bucket, change one thing, and prove the fix with a second run |
| [Agent Skills in Copilot Studio](../../../demos/03-copilot-studio/04-ui-update/04-agent-skills/readme.md) | [Package Team Knowledge into a Portable Skill](04-agent-skills/lab-01-portable-skill.md) | Author a `SKILL.md`, reuse it across two agents, and contrast with classic topics |
| [Tools, MCP, and the New Workflows Designer](../../../demos/03-copilot-studio/04-ui-update/05-workflows-and-mcp/readme.md) | [Build a Sales Account Assistant in the New Experience](05-workflows-and-mcp/lab-01-sales-account-assistant.md) | Capstone: build, ground, tool up, skill, and publish a new-experience agent end to end |

## Lab assets

Some labs ship starter files in a folder next to the lab guide:

| Lab | Assets |
|-----|--------|
| [Evaluate a New-Experience Agent with Test Sets](03-evaluations/lab-01-evaluate-with-test-sets.md) | [`lab-01-evaluate-with-test-sets/`](03-evaluations/lab-01-evaluate-with-test-sets/): test set CSV, two instruction versions, a knowledge document, and a scorecard |
| [Package Team Knowledge into a Portable Skill](04-agent-skills/lab-01-portable-skill.md) | [`lab-01-portable-skill/`](04-agent-skills/lab-01-portable-skill/) |
| [Build a Sales Account Assistant in the New Experience](05-workflows-and-mcp/lab-01-sales-account-assistant.md) | [`lab-01-sales-account-assistant/`](05-workflows-and-mcp/lab-01-sales-account-assistant/) |

## Prerequisites

- A Copilot Studio environment where the New experience toggle is available on the home page
- Permission to create agents, knowledge sources, and tools in that environment
- The classic labs in [Basics](../01-basics/readme.md), [Tools](../02-tools/readme.md), and [Advanced](../03-advanced/readme.md) completed, so the classic-to-new comparisons land
