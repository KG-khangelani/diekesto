#!/usr/bin/env wolframscript

projectRoot = DirectoryName[DirectoryName[$InputFileName]];

Get[FileNameJoin[{projectRoot, "src", "Morphologies.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "ModelCore.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "Metrics.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "ExportTools.wl"}]];

Needs["RuliologyUrbanDynamics`Morphologies`"];
Needs["RuliologyUrbanDynamics`ModelCore`"];
Needs["RuliologyUrbanDynamics`Metrics`"];
Needs["RuliologyUrbanDynamics`ExportTools`"];

experimentId = "pilot-sweep-001";
gridSize = 50;
steps = 100;
seed = 1234;
morphologyTypes = {"OpenGrid", "Barrier", "Corridor"};
baseParams = DefaultParameters[];

parameterVariants = AssociationThread[
  "variant-" <> ToString[#] & /@ Range[4],
  AssociationThread[
    {"RiskAccessDamage", "RiskActivityDamping"},
    #
  ] & /@ Tuples[{{0.02, 0.08}, {0.15, 0.30}}]
];

RunSweepCase[type_String, variantId_String, variantParams_Association] := Module[
  {params, morphology, initialState, history, metrics, runId},
  params = Join[baseParams, variantParams];
  runId = StringRiffle[{experimentId, type, variantId}, "-"];
  morphology = CreateMorphology[type, gridSize];
  initialState = CreateInitialState[gridSize, morphology, params, seed];
  history = RunSimulation[initialState, params, steps];
  metrics = HistoryMetrics[history];
  <|
    "RunId" -> runId,
    "MorphologyType" -> type,
    "VariantId" -> variantId,
    "Params" -> params,
    "Metrics" -> metrics,
    "FinalMetrics" -> Last[metrics]
  |>
]

sweepResults = Flatten[
  Table[
    RunSweepCase[type, variantId, parameterVariants[variantId]],
    {type, morphologyTypes},
    {variantId, Keys[parameterVariants]}
  ],
  1
];

timestamp = DateString[Now, {"Year", "Month", "Day", "-", "Hour", "Minute", "Second"}];
runBase = experimentId <> "-" <> timestamp;

finalMetricRows = Table[
  Join[
    <|
      "RunId" -> result["RunId"],
      "MorphologyType" -> result["MorphologyType"],
      "VariantId" -> result["VariantId"],
      "RiskAccessDamage" -> result["Params"]["RiskAccessDamage"],
      "RiskActivityDamping" -> result["Params"]["RiskActivityDamping"]
    |>,
    result["FinalMetrics"]
  ],
  {result, sweepResults}
];

summary = <|
  "ModelVersion" -> "Prototype 0.1",
  "ExperimentId" -> experimentId,
  "Seed" -> seed,
  "MorphologyTypes" -> morphologyTypes,
  "GridSize" -> gridSize,
  "Steps" -> steps,
  "ParameterVariants" -> parameterVariants,
  "RunCount" -> Length[sweepResults],
  "FinalMetrics" -> finalMetricRows,
  "OutputLocation" -> FileNameJoin[{projectRoot, "data"}]
|>;

trapComparison = ListLinePlot[
  ({#["Step"], #["TrapIndex"]} & /@ #["Metrics"]) & /@ sweepResults,
  PlotLegends -> (#[["RunId"]] & /@ sweepResults),
  Frame -> True,
  Axes -> False,
  FrameLabel -> {"Step", "TrapIndex"},
  ImageSize -> 900,
  PlotRange -> All
];

jsonPath = FileNameJoin[{projectRoot, "data", "runs", runBase <> ".json"}];
finalMetricsPath = FileNameJoin[{projectRoot, "data", "metrics", runBase <> "-final-metrics.csv"}];
trapFigurePath = FileNameJoin[{projectRoot, "data", "figures", runBase <> "-trap-index-sweep.png"}];

ExportRunJSON[summary, jsonPath];
ExportMetricsCSV[finalMetricRows, finalMetricsPath];
ExportFigure[trapComparison, trapFigurePath];

requiredOutputs = {jsonPath, finalMetricsPath, trapFigurePath};
missingOutputs = Select[requiredOutputs, ! FileExistsQ[#] || FileByteCount[#] == 0 &];
If[Length[missingOutputs] > 0,
  Print["Export failed for: ", missingOutputs];
  Quit[1]
];

Print["Completed ", experimentId];
Print["Run summary: ", jsonPath];
Print["Final metrics: ", finalMetricsPath];
Print["Figure: ", trapFigurePath];
