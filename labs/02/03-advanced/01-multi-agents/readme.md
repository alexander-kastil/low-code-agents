# Lab: Parent Agent with a Child Agent in Microsoft Copilot Studio (Preview)

## What You’ll Build

- A **Parent** agent (router) that uses **generative orchestration** to decide when to invoke a **Child** agent.
- The **Child** agent is scoped to a narrow domain (e.g., HR policies). The parent remains the single entry point.

---

## Prerequisites

- Access to **Microsoft Copilot Studio** with rights to create agents in your environment.
- Multi-agent (child/connected agents) feature is currently in **preview**.

---

## Scenario

- **Parent**: “Contoso Help Hub” — Front door that answers general questions and routes specialized queries.
- **Child**: “Contoso HR Policy” — Answers HR policy questions only (benefits, PTO, holidays) and then hands control back to the parent automatically.

---

## Step 1 — Create the Parent Agent

1. Open **Copilot Studio** → **Create agent** → Name: **Contoso Help Hub**.
2. Provide a short **Description** and **Instructions**.
3. Ensure **Generative orchestration** is ON.
4. (Optional) Add general **Knowledge** sources.

**Recommended Parent Instructions:**

You are Contoso Help Hub. Act as a front door:
• If the user asks about HR policy (benefits, PTO, holidays, leave eligibility, country-specific HR rules), delegate to the “Contoso HR Policy” agent.
• Otherwise, answer directly using your knowledge and tools.
• Keep answers concise; cite sources when available.
• If unsure, ask a clarifying question rather than guessing.

Step 2 — Add a Child agent inside the parent

You can create child agents directly from the parent’s Agents page. Child agents are lightweight sub‑agents that live within the parent. [Add other...lot Studio]

In Contoso Help Hub, go to Agents → Add an agent → Create an agent. [Add other...lot Studio]
Name: Contoso HR Policy.
When will this be used?

- Leave as The agent chooses and write a precise Description (recommended), or select a specific behavior if offered.
- Example Description:
  “Only handle HR policy questions such as benefits, PTO/leave, holiday calendars, leave eligibility and policy rules. Don’t answer IT, finance, or travel questions.”
  The description/when‑to‑use settings drive when generative orchestration will choose this child. [Add other...lot Studio], [Orchestrat...lot Studio]

In Instructions for the child, paste:

You are Contoso HR Policy.
• Answer only HR policy questions (benefits, PTO/leave, holidays, eligibility).
• If the query isn't about HR policy, return the conversation to the parent.
• Keep answers scoped and link to HR documents where possible.

Step 3 — Test the routing (Parent → Child → Parent)

Open the Test pane for Contoso Help Hub (the parent). Ask:
“How many PTO days do I get?”
Expected: Parent routes to Contoso HR Policy; the child answers. [Orchestrat...lot Studio]
Then ask a non‑HR question, e.g.:
“What’s our Wi‑Fi guest password policy?”
Expected: Control is back with the Parent and it answers from its knowledge.

Step 4 — Make routing bullet‑proof

Sharpen the child’s Description with phrases like “only invoke when… / such as…” to reduce false positives and ensure the conversation naturally “returns” to the parent when out of scope. This tuning approach is commonly used by Copilot Studio practitioners. [Return fro...lot Studio]
Keep the Parent Instructions explicit about when to delegate vs answer directly. Generative orchestration uses these instructions to pick agents/tools.

Step 5 — (Optional) Use a Connected agent instead of a child
If you already have an HR agent elsewhere (another team/environment) and want reuse/ALM separation:

From the Parent → Agents → Add an agent → Connect an existing agent → pick the HR agent.
(If your UI presents it) consider whether to pass conversation history when connecting; keep privacy in mind. (Community walkthroughs show this option when connecting agents.) [Add other...lot Studio], [Setting Up...lot Studio]

Step 6 — Publish and validate

Publish the parent (the child is included). Test in your target channel (e.g., Teams). Monitor Analytics and Activity to improve routing and answer quality over time
