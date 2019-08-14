// vim: set nospell:
include <config.scad>
include <opencoreparts.scad>
include <core.scad>

module screwholes(x,y) {
  //screwholeradius=1.75;
  screwholeradius=(screwM+0.5)/2;
  z=25;
  screwholesX=5;
  screwholesY=5;
  holefromedge=50;

  gapX=(x-100)/(screwholesX-1);
  gapY=(y-100)/(screwholesY-1);

  //cube([x,y,z]);

 for (a =[0:(screwholesX-1)])
 { translate ([holefromedge+(gapX*a),extrusion/2,-paneldepth]) cylinder(paneldepth*2, screwholeradius,screwholeradius); }
  for (a =[0:(screwholesY-1)])
 { translate ([extrusion/2,holefromedge+(gapY*a),-paneldepth]) cylinder(paneldepth*2, screwholeradius,screwholeradius); }
  for (a =[0:(screwholesX-1)])
 { translate ([holefromedge+(gapX*a),y-extrusion/2,-paneldepth]) cylinder(paneldepth*2, screwholeradius,screwholeradius); }
    for (a =[0:(screwholesY-1)])
 { translate ([x-extrusion/2,holefromedge+(gapY*a),-paneldepth]) cylinder(paneldepth*2, screwholeradius,screwholeradius); }
}

module panel(x,y,d,panel)
{

      color("Burlywood")
  difference() {
      translate ([x/2,y/2,0])
      rounded_rectangle([x,y,d], panelcornerrounding);
      screwholes(x,y);
      if (panel=="bottom") {
          //front left motor hole
          motorholes(leadscrewX1+extrusionincrease,leadscrewY1+extrusionincrease,-paneldepth);
          //rear left motor hole
          motorholes(leadscrewX1+extrusionincrease,leadscrewY2+extrusionincrease,-paneldepth)  ;
          //right motor hole
          motorholes(leadscrewX2+extrusionincrease,leadscrewY3,-paneldepth) ;
          }
      if (panel=="front") {
        translate ([windowwidth/2+Xwindowspacing,windowheight/2+Zwindowspacingbottom,-epsilon/2])
          rounded_rectangle([windowwidth,windowheight,paneldepth+epsilon*2], panelcornerrounding);
      }
  }
}

// BOM Item Name: HDPE Side Panels
// BOM Quantity: 1
// BOM Link: http://railco.re/sidepanels
// Notes: DXFs available from here via
panelcornerrounding=5; // Corner rounding of panels
screwholes=5;     // Number of screwholes // IS THIS REDUNDANT?
// Define Panel Window Area (ZL match)
Xwindowspacing=35;
Zwindowspacingtop=25;  // 25 for ZL , 50 for ZLT
Zwindowspacingbottom=35;  // 35 for ZL , 50 for ZLT


windowwidth = panelX - (Xwindowspacing*2);
windowheight = panelZ - (Zwindowspacingtop+Zwindowspacingbottom);

module bottom_panel() {
  translate([0,0,-paneldepth/2]) panel(panelX,panelY,paneldepth,"bottom");
}

module front_panel() {
  translate([0,-paneldepth/2,0])
    rotate([90,0,0])
      panel(panelX,panelZ,paneldepth,"front");
}

module left_panel() {
  translate([-paneldepth/2,0,0])
    rotate([90,0,90])
      panel(panelY,panelZ,paneldepth);
}

module right_panel() {
  translate ([panelX+paneldepth/2,0,0])
    rotate([90,0,90])
      panel(panelY,panelZ,paneldepth);
}

module back_panel(){
  translate ([0,panelY+paneldepth/2,0])
    rotate([90,0,0])
      panel(panelX,panelZ,paneldepth);
}

module all_side_panels() {
  bottom_panel();
  front_panel();
  left_panel();
  right_panel();
  back_panel();
}

all_side_panels();
