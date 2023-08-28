// System dimensions
cm_to_m = 1 / 100;
quartz_height = 20.4 * cm_to_m;
in_channel_width = 0.45 * cm_to_m;
out_channel_width = 0.95 * cm_to_m;
electrode_body_width = 0.5 * cm_to_m;
full_electrode_length = 7.9 * cm_to_m;
straight_electrode_length = 7 * cm_to_m;
electrode_tip_start_length = 7.84 * cm_to_m;
start_electrode_tip_thickness = 0.07 * cm_to_m;
quartz_thickness = 1 * cm_to_m;
gap_distance = 5.0 * cm_to_m;
corner_rad = 0.03 * cm_to_m;
effluent_buffer_x = 2 * cm_to_m;
effluent_buffer_y = 1.0 * cm_to_m;
// Points
// Axis of symmetry
Point(0) = {0, 0, 0};
Point(1) = {0, quartz_height, 0};
// Electrode
Point(2) = {electrode_body_width, quartz_height, 0};
Point(3) = {electrode_body_width, quartz_height - straight_electrode_length + 0.0005, 0};
Point(4) = {electrode_body_width - 0.00004, quartz_height - straight_electrode_length, 0};
Point(5) = {electrode_body_width - 0.0002, quartz_height - straight_electrode_length - 0.0004, 0};
Point(6) = {start_electrode_tip_thickness, quartz_height - electrode_tip_start_length, 0};
Point(7) = {0, quartz_height - full_electrode_length, 0};
// Control point for tip rounding
Point(8) = {0, quartz_height - electrode_tip_start_length + 0.01, 0};
// Channel Outline
Point(9) = {out_channel_width, quartz_height, 0};
Point(10) = {out_channel_width, 0, 0};
// Quartz Outline
Point(11) = {out_channel_width + quartz_thickness, quartz_height, 0};
//Point(12) = {out_channel_width + quartz_thickness, 0, 0};
// Channel Past the quartz
Point(13) = {0, - gap_distance, 0};
Point(14) = {out_channel_width + quartz_thickness, -gap_distance, 0};
// rounding inner quartz corner
Point(15) = {out_channel_width + corner_rad, 0, 0};
Point(16) = {out_channel_width + corner_rad, corner_rad, 0};
Point(17) = {out_channel_width, corner_rad, 0};
// adding buffer around the effluent
//Point(18) = {out_channel_width + quartz_thickness + effluent_buffer_x, -gap_distance, 0};
//Point(19) = {out_channel_width + quartz_thickness + effluent_buffer_x, effluent_buffer_y, 0};
Point(20) = {out_channel_width + quartz_thickness, effluent_buffer_y, 0};
// rounding outer quartz corner
Point(21) = {out_channel_width + quartz_thickness - corner_rad, 0, 0};
Point(22) = {out_channel_width + quartz_thickness - corner_rad, corner_rad, 0};
Point(23) = {out_channel_width + quartz_thickness, corner_rad, 0};
// Rounding corner of upper right effluent buffer
Point(24) = {out_channel_width + quartz_thickness + effluent_buffer_x, effluent_buffer_y - corner_rad, 0};
Point(25) = {out_channel_width + quartz_thickness + effluent_buffer_x - corner_rad, effluent_buffer_y - corner_rad, 0};
Point(26) = {out_channel_width + quartz_thickness + effluent_buffer_x - corner_rad, effluent_buffer_y, 0};
// Rounding for the lower right effluent bufer
Point(27) = {out_channel_width + quartz_thickness + effluent_buffer_x - corner_rad, -gap_distance, 0};
Point(28) = {out_channel_width + quartz_thickness + effluent_buffer_x - corner_rad, -gap_distance + corner_rad, 0};
Point(29) = {out_channel_width + quartz_thickness + effluent_buffer_x, -gap_distance + corner_rad, 0};
// Ground Points
Point(30) = {out_channel_width + quartz_thickness, quartz_height - 0.02, 0};
Point(31) = {out_channel_width + quartz_thickness, quartz_height - 0.08, 0};
// Lines
//Axis of symmetry
Line(07) = {0, 7};
// Electrode Outline
// Rounding the tip
Ellipse(786) = {7, 8, 6};
Line(65) = {6, 5};
// Rounding the body to tip transition
Spline(543) = {5, 4, 3};
Line(32) = {3, 2};
Line(29) = {2, 9};
Line(917) = {9, 17};
// Quartz Lines
Line(911) = {9, 11};
Line(1130) = {11, 30};
Line(3031) = {30, 31};
Line(3120) = {31, 20};
Line(2023) = {20, 23};
Line(2115) = {21, 15};
// Electrode
Line(21) = {2, 1};
Line(81) = {8, 1};
Line(87) = {8, 7};
// Effluent
Line(013) = {0, 13};
Line(1314) = {13, 14};
Line(1427) = {14, 27};
Line(2924) = {29, 24};
Line(2620) = {26, 20};
// Corner Rounding for inner quartz
Circle(151617) = {15, 16, 17};
// Corner rounding for outer quartz
Circle(212223) = {21, 22, 23};
// Rounding upper right corner
Circle(242526) = {24, 25, 26};
// Rounding Corner lower right
Circle(272829) = {27, 28, 29};
// Plasma Domain
Line Loop(50) = {07, 786, 65, 543, 32, 29, 917, -151617, -2115, 212223, -2023, -2620, -242526, -2924, -272829, -1427, -1314, -013};
Plane Surface(51) = {50};
Physical Surface("plasma") = {51};
// Quartz Domain
Line Loop(52) = {911, 1130, 3031, 3120, 2023, -212223, 2115, 151617, -917};

Plane Surface(53) = {52};
Physical Surface("quartz") = {53};
// Electrode Domain
Line Loop(34) = {21, -81, 87, 786, 65, 543, 32};
//Plane Surface(35) = {34};
//Physical Surface("electrode") = {35};
// Boundaries
Physical Line("inlet") = {29};
Physical Line("electrode_boundary") = {786, 65, 543, 32};
Physical Line("symmetry_axis") = {7, 13};
Physical Line("outlet") = {1314, 2924, 272829, 1427, 2620, 242526};
Physical Line("quartz_boundary") = {917, 151617, 2115, 2023, 212223, 3120, 1130};
Physical Line("ground") = {3031};
// // Refinements
// max = 3e-3;
// channel = 1 / 2;
// inlet = 1 / 15;
// electrode = 1 / 5;
// effluent = 1 / 6;

// start_tip_refine = quartz_height - full_electrode_length + 3 * cm_to_m;
// stop_tip_refine = quartz_height - full_electrode_length - 2 * cm_to_m;

// Field[1] = Box;
// Field[1].VIn = max * channel;
// Field[1].VOut = max;
// Field[1].XMin = start_electrode_tip_thickness;
// Field[1].XMax = out_channel_width;
// Field[1].YMin = start_tip_refine;
// Field[1].YMax = quartz_height;
// Field[1].Thickness = 1 * cm_to_m;

// Field[2] = Box;
// Field[2].VIn = max * electrode;
// Field[2].VOut = max;
// Field[2].XMin = start_electrode_tip_thickness;
// Field[2].XMax = out_channel_width;
// Field[2].YMin = stop_tip_refine;
// Field[2].YMax = start_tip_refine;
// Field[2].Thickness = 1 * cm_to_m;

// Field[3] = Box;
// Field[3].VIn = max * effluent;
// Field[3].VOut = max;
// Field[3].XMin = 0;
// Field[3].XMax = out_channel_width + quartz_thickness + effluent_buffer_x;
// Field[3].YMin = -gap_distance;
// Field[3].YMax = effluent_buffer_y + 1 * cm_to_m;
// Field[3].Thickness = 5 * cm_to_m;

// Field[20] = Min;
// Field[20].FieldsList = {1, 2, 3};
// Background Field = 20;

// Mesh.ElementOrder = 2;
