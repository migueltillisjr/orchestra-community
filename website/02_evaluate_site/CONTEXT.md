## Rules

- Read and follow `website/shared/references/DIRECTIONS.md` before starting this stage.
- Use the index.html and respective site resources form local disk at `website/01_generate_site/output/` for evaluation items.
- Copy the previous-stage website html and respective items in `website/01_generate_site/output/*` into `website/02_evaluate_site/output/*` as the evaluation-stage working artifact.

## Process

1. Read files in `website/01_generate_site/output/*`.
2. Run the evaluation against `website/01_generate_site/output/*` and its source using the common verification checks in `website/shared/references/RUBRIC.md`.
3. Record findings in `website/02_evaluate_site/output/EVALUATION.md`, ordered by severity. Include the criterion, observed evidence, user impact, affected viewport or state, and a concrete recommendation.


## Quality Requirements

- `website/01_generate_site/output/index.html` must remain unchanged and available as the baseline reference.
- `website/02_evaluate_site/output/index.html` must be the page used for evaluation evidence and must open directly from disk with its local assets.
- `website/02_evaluate_site/output/EVALUATION.md` must identify the review date, baseline path, viewports tested, evaluation methods, weighted score, failed release gates, findings by severity, and unresolved content or approval gaps.