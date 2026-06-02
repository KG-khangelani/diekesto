BeginPackage["RuliologyUrbanDynamics`AtlasTools`"]

FieldPlot::usage = "FieldPlot[state, field] creates a heatmap for a model field.";
StatePanel::usage = "StatePanel[state] creates a 2x2 panel of P, A, B, and R heatmaps.";
MetricTimeSeriesPlot::usage = "MetricTimeSeriesPlot[metrics, metric] plots one metric over time.";
HistorySummaryPanel::usage = "HistorySummaryPanel[history, metrics] creates a compact final-state and metrics summary panel.";

Begin["`Private`"]

FieldLabels = <|"P" -> "Population Pressure (P)", "A" -> "Accessibility (A)", "B" -> "Economic Activity (B)", "R" -> "Disruption / Risk (R)"|>;

FieldPlot[state_Association, field_String] := ArrayPlot[
  state[field],
  PlotRange -> {0, 1},
  ColorFunction -> "SolarColors",
  Frame -> False,
  ImageSize -> 260,
  PlotLabel -> Lookup[FieldLabels, field, field]
]

StatePanel[state_Association] := GraphicsGrid[
  Partition[FieldPlot[state, #] & /@ {"P", "A", "B", "R"}, 2],
  Spacings -> {0.4, 0.6},
  ImageSize -> 650
]

MetricTimeSeriesPlot[metrics_List, metric_String] := ListLinePlot[
  ({#["Step"], #[metric]} & /@ metrics),
  Frame -> True,
  Axes -> False,
  FrameLabel -> {"Step", metric},
  ImageSize -> 520,
  PlotRange -> All
]

HistorySummaryPanel[history_List, metrics_List] := GraphicsGrid[
  {{
    StatePanel[Last[history]],
    MetricTimeSeriesPlot[metrics, "TrapIndex"]
  }},
  ImageSize -> 1050
]

End[]
EndPackage[]
