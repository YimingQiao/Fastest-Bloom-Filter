# Fixed four-arm native build-policy confirmation

All40 processes/72 contracts completed under the frozen same-process native C++/Rust caller. The prescribed analysis retains432 individual contrasts,3,456 cycle records,9,216 original trial values and36 matched two-seed contracts. There is no pooling across language, family, scenario, contract or seed. Query performance, external leadership and cross-language speed are outside scope.

Every ratio is numerator latency / denominator latency; values above1 mean slower. The engineering band is[0.97,1.03]. Pointwise intervals resample only eight complete Williams cycles under the fixed10,000-draw bootstrap. These intervals depend on representativeness/independence assumptions, are not familywise guarantees, and cannot prove absence of a small effect. All contrasts reuse the same observed A samples and index draws; they are not independent experiments.

Prespecified classifications: consistently_faster=1, consistently_slower=0, practically_within_band=4, unresolved_negative_controls=31, unresolved_policy_intervals=0.

A policy classification is permitted only when all three negative-control full intervals are inside the engineering band at both seeds. A large observed active-gate gain can therefore coexist with an unresolved classification if the negative controls are unstable. The policy interval pattern remains visible below. No default integration follows from unexplained offsets.

|Language / family|Scenario / contract|Gate|Negative controls inside both seeds|Policy interval pattern|Classification|
|---|---|---|---|---|---|
|cpp / Split64|0 small_empty_uniform / insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|cpp / Split64|0 small_empty_uniform / allocate_insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|rust / Split64|0 small_empty_uniform / insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|rust / Split64|0 small_empty_uniform / allocate_insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|cpp / Split64Range|0 small_empty_uniform / insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|cpp / Split64Range|0 small_empty_uniform / allocate_insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|rust / Split64Range|0 small_empty_uniform / insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|rust / Split64Range|0 small_empty_uniform / allocate_insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|cpp / Split64|1 above_batch_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|cpp / Split64|1 above_batch_empty_uniform / allocate_insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|rust / Split64|1 above_batch_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|rust / Split64|1 above_batch_empty_uniform / allocate_insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|cpp / Split64Range|1 above_batch_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|cpp / Split64Range|1 above_batch_empty_uniform / allocate_insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|rust / Split64Range|1 above_batch_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|rust / Split64Range|1 above_batch_empty_uniform / allocate_insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|cpp / Split64|2 small_prefilled_hotspot / insert|active|True|all_policy_intervals_faster|consistently_faster|
|rust / Split64|2 small_prefilled_hotspot / insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|cpp / Split64Range|2 small_prefilled_hotspot / insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|rust / Split64Range|2 small_prefilled_hotspot / insert|active|False|all_policy_intervals_faster|unresolved_negative_controls|
|cpp / Split64|3 above_bytes_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|cpp / Split64|3 above_bytes_empty_uniform / allocate_insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|rust / Split64|3 above_bytes_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|rust / Split64|3 above_bytes_empty_uniform / allocate_insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|cpp / Split64Range|3 above_bytes_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|cpp / Split64Range|3 above_bytes_empty_uniform / allocate_insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|rust / Split64Range|3 above_bytes_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|rust / Split64Range|3 above_bytes_empty_uniform / allocate_insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|cpp / Split64|4 large_empty_uniform / insert|outside|False|all_policy_intervals_inside|unresolved_negative_controls|
|cpp / Split64|4 large_empty_uniform / allocate_insert|outside|True|all_policy_intervals_inside|practically_within_band|
|rust / Split64|4 large_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|rust / Split64|4 large_empty_uniform / allocate_insert|outside|True|all_policy_intervals_inside|practically_within_band|
|cpp / Split64Range|4 large_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|cpp / Split64Range|4 large_empty_uniform / allocate_insert|outside|True|all_policy_intervals_inside|practically_within_band|
|rust / Split64Range|4 large_empty_uniform / insert|outside|False|mixed_policy_intervals|unresolved_negative_controls|
|rust / Split64Range|4 large_empty_uniform / allocate_insert|outside|True|all_policy_intervals_inside|practically_within_band|

The two targets were fixed before these data: C++ Split64 scenario1/T4 insert and Rust Split64 scenario1/T8 allocation+insert. Their individual controls and intervals are retained without replacing the other34 contracts:

|Target|Contrast|Seed2694173 ratio [interval]|Seed3819257 ratio [interval]|
|---|---|---:|---:|
|cpp insert|A1/A0|0.989350 [0.955062, 1.019554]|1.034726 [0.981542, 1.099803]|
|cpp insert|Policy/A0|1.056797 [0.974301, 1.170561]|1.003964 [0.955631, 1.068259]|
|cpp insert|Policy/A1|1.068172 [0.994677, 1.170448]|0.970271 [0.902026, 1.052223]|
|cpp insert|Clone/A0|0.990131 [0.954663, 1.022497]|0.976875 [0.957412, 0.993733]|
|cpp insert|Clone/A1|1.000789 [0.991906, 1.010740]|0.944091 [0.893919, 0.989064]|
|cpp insert|Policy/Clone|1.067330 [0.988545, 1.175725]|1.027730 [0.991968, 1.087246]|
|rust allocate_insert|A1/A0|0.977878 [0.922942, 1.029489]|1.020726 [0.961158, 1.089400]|
|rust allocate_insert|Policy/A0|0.988379 [0.929771, 1.045816]|1.016752 [0.982022, 1.055208]|
|rust allocate_insert|Policy/A1|1.010739 [0.987635, 1.036659]|0.996107 [0.936231, 1.047033]|
|rust allocate_insert|Clone/A0|0.977185 [0.942752, 1.004071]|0.968767 [0.927052, 1.010510]|
|rust allocate_insert|Clone/A1|0.999291 [0.958653, 1.050107]|0.949096 [0.918619, 0.980788]|
|rust allocate_insert|Policy/Clone|1.011456 [0.961543, 1.059078]|1.049533 [1.007960, 1.089431]|

All individual point-slower outcomes remain in `individual_slower.csv`; all gains/ties/intervals remain in `contrasts.csv` and `matched_seeds.csv`. An interval crossing the band is unresolved, not an asserted deterministic regression. `arm_metrics.csv` retains every absolute timing vector, while `samples.csv` retains chronological cycle/position/predecessor context. Samples are references to the same raw arm observations, not additional independent data.

The two fresh input seeds reverse the20-cell process order, but this is still one session and machine. Every Williams block balances absolute arm positions and within-row predecessor pairs; cross-row/process carryover is not claimed balanced. Clone and Before have distinct measured function addresses in this binary; that fact alone does not identify the cause of an observed difference. The same unchanged native policy is evaluated throughout, with no threshold/sample extension.
