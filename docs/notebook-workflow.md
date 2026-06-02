# Notebook Workflow

Each notebook should follow this structure:

1. Purpose
2. Research question
3. Assumptions
4. Parameters
5. Code execution
6. Visual output
7. Metric output
8. Interpretation note
9. Next questions

## Loading Packages

From a notebook in `notebooks/`, set the project root and load packages:

```wolfram
projectRoot = ParentDirectory[NotebookDirectory[]];
Get[FileNameJoin[{projectRoot, "src", "Morphologies.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "ModelCore.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "Metrics.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "AtlasTools.wl"}]];
```

## Keeping Notebooks Clean

- Keep reusable functions in `src/`.
- Keep generated files in `data/`.
- Write interpretation notes as cautious synthetic findings.
- Record seed, grid size, morphology, steps, and parameters for every run.
