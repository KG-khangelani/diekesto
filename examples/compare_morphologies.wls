#!/usr/bin/env wolframscript

projectRoot = DirectoryName[DirectoryName[$InputFileName]];

Get[FileNameJoin[{projectRoot, "src", "Morphologies.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "ModelCore.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "Metrics.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "AtlasTools.wl"}]];
Get[FileNameJoin[{projectRoot, "src", "ExportTools.wl"}]];

Needs["RuliologyUrbanDynamics`Morphologies`"];
Needs["RuliologyUrbanDynamics`ModelCore`"];
Needs["RuliologyUrbanDynamics`Metrics`"];
Needs["RuliologyUrbanDynamics`AtlasTools`"];
Needs["RuliologyUrbanDynamics`ExportTools`"];

experimentId = "morphology-comparison-001";
gridSize = 50;
steps = 100;
seed = 1234;
params = DefaultParameters[];
morphologyTypes = {"OpenGrid", "Barrier", "Corridor"};

RunForMorphology[type_String] := Module[{morphology, initialState, history, metrics},
  morphology = CreateMorphology[type, gridSize];
  initialState = CreateInitialState[gridSize, morphology, params, seed];
  history = RunSimulation[initialState, params, steps];
  metrics = HistoryMetrics[history];
  <|"MorphologyType" -> type, "Morphology" -> morphology, "History" -> history, "Metrics" -> metrics, "FinalState" -> Last[history]|>
]

results = AssociationThread[morphologyTypes, RunForMorphology /@ morphologyTypes];
timestamp = DateString[Now, {"Year", "Month", "Day", "-", "Hour", "Minute", "Second"}];
runBase = experimentId <> "-" <> timestamp;

metricRows = Flatten[
  Table[
    Append[#, "MorphologyType" -> type] & /@ results[type]["Metrics"],
    {type, morphologyTypes}
  ],
  1
];

finalMetricRows = Table[
  Join[
    <|"MorphologyType" -> type|>,
    Last[results[type]["Metrics"]]
  ],
  {type, morphologyTypes}
];

summary = <|
  "ModelVersion" -> "Prototype 0.1",
  "ExperimentId" -> experimentId,
  "Seed" -> seed,
  "MorphologyTypes" -> morphologyTypes,
  "GridSize" -> gridSize,
  "Steps" -> steps,
  "Params" -> params,
  "InitialCondition" -> params["InitialCondition"],
  "FinalMetrics" -> finalMetricRows,
  "OutputLocation" -> FileNameJoin[{projectRoot, "data"}]
|>;

comparisonPanel = GraphicsGrid[
  Partition[
    Labeled[StatePanel[results[#]["FinalState"]], Style[#, Bold, 14], Top] & /@ morphologyTypes,
    1
  ],
  Spacings -> {0.2, 1.0},
  ImageSize -> 760
];

trapComparison = ListLinePlot[
  Table[
    ({#["Step"], #["TrapIndex"]} & /@ results[type]["Metrics"]),
    {type, morphologyTypes}
  ],
  PlotLegends -> morphologyTypes,
  Frame -> True,
  Axes -> False,
  FrameLabel -> {"Step", "TrapIndex"},
  ImageSize -> 720,
  PlotRange -> All
];

jsonPath = FileNameJoin[{projectRoot, "data", "runs", runBase <> ".json"}];
metricsPath = FileNameJoin[{projectRoot, "data", "metrics", runBase <> "-metrics.csv"}];
finalMetricsPath = FileNameJoin[{projectRoot, "data", "metrics", runBase <> "-final-metrics.csv"}];
fieldsFigurePath = FileNameJoin[{projectRoot, "data", "figures", runBase <> "-fields.png"}];
trapFigurePath = FileNameJoin[{projectRoot, "data", "figures", runBase <> "-trap-index-comparison.png"}];

ExportRunJSON[summary, jsonPath];
ExportMetricsCSV[metricRows, metricsPath];
ExportMetricsCSV[finalMetricRows, finalMetricsPath];
ExportFigure[comparisonPanel, fieldsFigurePath];
ExportFigure[trapComparison, trapFigurePath];

requiredOutputs = {jsonPath, metricsPath, finalMetricsPath, fieldsFigurePath, trapFigurePath};
missingOutputs = Select[requiredOutputs, ! FileExistsQ[#] || FileByteCount[#] == 0 &];
If[Length[missingOutputs] > 0,
  Print["Export failed for: ", missingOutputs];
  Quit[1]
];

Print["Completed ", experimentId];
Print["Run summary: ", jsonPath];
Print["Metrics: ", metricsPath];
Print["Final metrics: ", finalMetricsPath];
Print["Figures: ", FileNameJoin[{projectRoot, "data", "figures"}]];
