include <config.scad>

// RAILCORE II ZL improvement playground
module rc300zlv2(position = [0, 0, 0]) {
  $front_window_size = front_window_zl;
  $extrusion_type = extrusion15;
  $NEMA_XY = NEMA17;
  $NEMA_Z = NEMA17;
  $frame_size = frame_rc300zl;
  $rail_specs = rails_rc300zl;
  $leadscrew_specs = leadscrew_rc300zl ;
  $bed = bed_rc300;
  $elecbox = elec_new_ZL ; //electronics box size and placements
  $branding_name = "ZLv2";
  $enclosure_size = enclosure_rc300zl;
  children();
}

// ABSURDO 4040 EXTRUSION RAILCORE
module rc300zl40(position = [0, 0, 0]) {
  $front_window_size = front_window_zl;
  $extrusion_type = extrusion40;
  $NEMA_XY = NEMA23;
  $NEMA_Z = NEMA17;
  $frame_size = frame_rc300zl4040;
  $rail_specs = rails_rc300zl4040;
  $leadscrew_specs = leadscrew_zl4040 ;
  $bed = bed_custom;
  $elecbox = elec_custom ; //electronics box size and placements
  $branding_name = "4040 ZL";
  $enclosure_size = enclosure_rc300zl4040;
  children();
}

// TINYCORE - based on a bit of info about the bed :)
module tinycore(position = [0, 0, 0]) {
  //                            name       sizeXY   depth thick
  $front_window_size =   ["WINDOW_TYPE", [245, 210], 10, [0, 5]];
  $extrusion_type = extrusion15;
  $NEMA_XY = NEMA23;
  $NEMA_Z = NEMA17;
  //             sizeX sizeY sizeZ
  $frame_size = [315, 280, 325];
  //            sizeX  Xtype  sizeY  Ytype    sizeZ Ztype
  $rail_specs = [[225, MGN12], [225, MGN12], [280, MGN12]];
  //                     Name           height diameter
  $leadscrew_specs = ["LEADSCREW_SPECS", 280,  8];
  //       name  bed_plate_size   motor space  bed_overall_size  bed thickness
  $bed  = ["BED", [150, 167],      100,        [160, 342],        0.25 * inch];
  // ELECTRONICS BOX ALONG WITH  & ELECTRONICS & CABLE PLACEMENT -  placement of parts on right panel with X/Y as centre
  //                name       sizeX  sizeY  depth thick, lasercut cable_bundle    DuetE            Duex              PSU        SSR              RPi
  $elecbox      = ["ELEC.BOX", 118.9, 58.9, 59 ,   6,     true,   [-84,126.5,0], [-84.82,50.5,0], [-84.82,-59.5,0], [60,00,0],  [145,50,0] , [-90,-140,0]] ;
  $branding_name = "TinyCore";
  $enclosure_size = [315, 280, 225];
  children();
}

// CUSTOMCORE FOR DEBUGGING/QUICK RENDERING
module customcore(position = [0, 0, 0]) {
  $front_window_size = front_window_zl;
  $extrusion_type = extrusion15;
  $NEMA_XY = NEMA17;
  $NEMA_Z = NEMA17;
  $frame_size = frame_rc300_custom;
  $rail_specs = rails_custom;
  $leadscrew_specs = leadscrew_rc_custom;
  $bed = bed_rc300;
  $elecbox = elec_custom ; //electronics box size and placements
  $branding_name = "ZL+";
  $enclosure_size = enclosure_custom;
  children();
}
