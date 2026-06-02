BeginPackage["RuliologyUrbanDynamics`SweepRunner`", {
  "RuliologyUrbanDynamics`Morphologies`",
  "RuliologyUrbanDynamics`ModelCore`",
  "RuliologyUrbanDynamics`Metrics`",
  "RuliologyUrbanDynamics`ExportTools`"
}]

RunExperiment::usage = "RunExperiment[experiment] runs a single experiment specification.";
GenerateParameterGrid::usage = "GenerateParameterGrid[paramSpec] expands an association of parameter value lists.";
RunSweep::usage = "RunSweep[sweepSpec] runs a list or grid of experiment specifications.";
SaveExperimentResult::usage = "SaveExperimentResult[result, path] exports an experiment result.";

Begin["`Private`"]

RunExperiment[experiment_Association] := Module[
  {morphology, params, initial, history, metrics},
  params = Lookup[experiment, "Params", <||>];
  morphology = CreateMorphology[experiment["MorphologyType"], experiment["GridSize"]];
  initial = CreateInitialState[experiment["GridSize"], morphology, params, experiment["Seed"]];
  history = RunSimulation[initial, params, experiment["Steps"]];
  metrics = HistoryMetrics[history];
  <|"Experiment" -> experiment, "History" -> history, "Metrics" -> metrics, "FinalState" -> Last[history]|>
]

GenerateParameterGrid[paramSpec_Association] := AssociationThread[Keys[paramSpec], #] & /@ Tuples[Values[paramSpec]]

RunSweep[sweepSpec_Association] := RunExperiment /@ Lookup[sweepSpec, "Experiments", {}]

SaveExperimentResult[result_Association, path_String] := ExportRunJSON[KeyDrop[result, {"History"}], path]

End[]
EndPackage[]
