mm_to_m = 1e-3;
inch_to_mm = 25.4;
inch_to_m = inch_to_mm * mm_to_m;

inner_channel_length = 5 * mm_to_m;
total_width = 4.5 * mm_to_m;
angled_width = 3.5 * mm_to_m;

angled_length = 3.5 * mm_to_m;
outer_channel_length = inner_channel_length;

pi = 3.14159265359;

channel_width = 1 * mm_to_m;
channel_depth = 1 * mm_to_m;

channel_width = ((channel_width * channel_depth) / pi)^(1/2);

inner_channel_start_x = channel_width;
angled_length_start_x = total_width - angled_width + channel_width/2;
outer_channel_x = (inner_channel_start_x + total_width) * 2.5;

tip_to_quartz_distance = ( 42 - (30 + 2 + 9) ) * mm_to_m;
distance_to_target = 30 * mm_to_m;

target_width = 1 * inch_to_m;
// offset for boundary condition stability
target_height = 4 * mm_to_m;

// atmosphere for ample mixing space
x_buffer = 16 * mm_to_m;
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
// fins on the side of easier transition from no-slip to natural
fin_width = outer_channel_x;
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
Point(11) = {fin_width, -distance_to_target, 0};
Point(12) = {fin_width, inner_channel_length + y_buffer, 0 };
// top right round
Point(46) = {(fin_width - round_radius), 0, 0 };
Point(47) = {(fin_width - round_radius),- round_radius, 0 };
Point(48) = {(fin_width), - round_radius, 0 };
// bottom right
Point(49) = {(fin_width), -distance_to_target + round_radius, 0};
Point(50) = {(fin_width - round_radius), -distance_to_target + round_radius, 0};
Point(51) = {(fin_width - round_radius), -distance_to_target, 0};
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
// inlet
Line(13) = {1, 3};
// axis of symmetry
Line(01) = {0, 1};
Line(70) = {7,0};
Line(87) = {8,7};
// atmosphere right
// Line(5446) = {54, 46};
Circle(464748) = {46,47,48};
Circle(495051) = {49,50,51};
// Circle(525354) = {52,53,54};
Line(4849) = {48,49};
// electrode right boundary
Line(355) = {3, 55};
Circle(555657) = {55,56,57};
// Line(5758) = {57,58};
// Bezier(585960) = {58,59,60};
// Line(6061) = {60,61};
// Bezier(616263) = {61,62,63};
// Line(6352) = {63,52};
//outlet
Line(518) = {51,8};

Line(5746)={57,46};

// Physical Point("pressure_pin") = {8};
Physical Line("axis_of_symmetry") = {87,70,01};
Physical Line("target") = {518, 495051};
Physical Line("inlet") = {13};
Physical Line("electrode") = {355,555657,5746};
Physical Line("atmosphere") = {464748,4849};
// // defining the domain
Line Loop(200) = {355,555657,5746, 464748, 4849, 495051, 518, 87,70,01,13};
  // 58,585960,6061,616263,6352, 525354, 5446, 464748, 4849, 495051, 518, 87,};
Plane Surface(201) = {200};
Physical Surface("plasma") = {201};


// add refinements
max = 5e-1 * mm_to_m;
channel = 1 / 7;
electrode = 1 / 4;
corner = 1/4 ;
box_width =  1 * mm_to_m;
bounadry_refine_start = 3-3*mm_to_m;
// inner channel refinement
Field[1] = Box;
Field[1].VIn = max * channel;
Field[1].VOut = max;
Field[1].XMin = -inner_channel_start_x;
Field[1].XMax = inner_channel_start_x;
Field[1].YMin =  0;
Field[1].YMax = inner_channel_length;
Field[1].Thickness = 4 * mm_to_m;
// // // electrode refinement
Field[2] = Box;
Field[2].VIn = max * electrode;
Field[2].VOut = max;
Field[2].XMin = 0;
Field[2].XMax = inner_channel_start_x * 3;
Field[2].YMin = -distance_to_target;
Field[2].YMax = 0;
Field[2].Thickness =  4 * mm_to_m;
// electrode refinement
// Field[3] = Box;
// Field[3].VIn = max * electrode;
// Field[3].VOut = max;
// Field[3].XMin = 0;
// Field[3].XMax = (fin_width / 4);
// Field[3].YMin = -distance_to_target;
// Field[3].YMax = -distance_to_target + bounadry_refine_start;
// Field[3].Thickness = 4 * mm_to_m;
// // upper atomsphere refinement
// Field[4] = Box;
// Field[4].VIn = max * corner / 2;
// Field[4].VOut = max;
// Field[4].XMin = outer_channel_x;
// Field[4].XMax = (fin_width);
// Field[4].YMin = outer_channel_length + y_buffer - box_width;
// Field[4].YMax = outer_channel_length + y_buffer;
// Field[4].Thickness = 20 * mm_to_m;

Field[20] = Min;
Field[20].FieldsList = {1, 2};
Background Field = 20;

Mesh.ElementOrder = 2;
