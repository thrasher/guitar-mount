// Ukulele holder for music stand
// by Jason Thrasher
// created 9/29/2018

include <polygon.scad>;

$fn=50;

//echo(points);

CLIP_THICKNESS = 1.2;
CLIP_HEIGHT = 20;
STAND_TOP_DIA = 16;
STAND_BOTTOM_DIA = 28; // 27.8mm on height grip
INSTRUMENT_NECK = 42;
CRADLE_RADIUS = 10;
CRADLE_DEPTH = 10;

// music stand clip
module clip() {
    rotate([0,0,45])
    linear_extrude(height = CLIP_HEIGHT, twist = 0, slices = 1) {
        offset(r = CLIP_THICKNESS) {
            s = STAND_TOP_DIA / (POLYGON_RADIUS - CLIP_THICKNESS) / 2;
            scale(s) polygon(points = points);
        }
    }
}


module cradle_half() {
    union() {
        rotate_extrude(angle=90, convexity = 10)
        translate([(INSTRUMENT_NECK+2*CRADLE_RADIUS)/2, 0, 0])
        circle(r = CRADLE_RADIUS);

        translate([(INSTRUMENT_NECK+2*CRADLE_RADIUS)/2,0,0])
        rotate([90,0,0])
        cylinder(r = CRADLE_RADIUS, h = CRADLE_DEPTH);

        translate([(INSTRUMENT_NECK+2*CRADLE_RADIUS)/2,-10,0])
        hull() {
//        translate([(0,10,0])
//        rotate([90,0,0])
//        cylinder(r = CRADLE_RADIUS, h = CRADLE_DEPTH);

            sphere(r=CRADLE_RADIUS);
            translate([-CRADLE_RADIUS/2,CRADLE_RADIUS-CRADLE_RADIUS/2,CRADLE_RADIUS*1.5])
            sphere(r=CRADLE_RADIUS/2);
        }
    }
}

module cradle(){
    cradle_half();
    mirror([1,0,0]) cradle_half();
}

module bar() {
    hull() {
        translate([0,-STAND_TOP_DIA/2-1,CLIP_HEIGHT/2])
        cube([6,1,CLIP_HEIGHT], center = true);
    //    translate([0,-60+(INSTRUMENT_NECK+2*CRADLE_RADIUS)/2,CRADLE_RADIUS])
    //    sphere(r=CRADLE_RADIUS);
    translate([0,-60+(INSTRUMENT_NECK+2*CRADLE_RADIUS)/2,CRADLE_RADIUS])
    cube([6,1,CRADLE_RADIUS*2], center = true);
    }
}

module ziptie() {
    ZIP_H = 5 ;
    ZIP_W = 2;
    translate([0,0,(CLIP_HEIGHT)/2])
    difference() {
        cylinder(d = STAND_TOP_DIA + CLIP_THICKNESS*2*2-1 + ZIP_W*2, h=ZIP_H, center=true);
        cylinder(d = STAND_TOP_DIA + CLIP_THICKNESS*2*2, h=ZIP_H*2, center=true);
    }
}

module body() {
    clip();
    translate([0,-60, CRADLE_RADIUS])
    cradle();
    bar();
}

module music_stand() {
    difference() {
        body();
        ziptie();
    }
}

module wall_mount() {
    difference() {
    union() {
        translate([0,-70, CRADLE_RADIUS])
        cradle();

        difference() {
            hull(){
                translate([0,0,50])
                sphere(d=20);
                translate([10,0,10])
                sphere(d=20);
                translate([-10,0,10])
                sphere(d=20);
                translate([0,-70+(INSTRUMENT_NECK+2*CRADLE_RADIUS)/2,CRADLE_RADIUS])
                sphere(d=20);
            }
            translate([0,15,0])
            cube([50,30,200], center=true);
        }
    }
    screws();
    }
}

// screw hole
module screw_hole(head_dia, body_dia) {
    depth = 50;
    cylinder(d = head_dia, h = depth);
    translate([0, 0, -depth])
    cylinder(d = body_dia, h = depth);
    // cone for drywall screws
    translate([0, 0, -body_dia])
    cylinder(d2 = head_dia, d1 = body_dia, h = body_dia);
}

module screws() {
    screw_head_dia = 9;
    screw_body_dia = 5;
    screw_head_depth = 0.2;
    
    rotate([90,0,0]) {
        translate([0,10,8])
        screw_hole(screw_head_dia, screw_body_dia);
        translate([0,50,8])
        screw_hole(screw_head_dia, screw_body_dia);
    }
}

part = 1;
if (part == 1) {
     wall_mount();
} else if (part == 2) {
     music_stand();
} else {
     echo("error: specify part 1 or 2");
}
