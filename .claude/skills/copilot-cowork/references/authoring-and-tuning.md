# Authoring and Tuning a Cowork Skill

How to write a skill that actually triggers and actually produces your format. The format contract lives in `format-reference.md`; this file is about content quality.

## Writing the description

The description is the only part of the skill loaded before it triggers. Cowork reads it, and nothing else, when deciding whether this skill applies. Treat it as the skill's entire pitch.

A working description answers three things: what it produces, from what sources, and on which phrasings.

```yaml
description: Writes a one-page meeting brief in house format before a partner call or 1:1, pulling from my calendar, recent emails with the attendee, and related files. Use whenever I say prep me for a meeting, write a brief, or name an upcoming meeting to prepare for.
```

| Weak | Why it fails |
|------|--------------|
| `Helps with reports` | Names no situation, no trigger, no output |
| `Report generation skill` | Describes a category, not a moment |
| `Uses AI to summarize things` | Describes the mechanism instead of the job |

Two rules that fix most discovery failures:

- **Write the trigger phrases you actually type**, not the formal name of the task. If you say "get me ready for the Fjallbryggan call", the description needs "get me ready" and not only "meeting preparation".
- **Name the artifact.** "one-page meeting brief", "weekly status report as a Word document". Specific nouns match better than verbs.

## Structuring the body

The body is a recipe for a capable colleague with your permissions and no context. Order matters, because Cowork follows it.

1. **State the output and the format source first.** Point at the companion file by name: "in the house format defined by meeting-brief-template.docx, which sits in this skill folder."
2. **Say how to identify the subject.** "Identify the meeting I am preparing for from my request or my calendar." Include what to do when it is ambiguous: ask, rather than guess.
3. **Name the sources to gather.** Calendar, recent mail with the attendee, related files from a stated window.
4. **List the sections in order, one line each,** saying what belongs in each. This is the part that makes output match house format instead of a generic shape.
5. **Give rules for judgement calls.** What to do when a section has no data, what to draft versus leave blank.
6. **End with the artifact.** File type, title convention, where it goes.

## Evidence and refusal rules

The failure mode of a confident skill is fluent invention. Two instruction patterns prevent it:

```text
Every factual claim must trace to the source document. Name the source. If the
source does not support a claim, leave the claim out rather than softening it.
```

```text
Never invent pricing, terms, or figures. Those depend on decisions no document
holds, so ask me for that input and leave the section as a placeholder until I
supply it.
```

Instruct it to **refuse rather than soften**. "Be careful about claims" produces hedged invention; "leave it out" produces an honest gap you can see and fill.

If the source contains material that must not reach the output (confidential analysis feeding a customer-facing document), name those sections explicitly. A skill will not infer the boundary.

## The run-and-tune loop

A skill that has never been run and corrected is a draft. The loop is short and it is where most of the quality comes from.

1. **Run it by name** in a fresh session, on a real task, with real sources.
2. **Pressure-test the output.** Ask the skill to justify itself against the source: "For every factual claim, quote the line in the source that supports it. Show me any claim you cannot support that way."
3. **Ask what would miss.** "Which requests phrased the way I actually talk would fail to trigger this skill, and which instruction let through the weak claims we just found?" Cowork is reliable at diagnosing its own description gaps.
4. **Fold both fixes in:** widen the description with real phrasings, sharpen the instruction behind whichever section came out weakest.
5. **Re-run without naming the skill.** If it does not trigger on natural phrasing, the description is still too narrow. This is the acceptance test.

## Companion files

Ship the real artifact, not a description of it. A skill carrying `proposal-template.docx` produces house-format proposals; a skill whose body paraphrases the template produces approximations.

Worth adding beyond the template itself:

- **A worked example**, such as last quarter's winning proposal. It gives Cowork a standard to match, not just a shape to fill.
- **Reference data** the skill needs repeatedly: the segment taxonomy, the pricing tiers, the approved boilerplate.

Reference every companion by filename in the body. An unreferenced companion file may never be opened.

## When not to author a skill

- The task happens once. Just ask for it.
- The instructions change every time. A skill encodes a stable recipe; an unstable one becomes a constraint you fight.
- The real problem is missing data access rather than a missing recipe. A skill inherits your permissions and cannot reach what Cowork cannot reach.
