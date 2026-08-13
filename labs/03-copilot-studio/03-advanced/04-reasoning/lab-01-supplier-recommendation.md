# Recommend a Supplier with a Deep Reasoning Agent

Sourcing decisions are the kind of work an agent usually gets almost right: it reads the scorecard, picks the supplier with the best numbers, and quietly ignores the certificate that expires two weeks before the contract starts. The cost of "almost right" here is a twelve month contract awarded to a vendor who was never eligible. In this lab you build an Aurora Provisions sourcing advisor that has to screen ten suppliers against four disqualifying rules, respect a volume cap, and split an award across two regions, and you make it work the problem step by step instead of pattern matching an answer.

You will run the same hard question twice, once on the default model and once with deep reasoning switched on and the reason keyword placed on a single instruction step, then open the activity map to see the reasoning node the run produced. Budget 20 to 25 minutes.

## What you'll build

- A Copilot Studio agent called Sourcing Advisor with generative orchestration and deep reasoning turned on.
- Three grounded knowledge sources: a supplier scorecard, a sourcing policy, and an incident log that contradict each other on purpose.
- An instruction block that carries the reason keyword on exactly one step, so the slow model runs where it pays and nowhere else.
- A baseline answer and a deep reasoning answer for the same question, side by side, plus the activity map that shows which model did what.

## Lab Files

| File | What it represents |
|------|--------------------|
| [lab-01-supplier-recommendation/supplier-scorecard.xlsx](lab-01-supplier-recommendation/supplier-scorecard.xlsx) | Ten suppliers with capacity, on-time delivery, defect rate, landed price index, and certification expiry |
| [lab-01-supplier-recommendation/sourcing-policy.docx](lab-01-supplier-recommendation/sourcing-policy.docx) | Policy SP-14: the four eligibility rules, the 60 percent concentration cap, the continuity rule, and the ranking order |
| [lab-01-supplier-recommendation/supplier-incidents.docx](lab-01-supplier-recommendation/supplier-incidents.docx) | Six incidents with severity and status, three of them still open |

## Prerequisites

- A Copilot Studio environment where you can create agents, hosted in the United States or in the EU excluding the United Kingdom. Deep reasoning is not available in other regions.
- Permission to change agent settings, since generative orchestration and deep reasoning are both settings-level switches.
- The three files above available locally, in the `lab-01-supplier-recommendation` folder next to this guide.
- An awareness that deep reasoning is in preview, consumes billed Copilot Credits per use, and makes responses noticeably slower. See [Use deep reasoning models for complex tasks](https://learn.microsoft.com/microsoft-copilot-studio/authoring-reasoning-models).

## Exercise 1: Create the agent and turn on generative orchestration

Deep reasoning is not a standalone feature. It plugs into generative orchestration, the planning layer that reads a request, decides which knowledge and tools to use, and sequences the steps. Without orchestration there is no plan for a reasoning model to be invoked inside, and the deep reasoning switch stays unavailable. So the first move is an agent whose planner is on.

1. In Copilot Studio, select **Create**, then **New agent**.
2. Name the agent `Sourcing Advisor` and paste this description:

```text
You advise the Aurora Provisions sourcing team on annual supply contracts. You screen suppliers against the Aurora sourcing policy, apply the award rules, and recommend a volume split that a category manager can sign off.
```

3. Create the agent, then open **Settings** for it.
4. Under the generative AI or orchestration section, turn on **Generative orchestration**.

Expected: the agent opens with generative orchestration enabled, and the setting persists after you leave and return to **Settings**. No topics were authored; the planner is what will do the work.

> **Note:** If your environment still shows classic orchestration only, the deep reasoning switch in the next exercise will be missing or greyed out. Fix orchestration first rather than hunting for the reasoning toggle.

## Exercise 2: Turn on deep reasoning

With deep reasoning on, the agent decides for itself which steps deserve the slower model, and you can force the decision with a keyword. The model behind it is Azure OpenAI o3, which trades response time for logical, step-by-step problem solving. This is a per-agent switch, not a per-environment one, so an agent that does simple lookups keeps running on the fast default.

1. Stay in **Settings** for the Sourcing Advisor.
2. Turn on **Deep reasoning (preview)**.
3. Read the preview notice, including the note that data may be processed outside your region, and confirm.
4. Return to the agent overview.

Expected: **Deep reasoning (preview)** shows as enabled in **Settings**, next to generative orchestration. Nothing about the agent's behavior has changed yet, because no request has been hard enough to trigger it and no instruction asks for it.

## Exercise 3: Ground the agent on the sourcing pack

Deep reasoning improves how an agent works through a problem; it invents no facts. The hard part of this scenario is that the answer lives across three documents that disagree: the scorecard says who is best, the incident log says who is out, and the policy says how to weigh both. Descriptions matter here because the orchestrator picks sources by matching a request against them.

1. Open the **Knowledge** page for the agent and select **Add knowledge**.
2. Upload `supplier-scorecard.xlsx` and give it this description:

```text
Supplier scorecard for organic green tea leaf. One row per supplier with region, annual capacity in cases, trailing twelve-month on-time delivery percentage, defect rate, landed price index, ISO 9001 expiry date, and last audit date. Use it for any question about supplier performance, capacity, price, or certification validity.
```

3. Add `sourcing-policy.docx` with this description:

```text
Aurora sourcing policy SP-14 for the 2026 annual tea leaf contract. Contains the contract volume and start date, the four eligibility rules R1 to R4, the concentration cap R5, the continuity rule R6, the ranking order R7, and the escalation rule R8. Use it whenever a request involves awarding, splitting, or screening a contract.
```

4. Add `supplier-incidents.docx` with this description:

```text
Supplier incident log with severity, open or closed status, and detail for each incident raised against tea leaf suppliers. Use it to check whether a supplier has an open incident before recommending them.
```

5. Wait until all three sources report that they are ready.

Expected: three sources listed on the **Knowledge** page with a ready status and your descriptions visible. The agent can now reach every fact the decision needs, and every fact that will trip it up.

> **Tip:** Write each description as "what is in it, and when to use it". A description that only names the file is the most common reason a perfectly good knowledge source never gets searched.

## Exercise 4: Establish the baseline

Before switching anything on in the prompt, capture what the agent does unaided. This is the measurement the rest of the lab is judged against, and skipping it is how teams end up believing a feature helped without evidence. Ask the full question with no instructions in place, so the agent answers the way a fast general model does.

1. Open the **Test your agent** panel.
2. Send this message:

```text
We need to award the 2026 organic green tea leaf contract. Which supplier or suppliers should get it, and in what volumes?
```

3. Note three things: which suppliers it recommends, whether it names any supplier it ruled out, and how long the answer takes.

Expected: a fluent recommendation that leans on the strongest scorecard numbers, typically Harbor Leaf Trading or Rhinevale Botanicals, delivered in a couple of seconds. In most runs the answer misses at least one of the disqualifications, the 60 percent concentration cap, or the different-region rule, and it rarely lists the excluded suppliers with the rule that excluded them. Keep this answer open in the transcript, you will compare against it in Exercise 6.

> **Note:** The baseline is model-dependent and will not be identical for every learner. What matters is not which supplier it named but whether it screened at all: count how many of the four eligibility rules the answer visibly applied.

## Exercise 5: Write instructions that place reason on one step

An agent with deep reasoning on still decides for itself when to use it. The keyword `reason` inside an instruction step removes the guesswork and forces the deep reasoning model for that step only. That precision is the whole design: every step carrying the keyword costs credits and seconds, so you put it on the step where judgment lives, not on the lookups around it.

1. Open the **Instructions** for the agent.
2. Replace the contents with this block:

```text
You are the Aurora Sourcing Advisor. When asked to award or split a supply contract, follow these steps in order:

1. Read sourcing policy SP-14 and extract the contract volume, the contract start date, and rules R1 to R8.
2. Read the supplier scorecard and list every supplier with its region, capacity, on-time delivery, defect rate, landed price index, and ISO 9001 expiry.
3. Read the supplier incident log and note every incident that is still open, with its severity.
4. Using the policy, the scorecard, and the incident log together, reason through the award: screen each supplier against R1 to R4, apply the concentration cap R5 and the continuity rule R6, rank the survivors with R7, and determine the volume split. Escalate under R8 if no combination covers the volume.
5. Present the recommendation as: the primary supplier and its volume, the secondary supplier and its volume, then a table of every excluded supplier with the rule number that excluded it.

Never recommend a supplier without checking its certification expiry against the contract start date and its open incidents. State volumes in cases and as a percentage of contract volume.
```

3. Save the instructions.

Expected: the instruction block saves with the word reason sitting in step 4 and nowhere else. Steps 1 to 3 are retrieval and stay on the fast default model; step 4 is the one that will run on Azure OpenAI o3.

> **Warning:** Resist adding reason to steps 1, 2, and 3 to be thorough. Each keyword sends another step to the slow model, and a four-reason instruction block turns a ten second answer into a minute of waiting while the credits meter runs.

## Exercise 6: Run the same question again and compare

Now the comparison. Same question, same knowledge, same agent, with the only difference being an instruction block that forces one reasoning step. Watch the latency as well as the content, because the pause before the answer is the most direct evidence that a different model handled the hard part.

1. In **Test your agent**, start a fresh conversation.
2. Send the exact same message as in Exercise 4:

```text
We need to award the 2026 organic green tea leaf contract. Which supplier or suppliers should get it, and in what volumes?
```

3. Wait for the response; it takes visibly longer than the baseline.
4. Grade the answer against the marking scheme below.

The policy and the data admit one correct outcome:

| Element | Correct result |
|---------|----------------|
| Primary | Silverpine Estates, 6,800 cases (56.7 percent of contract volume) |
| Secondary | Cascade Organics, 5,200 cases, Americas, satisfying the different-region rule |
| Excluded by R1 | Rhinevale Botanicals (ISO expires 2026-01-15), Kestrel Highland Tea (ISO expires 2026-03-10) |
| Excluded by R2 | Meridian Tea Co. (93.4 percent), Lowfield Commodity Group (94.1 percent) |
| Excluded by R3 | Harbor Leaf Trading (open critical incident INC-2214), Lowfield Commodity Group (open major incident INC-2231) |
| Excluded by R4 | Alpen Blattwerk (price index 112) |
| Not selected | Coastline Naturals and Terra Verde Farms are eligible but rank below Cascade Organics under R7 |

Expected: the deep reasoning answer names Silverpine Estates as primary and a different-region secondary, and it shows its screening rather than asserting a winner. Compare it against the Exercise 4 transcript: the baseline named a supplier, this answer defends one. If it still misses an exclusion, sharpen step 4 to name the rule numbers explicitly and run once more.

> **Tip:** A supplier with an open incident of severity minor, Kestrel Highland Tea, is deliberately in the data. An answer that excludes it under R3 is over-applying the rule, which is a different failure from missing an exclusion and worth pointing out in a review.

## Exercise 7: Trace the reasoning in the activity map

An answer you cannot trace is an answer you cannot defend, and a sourcing recommendation will be questioned. The activity map draws the plan the orchestrator built, with one node per step, and it renders a distinct node wherever a deep reasoning model ran. Opening that node is how you confirm the slow model ran where you meant it to and not on the whole conversation.

1. In the **Test your agent** panel, select the three dots (**…**) and turn on **Show activity map when testing**.
2. Re-send the award question so a fresh map is generated.
3. When the map appears, find the deep reasoning node and select it to expand it.
4. Read the reasoning steps, the data the model used, and the result it returned.
5. Open the **Activity** page for the agent and select the same activity to see the map alongside the transcript.

Expected: the map shows knowledge nodes for the three sources plus a deep reasoning node covering the award decision, and expanding that node reveals the intermediate screening and the output it handed back. On the **Activity** page the same activity is listed with its completed steps and status, so the trace survives beyond your test session.

> **Note:** Historical activity requires a Microsoft Exchange license and mailbox, since transcripts are stored through Microsoft 365 services. If the **Activity** page is empty, the real-time map in the test panel still gives you the trace.

## Exercise 8: Confirm the fast path is still fast

Deep reasoning is a cost decision as much as a quality one. An agent that reasons deeply about everything is slow and expensive, and users abandon it long before finance notices. This last check proves the scoping worked: a simple lookup should come back quickly and produce no reasoning node at all.

1. In **Test your agent**, start a fresh conversation and send:

```text
What is Terra Verde Farms' on-time delivery percentage?
```

2. Watch the response time and the activity map.
3. Send one more complex request to confirm the reasoning path is still reachable:

```text
Re-run the award assuming Harbor Leaf Trading closes incident INC-2214 before the contract start date. What changes?
```

Expected: the lookup answers in about the same time as the Exercise 4 baseline, with a knowledge node and no deep reasoning node in the map. The re-run question produces a reasoning node again and a changed recommendation, since Harbor Leaf Trading becomes eligible and outranks Silverpine Estates on on-time delivery, while the 60 percent cap still forces a split with a different-region secondary. You now have an agent that reasons only where reasoning pays.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| **Deep reasoning (preview)** is missing from **Settings** | Generative orchestration is off, or the environment region is outside the United States and the EU excluding the United Kingdom | Turn on generative orchestration first; if the toggle is still absent, check the environment region, since no agent setting can work around it |
| Both runs return the same shallow answer | The instructions did not save, or the keyword was reworded | Reopen **Instructions** and confirm the literal word reason appears in step 4; synonyms such as "think carefully" do not trigger the model |
| Every response is slow | The keyword appears in more than one step | Remove reason from the retrieval steps so only the award step carries it |
| The answer cites no policy rules | The policy file is still processing, or its description is too thin for the orchestrator to match | Confirm all three sources show ready, then re-apply the Exercise 3 descriptions, which state when to use each source |
| No deep reasoning node in the activity map | The map was generated before the instructions were saved, or the request was easy enough to stay on the default model | Start a fresh conversation and re-send the full award question rather than a follow-up |
| The recommendation names one supplier for all 12,000 cases | The concentration cap was read but not applied | Confirm the scorecard uploaded as a single sheet, then re-run; if it persists, name the 60 percent cap explicitly in step 4 |

## Summary

You built the Aurora Sourcing Advisor: an agent with generative orchestration and deep reasoning turned on, grounded on three deliberately contradictory sources, instructed so that exactly one step runs on the deep reasoning model, and traced through the activity map. You can now:

- Turn on deep reasoning for an agent and state the prerequisites and regional limits it carries.
- Place the reason keyword on a single instruction step so the slow model runs where judgment lives.
- Measure a baseline before enabling a feature, and grade the after against a known correct answer.
- Read a deep reasoning node in the activity map and explain which model handled which step.
- Judge when a task deserves deep reasoning and when it is paying for latency it does not need.

Next, put this planning behavior to work across several agents in [Setup multi-agent orchestration](../01-multi-agents/readme.md), or read the topic background in [Advanced Copilot Studio Agents](../../../../demos/03-copilot-studio/03-advanced/readme.md).
