# Ruliology of Post-Segregation Urban Dynamics

This repository contains Wolfram Language notebooks and packages for exploring a constrained rule-space of synthetic urban-economic cellular automata.

The project investigates how local coupling rules and spatial morphology generate macro-level regimes such as homogenization, stable heterogeneity, polarization, oscillation, volatility, localized traps, and recovery.

This is an exploratory research framework. Prototype versions do not predict any real city or settlement. They generate synthetic behaviours for classification, hypothesis formation, and later empirical extension.

## Research Purpose

Prototype 0.1 builds a small, reproducible rule-space laboratory. The first model uses a synthetic two-dimensional lattice and asks how local update rules and morphology-conditioned accessibility can produce qualitative macro-regimes.

## Model Fields

- `P`: population pressure, interpreted as a synthetic analogue for occupancy or crowding tendency.
- `A`: accessibility, interpreted as a process abstraction for movement, permeability, and access.
- `B`: economic activity, interpreted as local activity intensity or opportunity density.
- `R`: disruption or risk load, interpreted as instability, friction, hazard, or service stress.

All fields are continuous numeric grids clipped to `[0, 1]`.

## Repository Structure

- `src/`: reusable Wolfram Language packages.
- `notebooks/`: research notebooks for model exploration and interpretation.
- `examples/`: command-line example runs.
- `tests/`: Wolfram VerificationTest files.
- `docs/`: model semantics, rule schema, morphology schema, and workflow notes.
- `data/`: generated run outputs, metrics, figures, and exports.

## Quick Start

Run the minimal simulation from the repository root:

```powershell
wolframscript -file examples/minimal_run.wls
```

This creates a seeded 50x50 open-grid run for 100 timesteps and exports metadata, metrics, and figures into `data/`.

## Prototype Status

Prototype 0.1 includes synthetic morphologies, a four-field local update model, basic metrics, visual panels, a minimal runner, and tests. GIS, empirical calibration, machine learning, dashboards, and real settlement data are intentionally out of scope for this version.

## Development Principles

- Keep notebooks for research thinking and `.wl` packages for reusable logic.
- Record seeds, parameters, morphology, grid size, steps, and output locations for every experiment.
- Treat all outputs as synthetic exploratory results.
- Avoid claims that the model predicts or explains real urban behaviour.

## Citation / Academic Status

Working title: *Ruliology of Post-Segregation Urban Dynamics: Exploring the Rule Universe*.

Author / researcher: Khangelani Mgoqi.

## License

License terms are not yet finalized.
