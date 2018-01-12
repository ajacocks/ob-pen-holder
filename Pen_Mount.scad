//
// copyright 2018 J. Alexander Jacocks - jjacocks@mac.com
// creative commons attribution licensed
//
resolution = 60;

mh_x_offset = 73/2; // 41mm = side, 73mm = front
height = 20;
m5_hole = 5.5; // m5
pen_hole = 12.5; // sharpie + 0.5mm
pen_wall = 5;
thickness = 3;
width = mh_x_offset*2 + 14;
roundover = 4;
m4_thickness = 2.9;
m4_width = 6.9;
m4_hole = 4.5;

// trim corners to a given radius
module corner_radius( radius, thickness, corner="all", resolution=30 ) {
    difference() {
        cube([ radius*2, radius*2, thickness ], center=true );
        cylinder( r=radius, h=thickness, center=true, $fn=resolution );
        if( corner == "topright" ) {
            translate([ -radius, -radius, -thickness/2 ]) {
                cube([ radius, radius*2, thickness ]);
                cube([ radius*2, radius, thickness ]);
            }
        } else if( corner == "topleft" ) {
            translate([ -radius, -radius, -thickness/2 ]) {
                cube([ radius, radius, thickness ]);
            }
            translate([ 0, -radius, -thickness/2 ]) {
                cube([ radius, radius*2, thickness ]);
            }
        } else if( corner == "bottomleft" ) {
            translate([ -radius, 0, -thickness/2 ]) {
                cube([ radius*2, radius, thickness ]);
            }
            translate([ 0, -radius, -thickness/2 ]) {
                cube([ radius, radius, thickness ]);
            }
        } else if( corner == "bottomright" ) {
            translate([ -radius, 0, -thickness/2 ]) {
                cube([ radius*2, radius, thickness ]);
            }
            translate([ -radius, -radius, -thickness/2 ]) {
                cube([ radius, radius, thickness ]);
            }
        }
    }
}


// main body
difference() {
    // base plate
    cube([ width, height, thickness ], center=true);
    // m5 mounting holes
    translate([ -mh_x_offset, 0, 0 ]) {
        cylinder( d=m5_hole, h=thickness+1, $fn=resolution, center=true );
    }
    translate([ mh_x_offset, 0, 0 ]) {
        cylinder( d=m5_hole, h=thickness+1, $fn=resolution, center=true );
    }
    // radius all 4 corners
    translate([ -width/2+roundover, height/2-roundover, 0 ]) {
        corner_radius( roundover, thickness, "topleft" );
    }
    translate([ width/2-roundover, height/2-roundover, 0 ]) {
        corner_radius( roundover, thickness, "topright" );
    }
    translate([ -width/2+roundover, -height/2+roundover, 0 ]) {
        corner_radius( roundover, thickness, "bottomleft" );
    }
    translate([ width/2-roundover, -height/2+roundover, 0 ]) {
        corner_radius( roundover, thickness, "bottomright" );
    }
}

// pen holder
difference() {
    // pen cylinder
    translate([ 0, 0, thickness/2 + pen_hole/2 ]) {
        rotate([ 90, 0, 0 ]) {
            linear_extrude( height=height, center=true ) {
                difference() {
                    offset( r=pen_wall ) {
                        circle( r=pen_hole/2, center=true, $fn=resolution );
                    }
                    circle( r=pen_hole/2, center=true, $fn=resolution );
                }
            }
        }
    }
    // trim off unnecessary height
    translate([ 0, 0, -thickness ]) {
        cube([ width, height, thickness ], center=true);
    }
    translate([ 0, 0, pen_hole + pen_wall/2 + thickness ]) {
        cube([ width, height, thickness ], center=true);
    }
    // cut holes for m4 grub nuts
    translate([ pen_hole/2 + pen_wall*11/24, 0, thickness/2 + pen_hole/2 ]) {
        cube([ m4_thickness, height, m4_width ], center=true );
    }
    translate([ -pen_hole/2 - pen_wall*11/24, 0, thickness/2 + pen_hole/2 ]) {
        cube([ m4_thickness, height, m4_width ], center=true );
    }
    // cut holes for m4 grub screws
    translate([ pen_hole/2+pen_wall/2, 0, thickness/2 + pen_hole/2 ]) {
        rotate([ 0, 90, 0 ]) {
            cylinder( d=m4_hole, h=pen_wall+1, $fn=resolution, center=true );
        }
    }
    translate([ -pen_hole/2-pen_wall/2, 0, thickness/2 + pen_hole/2 ]) {
        rotate([ 0, 90, 0 ]) {
            cylinder( d=m4_hole, h=pen_wall+1, $fn=resolution, center=true );
        }
    }
}