# Prototype 0.1 Smoke Test

This smoke test verifies the current synthetic Prototype 0.1 implementation. It does not use GIS, machine learning, dashboards, real Cape Town data, or parameter sweeps.

## Prerequisites

- WolframScript available on `PATH`
- Commands run from the repository root

## Run the Minimal Example

```powershell
wolframscript -file examples\minimal_run.wls
```

The script runs a 50 by 50 OpenGrid simulation for 100 steps with seed `1234`.

Expected outputs:

- `data/runs/minimal-opengrid-001-<timestamp>.json`
- `data/metrics/minimal-opengrid-001-<timestamp>-metrics.csv`
- `data/figures/minimal-opengrid-001-<timestamp>-fields.png`
- `data/figures/minimal-opengrid-001-<timestamp>-trap-index.png`

The script exits with code `1` if any required export is missing or empty.

## Run Tests

```powershell
wolframscript -code 'TestReport[FileNames["*.wlt", "tests"]]'
```

Expected result: all tests in `tests/ModelCoreTests.wlt`, `tests/MorphologyTests.wlt`, and `tests/MetricsTests.wlt` succeed.

## Current Scope

This smoke test only confirms package loading, seeded synthetic initialization, basic morphologies, model stepping, metrics, and file export. It does not validate the model against real urban data or support interpretive claims about actual settlements.
