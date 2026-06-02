# CODEX_HANDOVER.md

# Ruliology of Post-Segregation Urban Dynamics
## Codex Handover Documentation

**Project status:** pre-repo / repo bootstrap  
**Primary implementation target:** Wolfram Language + Wolfram Notebooks  
**Secondary tooling:** optional Python for batch analysis, export, and report generation  
**Research mode:** synthetic computational experimentation first; GIS/data calibration later  
**Author / researcher:** Khangelani Mgoqi  
**Working title:** *Ruliology of Post-Segregation Urban Dynamics: Exploring the Rule Universe*

---

## 0. Purpose of this handover

This document is written for Codex or another coding agent that will help start and develop the repository.

The task is not to build a generic urban simulation toy. The task is to build a reproducible research codebase for a thesis project.

The core project is a **Wolfram-notebook-based rule-space laboratory** for exploring how local urban-economic update rules and spatial morphology generate macro-level regimes such as:

- homogenization
- stable heterogeneity
- persistent polarization
- oscillatory dynamics
- chaotic volatility
- localized high-disruption / low-activity traps
- recovery or resilience after shocks

The work should begin with **synthetic cellular automata experiments**, not real GIS data.

The immediate goal is **Prototype 0.1**: a minimal but rigorous Wolfram Language implementation of a multi-field cellular automaton with visualization, metrics, and repeatable experiment runs.

---

## 1. Research framing Codex must preserve

### 1.1 Main research object

The project investigates a constrained rule-space approach to urban dynamics.

The model does **not** try to predict Cape Town, Soweto, Khayelitsha, or any real settlement at first.

Instead, it asks:

> Within a constrained family of urban-economic local update rules, what qualitative macro-regimes emerge, and how does spatial morphology shift regime membership?

The model is therefore an exploratory computational microscope.

### 1.2 What the model represents

The first model uses a 2D lattice. Each cell has four continuous fields:

| Symbol | Field name | Initial interpretation | Range |
|---|---|---|---|
| `P` | population pressure | occupancy, density pressure, settlement demand, crowding tendency | `[0, 1]` |
| `A` | accessibility | permeability, connection, ease of movement, access to opportunity | `[0, 1]` |
| `B` | economic activity | local activity intensity, opportunity density, exchange potential | `[0, 1]` |
| `R` | disruption / risk load | instability, friction, hazard, service failure, stress load | `[0, 1]` |

Important: these fields are **operational abstractions**, not direct empirical claims. The first prototype must keep them synthetic.

### 1.3 What “ruliology” means here

Use ruliology as a method: systematic exploration of a family of possible rules and their generated behaviours.

Do **not** implement grand claims such as “simple rules explain all urban reality.”

The project stance is:

> Ruliology is used as a disciplined method for exploring rule spaces, classifying emergent behaviour, and identifying robust regime classes. It is not used as a metaphysical claim that simple rules fully explain cities.

### 1.4 Conceptual ancestry

The codebase should be shaped by these modelling ideas:

1. Schelling-style micro-to-macro logic: local rules can generate surprising aggregate spatial patterns.
2. Urban CA caution: cells, states, and transition rules need explicit meanings.
3. CA/ABM urban modelling context: urban systems are complex, dynamic, spatial, and path-dependent.
4. Wolfram-style computational exploration: classify generated behaviours across rule spaces.
5. Local South African relevance: post-segregation urban systems are underrepresented in computational urban modelling, but the first implementation remains synthetic.

---

## 2. Non-negotiable development principles

### 2.1 Build the smallest executable artefact first

Do not begin with:

- GIS import
- shapefiles
- remote sensing
- ML models
- full Cape Town data
- CUDA/GPU optimization
- complex ABM agents
- dashboards
- web apps

Begin with:

- one 2D grid
- four fields
- one update function
- three synthetic morphologies
- deterministic seeded randomness
- basic visualizations
- basic metrics
- experiment export

### 2.2 Notebooks are for thinking; packages are for reusable code

Wolfram Notebooks should show:

- research intention
- assumptions
- model equations
- executable calls
- plots
- interpretation notes

Reusable logic should live in `.wl` package files.

### 2.3 Every experiment must be reproducible

Every run must record:

- model version
- random seed
- morphology type
- grid size
- number of timesteps
- parameter values
- initial condition method
- output metrics
- output location

### 2.4 Avoid semantic overclaiming

Code comments and docs must avoid phrases such as:

- “this proves post-apartheid instability”
- “this predicts informal settlement growth”
- “this models actual people”
- “this represents real economic behaviour”

Use safer language:

- “synthetic analogue”
- “process abstraction”
- “rule-induced regime”
- “morphology-conditioned outcome”
- “exploratory simulation”
- “candidate mechanism”

---

## 3. Recommended repository structure

Create the repo with this structure:

```text
ruliology-urban-dynamics/
  README.md
  CODEX_HANDOVER.md
  LICENSE
  .gitignore

  notebooks/
    00_research_map.nb
    01_minimal_model.nb
    02_morphologies.nb
    03_rule_sweeps.nb
    04_metrics.nb
    05_atlas_generation.nb
    06_interpretation_notes.nb

  src/
    ModelCore.wl
    Morphologies.wl
    Metrics.wl
    SweepRunner.wl
    AtlasTools.wl
    ExportTools.wl

  tests/
    ModelCoreTests.wlt
    MorphologyTests.wlt
    MetricsTests.wlt

  data/
    runs/
    metrics/
    figures/
    exports/
    README.md

  docs/
    variable-semantics.md
    rule-schema.md
    morphology-schema.md
    experiment-log-template.md
    thesis-claims.md
    notebook-workflow.md

  scripts/
    run_pilot.wls
    export_figures.wls

  examples/
    minimal_run.wls
    parameter_sweep_example.wls
```

If the repo name already exists, adapt the structure but preserve the logical separation.

---

## 4. Wolfram Language package responsibilities

### 4.1 `src/ModelCore.wl`

Responsible for:

- model state representation
- initialization
- neighbourhood operations
- one-step update
- multi-step simulation
- parameter validation
- clipping values to `[0, 1]`

Suggested public functions:

```wolfram
CreateInitialState[gridSize_Integer, morphology_, params_Association, seed_Integer] := ...
StepModel[state_Association, params_Association] := ...
RunSimulation[initialState_Association, params_Association, steps_Integer] := ...
ValidateParameters[params_Association] := ...
ClipField[field_] := ...
```

Model state should be represented as an association:

```wolfram
<|
  "P" -> pGrid,
  "A" -> aGrid,
  "B" -> bGrid,
  "R" -> rGrid,
  "Morphology" -> morphology,
  "Step" -> t,
  "Seed" -> seed,
  "Params" -> params
|>
```

Each field is a numeric 2D array with dimensions `{n, n}`.

### 4.2 `src/Morphologies.wl`

Responsible for generating synthetic morphology masks.

Suggested public functions:

```wolfram
CreateMorphology[type_String, gridSize_Integer, opts___] := ...
OpenGridMorphology[gridSize_Integer] := ...
BarrierMorphology[gridSize_Integer, opts___] := ...
CorridorMorphology[gridSize_Integer, opts___] := ...
BottleneckMorphology[gridSize_Integer, opts___] := ...
MorphologyToAccessibility[morphology_Association] := ...
```

Morphology should return an association:

```wolfram
<|
  "Type" -> "Barrier",
  "GridSize" -> 50,
  "AccessMask" -> matrix,
  "BarrierMask" -> matrix,
  "Metadata" -> <|...|>
|>
```

Minimum morphologies for Prototype 0.1:

1. `OpenGrid`
2. `Barrier`
3. `Corridor`

Later morphologies can include:

- radial city
- fragmented patches
- formal/informal adjacency
- transport corridor
- service-node anchor
- random bottleneck network
- imported raster morphology

### 4.3 `src/Metrics.wl`

Responsible for computing observables.

Suggested public functions:

```wolfram
FieldMean[state_Association, field_String] := ...
FieldVariance[state_Association, field_String] := ...
FieldEntropy[state_Association, field_String] := ...
SpatialClusteringIndex[state_Association, field_String] := ...
TemporalVolatility[history_List, field_String] := ...
TrapIndex[state_Association] := ...
RegimeSummary[history_List] := ...
```

Minimum metrics for Prototype 0.1:

| Metric | Meaning |
|---|---|
| mean of each field | global state |
| variance of each field | heterogeneity |
| entropy of each field | disorder / spread of values |
| high-R low-B trap index | trapped disruption / low activity pocket |
| volatility | change magnitude over time |

A simple trap index can be:

```text
TrapIndex = proportion of cells where R > 0.7 and B < 0.3
```

### 4.4 `src/SweepRunner.wl`

Responsible for parameter sweeps.

Suggested public functions:

```wolfram
RunExperiment[experiment_Association] := ...
RunSweep[sweepSpec_Association] := ...
GenerateParameterGrid[paramSpec_Association] := ...
SaveExperimentResult[result_Association, path_String] := ...
```

Experiment spec format:

```wolfram
<|
  "ExperimentId" -> "pilot-001",
  "GridSize" -> 50,
  "Steps" -> 100,
  "Seed" -> 1234,
  "MorphologyType" -> "OpenGrid",
  "Params" -> <|
    "AccessActivityCoupling" -> 0.4,
    "ActivityPressureCoupling" -> 0.3,
    "PressureRiskCoupling" -> 0.3,
    "RiskActivityDamping" -> 0.4,
    "RiskDiffusion" -> 0.1,
    "AccessDiffusion" -> 0.1,
    "ShockNoise" -> 0.02,
    "SaturationStrength" -> 0.2
  |>
|>
```

### 4.5 `src/AtlasTools.wl`

Responsible for turning results into visual atlases.

Suggested public functions:

```wolfram
FieldPlot[state_Association, field_String] := ...
StatePanel[state_Association] := ...
HistoryPanel[history_List] := ...
MetricTimeSeriesPlot[metrics_List, metric_String] := ...
RegimeThumbnail[result_Association] := ...
CreateAtlas[results_List] := ...
```

Initial visualizations:

- heatmap of `P`
- heatmap of `A`
- heatmap of `B`
- heatmap of `R`
- 2×2 panel of fields
- metric time series
- final-state thumbnails across parameter settings

### 4.6 `src/ExportTools.wl`

Responsible for saving outputs.

Suggested public functions:

```wolfram
ExportRunJSON[result_Association, path_String] := ...
ExportMetricsCSV[metrics_List, path_String] := ...
ExportFigure[figure_, path_String] := ...
ExportNotebookReport[result_Association, path_String] := ...
```

---

## 5. Prototype 0.1 model design

### 5.1 Minimal update logic

Each timestep updates the fields using local neighbourhood averages and coupling parameters.

Use Moore neighbourhood radius 1 for the first prototype.

Let:

```text
N[X] = local neighbourhood mean of field X
```

A possible first update rule:

```text
A(t+1) = clip[A + accessDiffusion * (N[A] - A) - riskAccessDamage * R]

B(t+1) = clip[
  B
  + accessActivityCoupling * A * (1 - B)
  - riskActivityDamping * R * B
  + activityDiffusion * (N[B] - B)
]

P(t+1) = clip[
  P
  + activityPressureCoupling * B * (1 - P)
  - riskPressureRepulsion * R * P
  + pressureDiffusion * (N[P] - P)
]

R(t+1) = clip[
  R
  + pressureRiskCoupling * P * (1 - A)
  - activityRiskAbsorption * B * R
  + riskDiffusion * (N[R] - R)
  + shockNoise
]
```

Important:

- use seeded random noise
- keep all values in `[0, 1]`
- document every equation
- keep formula modular so it can be changed later

### 5.2 Suggested first parameter defaults

```wolfram
DefaultParams = <|
  "AccessDiffusion" -> 0.08,
  "ActivityDiffusion" -> 0.05,
  "PressureDiffusion" -> 0.04,
  "RiskDiffusion" -> 0.06,

  "AccessActivityCoupling" -> 0.35,
  "ActivityPressureCoupling" -> 0.30,
  "PressureRiskCoupling" -> 0.25,

  "RiskActivityDamping" -> 0.30,
  "RiskPressureRepulsion" -> 0.15,
  "RiskAccessDamage" -> 0.08,
  "ActivityRiskAbsorption" -> 0.12,

  "ShockNoise" -> 0.015,
  "SaturationStrength" -> 0.20
|>
```

These are not truth claims. They are bootstrapping values.

### 5.3 Initial conditions

Prototype 0.1 should support at least:

1. random low-level initialization
2. central activity anchor
3. corridor activity anchor
4. risk shock region
5. morphology-derived accessibility

Example:

```text
P: low random field, perhaps with small clusters
A: derived from morphology
B: activity around access corridors or anchor points
R: low background risk with optional shock patch
```

---

## 6. Notebook workflow

Each notebook must follow this pattern:

```text
1. Purpose
2. Research question
3. Assumptions
4. Parameters
5. Code execution
6. Visual output
7. Metric output
8. Interpretation note
9. Next questions
```

### 6.1 `00_research_map.nb`

Purpose:

- high-level project map
- diagram of model architecture
- list of fields
- list of morphologies
- current milestones
- research diary

### 6.2 `01_minimal_model.nb`

Purpose:

- load `ModelCore.wl`
- create initial state
- run 100 timesteps
- visualize final state
- plot metrics over time
- write first interpretation

Acceptance criteria:

- one command can run the simulation
- final 2×2 field plot works
- metrics export works

### 6.3 `02_morphologies.nb`

Purpose:

- generate open, barrier, and corridor morphologies
- convert morphology to accessibility field
- compare simulations under identical rules

Acceptance criteria:

- same parameter set can run on all three morphologies
- output shows how morphology changes outcomes

### 6.4 `03_rule_sweeps.nb`

Purpose:

- run small parameter sweeps
- begin phase-space mapping

Acceptance criteria:

- at least 30 runs exported
- result files include metadata
- plots show how at least two parameters affect outcomes

### 6.5 `04_metrics.nb`

Purpose:

- refine observables
- validate metric definitions against known patterns

Acceptance criteria:

- metrics behave sensibly on synthetic known cases
- trap index, volatility, variance, and entropy are implemented

### 6.6 `05_atlas_generation.nb`

Purpose:

- generate thumbnails and summary panels
- classify regime candidates

Acceptance criteria:

- one generated atlas figure from a pilot sweep
- one table of run ID, parameters, morphology, metrics, candidate regime

### 6.7 `06_interpretation_notes.nb`

Purpose:

- bridge code outputs to thesis writing
- record claims and counterclaims
- record what the model cannot yet say

Acceptance criteria:

- short text notes for each pilot result group
- no overclaiming
- each claim tied to a run or metric

---

## 7. Documentation files to create

### 7.1 `docs/variable-semantics.md`

Must define:

- what each field means
- what each field does not mean
- allowed range
- update role
- likely empirical proxy later

Example structure:

```markdown
# Variable Semantics

## P: Population Pressure

Operational meaning:
...

Not claimed:
...

Possible later empirical proxies:
...
```

### 7.2 `docs/rule-schema.md`

Must define:

- update equations
- parameter definitions
- allowable ranges
- interpretation
- expected qualitative effect

### 7.3 `docs/morphology-schema.md`

Must define:

- synthetic morphology types
- access mask
- barrier mask
- corridor mask
- how morphology affects initial `A`

### 7.4 `docs/experiment-log-template.md`

Must provide a reusable experiment log format.

```markdown
# Experiment Log

## Experiment ID

## Date

## Purpose

## Hypothesis

## Parameters

## Morphology

## Seed

## Observed behaviour

## Metrics

## Interpretation

## Problems

## Next run
```

### 7.5 `docs/thesis-claims.md`

Must separate:

```markdown
# Supported Claims

# Tentative Claims

# Unsupported / Forbidden Claims

# Future Work Claims
```

This file is important because the research has a politically and historically sensitive motivation. It should prevent semantic drift and overclaiming.

### 7.6 `docs/notebook-workflow.md`

Must explain:

- how to run notebooks
- how to load packages
- how to export results
- how to keep notebooks clean
- how to write interpretation notes

---

## 8. First Codex task list

Codex should complete these tasks in order.

### Task 1: Bootstrap repo structure

Create the folder structure listed above.

Create:

- `README.md`
- `.gitignore`
- `CODEX_HANDOVER.md`
- `/src`
- `/notebooks`
- `/docs`
- `/tests`
- `/scripts`
- `/examples`
- `/data`

Add placeholder `README.md` files in empty folders where needed.

### Task 2: Create `.gitignore`

Include ignores for:

```gitignore
# Wolfram
*.mx
*.wl~
*.nb~
*.bak
*.log

# OS/editor
.DS_Store
Thumbs.db
.vscode/
.idea/

# Data outputs
data/runs/*
data/metrics/*
data/figures/*
data/exports/*

# Keep folder placeholders
!data/runs/.gitkeep
!data/metrics/.gitkeep
!data/figures/.gitkeep
!data/exports/.gitkeep
```

### Task 3: Implement `src/Morphologies.wl`

Minimum functions:

- `OpenGridMorphology`
- `BarrierMorphology`
- `CorridorMorphology`
- `CreateMorphology`
- `MorphologyToAccessibility`

### Task 4: Implement `src/ModelCore.wl`

Minimum functions:

- `DefaultParameters`
- `ValidateParameters`
- `ClipField`
- `NeighbourhoodMean`
- `CreateInitialState`
- `StepModel`
- `RunSimulation`

### Task 5: Implement `src/Metrics.wl`

Minimum functions:

- `FieldMean`
- `FieldVariance`
- `FieldEntropy`
- `TrapIndex`
- `StateMetrics`
- `HistoryMetrics`

### Task 6: Implement `src/AtlasTools.wl`

Minimum functions:

- `FieldPlot`
- `StatePanel`
- `MetricTimeSeriesPlot`
- `HistorySummaryPanel`

### Task 7: Create `examples/minimal_run.wls`

This script should:

1. load packages
2. create a 50×50 open-grid morphology
3. initialize state with seed 1234
4. run 100 timesteps
5. compute metrics
6. export JSON/CSV/PNG outputs

### Task 8: Create basic tests

Tests should verify:

- generated fields have dimensions `{n, n}`
- all field values remain in `[0, 1]`
- same seed produces same initial state
- different morphology types produce different access masks
- `RunSimulation` returns expected number of states
- `TrapIndex` is between 0 and 1

---

## 9. Acceptance criteria for Prototype 0.1

Prototype 0.1 is complete when:

- repo structure exists
- Wolfram packages load without syntax errors
- `examples/minimal_run.wls` runs end-to-end
- a 50×50 simulation can run for 100 timesteps
- OpenGrid, Barrier, and Corridor morphologies work
- outputs include:
  - final field plots
  - metric time series
  - run metadata
  - metrics table
- tests pass
- documentation files exist with meaningful first content
- no claims are made that the model predicts real Cape Town behaviour

---

## 10. Suggested README content

The `README.md` should say:

```markdown
# Ruliology of Post-Segregation Urban Dynamics

This repository contains Wolfram Language notebooks and packages for exploring a constrained rule-space of synthetic urban-economic cellular automata.

The project investigates how local coupling rules and spatial morphology generate macro-level regimes such as homogenization, stable heterogeneity, polarization, oscillation, volatility, localized traps, and recovery.

This is an exploratory research framework. Prototype versions do not predict any real city or settlement. They generate synthetic behaviours for classification, hypothesis formation, and later empirical extension.
```

Include sections:

- Research purpose
- Model fields
- Repository structure
- Quick start
- Prototype status
- Development principles
- Citation / academic status
- License

---

## 11. Recommended Wolfram coding style

Use readable Wolfram Language.

Prefer explicit associations over positional lists.

Good:

```wolfram
state["P"]
params["AccessActivityCoupling"]
```

Avoid opaque positional code:

```wolfram
state[[1]]
params[[3]]
```

Use pure functions where useful, but do not make code cryptic.

Every exported public function should have a short comment explaining purpose.

---

## 12. Suggested package template

Use this pattern:

```wolfram
BeginPackage["RuliologyUrbanDynamics`ModelCore`"]

CreateInitialState::usage = "CreateInitialState[gridSize, morphology, params, seed] creates an initial model state.";
StepModel::usage = "StepModel[state, params] advances the model by one timestep.";
RunSimulation::usage = "RunSimulation[initialState, params, steps] runs the model for a number of steps.";

Begin["`Private`"]

(* implementation *)

End[]
EndPackage[]
```

Use package names:

```wolfram
RuliologyUrbanDynamics`ModelCore`
RuliologyUrbanDynamics`Morphologies`
RuliologyUrbanDynamics`Metrics`
RuliologyUrbanDynamics`AtlasTools`
RuliologyUrbanDynamics`SweepRunner`
RuliologyUrbanDynamics`ExportTools`
```

---

## 13. Example Codex implementation prompt

Use this prompt when starting Codex:

```text
You are working on a Wolfram Language research repository called `ruliology-urban-dynamics`.

Read `CODEX_HANDOVER.md` first and follow it strictly.

Start by creating the repo structure, then implement Prototype 0.1:
- synthetic 2D multi-field cellular automaton
- fields P, A, B, R in [0,1]
- morphologies: OpenGrid, Barrier, Corridor
- seeded initial conditions
- one-step and multi-step simulation
- basic metrics
- basic plots
- minimal run script
- basic tests

Do not add GIS, ML, web app, dashboard, CUDA, or real Cape Town data yet.

Keep the model synthetic and exploratory. Avoid claims that the model predicts real urban behaviour.

After each major change:
1. summarize what changed
2. list files changed
3. explain how to run it
4. list known limitations
```

---

## 14. First issue backlog

Create these GitHub issues if using GitHub.

### Issue 1: Bootstrap repository structure

**Goal:** Create initial folders, README, gitignore, docs placeholders.

**Acceptance criteria:**

- folder structure exists
- `.gitignore` added
- `README.md` has project framing
- `CODEX_HANDOVER.md` added

### Issue 2: Implement synthetic morphologies

**Goal:** Implement OpenGrid, Barrier, and Corridor morphology generators.

**Acceptance criteria:**

- functions return association structure
- access masks are numeric matrices
- each morphology visualizes correctly
- tests verify dimensions and mask differences

### Issue 3: Implement model core

**Goal:** Implement four-field cellular automaton update logic.

**Acceptance criteria:**

- initial state generated
- one-step update works
- multi-step simulation works
- values stay in `[0,1]`
- seeded reproducibility works

### Issue 4: Implement metrics

**Goal:** Compute basic observables over states and histories.

**Acceptance criteria:**

- mean, variance, entropy, trap index
- metric history table
- tests pass

### Issue 5: Build minimal run example

**Goal:** Run a complete 100-step simulation from command line.

**Acceptance criteria:**

- script loads packages
- runs model
- exports metrics
- exports at least one figure
- documents command to run

### Issue 6: Generate first atlas notebook

**Goal:** Create a notebook showing morphologies, runs, metrics, and interpretation notes.

**Acceptance criteria:**

- all three morphologies compared
- same parameters used for each
- final field panels shown
- metric time-series shown
- short interpretation written

---

## 15. Development sequence

Recommended sequence:

```text
Milestone A: Repo skeleton
Milestone B: Synthetic morphologies
Milestone C: Model core
Milestone D: Metrics
Milestone E: Minimal run script
Milestone F: Notebook 01
Milestone G: Morphology comparison
Milestone H: Small parameter sweep
Milestone I: Atlas generation
Milestone J: Thesis interpretation notes
```

Do not jump to Milestone H before C, D, and E work.

---

## 16. Later roadmap, not for Prototype 0.1

These are future directions. Do not implement unless explicitly requested.

### 16.1 Prototype 0.2

- parameter sweeps
- regime classification
- atlas thumbnails
- experiment metadata store
- more morphologies

### 16.2 Prototype 0.3

- improved metrics
- phase diagrams
- shock experiments
- sensitivity analysis
- robustness checks

### 16.3 Prototype 0.4

- optional Python exports
- DuckDB/SQLite experiment registry
- static HTML reports

### 16.4 Prototype 1.0

- GIS raster import
- synthetic-to-real morphology comparison
- Cape Town-inspired abstract morphology
- calibration experiments
- possible ML component

---

## 17. Possible Wolfram Notebook Assistant workflow

When using Wolfram Notebook Assistant, use it for:

- explaining Wolfram syntax
- converting equations into code
- refactoring notebook cells into package functions
- generating `Manipulate` interfaces
- creating visualizations
- writing tests
- debugging package loading issues

Do not use it to decide the thesis claims.

Useful prompts:

```text
Convert this local update equation into a Wolfram Language function over 2D numeric arrays.
```

```text
Refactor this notebook code into a package function with usage messages.
```

```text
Create a Manipulate interface for these parameters so I can see how the four fields evolve.
```

```text
Write tests that verify all field values remain in [0,1] after 100 timesteps.
```

```text
Explain this Wolfram Language function line by line and suggest a clearer implementation.
```

---

## 18. Research integrity constraints

The project is politically and historically sensitive.

The code and docs must preserve these distinctions:

| Safe claim | Unsafe claim |
|---|---|
| “The model explores synthetic mechanisms.” | “The model explains apartheid spatial dynamics.” |
| “Morphology can condition rule outcomes.” | “This proves segregation caused stability.” |
| “The model generates candidate regimes.” | “The model predicts post-apartheid instability.” |
| “The variables are operational abstractions.” | “The variables directly measure lived reality.” |
| “This is a foundation for later empirical work.” | “This is already a validated urban model.” |

If writing documentation, always choose the safe claim.

---

## 19. Technical uncertainty notes

Codex should expect possible issues with:

- Wolfram package path configuration
- running `.wls` scripts without Wolfram Engine installed
- exporting notebook visuals headlessly
- testing `.wlt` files depending on local Wolfram setup
- image export paths
- keeping notebooks version-control friendly

Where possible, write code so that package functions can be tested without notebook front-end dependencies.

---

## 20. Immediate “definition of done”

The first successful repo state is:

```text
A user can clone the repo, open the minimal notebook or run the minimal script, generate a 50×50 four-field synthetic urban CA simulation, view the four fields over time, compute basic metrics, and export the results with metadata.
```

That is the first mountain.

Everything else comes later.

---

## 21. Final instruction to Codex

Build cleanly, incrementally, and defensibly.

The thesis will grow from the behaviour of the machine.

Do not over-engineer the first version.

Do not chase real data yet.

Do not bury the researcher in complex architecture before the first visual simulation exists.

The first priority is a small working model that can be seen, measured, broken, and improved.
