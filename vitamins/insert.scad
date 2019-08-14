//
// NopSCADlib Copyright Chris Palmer 2018
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// This file is part of NopSCADlib.
//
// NopSCADlib is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either version 3 of
// the License, or (at your option) any later version.
//
// NopSCADlib is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
// without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// See the GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License along with NopSCADlib.
// If not, see <https://www.gnu.org/licenses/>.
//

//
//! Heatfit threaded inserts. Can be pushed into thermoplastics using a soldering iron with a conical bit set to 200&deg;C.
//
include <../core.scad>

function insert_length(type)         = type[1]; //! Length
function insert_outer_d(type)        = type[2]; //! Outer diameter at the top
function insert_hole_radius(type)    = type[3] / 2; //! Radius of the required hole in the plastic
function insert_screw_diameter(type) = type[4]; //! Screw size
function insert_barrel_d(type)       = type[5]; //! Diameter of the main barrel
function insert_ring1_h(type)        = type[6]; //! Height of the top and middle rings
function insert_ring2_d(type)        = type[7]; //! Diameter of the middle ring
function insert_ring3_d(type)        = type[8]; //! Diameter of the bottom ring

function insert_hole_length(type) = round_to_layer(insert_length(type));

module insert(type) { //! Draw specified insert
    length = insert_length(type);
    ring1_h = insert_ring1_h(type);

    chamfer1 = (insert_ring2_d(type) - insert_barrel_d(type)) / 2;
    chamfer2 = (insert_ring3_d(type) - insert_barrel_d(type)) / 2;
    ring2_h = ring1_h + chamfer1;
    gap = (length - ring1_h - ring2_h- chamfer2) / 3;

    vitamin(str("insert(", type[0], "): Heatfit insert M", insert_screw_diameter(type)));
    $fn = 64;
    explode(20, offset =[0, 0, -5]) color(brass) translate_z(eps) {
        vflip(){
            r1 = insert_screw_diameter(type) / 2;
            r2 = insert_barrel_d(type) / 2;
            r3 = insert_ring3_d(type) / 2;
            r4 = insert_ring2_d(type) / 2;
            r5 = insert_outer_d(type) / 2;
            h1 = ring1_h;
            h2 = ring1_h + gap;
            h3 = ring1_h + gap + ring2_h;
            h4 = ring1_h + gap + ring2_h + gap;
            rotate_extrude()
                polygon([
                    [r1, 0],
                    [r1, length],
                    [r2, length],
                    [r3, length - chamfer2],
                    [r3, h4],
                    [r2, h4],
                    [r2, h3],
                    [r4, h3 - chamfer1],
                    [r4, h2],
                    [r2, h2],
                    [r2, h1],
                    [r5, h1],
                    [r5, 0],
                ]);
        }
    }
}

module insert_hole(type, counterbore = 0, horizontal = false) { //! Make a hole to take an insert, ```counterbore``` is the extra length for the screw
    h = insert_hole_length(type);

    render(convexity = 2)
        if(horizontal) {
            teardrop_plus(r = insert_hole_radius(type), h = 2 * h);

            if(counterbore)
                teardrop_plus(r = insert_screw_diameter(type) / 2 + 0.1, h = 2 * (h + counterbore));
        }
        else {
            poly_cylinder(r = insert_hole_radius(type), h = 2 * h, center = true);

            if(counterbore)
                poly_cylinder(r = insert_screw_diameter(type) / 2 + 0.1, h = 2 * (h + counterbore), center = true);
        }
}

function insert_boss_radius(type, wall) = corrected_radius(insert_hole_radius(type)) + wall; //! Compute the outer radius of an insert boss

module insert_boss(type, z, wall = 2 * extrusion_width) { //! Make a boss to take an insert
    render(convexity = 3)
        difference() {
            ir = insert_hole_radius(type);
            linear_extrude(height = z)
                hull()
                    poly_ring(corrected_radius(ir) + wall, ir);

            translate_z(z)
                insert_hole(type, max(0, z - insert_hole_length(type) - 2 * layer_height));
        }
}

module insert_lug(insert, wall, side, counter_bore = 0) { //! Make a flying insert lug, see [ssr_shroud](#Ssr_shroud)
    boss_r = insert_boss_radius(insert, wall);
    boss_h = insert_hole_length(insert);
    boss_h2 = boss_h + counter_bore;
    translate_z(-boss_h)
        linear_extrude(height = boss_h)
             difference() {
                hull() {
                    circle(boss_r);

                    translate([side * (boss_r - 1), 0])
                        square([eps, 2 * boss_r], center = true);
                }
                poly_circle(insert_hole_radius(insert));
            }

    // insert boss counter_bore
    translate_z(-boss_h2) {
        linear_extrude(height = counter_bore + eps)
             difference() {
                hull() {
                    circle(boss_r);

                    translate([side * (boss_r - 1), 0])
                        square([eps, 2 * boss_r], center = true);
                }
                poly_circle(insert_screw_diameter(insert) / 2 + 0.1);
            }

        // support cones
        hull() {
            cylinder(h = eps, r = boss_r - eps);

            translate([side * (boss_r - 1), 0])
                cube([eps, 2 * boss_r, eps], center = true);

            translate([side * (boss_r - wall + eps), 0, - (2 * boss_r - wall)])
                cube(eps, center = true);
        }
    }
}