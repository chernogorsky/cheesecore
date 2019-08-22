// vim: set nospell:
include <config.scad>
include <nopscadlib/core.scad>
include <nopscadlib/lib.scad>

// this renders the belts at the specified carriage position
// origin is the center of the build volume.  We will adjust this later when we have better data for printhead offsets
module corexy_belts(position = [0, 0]) {
  // This defines how far about the lower belt path the upper belt path is
  vertical_offset = 10;

  // This sets how far from centerline of the machine the idler stack on the x-carriages is.
  // FIXME: the 13 is approximation of MGN12 carriage height
  // FIXME: the 5 is approximation of how far from carriage face center of idler pulley is
  x_carriage_pulley_offset = extrusion_length.y/2 - 13 - 5;

  // x/y coordinate of the x-carriage stack;
  carriage_stack = [position.x, x_carriage_pulley_offset];

  // Location of steppers in x
  // FIXME: the offset is made up
  stepper_location = extrusion_length.x/2 + 50;

  // FIXME: we use 16 tooth pulley instead of 20
  // FIXME: extract out vars for idler types to shorten this?
  // FIXME: everything but the actual carriage stack needs adjusted to put pulleys correctly in line
  // [ coordinate, pulley/idler type, whether to invert radius, whether to show pulley ]
  lower_path = [
    [[carriage_stack.x, -carriage_stack.y], GT2x20_plain_idler, true, true], // front idler stack
    [[stepper_location, -carriage_stack.y-pulley_pr(GT2x20_plain_idler) - pulley_pr(GT2x16_pulley)], GT2x16_pulley, false, true], // front stepper
    [[-extrusion_length.x/2 - 30, -x_carriage_pulley_offset - 1*pulley_pr(GT2x20_plain_idler) - pulley_pr(GT2x16_pulley)], GT2x20_toothed_idler, false, true], // front left idler
    [[-extrusion_length.x/2 - 10, x_carriage_pulley_offset], GT2x20_toothed_idler, false, true], // rear left idler
    [[carriage_stack.x, carriage_stack.y], GT2x20_toothed_idler, false, true],  // rear idler stack
    [[carriage_stack.x, 7], GT2x20_plain_idler, false, false],  // fake idler to offset belt
    [[carriage_stack.x, -7], GT2x20_plain_idler, true, false],  // fake idler to offset belt
  ];

  upper_path = [
    [[carriage_stack.x, -carriage_stack.y], GT2x20_toothed_idler, false, true], // front idler stack
    [[-extrusion_length.x/2 - 10, -x_carriage_pulley_offset], GT2x20_toothed_idler, false, true], // front left idler
    [[-extrusion_length.x/2 - 30, x_carriage_pulley_offset+1*pulley_pr(GT2x20_plain_idler)+pulley_pr(GT2x16_pulley)], GT2x20_toothed_idler, false, true], // rear left idler
    [[stepper_location, carriage_stack.y+pulley_pr(GT2x20_plain_idler) + pulley_pr(GT2x16_pulley)], GT2x20um_pulley, false, true], // rear stepper
    [[carriage_stack.x, carriage_stack.y], GT2x20_plain_idler, true, true],  // rear idler stack
    [[carriage_stack.x, 7], GT2x20_plain_idler, true, false],  // fake idler to offset belt
    [[carriage_stack.x, -7], GT2x20_plain_idler, false, false],  // fake idler to offset belt
  ];

  belt=GT2x6;

  translate([0,0,0]) {
    for(p=lower_path) {
      if(p[3])
        translate(p[0]) pulley_assembly(p[1]);
    }

    path = [ for(p=lower_path) [p[0].x, p[0].y, p[2] ? -pulley_pr(p[1]) : pulley_pr(p[1])] ];
    belt(type=belt, points=path, gap=10, gap_pt=[0,  belt_pitch_height(belt) - belt_thickness(belt) / 2]);
  }

  translate([0,0, vertical_offset]) {
    for(p=upper_path) {
      if(p[3])
        translate(p[0]) pulley_assembly(p[1]);
    }
    path = [ for(p=upper_path) [p[0].x, p[0].y, p[2] ? -pulley_pr(p[1]) : pulley_pr(p[1])] ];
    belt(type=belt, points=path, gap=10, gap_pt=[0,  belt_pitch_height(belt) - belt_thickness(belt) / 2]);
  }

  // square([1000, x_carriage_pulley_offset*2 + pulley_pr(GT2x20_toothed_idler)*2], center=true);
}

corexy_belts([0, 0]);
