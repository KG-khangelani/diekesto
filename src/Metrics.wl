BeginPackage["RuliologyUrbanDynamics`Metrics`"]

FieldMean::usage = "FieldMean[state, field] returns the mean value of a field.";
FieldVariance::usage = "FieldVariance[state, field] returns the variance of a field.";
FieldEntropy::usage = "FieldEntropy[state, field] returns a binned Shannon entropy for a field.";
TrapIndex::usage = "TrapIndex[state] returns the proportion of cells with R > 0.7 and B < 0.3.";
StateMetrics::usage = "StateMetrics[state] returns a metric association for one state.";
HistoryMetrics::usage = "HistoryMetrics[history] returns metric associations for a state history.";

Begin["`Private`"]

Fields = {"P", "A", "B", "R"};

FieldMean[state_Association, field_String] := Mean[Flatten[state[field]]]

FieldVariance[state_Association, field_String] := Variance[Flatten[state[field]]]

FieldEntropy[state_Association, field_String, bins_Integer : 20] := Module[{values, indices, counts, probs},
  values = Clip[Flatten[state[field]], {0, 1}];
  indices = Floor[values bins];
  indices = Clip[indices, {0, bins - 1}];
  counts = Lookup[Counts[indices], Range[0, bins - 1], 0];
  probs = Select[N[counts/Total[counts]], # > 0 &];
  -Total[probs Log2[probs]]
]

TrapIndex[state_Association] := Module[{risk, activity, trapped},
  risk = state["R"];
  activity = state["B"];
  trapped = MapThread[If[#1 > 0.7 && #2 < 0.3, 1, 0] &, {Flatten[risk], Flatten[activity]}];
  N[Total[trapped]/Length[trapped]]
]

StateMetrics[state_Association] := Join[
  <|"Step" -> state["Step"], "TrapIndex" -> TrapIndex[state]|>,
  Association[Join @@ Table[
    {
      field <> "Mean" -> FieldMean[state, field],
      field <> "Variance" -> FieldVariance[state, field],
      field <> "Entropy" -> FieldEntropy[state, field]
    },
    {field, Fields}
  ]]
]

HistoryMetrics[history_List] := StateMetrics /@ history

End[]
EndPackage[]
