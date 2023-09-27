mm_to_m = 1e-3;
inch_to_mm = 25.4;
inch_to_m = inch_to_mm * mm_to_m;

inner_channel_length = 30 * mm_to_m;
total_width = 4.5 * mm_to_m;
angled_width = 3.5 * mm_to_m;

angled_length = 3.5 * mm_to_m;
outer_channel_length = inner_channel_length;
channel_width = 1 * mm_to_m;
channel_depth = 1 * mm_to_m;


inner_channel_start_x = channel_width/2;
angled_length_start_x = total_width - angled_width + channel_width/2;
outer_channel_x = inner_channel_start_x + total_width;

tip_to_quartz_distance = ( 42 - (30 + 2 + 9) ) * mm_to_m;
distance_to_target = 4 * mm_to_m + tip_to_quartz_distance;

target_width = 1 * inch_to_m;
// offset for boundary condition stability
target_height = 4 * mm_to_m;

// atmosphere for ample mixing space
x_buffer = 50 * mm_to_m;
y_buffer = 0 * mm_to_m;
// rounding corners that break simulations
round_radius = 0.09* mm_to_m;

electrode_offset_x = 0.08 * mm_to_m;
electrode_lower_angle_offset_x2 = 0.08 * mm_to_m;
electrode_offset_y = 0.08 * mm_to_m;
electrode_lower_center_offset_x1 = 0.002 * mm_to_m;
electrode_lower_center_offset_y1 = -0.08 * mm_to_m;

electrode_upper_center_offset_x = -0.002 * mm_to_m;
electrode_upper_center_offset_y = 0 * mm_to_m;
// axis of symmetry
Point(0) = {0, 0, 0};
Point(1) = {0, inner_channel_length, 0};

// channel inner wall
Point(2) = {inner_channel_start_x, 0, 0};
Point(3) = {inner_channel_start_x, inner_channel_length, 0};
// Outer Channel Wall
Point(4) = {angled_length_start_x, 0, 0};
Point(5) = {outer_channel_x, angled_length, 0};
Point(6) = {outer_channel_x, outer_channel_length + y_buffer, 0};
// target start
Point(7) = {0, -tip_to_quartz_distance, 0};
Point(8) = {0, -distance_to_target, 0};
Point(9) = {target_width, -distance_to_target, 0};
Point(10) = {target_width, -distance_to_target - target_height, 0};
// extra cushion for any mixing dynamics that might be interesting
Point(11) = {target_width + x_buffer, -distance_to_target - target_height, 0};
Point(12) = {target_width + x_buffer, inner_channel_length + y_buffer, 0 };
// mirror side of jet
// starting on target
Point(13) = {-target_width, -distance_to_target, 0};
Point(14) = {-target_width, -distance_to_target - target_height, 0};
// extra cushion for any mixing dynamics that might be interesting
Point(15) = {-(target_width + x_buffer), -distance_to_target - target_height, 0};
Point(16) = {-(target_width + x_buffer), inner_channel_length + y_buffer, 0 };
Point(17) = {-outer_channel_x, outer_channel_length + y_buffer, 0};
Point(18) = {-outer_channel_x, angled_length, 0};
Point(19) = {-(angled_length_start_x), 0, 0};
Point(20) = {-inner_channel_start_x, 0, 0};
Point(21) = {-inner_channel_start_x, inner_channel_length, 0};
// top left round
Point(22) = {-(target_width + x_buffer), inner_channel_length + y_buffer  - round_radius, 0 };
Point(23) = {-(target_width + x_buffer - round_radius), inner_channel_length + y_buffer - round_radius, 0 };
Point(24) = {-(target_width + x_buffer - round_radius), inner_channel_length + y_buffer, 0 };
// bottom left round
Point(25) = {-(target_width + x_buffer - round_radius), -distance_to_target - target_height, 0};
Point(26) = {-(target_width + x_buffer - round_radius), -distance_to_target - target_height + round_radius, 0};
Point(27) = {-(target_width + x_buffer), -distance_to_target - target_height + round_radius, 0};
// top left near electrode
Point(28) = {-(outer_channel_x + round_radius), outer_channel_length + y_buffer, 0};
Point(29) = {-(outer_channel_x + round_radius), outer_channel_length + y_buffer - round_radius, 0};
Point(30) = {-(outer_channel_x), outer_channel_length + y_buffer - round_radius, 0};
// electrode left inner corner
Point(31) = {-(inner_channel_start_x + round_radius), 0, 0};
Point(32) = {-(inner_channel_start_x + round_radius), round_radius, 0};
Point(33) = {-(inner_channel_start_x), round_radius, 0};
// electrode lower angle point left
Point(34) = {-(angled_length_start_x + electrode_offset_x), electrode_offset_y, 0};
Point(35) = {-(angled_length_start_x + electrode_lower_center_offset_x1), electrode_offset_y + electrode_lower_center_offset_y1, 0};
Point(36) = {-(angled_length_start_x - electrode_offset_x), 0, 0};
// electrode upper angle point left
Point(37) = {-outer_channel_x, angled_length + electrode_offset_y, 0};
Point(38) = {-(outer_channel_x -electrode_upper_center_offset_x), angled_length - electrode_upper_center_offset_y, 0};
Point(39) = {-(outer_channel_x - electrode_offset_x), angled_length - electrode_offset_y, 0};
// round target lower left corner
Point(40) = {-target_width, -distance_to_target - target_height + round_radius, 0};
Point(41) = {-(target_width + round_radius), -distance_to_target - target_height + round_radius, 0};
Point(42) = {-(target_width + round_radius), -distance_to_target - target_height, 0};
// round target upper left corner
Point(43) = {- (target_width - round_radius), -distance_to_target, 0};
Point(44) = {- (target_width - round_radius), -distance_to_target - round_radius, 0};
Point(45) = {- (target_width), -distance_to_target - round_radius, 0};
// top right round
Point(46) = {(target_width + x_buffer - round_radius), inner_channel_length + y_buffer, 0 };
Point(47) = {(target_width + x_buffer - round_radius), inner_channel_length + y_buffer - round_radius, 0 };
Point(48) = {(target_width + x_buffer), inner_channel_length + y_buffer  - round_radius, 0 };
// bottom right
Point(49) = {(target_width + x_buffer), -distance_to_target - target_height + round_radius, 0};
Point(50) = {(target_width + x_buffer - round_radius), -distance_to_target - target_height + round_radius, 0};
Point(51) = {(target_width + x_buffer - round_radius), -distance_to_target - target_height, 0};
// top right near electrode
Point(52) = {(outer_channel_x), outer_channel_length + y_buffer - round_radius, 0};
Point(53) = {(outer_channel_x + round_radius), outer_channel_length + y_buffer - round_radius, 0};
Point(54) = {(outer_channel_x + round_radius), outer_channel_length + y_buffer, 0};
// electrode right inner corner
Point(55) = {(inner_channel_start_x), round_radius, 0};
Point(56) = {(inner_channel_start_x + round_radius), round_radius, 0};
Point(57) = {(inner_channel_start_x + round_radius), 0, 0};
// electrode lower angle point right
Point(58) = {(angled_length_start_x - electrode_offset_x), 0, 0};
Point(59) = {(angled_length_start_x + electrode_lower_center_offset_x1), electrode_offset_y + electrode_lower_center_offset_y1, 0};
Point(60) = {(angled_length_start_x + electrode_offset_x), electrode_offset_y, 0};
// electrode upper angle point right
Point(61) = {(outer_channel_x - electrode_offset_x), angled_length - electrode_offset_y, 0};
Point(62) = {(outer_channel_x -electrode_upper_center_offset_x), angled_length - electrode_upper_center_offset_y, 0};
Point(63) = {outer_channel_x, angled_length + electrode_offset_y, 0};
// round target lower right corner
Point(64) = {(target_width + round_radius), -distance_to_target - target_height, 0};
Point(65) = {(target_width + round_radius), -distance_to_target - target_height + round_radius, 0};
Point(66) = {target_width, -distance_to_target - target_height + round_radius, 0};
// round target upper right corner
Point(67) = {(target_width), -distance_to_target - round_radius, 0};
Point(68) = {(target_width - round_radius), -distance_to_target - round_radius, 0};
Point(69) = {(target_width - round_radius), -distance_to_target, 0};
// inlet
Line(13) = {1, 3};
Line(211) = {21,1};
// target left
Line(843) = {8, 43};
Circle(404142) = {40,41,42};
Line(4225) = {42,25};
Circle(434445) = {43,44,45};
Line(4540) = {45,40};
// atomsphere left
Circle(252627) = {25,26,27};
Circle(222324) = {22,23,24};
Line(2722) = {27,22};
Line(2428) = {24,28};
// atmosphere right
Circle(464748) = {46,47,48};
Line(4849) = {48,49};
Circle(495051) = {49,50,51};
Circle(525354) = {52,53,54};
Line(5446) = {54,46};
Line(5164) = {51,64};
// electrode left boundary
Circle(282930) = {28,29,30};
Line(3321) = {33,21};
Circle(313233) = {31,32,33};
Bezier(343536) = {34, 35,36};
Line(3631) = {36,31};
Bezier(373839) = {37,38,39};
Line(3934) = {39,34};
Line(3037) = {30,37};
// electrode right boundary
Line(355) = {3, 55};
Circle(555657) = {55,56,57};
Line(5758) = {57,58};
Bezier(585960) = {58,59,60};
Line(6061) = {60,61};
Bezier(616263) = {61,62,63};
Line(6352) = {63,52};
// target right
Circle(646566) = {64,65,66};
Line(6667) = {66,67};
Circle(676869) = {67,68,69};
Line(698) = {69,8};
// // // boundaries
Physical Line("target") = {646566,6667,676869,698,843,434445,4540,404142};
Physical Line("atmosphere") = {464748,4849,495051,5164,4225,252627,2722,222324};
Physical Line("upper_atmosphere") = {2428,282930,525354,5446};
Physical Line("electrode") = {3037,373839,3934,343536,3631,313233,3321,355,555657,5758,585960,6061,616263,6352};
Physical Line("inlet") = {211,13};

// // // defining the domain
Line Loop(200) = {355,555657,5758,585960,6061,616263,6352,525354,5446,464748,4849,495051,5164,646566,6667,676869,698,843,434445,4540,404142,4225,252627,2722,222324,2428,282930,3037,373839,3934,343536,3631,313233,3321,211,13};
Plane Surface(201) = {200};
Physical Surface("plasma") = {201};


// add refinements
max = 10e-1 * mm_to_m;
channel = 1 / 4;
electrode = 1 / 6;
corner = 1/7;
box_width =  1 * mm_to_m;
// inner channel refinement
Field[1] = Box;
Field[1].VIn = max * channel;
Field[1].VOut = max;
Field[1].XMin = -inner_channel_start_x;
Field[1].XMax = inner_channel_start_x;
Field[1].YMin =  -distance_to_target;
Field[1].YMax = inner_channel_length;
Field[1].Thickness = 4 * mm_to_m;
// // electrode refinement
Field[2] = Box;
Field[2].VIn = max * channel;
Field[2].VOut = max;
Field[2].XMin = -(outer_channel_x + 2 * mm_to_m);
Field[2].XMax = outer_channel_x + 2 * mm_to_m;
Field[2].YMin = -distance_to_target;
Field[2].YMax = angled_length + 2 * mm_to_m;
Field[2].Thickness = 20 * mm_to_m;
// upper left box refine
Field[3] = Box;
Field[3].VIn = max * corner;
Field[3].VOut = max;
Field[3].XMin = -(target_width + x_buffer);
Field[3].XMax = -(target_width + x_buffer) + box_width;
Field[3].YMin = outer_channel_length + y_buffer;
Field[3].YMax = outer_channel_length + y_buffer - box_width;
Field[3].Thickness = 4 * mm_to_m;

// upper left box refine near electrode
Field[4] = Box;
Field[4].VIn = max * corner;
Field[4].VOut = max;
Field[4].XMin = -(outer_channel_x + box_width );
Field[4].XMax = -(outer_channel_x);
Field[4].YMin = outer_channel_length + y_buffer;
Field[4].YMax = outer_channel_length + y_buffer - box_width;
Field[4].Thickness = 4 * mm_to_m;

// lower left corner refine
Field[5] = Box;
Field[5].VIn = max * corner;
Field[5].VOut = max;
Field[5].XMin = -(target_width + x_buffer);
Field[5].XMax = -(target_width + x_buffer) + box_width;
Field[5].YMin = -distance_to_target - target_height;
Field[5].YMax = -distance_to_target - target_height + box_width;
Field[5].Thickness = 4 * mm_to_m;

// corners near target
Field[6] = Box;
Field[6].VIn = max * corner;
Field[6].VOut = max;
Field[6].XMin = -(target_width);
Field[6].XMax = -(target_width + box_width);
Field[6].YMin = -distance_to_target - target_height;
Field[6].YMax = -distance_to_target - target_height + box_width;
Field[6].Thickness = 4 * mm_to_m;

// upper right box refine
Field[7] = Box;
Field[7].VIn = max * corner;
Field[7].VOut = max;
Field[7].XMin = (target_width + x_buffer) - box_width;
Field[7].XMax = (target_width + x_buffer);
Field[7].YMin = outer_channel_length + y_buffer;
Field[7].YMax = outer_channel_length + y_buffer - box_width;
Field[7].Thickness = 4 * mm_to_m;

// upper right box refine near electrode
Field[8] = Box;
Field[8].VIn = max * corner;
Field[8].VOut = max;
Field[8].XMin = (outer_channel_x);
Field[8].XMax = (outer_channel_x + box_width);
Field[8].YMin = outer_channel_length + y_buffer;
Field[8].YMax = outer_channel_length + y_buffer - box_width;
Field[8].Thickness = 4 * mm_to_m;

// lower right corner refine
Field[9] = Box;
Field[9].VIn = max * corner;
Field[9].VOut = max;
Field[9].XMin = (target_width + x_buffer) - box_width;
Field[9].XMax = (target_width + x_buffer);
Field[9].YMin = -distance_to_target - target_height;
Field[9].YMax = -distance_to_target - target_height + box_width;
Field[9].Thickness = 4 * mm_to_m;

// corners near target right
Field[10] = Box;
Field[10].VIn = max * corner;
Field[10].VOut = max;
Field[10].XMin = (target_width);
Field[10].XMax = (target_width) + box_width;
Field[10].YMin = -distance_to_target - target_height;
Field[10].YMax = -distance_to_target - target_height + box_width;
Field[10].Thickness = 4 * mm_to_m;




Field[20] = Min;
Field[20].FieldsList = {1, 2, 3, 4,5,6, 7, 8, 9, 10};
Background Field = 20;

Mesh.ElementOrder = 2;
