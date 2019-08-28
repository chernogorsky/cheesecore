//FIXME: this lib should not need to depend on the machine config
include <config.scad>
include <nopscadlib/core.scad>
use <lib/holes.scad>

module extrusion_profile(extrusion_size, slot_width) {
  difference() {
    // outside profile
    rounded_square(extrusion_size, r=0.5, $fn=12);

    // center hole
    circle(d=slot_width, $fs=slot_width/4);

    // slots
    translate([extrusion_size/2-slot_width/2+epsilon,0])
      square([slot_width, slot_width], center=true);
    translate([-extrusion_size/2+slot_width/2-epsilon,0])
      square([slot_width, slot_width], center=true);
    translate([0, extrusion_size/2-slot_width/2+epsilon])
      square([slot_width, slot_width], center=true);
    translate([0, -extrusion_size/2+slot_width/2-epsilon])
      square([slot_width, slot_width], center=true);
  }
}

module extrusion(extrusion_type, length, center=true) {
  extrusion_size = extrusion_width(extrusion_type);
  slot_width = extrusion_screw_size(extrusion_type);

  assert(extrusion_size != undef, "Could not look up extrusion_size");

  color("silver") {
    linear_extrude(length, center=center) {
      extrusion_profile(extrusion_size, slot_width);
    }
  }
}

extrusion_profile(15, 3.3);
translate([50,0,0]) extrusion(extrusion_type, 100);
