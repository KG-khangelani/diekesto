# Prototype 0.1 Memo

Date: 2026-06-04

## Purpose

This memo records the first verified Prototype 0.1 smoke run and the first morphology comparison. The model remains a synthetic exploratory cellular automaton. These outputs do not validate claims about any real city, settlement, or historical process.

## Verification Commands

```powershell
wolframscript -file examples\minimal_run.wls
wolframscript -code 'TestReport[FileNames["*.wlt", "tests"]]'
wolframscript -file examples\compare_morphologies.wls
```

## Smoke-Test Result

The minimal run completed successfully for a 50 by 50 OpenGrid simulation with seed `1234` and 100 steps.

Generated outputs:

- `data/runs/minimal-opengrid-001-20260604-141931.json`
- `data/metrics/minimal-opengrid-001-20260604-141931-metrics.csv`
- `data/figures/minimal-opengrid-001-20260604-141931-fields.png`
- `data/figures/minimal-opengrid-001-20260604-141931-trap-index.png`

## Test Result

All current Wolfram tests passed:

- `tests/ModelCoreTests.wlt`
- `tests/MorphologyTests.wlt`
- `tests/MetricsTests.wlt`

The tests currently verify package loading, morphology dimensions and differences, seeded reproducibility, simulation length, value clipping, entropy calculation, and trap-index range.

## First Morphology Comparison

The first comparison used identical parameters, grid size, seed, initial condition, and step count across three synthetic morphologies:

- `OpenGrid`
- `Barrier`
- `Corridor`

Generated outputs:

- `data/runs/morphology-comparison-001-20260604-142122.json`
- `data/metrics/morphology-comparison-001-20260604-142122-metrics.csv`
- `data/metrics/morphology-comparison-001-20260604-142122-final-metrics.csv`
- `data/figures/morphology-comparison-001-20260604-142122-fields.png`
- `data/figures/morphology-comparison-001-20260604-142122-trap-index-comparison.png`

Final metrics from this run:

| Morphology | Step | TrapIndex | PMean | AMean | BMean | RMean |
|---|---:|---:|---:|---:|---:|---:|
| OpenGrid | 100 | 1.0 | 0.000179 | 0.0 | 0.00000000234 | 0.976533 |
| Barrier | 100 | 1.0 | 0.000159 | 0.0 | 0.00000000199 | 0.975863 |
| Corridor | 100 | 1.0 | 0.00000658 | 0.0 | 0.0000000000146 | 0.965042 |

## Interpretation

Under the current default parameters, all three synthetic morphologies converge to a high-risk, low-activity, low-pressure state by step 100. The `TrapIndex` reaches `1.0` in each case because every cell satisfies the current trap condition `R > 0.7` and `B < 0.3`.

This is a model-behavior finding, not an empirical claim. It suggests that the default rule weights may be too risk-dominant for morphology differences to remain visible after 100 steps. The corridor case retains slightly lower mean risk and higher risk entropy, but the end-state regime is still effectively collapsed under the current trap metric.

## What Worked

- Wolfram packages load from command-line scripts.
- Seeded initialization is reproducible.
- OpenGrid, Barrier, and Corridor morphologies run through the same model path.
- JSON, CSV, and PNG exports are created and non-empty.
- The current test suite passes.

## What Failed Earlier

Before hardening, metric export could silently produce malformed CSV rows and zero-byte JSON when metric associations were invalid. That issue has been fixed in `src/Metrics.wl`, and `examples/minimal_run.wls` now fails if required exports are missing or empty.

## Limitations

- Prototype 0.1 is synthetic only.
- No GIS, real Cape Town data, dashboard, machine learning, calibration, or empirical validation is included.
- Current defaults appear to drive all tested morphologies into the same high-risk trap regime by step 100.
- The trap metric is intentionally simple and may be too coarse for later regime classification.
- The current morphology comparison is one seed and one parameter set, so it is a smoke comparison rather than a rule-space result.

## Next Step

The next step is a deliberately small parameter sweep to identify whether nearby parameter values preserve activity/accessibility longer or produce distinct morphology-conditioned outcomes. The sweep should remain synthetic and should record all parameters, seeds, morphologies, metrics, and output paths.
