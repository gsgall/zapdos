mm_to_m = 1e-3;

electrode_straight_length = 10 * mm_to_m;
electrode_tip_length = 2.6 * mm_to_m;
electrode_radius = 0.5 * mm_to_m;
tip_to_plate_distance = 6.1 * mm_to_m;
// degrees
tip_angle = 30;
tip_length = 0.866 * mm_to_m;
//
tip_round_center_y_offset1 = 0.07 * mm_to_m;
tip_round_center_x_offset = 0.015 * mm_to_m;
tip_round_center_y_offset2 = 0.01 * mm_to_m;
//
tip_round_body_x_offset1 = 0.04 * mm_to_m;
tip_round_body_y_offset1 = 0.08 * mm_to_m;

tip_round_body_x_offset2 = 0.01 * mm_to_m;
tip_round_body_y_offset2 = 0.03 * mm_to_m;
//
inner_radius = 1 * mm_to_m;
quartz_to_plate_distance = 4 * mm_to_m;
quartz_thickness = 0.5 * mm_to_m;

corner_round_radius = 0.08 * mm_to_m;

effluent_boundary_x = 10 * mm_to_m;
effluent_boundary_y = 10 * mm_to_m;

target_radius = 13 * mm_to_m;
target_height = 2 * mm_to_m;

Point(0) = {0, tip_to_plate_distance + tip_length + electrode_straight_length, 0};
Point(1) = {0, tip_to_plate_distance + tip_length, 0};

// control points for rounding the tip
Point(2) = {0, tip_to_plate_distance + tip_round_center_y_offset1, 0};
Point(3) = {0, tip_to_plate_distance, 0};
Point(4) = {tip_round_center_x_offset, tip_to_plate_distance + tip_round_center_y_offset2 , 0};

// Rounding for the point where the tip meets the body of the electrode
Point(5) = {electrode_radius - tip_round_body_x_offset1, tip_to_plate_distance + tip_length - tip_round_body_y_offset1, 0};
Point(6) = {electrode_radius - tip_round_body_x_offset2, tip_to_plate_distance + tip_length - tip_round_body_y_offset2, 0};
Point(7) = {electrode_radius, tip_to_plate_distance + tip_length, 0};

Point(8) = {electrode_radius, tip_to_plate_distance + tip_length + electrode_straight_length, 0};

Point(9) = {inner_radius, tip_to_plate_distance + tip_length + electrode_straight_length, 0};
Point(26) = {inner_radius, (tip_to_plate_distance + tip_length) - 2.5 * mm_to_m, 0};

Point(10) = {inner_radius, quartz_to_plate_distance + corner_round_radius, 0};
Point(11) = {inner_radius + corner_round_radius, quartz_to_plate_distance + corner_round_radius, 0};
Point(12) = {inner_radius + corner_round_radius, quartz_to_plate_distance, 0};

Point(13) = {inner_radius + quartz_thickness - corner_round_radius, quartz_to_plate_distance, 0};
Point(14) = {inner_radius + quartz_thickness - corner_round_radius, quartz_to_plate_distance + corner_round_radius, 0};
Point(15) = {inner_radius + quartz_thickness, quartz_to_plate_distance + corner_round_radius, 0};

Point(16) = {inner_radius + quartz_thickness, quartz_to_plate_distance - corner_round_radius + effluent_boundary_y, 0};
Point(17) = {inner_radius + quartz_thickness + corner_round_radius, quartz_to_plate_distance - corner_round_radius + effluent_boundary_y, 0};
Point(18) = {inner_radius + quartz_thickness + corner_round_radius, quartz_to_plate_distance+ effluent_boundary_y, 0};

Point(19) = {target_radius + inner_radius + quartz_thickness - corner_round_radius + effluent_boundary_x, quartz_to_plate_distance+ effluent_boundary_y, 0};
Point(20) = {target_radius + inner_radius + quartz_thickness - corner_round_radius + effluent_boundary_x, quartz_to_plate_distance - corner_round_radius + effluent_boundary_y, 0};
Point(21) = {target_radius + inner_radius + quartz_thickness + effluent_boundary_x, quartz_to_plate_distance + effluent_boundary_y - corner_round_radius, 0};

Point(22) = {target_radius + inner_radius + quartz_thickness + effluent_boundary_x, -target_height + corner_round_radius, 0};
Point(23) = {target_radius + inner_radius + quartz_thickness + effluent_boundary_x - corner_round_radius, -target_height + corner_round_radius, 0};
Point(24) = {target_radius + inner_radius + quartz_thickness + effluent_boundary_x - corner_round_radius, -target_height, 0};

Point(25) = {0, 0, 0};
Point(27) = {0, (tip_to_plate_distance + tip_length) - 2.5 * mm_to_m, 0};
Point(28) = {target_radius -corner_round_radius, 0, 0};
Point(29) = {target_radius -corner_round_radius, -corner_round_radius, 0};
Point(30) = {target_radius, -corner_round_radius, 0};

Point(31) = {target_radius, -target_height + corner_round_radius, 0};
Point(32) = {target_radius + corner_round_radius, -target_height + corner_round_radius, 0};
Point(33) = {target_radius + corner_round_radius, -target_height, 0};

// ) = {target_radius, - target_height, 0};
// Line(01) = {0, 1};
// Line(12) = {1, 2};
// Line(23) = {2, 3};

Ellipse(324) = {3, 2, 4};

Line(45) = {4, 5};

Spline(567) = {5, 6, 7};

Line(78) = {7, 8};
Line(89) = {8, 9};

Line(926) = {9, 26};
Line(2610) = {26, 10};

Circle(101112) = {10, 11, 12};
Line(1213) = {12, 13};
Circle(131415) = {13, 14, 15};


Line(1516) = {15, 16};
Circle(161718) = {16, 17, 18};
Line(1819) = {18, 19};
Circle(192021) = {19, 20, 21};
Line(2122) = {21, 22};
Circle(222324) = {22, 23, 24};


Line(2433) = {24, 33};
Circle(333231) = {33, 32, 31};
Line(3130) = {31, 30};
Circle(302928) = {30, 29,28};
Line(2825) = {28, 25};
Line(2527) = {25, 27};
Line(273) = {27, 3};


// boundaries
Physical Line("electrode_tip") = {324, 45, 567};
Physical Line("electrode_wall") = {78};
Physical Line("inlet") = {89};
Physical Line("inner_quartz_boundary") = {926};
Physical Line("quartz_boundary") = {101112, 1213, 131415, 1516,  2610};
Physical Line("upper_atmosphere") = {161718, 1819, 192021};
Physical Line("lower_atmosphere") = {333231, 2433, 222324, 2122};
Physical Line("upper_axis_of_symmetry")= {273};
Physical Line("axis_of_symmetry") = {2527};
Physical Line("target") = {2825, 302928, 3130};
// plasma domain
Line Loop(50) = {324, 45, 567, 78, 89, 926, 2610, 101112, 1213, 131415, 1516, 161718, 1819, 192021, 2122, 222324, 2433, 333231, 3130, 302928, 2825, 2527, 273};
Plane Surface(51) = {50};
Physical Surface("plasma") = {51};


max = 3e-1 * mm_to_m;
channel = 1 / 2;
// inlet = 1 / 15;
electrode = 1 / 6;
// effluent = 1 / 6;

start_tip_refine = tip_to_plate_distance + tip_length + 0.7 * mm_to_m;
stop_tip_refine = tip_to_plate_distance - 1 * mm_to_m;

Field[1] = Box;
Field[1].VIn = max * electrode;
Field[1].VOut = max;
Field[1].XMin = 0;
Field[1].XMax = (inner_radius + quartz_thickness) * 2;
Field[1].YMin = 0;
Field[1].YMax = start_tip_refine;
Field[1].Thickness = 4 * mm_to_m;

start_channel_refine = tip_to_plate_distance + tip_length + electrode_straight_length;

Field[2] = Box;
Field[2].VIn = max * channel;
Field[2].VOut = max;
Field[2].XMin = electrode_radius;
Field[2].XMax = inner_radius;
Field[2].YMin = start_tip_refine;
Field[2].YMax = start_channel_refine;
Field[2].Thickness = 1 * mm_to_m;

Field[20] = Min;
Field[20].FieldsList = {1, 2};
Background Field = 20;

Mesh.ElementOrder = 1;
