// vim: set nospell:
include <config.scad>
use <extrusion.scad>
use <corner_cube.scad>
use <lib/mirror.scad>

cornercube=extrusion; //1515 and 2020 these are the same. 3030 and 4040 will need to look at corner braces perhaps?

module vertical_extrusions() {
  mirror_xy() {
    translate([horizontalX/2+extrusion/2, horizontalY/2+extrusion/2, 0])
      extrusion(extrusion, corneruprightZ, 3.3, center=true);
  }
}

module Xextrusions()
{
  //Top Front X
  translate ([extrusion,extrusion,corneruprightZ+extrusion])
  rotate([0,0,-90])
  aluminiumextrusion(horizontalX,0);
  //Top Rear X
  translate ([horizontalX+extrusion,horizontalY+extrusion,corneruprightZ+extrusion])
  rotate([0,0,90])
  aluminiumextrusion(horizontalX,0);
  //Bottom Rear X
  translate ([horizontalX+extrusion,horizontalY+extrusion,0])
  rotate([0,0,90])
  aluminiumextrusion(horizontalX,0);
  //Bottom Front X
  translate ([extrusion,extrusion,0])
  rotate([0,0,-90])
  aluminiumextrusion(horizontalX,0);
  }

module horizontalYextrusions()
{
        // Bottom Left Y
        translate ([0,extrusion,0])
        rotate([0,0,0])
        aluminiumextrusion(horizontalY,0);
        // Bottom Right Y
        translate ([horizontalX+extrusion,extrusion,0])
        rotate([0,0,0])
        aluminiumextrusion(horizontalY,0);
        // Top Left Y
        translate ([0,extrusion,corneruprightZ+extrusion])
        rotate([0,0,0])
        aluminiumextrusion(horizontalY,0);
        // Bottom Right Y
        translate ([horizontalX+extrusion,extrusion,corneruprightZ+extrusion])
        rotate([0,0,0])
        aluminiumextrusion(horizontalY,0);
        echo("horizontalY are ", horizontalY , "mm");

}

////////////////////////
// BOM: Corner Cubes
////////////////////////
module corner_cubes() {
  mirror_xyz() {
    translate([horizontalX/2+extrusion/2, horizontalY/2+extrusion/2, corneruprightZ/2+extrusion/2])
      rotate([0,0,90])
        corner_cube();
  }
}

module frame() {
  // BOM Item Name: 15x15x425 (Misumi HFS3-1515-425 )
  // BOM Quantity: 4
  // BOM Link: http://railco.re/misumi
  // Notes: Misumi pre-cut (Horizontal Y)
  horizontalYextrusions();

  translate([horizontalX/2+extrusion, horizontalY/2+extrusion, corneruprightZ/2+extrusion])
    vertical_extrusions();

  // BOM Item Name: 15x15x460 (Misumi HFS3-1515-460 )
  // BOM Quantity: 4
  // BOM Link: http://railco.re/misumi
  // Notes: Misumi pre-cut (Horizontal X)
  //horizontalX=460;  // Misumi pre-cut (Horizontal X)

  // Manaul attempt at BOM generation :)
  echo("BOM Item Name: Quantity 4: 15x15x",horizontalX," (Misumi HFS3-1515-",horizontalX," )");
  Xextrusions();

  // BOM Item Name: 15x15 Corners (8)
  // BOM Quantity: 1
  // BOM Link: http://railco.re/1515corners
  // Notes: 4 Spare corners after ordering
  translate([horizontalX/2+extrusion, horizontalY/2+extrusion, corneruprightZ/2+extrusion])
    corner_cubes();
}

frame();
