dui add canvas_item rect "off_zoomed espresso_zoomed" 100 72 122 94 -outline $::PD_settings(green) -fill $::PD_settings(green) -tags pressure_icon
dui add canvas_item rect "off_zoomed espresso_zoomed" 296 72 318 94 -outline $::PD_settings(red) -fill $::PD_settings(red) -tags temperature_icon
dui add canvas_item rect "off_zoomed espresso_zoomed" 542 72 564 94 -outline $::PD_settings(blue) -fill $::PD_settings(blue) -tags flow_icon
dui add canvas_item rect "off_zoomed espresso_zoomed" 784 72 806 94 -outline $::PD_settings(brown) -fill $::PD_settings(brown) -tags weight_icon
dui add canvas_item rect "off_zoomed espresso_zoomed" 1016 72 1038 94 -outline $::PD_settings(yellow) -fill $::PD_settings(yellow) -tags resistance_icon
dui add variable "off_zoomed espresso_zoomed" 138 84 -tags pressure_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Pressure"]}
dui add variable "off_zoomed espresso_zoomed" 334 84 -tags temperature_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Temperature"]}
dui add variable "off_zoomed espresso_zoomed" 580 84 -tags flow_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Flow in Puck"]}
dui add variable "off_zoomed espresso_zoomed" 822 84 -tags weight_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Flow in Cup"]}
dui add variable "off_zoomed espresso_zoomed" 1054 84 -tags resistance_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Puck Resistance"]}
dui add dbutton "off_zoomed espresso_zoomed" 100 34 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph pressure}
dui add dbutton "off_zoomed espresso_zoomed" 326 34 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph temperature}
dui add dbutton "off_zoomed espresso_zoomed" 570 34 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph flow}
dui add dbutton "off_zoomed espresso_zoomed" 812 34 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph weight}
dui add dbutton "off_zoomed espresso_zoomed" 1044 34 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph resistance}

# todo change the following two buttons to icons fonts when we get a down arrow added to the font file
dui add dbutton "off_zoomed espresso_zoomed" 1610 38 \
    -bwidth 90 -bheight 90 \
    -labelvariable {\Uf063} -label_font [PD_font awesome 22] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 45 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_scroll_up}
dui add dbutton "off_zoomed espresso_zoomed" 1870 38 \
    -bwidth 90 -bheight 90 \
    -labelvariable {\Uf062} -label_font [PD_font awesome 22] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 45 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_scroll_down}

dui add variable "off_zoomed espresso_zoomed" 1784 84 -font [PD_font font_bold 15] -fill $::PD_settings(green) -anchor center -justify center -width 880 -textvariable {[translate "Graph"]}

###dui add dbutton "off_zoomed espresso_zoomed" 1610 38 \
    -bwidth 90 -bheight 90 \
    -labelvariable {$::PD_settings(icon_downarrow)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 45 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_scroll_up}


###dui add dbutton "off_zoomed espresso_zoomed" 1870 38 \
    -bwidth 90 -bheight 90 \
    -labelvariable {$::PD_settings(icon_uparrow)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 45 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_scroll_down}

dui add dbutton "off_zoomed espresso_zoomed" 2066 38 \
    -bwidth 90 -bheight 90 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 80] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 45 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_zoom_out}

dui add variable "off_zoomed espresso_zoomed" 2284 84 -tags PD_graph_reset_button_text -font [PD_font font_bold 15] -fill $::PD_settings(red) -anchor center -justify center -width 880 -textvariable {[PD_graph_reset_button_text]}
dui add dbutton "off_zoomed espresso_zoomed" 2190 38 \
    -bwidth 190 -bheight 90 \
    -command {PD_longpress_fix; PD_graph_reset_button}

dui add dbutton "off_zoomed espresso_zoomed" 2414 38 \
    -bwidth 90 -bheight 90 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 80] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 45 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_zoom_in}

add_de1_widget "off_zoomed espresso_zoomed" graph 40 165 {
    set ::PD_espresso_zoomed_graph $widget
    bind $widget [platform_button_press] {
        say [translate {zoom}] $::settings(sound_button_in);
        set_next_page off_zoomed off;
        set_next_page espresso_zoomed espresso;
        page_show $::de1(current_context);
    }
    $widget element create home_pressure_goal -xdata espresso_elapsed -ydata espresso_pressure_goal -symbol none -label "" -linewidth [rescale_x_skin 4] -color $::PD_settings(green)  -smooth $::settings(live_graph_smoothing_technique)  -pixels 0 -dashes {2 2};
    $widget element create home_flow_goal  -xdata espresso_elapsed -ydata espresso_flow_goal_2x -symbol none -label "" -linewidth [rescale_x_skin 4] -color $::PD_settings(blue) -smooth $::settings(live_graph_smoothing_technique) -pixels 0  -dashes {2 2};
    $widget element create home_temperature_goal -xdata espresso_elapsed -ydata PD_espresso_temperature_goal -symbol none -label "" -linewidth [rescale_x_skin 4] -color $::PD_settings(red) -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes {2 2};
    $widget element create home_pressure -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 6] -color $::PD_settings(green)  -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
    $widget element create home_flow  -xdata espresso_elapsed -ydata espresso_flow_2x -symbol none -label "" -linewidth [rescale_x_skin 6] -color $::PD_settings(blue) -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
    $widget element create home_weight  -xdata espresso_elapsed -ydata espresso_flow_weight_2x -symbol none -label "" -linewidth [rescale_x_skin 6] -color $::PD_settings(brown) -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
    $widget element create home_temperature -xdata espresso_elapsed -ydata PD_espresso_temperature_basket -symbol none -label ""  -linewidth [rescale_x_skin 6] -color $::PD_settings(red) -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
    $widget element create home_resistance  -xdata espresso_elapsed -ydata espresso_resistance -symbol none -label "" -linewidth [rescale_x_skin 6] -color $::PD_settings(yellow) -smooth $::settings(live_graph_smoothing_technique) -pixels 0
    $widget axis configure x -color $::PD_settings(off_white) -tickfont [PD_font font 16] -min 0.0;
    $widget axis configure y -color $::PD_settings(green) -tickfont [PD_font font 16] -min $::PD_settings(zoomed_y_axis_min) -max $::PD_settings(zoomed_y_axis_max) -subdivisions 5 -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}  -hide 0;
    $widget axis configure y2 -color $::PD_settings(blue) -tickfont [PD_font font 16] -min $::PD_settings(zoomed_y2_axis_min) -max $::PD_settings(zoomed_y2_axis_max) -subdivisions 2 -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8} -hide 0;
    $widget grid configure -color $::PD_settings(grid_colour) -dashes {5 5} -linewidth 1
} -plotbackground $::PD_settings(bg_colour) -width [rescale_x_skin 2480] -height [rescale_y_skin 1200] -borderwidth 1 -background $::PD_settings(bg_colour) -plotrelief flat

dui add dbutton "off_zoomed espresso_zoomed" 90 1406 \
    -bwidth 2040 -bheight 136 \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey)

dui add canvas_item line "off_zoomed espresso_zoomed" 254 1406 254 1542 -fill $::PD_settings(off_white) -width 2
dui add canvas_item line "off_zoomed espresso_zoomed" 570 1406 570 1542 -fill $::PD_settings(off_white) -width 2
dui add canvas_item line "off_zoomed espresso_zoomed" 1360 1406 1360 1542 -fill $::PD_settings(off_white) -width 2

dui add dtext "off_zoomed espresso_zoomed" 172 1474 -text [translate "DATA"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor center -justify center

dui add dtext "off_zoomed espresso_zoomed" 410 1496 -text [translate "Step in progress"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext "off_zoomed espresso_zoomed" 660 1496 -text [translate "Pressure"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext "off_zoomed espresso_zoomed" 840 1496 -text [translate "Flow in Puck"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext "off_zoomed espresso_zoomed" 1040 1496 -text [translate "Flow in Cup"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext "off_zoomed espresso_zoomed" 1240 1496 -text [translate "Temperature"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center

dui add variable "off_zoomed" 410 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[translate "Done"]}
dui add variable "espresso_zoomed" 410 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {$::settings(current_frame_description)}
dui add variable "off_zoomed espresso_zoomed" 660 1454 -font [PD_font font_bold 16] -fill $::PD_settings(green) -anchor center -justify center -textvariable {[round_to_one_digits [expr $::de1(pressure)]]bar}
dui add variable "off_zoomed espresso_zoomed" 840 1454 -font [PD_font font_bold 16] -fill $::PD_settings(blue) -anchor center -justify center -textvariable {[round_to_one_digits [expr $::de1(flow)]]mL/s}
dui add variable "off_zoomed espresso_zoomed" 1040 1454 -font [PD_font font_bold 16] -fill $::PD_settings(brown) -anchor center -justify center -textvariable {[round_to_one_digits [expr $::de1(scale_weight_rate)]]g/s}
dui add variable "off_zoomed espresso_zoomed" 1240 1454 -font [PD_font font_bold 16] -fill $::PD_settings(red) -anchor center -justify center -textvariable {[group_head_heater_temperature_text]}

dui add dtext "off_zoomed espresso_zoomed" 1440 1496 -text [translate "In"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext "off_zoomed espresso_zoomed" 1560 1496 -text [translate "Out"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext "off_zoomed espresso_zoomed" 1670 1496 -text [translate "Ratio"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext "off_zoomed espresso_zoomed" 1810 1496 -text [translate "Infusion"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext "off_zoomed espresso_zoomed" 1940 1496 -text [translate "Pouring"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext "off_zoomed espresso_zoomed" 2060 1496 -text [translate "Time"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center

dui add variable "off_zoomed" 1440 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[round_to_one_digits $::PD_graphs(live_graph_beans)]g}
dui add variable "off_zoomed" 1560 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {$::PD_graphs(live_graph_weight)g}
dui add variable "off_zoomed" 1670 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_last_extraction_ratio]}
dui add variable "off_zoomed" 1810 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {$::PD_graphs(live_graph_pi_time)s}
dui add variable "off_zoomed" 1940 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {$::PD_graphs(live_graph_pour_time)s}
dui add variable "off_zoomed" 2060 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {$::PD_graphs(live_graph_shot_time)s}
dui add variable "espresso_zoomed" 1440 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[round_to_one_digits $::settings(grinder_dose_weight)]g}
dui add variable "espresso_zoomed" 1560 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[round_to_one_digits $::de1(scale_sensor_weight)]g}
dui add variable "espresso_zoomed" 1670 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_live_extraction_ratio]}
dui add variable "espresso_zoomed" 1810 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[espresso_preinfusion_timer]s}
dui add variable "espresso_zoomed" 1940 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[espresso_pour_timer]s}
dui add variable "espresso_zoomed" 2060 1454 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[espresso_elapsed_timer]s}

dui add dbutton "off_zoomed espresso_zoomed" 2220 1422 \
    -bwidth 90 -bheight 90 \
    -labelvariable {$::PD_settings(icon_skip)} -label_font [PD_font icons 48] -label_fill $::PD_settings(green) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; PD_skip_to_next_step}

dui add dbutton "off_zoomed espresso_zoomed" 2370 1422 \
    -bwidth 90 -bheight 90 \
    -labelvariable {$::PD_settings(icon_stop)} -label_font [PD_font icons 48] -label_fill $::PD_settings(red) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; set_next_page off off; start_idle}
