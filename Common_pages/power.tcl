dui add dbutton "PD_power" 0 0 \
    -bwidth 2560 -bheight 1600 \
    -command {set_next_page off off; start_idle;}

dui add variable "PD_power" 1280 840 -font [PD_font font_bold 18] -fill $::PD_settings(off_white) -anchor center -justify center -width 880 -textvariable {[translate "Going to sleep in"]... [PD_power_off_timer]}


dui add dbutton "PD_power" 1140 600 \
    -bwidth 140 -bheight 140 \
    -labelvariable {[translate "EXIT"]} -label_font [PD_font font 13] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.85} \
    -shape round -radius 30 -fill $::PD_settings(red) \

dui add dbutton "PD_power" 1320 600 \
    -bwidth 140 -bheight 140 \
    -labelvariable {[translate "SLEEP"]} -label_font [PD_font font 13] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.85} \
    -shape round -radius 30 -fill $::PD_settings(green) \

dui add dbutton "PD_power" 1140 600 \
    -bwidth 140 -bheight 140 \
    -labelvariable {$::PD_settings(icon_x)} -label_font [PD_font awesome_light 40] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.4} \
    -command {PD_exit}

dui add dbutton "PD_power" 1320 600 \
    -bwidth 140 -bheight 140 \
    -labelvariable {$::PD_settings(icon_sleep)} -label_font [PD_font awesome_light 40] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.4} \
    -command {PD_sleep}


