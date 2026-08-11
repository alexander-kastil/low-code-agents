# The three-session daily loop

Source: Khairallah AL-Awady (@eng_khairallah1), "How to Automate Your Entire Workflow Using Claude
Cowork", X, 8 May 2026. The structure below is his; the gates, the template contract, and the
failure modes are the parts worth keeping and are restated here in operational form.

The claim to test rather than believe: one to two days to build, one to three hours saved per
workday. Treat that as a hypothesis you measure in week four, not a reason to build all three
sessions at once. Build session 1 alone, run it for a week, and only then decide whether 2 and 3
earn their setup.

## The shape

Three sessions, two of them scheduled and one triggered by hand.

| Session | When | Trigger | Produces |
| --- | --- | --- | --- |
| Morning briefing | ~07:00 weekdays | scheduled | one markdown file in the briefings folder |
| Production block | midday | manual | the actual work artifacts, in their own folders |
| End-of-day wrap-up | ~17:00 weekdays | scheduled | one wrap-up file, including a carry-forward list |

The loop closes because the wrap-up's **carry-forward section is an input to tomorrow's briefing**.
Without that link you have three unrelated reports rather than a system, and the briefing has no
memory of what it asked for yesterday.

## Session 1: morning briefing

Prerequisites: connectors for mail, calendar, and chat; a dedicated output folder
(`Documents/Daily-Briefings` or equivalent) that the task may write to.

The briefing gathers, categorizes, and compiles. It does not send anything. Drafting replies is
fine; sending them is not a thing a scheduled unattended task should ever do.

**Define your own urgency tiers. This is the whole quality of the briefing.** A model asked to
sort by "urgency" invents a scheme, and it invents a different one each morning. Name the tiers
and the boundary between them:

```text
Tier 1: needs a response before 09:00
Tier 2: needs a response today
Tier 3: can wait until this week
Tier 4: informational, no response needed
```

Yours will not be these. Whatever they are, they must be stated in the prompt and stated as
observable conditions, not adjectives. "Urgent" is not a tier; "from a customer, and mentions a
deadline inside 24 hours" is.

Body of the briefing: mail by tier, calendar with a short prep note per meeting, chat highlights
from overnight, the top three things that need your judgement today, and yesterday's carry-forward
items. One file, readable in five minutes.

## Session 2: the production block

The reason to use Cowork rather than a chat: it operates on your actual files. It creates the
document, updates the sheet, writes the report to the folder it belongs in. Output you have to
copy out of a chat window is not production.

The unit of reuse is a **task template**, and every template names four things:

1. **Input source.** The exact folder, file, or query. Not "my notes".
2. **Processing steps.** Ordered, in the sequence you would do them.
3. **Output format.** The document type and its structure, or better, a companion file that is the
   house format itself rather than a description of it.
4. **Save location.** The exact path, and the naming convention for the file.

A template missing any of the four gets babysat every run, which defeats the point. Missing #4 is
the most common and the most annoying: the work is correct and you cannot find it.

Work that suits this session: batches of documents to extract and summarize, data pulled from
several places into one view, content produced against a brief, research compiled into a structured
document instead of twenty open tabs. What does not suit it: anything where the judgement is the
work, and anything irreversible or outward-facing.

Start with the five recurring tasks you actually repeat. Write a template for each. Run each once
and fix what came back wrong before writing the sixth.

## Session 3: end-of-day wrap-up

Reviews what happened (mail sent and received, meetings that occurred, files modified in the
working folders today), cross-references it against the morning briefing to see what was handled
and what was not, and writes the wrap-up.

**The carry-forward section is the point.** Unresolved items, named, so tomorrow's briefing opens
with them as priorities. A wrap-up without carry-forward is a diary entry.

## Gates before anything gets scheduled

- **Run it manually three times, correcting after each.** A scheduled task is a promise that the
  output is useful unattended; you cannot make that promise about a prompt you have never seen run.
- **Scope the write permission to one folder.** Scheduled tasks write without a human in the loop,
  so the blast radius is whatever you granted.
- **No sends, no posts, no deletes on a schedule.** Draft, flag, and stage instead, and keep the
  send as a human action. This is the same rule that governs any unattended agent.
- **Give it somewhere to say "nothing".** A briefing that must fill every section will pad. State
  that an empty section should be rendered as one line saying it is empty.

## The weekly refinement pass

Fifteen minutes, one fixed slot per week. Read the week's outputs and answer three questions:

1. **What did the briefing miss that I had to find myself?** Fold it into the prompt.
2. **What did it produce that I had to redo?** Fix the template that produced it, not the output.
3. **What recurring task showed up this week that should be a template?** Write it.

This is where the compounding lives, and it is the step people skip. A system set up once and never
corrected degrades: your work changes, the prompt does not, and within two months the briefing is
describing a job you no longer have.

**The counter-question the source does not ask: what should be deleted?** Add it. Any scheduled
output you have not opened in two weeks gets switched off. An automation you ignore is not free,
and the folder full of unread reports is the actual failure mode of this whole pattern, not a
briefing that misses an email.
