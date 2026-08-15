# Using the Writing Agent

This agent helps you write any structured text step by step, including reports, blog posts, articles, essays, and case studies.

## Quick start

1. Fill in the requirements, rubric, and optional template in the shared references folder.
    - `report/shared/references/REQUIREMENTS.md` (topic, audience, tone, goals)
    - `report/shared/references/RUBRIC.md` (quality checklist or grading criteria)
    - `report/shared/references/TEMPLATE.md` (optional structure/format)
2. Provide the topic, audience, tone, and goals you want the writing to follow.
3. Let the workflow run through scope, research, outline, draft, revise, polish, evaluate, and revision pass.
    "Generate report/blog"
4. Review the outputs in the stage folders and use the evaluation notes to improve the final version.
    - `report/06_final_polish/output/final_report.md`
5. Modify your output and references then rerun the generate agent until you get your desired output.

---

## What it does

It handles stages 1-8 as a sequential workflow:

1. Stage 1 - Scope: define the topic, audience, goals, and boundaries for the piece.
2. Stage 2 - Research: gather supporting facts, evidence, and source material.
3. Stage 3 - Outline: turn the research into a clear structure and flow.
4. Stage 4 - Draft: write the first full version of the content.
5. Stage 5 - Revise: strengthen clarity, logic, and completeness.
6. Stage 6 - Final polish: refine tone, style, formatting, and presentation.
7. Stage 7 - Evaluate: review the polished draft against your requirements and rubric.
8. Stage 8 - Revision pass: apply the evaluation feedback and produce the final improved version.

The stages are meant to build on one another, and each phase uses the appropriate agent:

| Stages | Purpose | Agent |
|---|---|---|
| 1-6 | Writing pipeline: scope, research, outline, draft, revise, and polish | Report agent |
| 7 | Evaluation and quality review | Eval agent |
| 8 | Revision pass based on evaluation feedback | Revise agent |

The evaluation step checks the draft against your requirements and rubric, then suggests improvements. If you want a stronger pass, you can run the evaluation workflow and then the revision pass.

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
- `report/07_evaluation/output/evaluation.md`

Final revised file:

- `report/08_revision_pass/output/revised_report.md`

## Rules

- Don't use the run_report.sh script, this is only used for administration