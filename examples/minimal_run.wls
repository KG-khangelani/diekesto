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

ExportRunJSON[runSummary, FileNameJoin[{projectRoot, "data", "runs", runBase <> ".json"}]];
ExportMetricsCSV[metrics, FileNameJoin[{projectRoot, "data", "metrics", runBase <> "-metrics.csv"}]];
ExportFigure[StatePanel[finalState], FileNameJoin[{projectRoot, "data", "figures", runBase <> "-fields.png"}]];
ExportFigure[MetricTimeSeriesPlot[metrics, "TrapIndex"], FileNameJoin[{projectRoot, "data", "figures", runBase <> "-trap-index.png"}]];

Print["Completed ", experimentId];
Print["Run summary: ", FileNameJoin[{projectRoot, "data", "runs", runBase <> ".json"}]];
Print["Metrics: ", FileNameJoin[{projectRoot, "data", "metrics", runBase <> "-metrics.csv"}]];
Print["Figures: ", FileNameJoin[{projectRoot, "data", "figures"}]];
