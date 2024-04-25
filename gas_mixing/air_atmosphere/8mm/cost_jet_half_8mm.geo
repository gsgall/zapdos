mm_to_m = 1e-3;
inch_to_mm = 25.4;
inch_to_m = inch_to_mm * mm_to_m;

inner_channel_length = 2 * mm_to_m;
total_width = 4.5 * mm_to_m;
angled_width = 3.5 * mm_to_m;

angled_length = 3.5 * mm_to_m;
outer_channel_length = inner_channel_length;

pi = 3.14159265359;

channel_width = 1 * mm_to_m;
channel_depth = 1 * mm_to_m;

channel_width = channel_width / pi^(1/2);

inner_channel_start_x = channel_width;
angled_length_start_x = total_width - angled_width + channel_width/2;
outer_channel_x = inner_channel_start_x + total_width;

tip_to_quartz_distance = ( 42 - (30 + 2 + 9) ) * mm_to_m;
distance_to_target = 8 * mm_to_m;

target_width = 1 * inch_to_m;
// offset for boundary condition stability
target_height = 4 * mm_to_m;

// atmosphere for ample mixing space
x_buffer = 20 * mm_to_m;
y_buffer = 20 * mm_to_m;
// rounding corners that break simulations
round_radius = 0.09* mm_to_m;

electrode_offset_x = 0.08 * mm_to_m;
electrode_lower_angle_offset_x2 = 0.08 * mm_to_m;
electrode_offset_y = 0.08 * mm_to_m;
electrode_lower_center_offset_x1 = 0.002 * mm_to_m;
electrode_lower_center_offset_y1 = -0.08 * mm_to_m;

electrode_upper_center_offset_x = -0.002 * mm_to_m;
electrode_upper_center_offset_y = 0 * mm_to_m;
// fins on the side of easier transition from no-slip to natural
fin_width = 10 * mm_to_m;
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
// extra cushion for any mixing dynamics that might be interesting
Point(11) = {target_width + x_buffer, -distance_to_target, 0};
Point(12) = {target_width + x_buffer, inner_channel_length + y_buffer, 0 };


Point(46) = {(target_width + x_buffer - round_radius), inner_channel_length + y_buffer, 0 };
Point(47) = {(target_width + x_buffer - round_radius), inner_channel_length + y_buffer - round_radius, 0 };
Point(48) = {(target_width + x_buffer), inner_channel_length + y_buffer  - round_radius, 0 };
// bottom right
Point(49) = {(target_width + x_buffer), -distance_to_target + round_radius, 0};
Point(50) = {(target_width + x_buffer - round_radius), -distance_to_target + round_radius, 0};
Point(51) = {(target_width + x_buffer - round_radius), -distance_to_target, 0};
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
//
Point(69) = {(target_width - round_radius), -distance_to_target, 0};
Point(71) = {(outer_channel_x + fin_width), outer_channel_length + y_buffer, 0};
// point for pressure pin
// Point(72) =  {(target_width + x_buffer), -distance_to_target + 5e-3, 0};
// inlet
Line(13) = {1, 3};

Line(01) = {0, 1};
Line(70) = {7,0};
Line(87) = {8,7};
// Line(4872) = {48,72};
// Line(7249) = {72,49};
Line(4849) = {48,49};
Circle(495051) = {49,50,51};
Circle(525354) = {52,53,54};
// Line(5446) = {54,46};
Line(5471) = {54,71};
Line(7146) = {71,46};
// electrode right boundary
Line(355) = {3, 55};
Circle(555657) = {55,56,57};
Line(5758) = {57,58};
Bezier(585960) = {58,59,60};
Line(6061) = {60,61};
Bezier(616263) = {61,62,63};
Line(6352) = {63,52};
// target
Line(5169) = {51, 69};
Line(698) = {69,8};
Circle(464748) = {46, 47, 48};

// boundaries
Physical Line("axis_of_symmetry") = {87,70,01};
Physical Line("target") = { 698, 5169, 495051};
Physical Line("atmosphere") = {7146, 464748, 4849};
Physical Line("upper_atmosphere") = {5471};
Physical Line("electrode") = {6352, 616263, 6061, 585960, 5758, 555657, 355, 525354};
Physical Line("inlet") = {13};
// Physical Point("pressure_pin") = {46};
// // // // defining the domain
Line Loop(200) = {01, 13, 355, 555657, 5758, 585960, 6061, 616263, 6352, 525354, 5471, 7146, 464748, 4849, 495051, 5169, 698, 87, 70};
Plane Surface(201) = {200};
Physical Surface("plasma") = {201};


// add refinements
max = 5e-1 * mm_to_m;
channel = 1 / 7;
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
Field[2].XMin = 0;
Field[2].XMax = ((outer_channel_x + 8) * mm_to_m);
Field[2].YMin = -distance_to_target;
Field[2].YMax = angled_length + 2 * mm_to_m;
Field[2].Thickness = 20 * mm_to_m;

// // upper right box refine
// Field[7] = Box;
// Field[7].VIn = max * corner;
// Field[7].VOut = max;
// Field[7].XMin = (target_width + x_buffer) - box_width;
// Field[7].XMax = (target_width + x_buffer);
// Field[7].YMin = outer_channel_length + y_buffer;
// Field[7].YMax = outer_channel_length + y_buffer - box_width;
// Field[7].Thickness = 4 * mm_to_m;

// upper right box refine near electrode
// Field[8] = Box;
// Field[8].VIn = max * corner * 1.5;
// Field[8].VOut = max;
// Field[8].XMin = (outer_channel_x);
// Field[8].XMax = (outer_channel_x + fin_width);
// Field[8].YMin = outer_channel_length + y_buffer;
// Field[8].YMax = outer_channel_length + y_buffer - 3 * box_width;
// Field[8].Thickness = 8 * mm_to_m;

// // lower right corner refine
// Field[9] = Box;
// Field[9].VIn = max * corner;
// Field[9].VOut = max;
// Field[9].XMin = (target_width + x_buffer) - box_width;
// Field[9].XMax = (target_width + x_buffer);
// Field[9].YMin = -distance_to_target - target_height;
// Field[9].YMax = -distance_to_target - target_height + box_width;
// Field[9].Thickness = 4 * mm_to_m;

// // corners near target right
// Field[10] = Box;
// Field[10].VIn = max * corner;
// Field[10].VOut = max;
// Field[10].XMin = (target_width);
// Field[10].XMax = (target_width) + box_width;
// Field[10].YMin = -distance_to_target - target_height;
// Field[10].YMax = -distance_to_target - target_height + box_width;
// Field[10].Thickness = 4 * mm_to_m;


// // refine near the transition from no BC to no slip
// Field[11] = Box;
// Field[11].VIn = max * corner;
// Field[11].VOut = max;
// Field[11].XMin = (outer_channel_x +fin_width - box_width / 2);
// Field[11].XMax = (outer_channel_x + fin_width + box_width/2);
// Field[11].YMin = outer_channel_length + y_buffer;
// Field[11].YMax = outer_channel_length + y_buffer - box_width;
// Field[11].Thickness = 4 * mm_to_m;


// // upper right box refine
// Field[13] = Box;
// Field[13].VIn = max * corner * 2;
// Field[13].VOut = max;
// Field[13].XMin = (target_width + x_buffer) - box_width / 2;
// Field[13].XMax = (target_width + x_buffer);
// Field[13].YMin = -distance_to_target - target_height + box_width;
// Field[13].YMax = outer_channel_length + y_buffer - box_width;
// Field[13].Thickness = 1 * mm_to_m;


Field[20] = Min;
// Field[20].FieldsList = {1, 2, 8, 9, 10,11, 13};
Field[20].FieldsList = {1, 2};
Background Field = 20;

Mesh.ElementOrder = 2;
