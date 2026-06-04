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

experimentId = "minimal-opengrid-001";
gridSize = 50;
steps = 100;
seed = 1234;
params = DefaultParameters[];
morphology = CreateMorphology["OpenGrid", gridSize];
initialState = CreateInitialState[gridSize, morphology, params, seed];
history = RunSimulation[initialState, params, steps];
metrics = HistoryMetrics[history];
finalState = Last[history];

timestamp = DateString[Now, {"Year", "Month", "Day", "-", "Hour", "Minute", "Second"}];
runBase = experimentId <> "-" <> timestamp;

runSummary = <|
  "ModelVersion" -> "Prototype 0.1",
  "ExperimentId" -> experimentId,
  "Seed" -> seed,
  "MorphologyType" -> morphology["Type"],
  "GridSize" -> gridSize,
  "Steps" -> steps,
  "Params" -> params,
  "InitialCondition" -> params["InitialCondition"],
  "FinalMetrics" -> Last[metrics],
  "OutputLocation" -> FileNameJoin[{projectRoot, "data"}]
|>;

jsonPath = FileNameJoin[{projectRoot, "data", "runs", runBase <> ".json"}];
csvPath = FileNameJoin[{projectRoot, "data", "metrics", runBase <> "-metrics.csv"}];
fieldsFigurePath = FileNameJoin[{projectRoot, "data", "figures", runBase <> "-fields.png"}];
trapFigurePath = FileNameJoin[{projectRoot, "data", "figures", runBase <> "-trap-index.png"}];

ExportRunJSON[runSummary, jsonPath];
ExportMetricsCSV[metrics, csvPath];
ExportFigure[StatePanel[finalState], fieldsFigurePath];
ExportFigure[MetricTimeSeriesPlot[metrics, "TrapIndex"], trapFigurePath];

requiredOutputs = {jsonPath, csvPath, fieldsFigurePath, trapFigurePath};
missingOutputs = Select[requiredOutputs, ! FileExistsQ[#] || FileByteCount[#] == 0 &];
If[Length[missingOutputs] > 0,
  Print["Export failed for: ", missingOutputs];
  Quit[1]
];

Print["Completed ", experimentId];
Print["Run summary: ", jsonPath];
Print["Metrics: ", csvPath];
Print["Figures: ", FileNameJoin[{projectRoot, "data", "figures"}]];
