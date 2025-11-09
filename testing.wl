(* Just Wolfram Language code, no special script syntax *)

Print["Hello from Wolfram Language"];

square[x_] := x^2
nums = Range[10];
Print["Squares: ", square /@ nums];

(* A tiny “data task” so you feel the power *)
nodes = {
  <|"name" -> "node1", "CPU" -> 4, "RAM" -> 16|>,
  <|"name" -> "node2", "CPU" -> 8, "RAM" -> 32|>,
  <|"name" -> "node3", "CPU" -> 16, "RAM" -> 64|>
};

avgCPU = Mean[nodes[[All, "CPU"]]];
Print["Average CPU: ", avgCPU];
