---
name: copilot-cowork
description: Router for Cowork work, both authoring a custom skill and running Cowork as standing infrastructure. Covers the Microsoft 365 Copilot Cowork skill contract (frontmatter, kebab-case name-matches-folder, OneDrive placement, companion files, the run-and-tune loop) and the product-agnostic operating loop (scheduled morning briefing, manual production block, scheduled end-of-day wrap-up, reusable task templates, weekly refinement). Read the ONE matching reference. Use when asked to create or fix a cowork skill, write a SKILL.md for Copilot, package a skill for upload, a skill will not load or will not trigger, or to automate the day, build a morning briefing or end-of-day report, schedule a recurring session, write a task template, or work out why an automation stopped being useful.
metadata:
  version: 2.0.0
---

# Cowork

Two jobs live here: **authoring** a Microsoft 365 Copilot Cowork custom skill, and **operating**
Cowork as recurring infrastructure rather than a chat window.

| Ask | Read |
| --- | --- |
| The frontmatter contract, size and count limits, companion-file rules, the three-layer loading model, cross-platform compatibility | `references/format-reference.md` |
| Writing a description that triggers, structuring the instruction body, evidence and refusal rules, the run-and-pressure-test loop | `references/authoring-and-tuning.md` |
| The recurring daily loop (briefing, production block, wrap-up), task templates, the gates before scheduling anything, keeping it useful over time | `references/daily-loop.md` |

The authoring half below is **Microsoft 365 Copilot Cowork** specific. The operating loop in
`daily-loop.md` holds for Claude Cowork as well, which shares the name and almost nothing else.

Related: `schedule` and `loop` for the same recurring idea inside Claude Code, `obsidian` when the
outputs land in a vault, `claude-orchestration` when one session needs to fan out across agents
instead of repeating on a schedule.

## Authoring a Copilot Cowork skill

Author a Microsoft 365 Copilot Cowork custom skill: a `SKILL.md` file with YAML frontmatter and plain-language instructions, plus any companion files it needs.

A Cowork skill is not code. It is a recipe written for a capable colleague who has your permissions and none of your context. The two things that decide whether it works are the `description` (does Cowork reach for it at the right moment) and the specificity of the body (does it produce your format rather than a generic one).

---

## The minimum viable skill

```markdown
---
name: weekly-report
description: Generates my Northern Europe weekly status report from my sent emails, meetings, and latest figures. Use when I say write my weekly report, status update, or ask for the week's summary.
---

Gather my sent emails and calendar events from the past seven days.

Fill every section in order:
- Highlights: three to five outcome-led wins.
- Risks: anything slipping, with the owner named.
- Next week: the three commitments I am making.

Save the finished report as a Word document titled with the week ending date.
```

Two required frontmatter fields, `name` and `description`. Nothing else is required.

---

## Hard rules (these are what break skills)

- **`name` is kebab-case and must match the folder name exactly.** `skills/weekly-report/SKILL.md` carries `name: weekly-report`. A mismatch is the single most common cause of a skill failing to load. Lowercase alphanumerics and hyphens only; no consecutive, leading, or trailing hyphens.
- **The manifest filename is exactly `SKILL.md`**, uppercase.
- **The `description` is the only thing loaded until the skill triggers.** If it does not name the situation and the trigger phrases, the skill never runs no matter how good the body is.
- **Discovery happens at the start of a session.** A skill you just saved appears in the next new task, not the one already open. Always test in a fresh session.
- **Never invent a capability in the body.** The skill inherits the user's permissions and Cowork's built-in skills; it cannot reach systems Cowork cannot reach.

> Microsoft's own docs are inconsistent here: the OneDrive authoring page shows `name: Weekly Report` (title case with a space), while the plugin-development page specifies kebab-case matching the folder and lists it as an Error-severity validation rule. Follow the strict rule; it satisfies both.

---

## Where the skill lives

| Goal | Location |
|------|----------|
| Personal skill, authored by hand | OneDrive `Documents/Cowork/skills/<name>/SKILL.md` |
| Authored conversationally | Ask Cowork in chat to build a skill, or use **Customize** > **Skills** > **Add** > **Create new** |
| Import an existing skill | **Customize** > **Skills** > **Add** > **Upload skill** (`.md`, `.zip`, or `.skill`) |
| Share with the organization | Package as a plugin and publish, see the plugin path in `references/format-reference.md` |

Create the `Documents/Cowork/skills/` folder if it does not exist. Each skill gets its own subfolder named for the skill.

---

## Workflow

1. **Name the recurring job.** A skill is worth authoring when you have re-explained the same format more than twice. If the task happens once, just ask for it.
2. **Find the house format.** Locate the template, the past example, or the document the output must match. This becomes a companion file, not a paraphrase in the body.
3. **Write the description first.** Say what it produces and when to use it, including the phrases you would actually type. See `references/authoring-and-tuning.md`.
4. **Write the body as an ordered recipe.** Sources to gather, sections to fill in order, rules for judgement calls, and the artifact to save.
5. **Save into its own folder** with the companion files beside it.
6. **Test in a new session**, by name first, then without naming it.
7. **Tune what failed.** Ask Cowork which phrasings would miss the skill and which instruction let a weak result through, then fold the answers back in.

Steps 6 and 7 are not optional polish; a skill that has never been run and corrected is a draft.

---

## Reference material

Read the reference file that matches the task:

- `references/format-reference.md` — the full frontmatter contract, size and count limits, companion-file rules and validation table, the three-layer loading model, and cross-platform compatibility with Claude Code and other Agent Skills hosts.
- `references/authoring-and-tuning.md` — how to write a description that triggers, how to structure the instruction body, evidence and refusal rules, and the run-and-pressure-test loop.
- `references/daily-loop.md` — the three-session operating loop, task templates, the gates before anything gets scheduled, and the weekly refinement pass.

---

## Quality bar

A skill is done when all of these hold:

- It triggers in a new session from phrasing that does not name it.
- Its output matches the house format without follow-up correction.
- It refuses or asks rather than inventing anything it cannot source.
- Its companion files are referenced by name in the body, so Cowork knows to open them.
