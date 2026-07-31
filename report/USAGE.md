# Using the Writing Agent

This agent helps you write any structured text step by step, including reports, blog posts, articles, essays, and case studies.

## What it does

It handles stages 1-6:

1. Scope
2. Research
3. Outline
4. Draft
5. Revise
6. Final polish

Then other agents can evaluate and improve the draft.

## What you can create

- Report
- Blog post
- Article
- Essay
- Case study
- Long-form social post or newsletter draft

## What to prepare first

Update these files:

- `report/shared/references/REQUIREMENTS.md` (topic, audience, tone, goals)
- `report/shared/references/RUBRIC.md` (quality checklist or grading criteria)
- `report/shared/references/TEMPLATE.md` (optional structure/format)

Optional: add sources to `report/02_research_and_sources/references/`.

## Where output goes

Note: folder names use "report", but you can still use this workflow for other writing types.

Main output files:

- `report/01_topic_and_scope/output/scope.md`
- `report/02_research_and_sources/output/sources.md`
- `report/03_outline/output/outline.md`
- `report/04_drafting/output/draft.md`
- `report/05_revision/output/revised_draft.md`
- `report/06_final_polish/output/final_report.md`

Final revised file:

- `report/08_revision_pass/output/revised_report.md`

## Simple checklist

1. Define what you are writing in requirements (for example, blog or article).
2. Run `./run_report.sh`.
3. Review output files.
4. Improve inputs and run again if needed.