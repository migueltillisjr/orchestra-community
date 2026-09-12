## Rules

- Read and follow `website/shared/references/DIRECTIONS.md` before starting this stage.

## Process

- Read `website/shared/references/RUBRIC.md` before refining. Use the rubric and release gates to decide which evaluation findings are blockers, high-priority fixes, or acceptable residual gaps.
- Read `website/02_evaluate_site/output/EVALUATION.md` as the required refinement brief. If it is missing, stop and report that evaluation must be completed before refinement; do not invent failed findings.
- Copy the previous-stage respective output items in `website/02_evaluate_site/output/*` into `website/03_evaluate_site/output/*` as the current stage working artifact.
- Apply the corrections in the maintained website source, rebuild or regenerate the final page, and ensure the final deliverables are saved at `website/03_refine_site/output/*`.
- Re-run the affected checks and then perform the common verification checks in `website/shared/references/DIRECTIONS.md`.
- Append to file `website/03_refine_site/output/REFINE_CHANGES.md`. For each evaluation failure, summarize the finding, affected criterion or release gate, change made, verification performed, and any remaining limitation.


## Visual System

- Refine visual choices according to the shared visual direction in `website/shared/references/DIRECTIONS.md`, preserving successful elements and changing only documented failures.


## Quality Requirements

- `website/02_evaluate_site/output/EVALUATION.md` must exist and be the source for refinement decisions. Every documented failure must be addressed, intentionally deferred with a reason, or identified as blocked by missing organization approval.
- `website/02_evaluate_site/output/index.html` must remain unchanged as the previous-stage reference.
- **Always generate and save the final website to `website/03_refine_site/output/index.html`.** Do not return a chat-only design, use another final filename, or treat a file outside `website/03_refine_site/output/` as the delivery artifact.
- **Always write the refinement summary to `website/03_refine_site/output/REFINE_CHANGES.md`.** It must summarize what failed in evaluation and what changed as a result.
- `REFINE_CHANGES.md` must include the review date, evaluation source path, final output path, each failed criterion or gate, the observed failure, the implemented change, verification evidence, and unresolved content, rights, privacy, or approval gaps.
- The final page must open directly from `website/03_refine_site/output/index.html` with local assets.
- Apply the common verification checks in `website/shared/references/DIRECTIONS.md`; do not claim a finding was fixed or a release gate passed unless the corresponding check was actually run.
