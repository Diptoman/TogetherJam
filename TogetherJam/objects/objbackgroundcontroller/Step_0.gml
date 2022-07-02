//Road Speed
global.baseRoadSpeed = -4;

layer_hspeed("Cloud1", -.8 * global.slowmotimescale * global.timescale);
layer_hspeed("Cloud2", -1.2 * global.slowmotimescale * global.timescale);
layer_hspeed("Cloud3", -1.6 * global.slowmotimescale * global.timescale);
layer_hspeed("Road", global.baseRoadSpeed * global.slowmotimescale * global.timescale);
layer_hspeed("Ground", global.baseRoadSpeed * global.slowmotimescale * global.timescale);
layer_hspeed("Sky", -2 * global.slowmotimescale * global.timescale);