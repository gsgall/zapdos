//GMSH script for the RF Jet
//All dimensions are approximate for this script
//More accuracy will follow
/////////////////////////////////////////////////
//Points
cm_to_m  = 1 / 100;
Point(1) = 	{0, 0, 0};
Point(2) = 	{0.55 * cm_to_m, 0, 0};
Point(3) = 	{0.55 * cm_to_m, 0, 20.4 * cm_to_m};
Point(4) = 	{0	,0	,20.4 * cm_to_m};
Point(5) = 	{0	,0	,18.4 * cm_to_m};
Point(6) = 	{-1	* cm_to_m,0	,18.4 * cm_to_m};
Point(7) = 	{-1	* cm_to_m,0	,12.6 * cm_to_m};
Point(8) = 	{0	,0	,12.6 * cm_to_m};
Point(9) = 	{2.45	* cm_to_m,0	,0};
Point(10) = 	{3.0 * cm_to_m	,0	,0};
Point(11) = 	{3.0 * cm_to_m	,0	,12.6	* cm_to_m};
Point(12) = 	{4.0 * cm_to_m ,0	,12.6 * cm_to_m};
Point(13) = 	{4.0 * cm_to_m	,0	,18.4	* cm_to_m};
Point(14) = 	{3.0 * cm_to_m	,0	,18.4	* cm_to_m};
Point(15) = 	{3.0 * cm_to_m	,0	,20.4	* cm_to_m};
Point(16) = 	{2.45 * cm_to_m ,0	,20.4	* cm_to_m};
Point(17) = 	{1 * cm_to_m ,0	,20.4	* cm_to_m};
Point(18) = 	{1 * cm_to_m ,0	,13.4	* cm_to_m};
Point(19) = 	{1.5	* cm_to_m ,0	,12.5	* cm_to_m};

Point(20) = 	{2	* cm_to_m,0	,13.4	* cm_to_m};
Point(21) = 	{2	* cm_to_m,0	,20.4	* cm_to_m};

//spline left start
Point(23) = 	{1.43	* cm_to_m,0	,12.6188	* cm_to_m};
//spline right start
Point(24) = 	{1.57	* cm_to_m,0	,12.6188	* cm_to_m};
Point(101) = 	{1.5 * cm_to_m ,0	,20.4	* cm_to_m};
//Lines

//right side of quartz tube
Line(1) = 	{1, 2};
Line(2) = 	{2, 3};
Line(3) = 	{3, 4};
Line(4) = 	{4, 1};
//right ground
Line(5) = 	{5	,6};
Line(6) = 	{6	,7};
Line(7) = 	{7	,8};
Line(8) = 	{8	,5};
//left side of quartz tube
Line(9) = 	{9	,10};
Line(10) = 	{10	,15};
Line(11) = 	{15	,16};
Line(12) = 	{16	,9};
//left ground
Line(13) = 	{11	,12};
Line(14) = 	{12	,13};
Line(15) = 	{13	,14};
Line(16) = 	{14	,11};
//electrode
Line(17) = 	{17	,18};
Line(18) = 	{18	,23};
//Circle for electrode tip
Spline(22) =	{23	,19	,24};
Line(19) = 	{24	,20};
Line(20) = 	{20	,21};
Line(21) = 	{21	,17};


//Axis of symmetry

Line(102) = 	{101	,19};


// closing in the plasma domain
Line(92) = {9, 2};
Line(317) = {3, 17};
Line(2116) = {21, 16};



//Identifying Surfaces

// electrode domain
Line Loop(30) = {17, 18, 22, 19, 20, 21};
Physical Line("electrode_boundary") = {17, 18, 22, 19, 20};
//Plane Surface(31) = {30};
//Physical Surface("electrode") = {31};

//left ground domain
Line Loop(32) = {13, 14, 15, 16};
//Plane Surface(33) = {32};
//Physical Surface("left_ground") = {33};

//right ground domain
Line Loop(34) = {5, 6, 7, 8};
//Plane Surface(35) = {34};
//Physical Surface("right_ground") = {35};

//right quartz domain
Line Loop(36) = {1, 2, 3, 4};
Physical Line("left_inlet") = {317};
Physical Line("left_quartz_boundary") = {2};
//Plane Surface(37) = {36};
//Physical Surface("right_quartz") = {37};

//left quartz domain
Line Loop(38) = {9, 10, 11, 12};
Physical Line("right_inlet") = {2116};
Physical Line("right_quartz_boundary") = {12};
//Plane Surface(39) = {38};
//Physical Surface("left_quartz") = {39};


// plasma and flow domain
Line Loop(40) = {317, 17, 18, 22, 19, 20, 2116, 12, 92, 2};
Plane Surface(41) = {40};
Physical Surface("plasma") = {41};
// Physical axis of symmetry(if needed)
Physical Line("axis") = {102};
Physical Line("outlet") = {92};
// Refinements
max = 3e-3;
channel = 1 / 2;
inlet = 1 / 15;
electrode = 1 / 5;

start_refine_inlet = 20.4;
end_refine_inlet = 19.4;

start_refine_tip = 14.0;
end_refine_tip = 12.0;
// right_channel_box
Field[1] = Box;
Field[1].VIn = max * channel;
Field[1].VOut = max;
Field[1].XMin = 2.00 * cm_to_m;
Field[1].XMax = 2.45 * cm_to_m;
Field[1].ZMin = start_refine_tip;
Field[1].ZMax = end_refine_inlet;
Field[1].Thickness = 0.2 * cm_to_m;
// left_channel_box
Field[2] = Box;
Field[2].VIn = max * channel;
Field[2].VOut = max;
Field[2].XMin = 0.55 * cm_to_m;
Field[2].XMax = 1.00 * cm_to_m;
Field[2].ZMin = start_refine_tip;
Field[2].ZMax = end_refine_inlet;
Field[2].Thickness = 0.2 * cm_to_m;
// refinement around the electrode
Field[3] = Box;
Field[3].VIn = max * electrode;
Field[3].VOut = max;
Field[3].XMin = 0.55 * cm_to_m;
Field[3].XMax = 2.45 * cm_to_m;
Field[3].ZMin = end_refine_tip;
Field[3].ZMax = start_refine_tip;
Field[3].Thickness = 0.5 * cm_to_m;
// transition to bulk
Field[4] = Box;
Field[4].VIn = max * channel;
Field[4].VOut = max;
Field[4].XMin = 0.55 * cm_to_m;
Field[4].XMax = 2.45 * cm_to_m;
Field[4].ZMin = 10 * cm_to_m;
Field[4].ZMax = end_refine_tip;
Field[4].Thickness = 0.5 * cm_to_m;
// right inlet refinement
Field[5] = Box;
Field[5].VIn = max * inlet;
Field[5].VOut = max;
Field[5].XMin = 2.00 * cm_to_m;
Field[5].XMax = 2.45 * cm_to_m;
Field[5].ZMin = end_refine_inlet;
Field[5].ZMax = start_refine_inlet;
Field[5].Thickness = 0.2 * cm_to_m;
// left_channel_box
Field[6] = Box;
Field[6].VIn = max * inlet;
Field[6].VOut = max;
Field[6].XMin = 0.55 * cm_to_m;
Field[6].XMax = 1.00 * cm_to_m;
Field[6].ZMin = end_refine_inlet;
Field[6].ZMax = start_refine_inlet;
Field[6].Thickness = 0.2 * cm_to_m;


Field[20] = Min;
Field[20].FieldsList = {1, 2, 3, 4, 5, 6};
Background Field = 20;

Mesh.ElementOrder = 2;
