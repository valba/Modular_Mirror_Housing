/* [PARTS] */

Mirror_Housing_Part = 1;// [0:No, 1:Yes]
Mirror_Bottom_Holder_Part = 1;// [0:No, 1:Yes]
Mirror_Top_Holder_Part = 1;// [0:No, 1:Yes]
Long_Adapter_Part = 1;// [0:No, 1:Yes]
Short_Adapter_Part = 1;// [0:No, 1:Yes]
Mirror_Plate_Part = 1;// [0:No, 1:Yes]

/* [HOUSING_PARAMETERS] */

//windows

window_height = 160;
window_width = 210;
window_width_repaired = window_width - 0.001;
    
//frames

frame_thickness = 50;
frame_thickness_repaired = frame_thickness + 0.001;
frame_height = window_height + 2 * frame_thickness;
frame_width = window_width + 2 * frame_thickness;
frame_width_repaired = frame_width + 0.001;

// [0:frame_thickness]
chamfer = 15;
bevel_width = frame_thickness - chamfer;
// [0:frame_thickness]
bevel_height = 25;

//screws

// [basement_height = screwhead_height + screwstem_height]
screwhead_height = 45;
// [basement_height = screwhead_height + screwstem_height]
screwstem_height = 25;
screwhead_radius = 40;
screwstem_radius = 20;

make = "INEXTREMIS";

//mirror

/* [MIRROR_PLATE_PARAMETERS] */

mirror_geometry = "elliptic";// [elliptic, rectangular, circular]
mirror_width = 200;
mirror_height = 100;
mirror_thickness = 30;
//mirror_geometry = "elliptic";
//mirror_geometry = "rectangular";
//mirror_geometry = "circular";

// MIRROR PLATE POSITION

//if (Mirror_Plate_Part == 1){
//    translate(frame_center) rotate([0,0,45])
//        color("pink") mirror_plate();
//}

// MIRROR POSITION

//Mirror's position
//translate(frame_center) rotate([0,0,135])
//color("silver") mirror();

//Mirror's bottom platform

/* [PLATFORM_PARAMETERS] */

platform_thickness = frame_thickness - 30;
rail_guide_thickness = 20;
rail_guide_height = frame_thickness - platform_thickness;
//translate([0, 0, basement_height + platform_thickness/2]) 
//color("pink") mirror_bottom_platform();

/* [ADAPTER_PARAMETERS] */

// max. disk thickness
groove_thickness = 30;
// max. disk diameter [0: window_width - frame_thickness]
groove_width = 160;


/* [Hidden] */

//basement
basement_height = screwhead_height + screwstem_height;
basement_width = frame_width;

//complete block
block_height = basement_height + frame_height;
block_width = frame_width;
block_width_repaired = block_width + 0.001;
echo("BLOCK SIZE (L x W x H) = ", block_width, block_width, block_height);

//origin
ox = 0; //origin's_x
oy = 0; //origin's_y
oz = 0; //origin's_z

block_center = [ox, oy, oz + block_height/2];
frame_center = [ox, oy, oz + basement_height + frame_height/2];
window_center = frame_center;
basement_center = [ox, oy, oz + basement_height/2];

groove_height = block_height - groove_width/2;

// MIRROR HOUSING
if (Mirror_Housing_Part == 1) {
    mirror_housing();
    echo("MIRROR HOUSING SIZE (L x W x H) = ", frame_thickness * 2, frame_width, block_height + frame_thickness + groove_width);
}

//MIRROR PLATFORMS
if (Mirror_Bottom_Holder_Part == 1)
    translate ([250, 500, platform_thickness/2]) mirror_bottom_platform();
if (Mirror_Top_Holder_Part == 1)
    translate ([-250, 500, platform_thickness/2]) mirror_top_platform();
if (Mirror_Plate_Part == 1)
    translate ([500, 0, frame_height/2]) mirror_plate();  

//SAMPLE ADAPTERS
if (Long_Adapter_Part == 1)
    translate ([-500, 0, (block_height + groove_width)/2 + frame_thickness/2 - groove_width/2]) long_adapter();
if (Short_Adapter_Part == 1)
    translate ([0, -500, (block_height + groove_width)/2 + frame_thickness/2 - groove_width/2])  short_adapter();  

// MIRROR HOUSING
module mirror_housing() {
difference() {
    translate(block_center)
    block(block_width, block_width, block_height);
    translate(frame_center)
    windowHoles();
    translate(basement_center)
        basementHole(screwhead_height, screwhead_radius, screwstem_height, screwstem_radius);

    //VERTICAL GRAFFITI
    //translate(basement_center + [0, frame_width/2 - 3 , 0])
    //    rotate([90, 0, 180])
    //    letterBlock(make, size = 20);

    //BASE GRAFFITI
    translate([-frame_width/4, 0, 10])
        rotate([180, 0, 90])
        letterBlock(make, size = 25 );
}
// FRAME FOR ADAPTERS
translate(block_center + [frame_thickness + block_width/2, 0, 0]) 
    color ("white") sampleSupport();

// ADAPTER POSITION
//translate(block_center + [frame_thickness + block_width/2, 0, basement_height]) 
 //   color ("orange") short_adapter ();

}
function ngon(num, r) = [for (i=[0:num-1], a=i*360/num) [ r*cos(a), r*sin(a) ]];

module cubic_torus(){
    rotate_extrude(convexity = 10)
        translate([80, 0, 0]) rotate([0, 0, 45])
            polygon(ngon(3, frame_thickness*1.5));
	}

module mirror_bottom_platform() {
    difference () {
        union () {
            cube ([window_width, window_width, platform_thickness], center = true);
            translate ([0, 0, platform_thickness/2 + rail_guide_height/2]) rotate([0, 0, -45]) 
                cube ([mirror_width * sqrt(2) - mirror_thickness * 2 * sqrt(3), mirror_thickness + 2 * rail_guide_thickness, rail_guide_height], center = true);
        }
        union () {
            translate ([0, 0, platform_thickness/2 + rail_guide_height/2 - rail_guide_thickness/2]) 
                rotate([0, -90, -45]) rotate([0, 0, -45]) prism_z(mirror_thickness * sqrt(2), mirror_thickness * sqrt(2), window_width * sqrt(2));
            translate ([0, 0, platform_thickness/2 + rail_guide_height/2]) { 
                rotate([0, 0, -45]) 
                    cube ([mirror_width * sqrt(2), mirror_thickness, rail_guide_height], center = true);
                difference () {
                    cube ([window_width + frame_thickness * 2, window_width + frame_thickness * 2, platform_thickness + rail_guide_height], center = true);
                    cube ([window_width, window_width, platform_thickness + rail_guide_height+ 0.001], center = true);
                }
            }
        }
    }
}

module mirror_top_platform() {
    union () {
        cube ([frame_width - frame_thickness, frame_width - frame_thickness, platform_thickness], center = true);
        translate ([0, 0, platform_thickness])
            mirror_bottom_platform();
    }
}

module mirror () {
    if (mirror_geometry == "elliptic")
        elliptic_mirror (mirror_width, mirror_height, mirror_thickness);
    if (mirror_geometry == "rectangular")
        rectangular_mirror (mirror_width, mirror_height, mirror_thickness);
    if (mirror_geometry == "circular")
        circular_mirror (mirror_width, mirror_height, mirror_thickness);
}


module rectangular_mirror (w, h, l) {
    translate([0, mirror_thickness/2, 0]) cube([mirror_width, mirror_thickness, mirror_height], center = true);
}

module circular_mirror (w, h, l) {
    translate([0, mirror_thickness/2, 0]) rotate([-90, 0, 0]) cylinder(h = mirror_thickness, r = mirror_width/2 , center = true);
}

module elliptic_mirror (w, h, l) {
    w = w /2;
    l = l;
    z = l / sin(45);
    rotate(a = [180, -90, -90]) {
    side = w / sin(45) + z;
        translate ([0, -side / 2, (-side + z)/2 - l/2 + 0.001]) rotate(a = [-45, 0, 0]) {
            intersection () {
                difference () {
                    cylinder(h = side * 1.15, r = w/2);
                    translate([-w, -w, z/2]) rotate ([45, 0 ,0]) cube  ([2 * side, 2 * side, 2 * side]);
                }
                translate([-w, -w, -z/2]) rotate ([45, 0 ,0]) cube  ([2 * side, 2 * side, 2 * side]);
            }    
        }
    }
}


module mirror_plate () {
    difference(){
            rotate ([0, 0, 45]) mainRoom (window_width, window_width, frame_height);
            translate ([0, -window_width * sqrt(2)/2 + 0.001, 0]) prism_z (window_width * sqrt(2), window_width * sqrt(2), frame_height);
            rotate ([0, 0, 90]) mirror();
    }
 }

module sampleSupport () {
    difference() {
        translate([-frame_thickness * 0.25, 0, 0])
            cube([frame_thickness * 2.5, block_width + frame_thickness * 2, block_height], center = true);
	translate([-0, 0, basement_height])
        color ("grey") slot();
        translate( [- frame_thickness_repaired *1.5, -block_width_repaired/2 - frame_thickness, 0])
            rotate (a = [180, 180, 180])
                prism_z(bevel_height, frame_thickness, block_height *2);
        translate( [- frame_thickness *1.5, block_width_repaired/2 + frame_thickness, 0])
            rotate (a = [180, 0, 0])
                prism_z(bevel_height, frame_thickness, block_height);
/*        translate([-frame_thickness , 0, basement_height])
            cube([frame_thickness, window_width + frame_thickness, window_height + frame_thickness * 2.5], center = true);
*/    }
}

module long_adapter() {
    difference() {
        union() {
            translate([0, 0, -frame_thickness]) slot3(); 
            translate([0, 0, -frame_thickness/2]) slot2(); 
  //          translate([0, 0, -frame_thickness]) slot1(); 
        }
        translate([0, 0, -frame_thickness/2]) groove(); 
    }
}

module short_adapter() {
    difference() {
        long_adapter();
        translate([0, 0, frame_thickness/2 + block_height/2 + groove_width/2]) 
        cube ([frame_thickness * 2, frame_width, groove_width * 2], center = true);
    }
}
module slot() {
    difference() {
        union() {
            translate([0, 0, -frame_thickness]) slot3(); 
            translate([0, 0, -frame_thickness/2]) slot2(); 
            translate([0, 0, -frame_thickness]) slot1(); 
        }
    //    translate([0, 0, -frame_thickness/2]) groove(); 
    }
}

module groove() {
    rotate (a = [0, 90, 0]) {
        cylinder(h = frame_thickness * 3, r1 = groove_width * 0.22, r2 = groove_width * 0.44, center = true);
        cylinder(h = groove_thickness, r1 = groove_width/2, r2 = groove_width/2, center = true);
    }
	translate([0, 0, groove_height/2]) 
		rotate (a = [0, 0, 0]) 
			cube([groove_thickness, groove_width, groove_height], center = true);
	translate([0, 0, groove_height]) 
    rotate (a = [0, 90, 0]) 
        cylinder(h = groove_thickness, r1 = groove_width/2, r2 = groove_width/2, center = true);
}

module slot3() {
   	//External
    translate([frame_thickness/2, 0, 0]) 
    union() {
        difference() {
            cube([frame_thickness, frame_width - frame_thickness, block_height], center = true);
            union() {
        // Horizontal bar        
            translate([-frame_thickness/2, 0, -window_height/2 - frame_thickness/2])
                rotate (a = [-90, 180, 180])
                    prism_z(frame_thickness, bevel_height, window_width + frame_thickness);
        translate ([0, window_width/2 + frame_thickness/2, -window_height/2 -frame_thickness/2 ])
            cube([frame_thickness, frame_thickness,  frame_thickness], center = true);
        translate ([0, -window_width/2 - frame_thickness/2, -window_height/2 -frame_thickness/2 ])
            cube([frame_thickness, frame_thickness,  frame_thickness], center = true);
        translate ([0, 0, -block_height/2 ])
            cube([frame_thickness, frame_width,  basement_height + frame_thickness_repaired], center = true);
            translate([-frame_thickness/2, - block_width_repaired/2 + bevel_height, 0])
                rotate (a = [0, 0, 0])
                    prism_z(frame_thickness, bevel_height, block_height);
            translate([-frame_thickness/2, + block_width_repaired/2 - bevel_height, 0])
                rotate (a = [180, 0, 0])
                    prism_z(frame_thickness, bevel_height, block_height);
            }
        }
        translate ([-frame_thickness/2, window_width/2, -window_height/2 ])       
            rotate ([0, 90, 0])
                pyramid (frame_thickness, bevel_height);
        translate ([-frame_thickness/2, - window_width/2, -window_height/2])
            rotate ([0, 90, 0])
                pyramid (frame_thickness, bevel_height);
    }
}

module slot2() {
	//Internal
    translate([-frame_thickness/2, 0, 0]) 
        difference() {
            union() {
                translate ([0, 0, (frame_thickness + groove_width)/2])
                cube([frame_thickness, frame_width, block_height + frame_thickness + groove_width], center = true);
            }
            translate([-frame_thickness/2, - frame_width/2, 0])
                rotate (a = [0, 0, 0])
                    prism_z(frame_thickness, bevel_height, block_height);
            translate([-frame_thickness/2, frame_width_repaired/2.0, 0])
                rotate (a = [180, 0, 0])
                    prism_z(frame_thickness, bevel_height, block_height);
        }
}

module slot1() {
//Internal
    translate([-frame_thickness *1.5, 0, frame_thickness /2]) 
        cube([frame_thickness, frame_width, block_height + frame_thickness + groove_width], center = true);
}

module letterBlock(word, size) {
            // convexity is needed for correct preview
            // since characters can be highly concave
            linear_extrude(height=size, convexity=4)
                text(word, 
                     size=size,
//                   font="Bitstream Vera Sans:style=Bold",
//                   font="Liberation Sans:style=Bold",
                     font="SF Fedora Outline:style=Bold",
//                   font="TeXGyreChorus:style=Bold",
                     halign="center",
                     valign="center");
}

module prism_z(w, h, l) {
	translate([0, 0, -l/2]) rotate(a = [0, 0, 0]) 
	linear_extrude(height = l) polygon(points = [
		[0, 0],
		[w, 0],
		[0, h]
	], paths=[[0,1,2]]);
}

module wHoleA() rotate([0, 0, 0]) windowHole(frame_width_repaired, window_width, window_height);

module wHoleB() rotate([0, 0, 90]) windowHole(frame_width_repaired, window_width, window_height);

module wHoleC() mainRoom(window_width, window_width, frame_height);

module windowHoles() {
    union() {
        wHoleA();
        wHoleB();
        wHoleC();
        hFrames();
        vFrames();
        cones();
    }
}

module block(l, w, h) {
	cube([l, w, h], center = true);	//main room
}

module mainRoom(l, w, h) {
	color("white") cube([l, w, h], center = true);	//main room
}

module basementHole(head_height, head_radius, stem_height, stem_radius) {
    color("silver") {
        union(){
            translate([0, 0, stem_height/2]) 
            cylinder(h = head_height, r1 = head_radius, r2 =  head_radius,  center = true); 
            translate([0, 0, -head_height/2]) 
            cylinder(h = stem_height, r1 = stem_radius, r2 =  stem_radius,  center = true); 
        }
    }
}

module windowHole(l, w, h) {
    cube([l, w, h],  center = true); 
}

module pyramid(h, r) {
    cylinder(h = h, r1 = 0, r2 = r);
}

module hFrames(){
   //TOP FRAMES
    color("red") translate([-frame_width_repaired/2, 0, window_height/2]) rotate (a = [90, 0, 0])
    prism_z(bevel_width, bevel_height, window_width_repaired);
    color("yellow") translate([frame_width_repaired/2, 0,  window_height/2]) rotate (a = [90, 0, 180])
    prism_z(bevel_width, bevel_height, window_width_repaired);
    color("blue") translate([0,  -frame_width_repaired/2, window_height/2]) rotate (a = [90, 0, 90])
    prism_z(bevel_width, bevel_height, window_width_repaired);
    color("green") translate([0, frame_width_repaired/2, window_height/2]) rotate (a = [90, 0, -90])
    prism_z(bevel_width, bevel_height, window_width_repaired);
    
    //BOTTOM FRAMES
    color("red") translate([-frame_width_repaired/2, 0, -window_height/2]) rotate (a = [90, 180, 180])
    prism_z(bevel_width, bevel_height, window_width_repaired);
    color("yellow") translate([frame_width_repaired/2, 0, -window_height/2]) rotate (a = [90, 180, 0])
    prism_z(bevel_width, bevel_height, window_width_repaired);
    color("blue") translate([0, -frame_width_repaired/2, -window_height/2]) rotate (a = [90, 180, -90])
    prism_z(bevel_width, bevel_height, window_width_repaired);
    color("green") translate([0, frame_width_repaired/2, -window_height/2]) rotate (a = [90, 180, 90])
    prism_z(bevel_width, bevel_height, window_width_repaired);
}   
    
module vFrames() {
    color("red") translate([- frame_width_repaired/2, + window_width_repaired/2, 0]) rotate (a = [0, 0, 0])
    prism_z(bevel_width, bevel_height, window_height);
    color("red") translate([- frame_width_repaired/2, - window_width_repaired/2, 0]) rotate (a = [180, 0, 0])
    prism_z(bevel_width, bevel_height, window_height);
    color("yellow") translate([+ frame_width_repaired/2, - window_width_repaired/2, 0]) rotate (a = [0, 0, 180])
    prism_z(bevel_width, bevel_height, window_height);
    color("yellow") translate([frame_width_repaired/2, window_width_repaired/2, 0]) rotate (a = [180, 0, 180])
    prism_z(bevel_width, bevel_height, window_height);
    
    color("blue") translate([ - window_width_repaired/2, - frame_width_repaired/2, 0]) rotate (a = [0, 0, 90])
    prism_z(bevel_width, bevel_height, window_height);
    color("blue") translate([ + window_width_repaired/2,  - frame_width_repaired/2, 0]) rotate (a = [180, 0, 90])
    prism_z(bevel_width, bevel_height, window_height);
    color("green") translate([+ window_width_repaired/2, + frame_width_repaired/2, 0]) rotate (a = [0, 0, -90])
    prism_z(bevel_width, bevel_height, window_height);
    color("green") translate([ - window_width_repaired/2, + frame_width_repaired/2, 0]) rotate (a = [180, 0, -90])
    prism_z(bevel_width, bevel_height, window_height);
}     

module cone() {
    pyramid (frame_thickness - chamfer, bevel_height);
}

module cones() {
    //TOP cones
    color("yellow") translate ([window_width/2 + chamfer, window_width/2, window_height/2]) rotate ([0, 90, 0])
    cone();
    color("yellow") translate ([window_width/2 + chamfer, -window_width/2, window_height/2]) rotate ([0, 90, 0])
    cone();
    color("red") translate ([-(window_width/2 + chamfer), -window_width/2, window_height/2]) rotate ([0, -90, 0])
    cone();
    color("red") translate ([-(window_width/2 + chamfer), window_width/2, window_height/2]) rotate ([0, -90, 0])
    cone();

    color("blue") translate ([window_width/2, -(window_width/2 + chamfer), window_height/2]) rotate ([90, 0, 0])
    cone();
    color("blue") translate ([-window_width/2, -(window_width/2 + chamfer), window_height/2]) rotate ([90, 0, 0])
    cone();
    color("green") translate ([-window_width/2, window_width/2 + chamfer, window_height/2]) rotate ([-90, 0, 0])
    cone();
    color("green") translate ([window_width/2, window_width/2 + chamfer, window_height/2]) rotate ([-90, 0, 0])
    cone();
        
    //bottom cones
    color("yellow") translate ([window_width/2 + chamfer, -window_width/2, -window_height/2]) rotate ([0, 90, 0])
    cone();
    color("yellow") translate ([window_width/2 + chamfer, window_width/2, -window_height/2]) rotate ([0, 90, 0])
    cone();
    color("red") translate ([-(window_width/2 + chamfer), window_width/2, -window_height/2]) rotate ([0, -90, 0])
    cone();
    color("red") translate ([-(window_width/2 + chamfer), -window_width/2, -window_height/2]) rotate ([0, -90, 0])
    cone();

    color("blue") translate ([window_width/2, -(window_width/2 + chamfer), -window_height/2]) rotate ([90, 0, 0])
    cone();
    color("blue") translate ([-window_width/2, -(window_width/2 + chamfer), -window_height/2]) rotate ([90, 0, 0])
    cone();
    color("green") translate ([-window_width/2, window_width/2 + chamfer, -window_height/2]) rotate ([-90, 0, 0])
    cone();
    color("green") translate ([window_width/2, window_width/2 + chamfer, -window_height/2]) rotate ([-90, 0, 0])
    cone();
}
