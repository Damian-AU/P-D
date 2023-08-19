##### temperary patch for longpress#####
### todo remove patch when DUI fix reaches to stable app

if { [package vcompare [package version de1app] 1.42.1.24] < 0 } {
    set ::dui::item::longpress_threshold 2000
    proc ::dui::item::longpress_press { widget_name longpress_command } {
        variable longpress_threshold
        set ::dui::item::press_events($widget_name,press) [clock milliseconds]
        set ::long_press_timer [after $longpress_threshold [subst {
            if { \[info exists ::dui::item::press_events($widget_name,press)\] } {
                unset -nocomplain ::dui::item::press_events($widget_name,press)
                uplevel #0 $longpress_command
            }
        }]]
    }
    proc PD_longpress_fix {} {
        catch {
            after cancel $::long_press_timer
            set ::long_press_timer {}
        }
    }
    set ::PD_version_check {Longpress patch enabled}
} else {
    proc PD_longpress_fix {} {
        set ::PD_version_check {Longpress ok}
    }
    set ::PD_version_check {Longpress ok}
}
# note: PD_longpress_fix; added to all dbutton -command options
##### end patch #####



set ::PD_home_pages "off espresso steam water hotwaterrinse"

set ::PD_settings(heading) {Christee-Lee's Coffee}

# Top row
dui add variable $::PD_home_pages 1280 100 -font [PD_font font 60] -fill $::PD_settings(heading_colour) -anchor center -tags PD_heading -textvariable {$::PD_settings(heading)}
dui add variable $::PD_home_pages 1280 20 -font [PD_font font 16] -fill $::PD_settings(blue) -anchor center -tags PD_heading -textvariable {[binary scan hex: 2A 19 cu* bytes]}

dui add dbutton $::PD_home_pages 680 0 \
    -bwidth 1200 -bheight 180 \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) -longpress_threshold 2000 \
    -command {PD_longpress_fix; PD_edit_heading}


# left side
#-bwidth 1010 -bheight 1370
#-bwidth 1010 -bheight 956
dui add dbutton $::PD_home_pages 40 190 \
    -bwidth 1010 -bheight 1370 \
    -shape round -radius 30 -fill $::PD_settings(dark_grey)

# Machine
dui add variable $::PD_home_pages 650 252 -font [PD_font font 17] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_group_head_heater_temperature_text]}
dui add variable $::PD_home_pages 790 252 -font [PD_font font 17] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_steamtemp_text]}
dui add variable $::PD_home_pages 940 252 -font [PD_font font 17] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_low_water]}
dui add dtext $::PD_home_pages 650 290 -text [translate "Group"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext $::PD_home_pages 790 290 -text [translate "Steam"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext $::PD_home_pages 940 290 -text [translate "Tank"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center

# Clock
set ::PD_settings(clock_hide) 0
dui add variable $::PD_home_pages 236 270 -font [PD_font font 34] -fill $::PD_settings(off_white) -justify right -anchor e -textvariable {[PD_clock]}
dui add variable $::PD_home_pages 254 254 -font [PD_font font 14] -fill $::PD_settings(off_white) -justify center -anchor center -textvariable { [PD_day]}
dui add variable $::PD_home_pages 254 282 -font [PD_font font 16] -fill $::PD_settings(off_white) -justify center -anchor center -textvariable { [PD_date]}

# Ready state
dui add variable $::PD_home_pages 450 272 -font [PD_font font_bold 24] -fill $::PD_settings(green) -anchor center -justify center -width 880 -textvariable {[PD_start_button_ready]}


# Profile
dui add variable $::PD_home_pages 540 470 -font [PD_font font_bold 24] -fill $::PD_settings(off_white) -anchor center -justify center -tags PD_profile_name -textvariable {[PD_fav_colour_change]$::settings(profile_title)}
dui add variable $::PD_home_pages 540 506 -font [PD_font font 16] -fill $::PD_settings(red) -anchor center -justify center -textvariable {$::PD_profile_not_saved}
dui add dbutton $::PD_home_pages 140 390 \
    -bwidth 800 -bheight 120 \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; set ::settings(active_settings_tab) settings_1; show_settings} -longpress_cmd {PD_goto_profile_wizard}

dui add dbutton $::PD_home_pages 140 390 \
    -bwidth 800 -bheight 120 -tags PD_message_profile_button_block -initial_state hidden \
    -command {}

# Workflow Settings
dui add variable $::PD_home_pages 370 560 -font [PD_font font 17] -fill $::PD_settings(off_white) -anchor w -justify center -textvariable {[translate "Beans"] - $::settings(grinder_dose_weight)g}
dui add variable $::PD_home_pages 370 610 -font [PD_font font 17] -fill $::PD_settings(off_white) -anchor w -justify center -textvariable {[translate "Coffee"] - [PD_saw_switch]g}
dui add variable $::PD_home_pages 370 660 -font [PD_font font 17] -fill $::PD_settings(off_white) -anchor w -justify center -textvariable {[translate "Extraction Ratio"] - [PD_extraction_ratio]}
dui add variable $::PD_home_pages 370 710 -font [PD_font font 17] -fill $::PD_settings(off_white) -anchor w -justify center -textvariable {[translate "Flush timer"] - [round_to_integer $::settings(flush_seconds)]s}
dui add variable $::PD_home_pages 370 760 -font [PD_font font 17] -fill $::PD_settings(off_white) -anchor w -justify center  -tags PD_steam_value -textvariable {[translate "Steam timer"] ([PD_jug_letter]) - [PD_steam_text_s $::settings(steam_timeout)]}
dui add variable $::PD_home_pages 370 810 -font [PD_font font 17] -fill $::PD_settings(off_white) -anchor w -justify center -textvariable {[translate "Water"] - [PD_water_button_text_2]}

dui add dbutton $::PD_home_pages 300 510 \
    -bwidth 480 -bheight 400 \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; PD_toggle_workflow_settings}

dui add dbutton "steam hotwaterrinse" 40 400 \
    -bwidth 1010 -bheight 500 \
    -shape round -radius 30 -fill $::PD_settings(dark_grey)

dui add variable steam 540 710 -font [PD_font font 46] -fill $::PD_settings(off_white) -anchor center -textvariable {[PD_steam_timer]}
dui add variable hotwaterrinse 540 710 -font [PD_font font 46] -fill $::PD_settings(off_white) -anchor center -textvariable {[PD_flush_timer]}


###
#### Scale
dui add canvas_item line $::PD_home_pages 400 960 400 1014 -fill $::PD_settings(light_grey) -width 2
dui add canvas_item line $::PD_home_pages 680 960 680 1014 -fill $::PD_settings(light_grey) -width 2

dui add variable $::PD_home_pages 540 1004 -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_scale_disconnected]}
dui add variable $::PD_home_pages 800 940 -font [PD_font font 18] -fill $::PD_settings(off_white) -anchor w -textvariable {[PD_milk_weight]}

dui add variable $::PD_home_pages 540 956 -font [PD_font font 30] -fill $::PD_settings(off_white) -anchor center -textvariable {[round_to_one_digits $::de1(scale_sensor_weight)]g}
dui add dbutton $::PD_home_pages 420 900 \
    -bwidth 240 -bheight 140 \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; scale_tare; catch {ble_connect_to_scale}}

dui add dbutton $::PD_home_pages 260 900 \
    -bwidth 140 -bheight 140 \
    -labelvariable {$::PD_settings(icon_bean)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; PD_set_dose; PD_setting_updated_message}

dui add dbutton $::PD_home_pages 680 900 \
    -bwidth 140 -bheight 140 \
    -labelvariable {$::PD_settings(icon_D_steam_timer)} -label_font [PD_font D-font 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; PD_steam_time_calc; PD_setting_updated_message}




#### upper row favourites
dui add variable $::PD_home_pages 240 1250 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav1_label -initial_state hidden -textvariable {$::PD_settings(fav1_label)}
dui add variable $::PD_home_pages 240 1250 -font [PD_font D-font 46] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav1_cup -initial_state hidden -textvariable {$::PD_settings(icon_D_cup)}

dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_fav_options fav1}

dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button_blue -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(blue) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_fav_options fav1}
dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button_green -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(green) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_fav_options fav1}
dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button_orange -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(orange) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_fav_options fav1}
dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button_yellow -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(yellow) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_fav_options fav1}
dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button_brown -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(brown) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_fav_options fav1}
dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button_pink -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(pink) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_fav_options fav1}
dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button_red -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(red) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_fav_options fav1}
dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button_off_white -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(off_white) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_fav_options fav1}



dui add variable $::PD_home_pages 540 1250 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav2_label -initial_state hidden -textvariable {$::PD_settings(fav2_label)}
dui add variable $::PD_home_pages 540 1250 -font [PD_font D-font 46] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav2_cup -initial_state hidden -textvariable {$::PD_settings(icon_D_cup)}

dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_fav_options fav2}
dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button_blue -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(blue) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_fav_options fav2}
dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button_green -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(green) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_fav_options fav2}
dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button_orange -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(orange) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_fav_options fav2}
dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button_yellow -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(yellow) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_fav_options fav2}
dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button_brown -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(brown) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_fav_options fav2}
dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button_pink -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(pink) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_fav_options fav2}
dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button_red -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(red) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_fav_options fav2}
dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button_off_white -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(off_white) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_fav_options fav2}




dui add variable $::PD_home_pages 840 1250 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav3_label -initial_state hidden -textvariable {$::PD_settings(fav3_label)}
dui add variable $::PD_home_pages 840 1250 -font [PD_font D-font 46] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav3_cup -initial_state hidden -textvariable {$::PD_settings(icon_D_cup)}

dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_fav_options fav3}
dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button_blue -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(blue) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_fav_options fav3}
dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button_green -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(green) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_fav_options fav3}
dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button_orange -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(orange) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_fav_options fav3}
dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button_yellow -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(yellow) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_fav_options fav3}
dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button_brown -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(brown) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_fav_options fav3}
dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button_pink -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(pink) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_fav_options fav3}
dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button_red -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(red) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_fav_options fav3}
dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button_off_white -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(off_white) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_fav_options fav3}




#### lower row favourites
dui add variable $::PD_home_pages 240 1440 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav4_label -initial_state hidden -textvariable {$::PD_settings(fav4_label)}
dui add variable $::PD_home_pages 240 1440 -font [PD_font D-font 46] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav4_cup -initial_state hidden -textvariable {$::PD_settings(icon_D_cup)}

dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_save fav4}
dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button_blue -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(blue) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_fav_options fav4}
dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button_green -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(green) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_fav_options fav4}
dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button_orange -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(orange) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_fav_options fav4}
dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button_yellow -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(yellow) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_fav_options fav4}
dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button_brown -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(brown) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_fav_options fav4}
dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button_pink -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(pink) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_fav_options fav4}
dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button_red -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(red) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_fav_options fav4}
dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button_off_white -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(off_white) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_fav_options fav4}




dui add variable $::PD_home_pages 540 1440 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav5_label -initial_state hidden -textvariable {$::PD_settings(fav5_label)}
dui add variable $::PD_home_pages 540 1440 -font [PD_font D-font 46] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav5_cup -initial_state hidden -textvariable {$::PD_settings(icon_D_cup)}

dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_fav_options fav5}
dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button_blue -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(blue) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_fav_options fav5}
dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button_green -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(green) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_fav_options fav5}
dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button_orange -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(orange) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_fav_options fav5}
dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button_yellow -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(yellow) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_fav_options fav5}
dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button_brown -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(brown) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_fav_options fav5}
dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button_pink -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(pink) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_fav_options fav5}
dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button_red -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(red) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_fav_options fav5}
dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button_off_white -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(off_white) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_fav_options fav5}




dui add variable $::PD_home_pages 840 1440 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav6_label -initial_state hidden -textvariable {$::PD_settings(fav6_label)}
dui add variable $::PD_home_pages 840 1440 -font [PD_font D-font 46] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav6_cup -initial_state hidden -textvariable {$::PD_settings(icon_D_cup)}

dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_fav_options fav6}
dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button_blue -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(blue) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_fav_options fav5}
dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button_green -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(green) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_fav_options fav6}
dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button_orange -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(orange) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_fav_options fav6}
dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button_yellow -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(yellow) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_fav_options fav6}
dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button_brown -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(brown) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_fav_options fav6}
dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button_pink -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(pink) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_fav_options fav6}
dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button_red -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(red) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_fav_options fav6}
dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button_off_white -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(off_white) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_fav_options fav6}




# right side
dui add dbutton $::PD_home_pages 1090 190 \
    -bwidth 1430 -bheight 956 \
    -shape round -radius 30 -fill $::PD_settings(dark_grey)

dui add variable espresso 0 -10 -font [PD_font font_bold 1] -textvariable {[PD_backup_live_graph]}

dui add canvas_item rect "off espresso hotwaterrinse water" 1150 240 1172 262 -outline $::PD_settings(green) -fill $::PD_settings(green) -tags pressure_icon
dui add canvas_item rect "off espresso hotwaterrinse water" 1346 240 1368 262 -outline $::PD_settings(blue) -fill $::PD_settings(blue) -tags flow_icon
dui add canvas_item rect "off espresso hotwaterrinse water" 1592 240 1614 262 -outline $::PD_settings(brown) -fill $::PD_settings(brown) -tags weight_icon
dui add canvas_item rect "off espresso hotwaterrinse water" 1824 240 1846 262 -outline $::PD_settings(red) -fill $::PD_settings(red) -tags temperature_icon
dui add canvas_item rect "off espresso hotwaterrinse water" 2066 240 2088 262 -outline $::PD_settings(yellow) -fill $::PD_settings(yellow) -tags resistance_icon
dui add canvas_item rect "off espresso hotwaterrinse water" 2346 240 2368 262 -outline $::PD_settings(dark_white) -fill $::PD_settings(dark_white) -tags steps_icon
dui add variable "off hotwaterrinse water" 1188 252 -tags pressure_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Pressure"]}
dui add variable "off hotwaterrinse water" 1384 252 -tags flow_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Flow in Puck"]}
dui add variable "off hotwaterrinse water" 1630 252 -tags weight_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Flow in Cup"]}
dui add variable "off hotwaterrinse water" 1862 252 -tags temperature_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Temperature"]}
dui add variable "off hotwaterrinse water" 2104 252 -tags resistance_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Puck Resistance"]}
dui add variable "off hotwaterrinse water" 2384 252 -tags steps_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Steps"]}
dui add variable "espresso" 1188 252 -tags pressure_data -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[round_to_one_digits [expr $::de1(pressure)]]bar}
dui add variable "espresso" 1384 252 -tags flow_data -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[round_to_one_digits [expr $::de1(flow)]]ml/s}
dui add variable "espresso" 1630 252 -tags weight_data -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[round_to_one_digits [expr $::de1(scale_weight_rate)]]g/s}
dui add variable "espresso" 1862 252 -tags temperature_data -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[group_head_heater_temperature_text]}
dui add variable "espresso" 2104 252 -tags resistance_data -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Puck Resistance"]}
dui add variable "espresso" 2384 252 -tags steps_data -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {Steps}



dui add dbutton "off espresso hotwaterrinse water" 1150 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph pressure}
dui add dbutton "off espresso hotwaterrinse water" 1376 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph flow}
dui add dbutton "off espresso hotwaterrinse water" 1620 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph weight}
dui add dbutton "off espresso hotwaterrinse water" 1852 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph temperature}
dui add dbutton "off espresso hotwaterrinse water" 2094 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph resistance}
dui add dbutton "off espresso hotwaterrinse water" 2374 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph steps}



dui add variable "espresso" 1800 1112 -font [PD_font font 18] -fill $::PD_settings(off_white) -anchor center -textvariable {$::settings(current_frame_description)}



#start for nonGHC
if {[ghc_required]} {

} else {

    dui add dbutton $::PD_home_pages 1380 1180 \
        -bwidth 830 -bheight 140 \
        -shape round -radius 30 -fill $::PD_settings(dark_grey)
    dui add canvas_item line off 1590 1240 1590 1294 -fill $::PD_settings(light_grey) -width 2
    dui add canvas_item line "off espresso" 1800 1240 1800 1294 -fill $::PD_settings(light_grey) -width 2
    dui add canvas_item line off 2010 1240 2010 1294 -fill $::PD_settings(light_grey) -width 2


    dui add dbutton off 1380 1180 \
        -bwidth 200 -bheight 140 \
        -labelvariable {$::PD_settings(icon_D_espresso)} -label_font [PD_font D-font 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
        -command {PD_longpress_fix; start_espresso}
    dui add dbutton off 1592 1180 \
        -bwidth 200 -bheight 140 \
        -labelvariable {$::PD_settings(icon_D_flush)} -label_font [PD_font D-font 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
        -command {PD_longpress_fix; start_flush}
    dui add dbutton off 1804 1180 \
        -bwidth 200 -bheight 140 \
        -labelvariable {$::PD_settings(icon_D_steam)} -label_font [PD_font D-font 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
        -command {PD_longpress_fix; start_steam; update_de1_state "$::de1_state(Steam)\x0"; de1_send_state "make steam" $::de1_state(Steam) }
    dui add dbutton off 2016 1180 \
        -bwidth 200 -bheight 140 \
        -labelvariable {$::PD_settings(icon_D_water)} -label_font [PD_font D-font 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
        -command {PD_longpress_fix; start_water}
    dui add dbutton "espresso" 1380 1180 \
        -bwidth 410 -bheight 140 \
        -labelvariable {[translate "SKIP"]} -label_font [PD_font font 40] -label_fill $::PD_settings(orange) -label_pos {0.5 0.5} \
        -command {PD_longpress_fix; PD_skip_to_next_step}
    dui add dbutton "espresso" 1800 1180 \
        -bwidth 410 -bheight 140 \
        -labelvariable {[translate "STOP"]} -label_font [PD_font font 40] -label_fill $::PD_settings(red) -label_pos {0.5 0.5} \
        -command {PD_longpress_fix; start_idle}
    dui add dbutton "steam water hotwaterrinse" 1380 1180 \
        -bwidth 830 -bheight 140 \
        -labelvariable {[translate "STOP"]} -label_font [PD_font font 40] -label_fill $::PD_settings(red) -label_pos {0.5 0.5} \
        -command {PD_longpress_fix; start_idle; update_de1_state "$::de1_state(Idle)\x0"; de1_send_state "make steam" $::de1_state(Idle) }

    dui add dbutton off 1380 1180 \
        -bwidth 830 -bheight 140 -tags PD_heating_button -initial_state normal\
        -labelvariable {[translate "HEATING"]} -label_font [PD_font font 36] -label_fill $::PD_settings(red) -label_pos {0.5 0.5} \
        -shape round -width 2 -arc_offset 20 -fill $::PD_settings(dark_grey) \


}

dui add dtext $::PD_home_pages 1100 1418 -text [translate "P&D"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1270 1418 -text [translate "Profile"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1470 1418 -text [translate "Machine"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1700 1418 -text [translate "App"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1880 1418 -text [translate "History"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 2080 1418 -text [translate "Steam"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center

dui add dtext $::PD_home_pages 1100 1464 -text [translate "Settings"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1270 1464 -text [translate "Settings"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1470 1464 -text [translate "Settings"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1700 1464 -text [translate "Settings"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1880 1464 -text [translate "Viewer"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 2080 1464 -text [translate "Graph"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center


dui add dbutton $::PD_home_pages 1070 1370 \
    -bwidth 180 -bheight 140 \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; page_show weight2steam}

dui add dbutton $::PD_home_pages 1260 1370 \
    -bwidth 180 -bheight 140 \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; PD_goto_profile_wizard}

dui add dbutton $::PD_home_pages 1460 1370 \
    -bwidth 180 -bheight 140 \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; set ::settings(active_settings_tab) settings_3; show_settings}

dui add dbutton $::PD_home_pages 1670 1370 \
    -bwidth 190 -bheight 140 \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; set ::settings(active_settings_tab) settings_4; show_settings}

dui add dbutton $::PD_home_pages 1860 1370 \
    -bwidth 190 -bheight 140 \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix;}

dui add dbutton $::PD_home_pages 2050 1370 \
    -bwidth 190 -bheight 140 \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; PD_show_steam_graph}

dui add dbutton $::PD_home_pages 2260 1366 \
    -bwidth 200 -bheight 140 \
    -labelvariable {$::PD_settings(icon_power)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; PD_power}





set ::PD_message ""
set ::PD_message_fav_instructions ""
dui add dbutton $::PD_home_pages 0 0 \
    -bwidth 2560 -bheight 1600 -tags PD_message_button_block -initial_state hidden

dui add canvas_item rect $::PD_home_pages 1060 190 2560 1600 -outline $::PD_settings(main_background_colour) -fill $::PD_settings(main_background_colour) -tags PD_rhs_bg_cover -initial_state hidden

dui add dbutton $::PD_home_pages 1120 580 \
    -bwidth 1400 -bheight 438 -tags PD_message_bg -initial_state hidden \
    -shape round_outline -width 2 -arc_offset 20 -fill $::PD_settings(dark_grey) -outline $::PD_settings(dark_grey) \
    -label {X} -label_font [PD_font font 20] -label_fill $::PD_settings(off_white) -label_pos {0.97 0.09} \
    -command {PD_longpress_fix; PD_clear_message}

dui add dbutton $::PD_home_pages 1120 704 \
    -bwidth 1400 -bheight 192 -tags PD_saved_message_bg -initial_state hidden \
    -shape round_outline -width 2 -arc_offset 20 -fill $::PD_settings(dark_grey) -outline $::PD_settings(dark_grey) \
    -label {} -label_font [PD_font font 20] -label_fill $::PD_settings(off_white) -label_pos {0.95 0.08} \
    -command {PD_longpress_fix; PD_clear_message}

dui add variable $::PD_home_pages 1820 800 -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor center -width 1480 -textvariable {$::PD_message}
dui add variable $::PD_home_pages 1170 800 -font [PD_font font 19] -fill $::PD_settings(off_white) -anchor w -width 1480 -textvariable {$::PD_message_fav_instructions}








dui add dbutton $::PD_home_pages 0 0 \
    -bwidth 2560 -bheight 1600 -tags PD_fav_option_left_cover -initial_state hidden \
    -command {PD_longpress_fix; PD_hide_fav_options; PD_save $::PD_fav_key}


dui add dbutton $::PD_home_pages 1120 530 \
    -bwidth 1400 -bheight 538 -tags PD_fav_option_bg -initial_state hidden \
    -shape round_outline -width 2 -arc_offset 20 -fill $::PD_settings(dark_grey) -outline $::PD_settings(dark_grey)

### heading settings
dui add dbutton $::PD_home_pages 0 0 \
    -bwidth 2560 -bheight 1600 -tags PD_heading_editor_exit_button -initial_state hidden \
    -command {PD_longpress_fix; PD_hide_heading_editor}

dui add entry $::PD_home_pages 1250 570 -textvariable ::PD_settings(heading) -tags PD_heading_entry -bg $::PD_settings(off_white) -width 32 -font_size 15 -initial_state hidden
dui add variable $::PD_home_pages 1250 666 -font [PD_font font 14] -fill $::PD_settings(off_white) -anchor w -tags PD_heading_text_line_1 -initial_state hidden -textvariable {[translate "Set the home page heading"]}
dui add variable $::PD_home_pages 1250 800 -font [PD_font font 14] -fill $::PD_settings(off_white) -anchor w -tags PD_heading_text_line_2 -initial_state hidden -textvariable {[translate "Set the home page heading colour"]}

dui add dbutton $::PD_home_pages 1250 730 \
    -bwidth 120 -bheight 50 -tags PD_heading_blue_button -initial_state hidden \
    -shape rect -fill $::PD_settings(blue) \
    -command {PD_longpress_fix; set ::PD_settings(heading_colour) $::PD_settings(blue); dui item config $::PD_home_pages PD_heading -fill $::PD_settings(blue)}
dui add dbutton $::PD_home_pages 1394 730 \
    -bwidth 120 -bheight 50 -tags PD_heading_green_button -initial_state hidden \
    -shape rect -fill $::PD_settings(green) \
    -command {PD_longpress_fix; set ::PD_settings(heading_colour) $::PD_settings(green); dui item config $::PD_home_pages PD_heading -fill $::PD_settings(green)}
dui add dbutton $::PD_home_pages 1538 730 \
    -bwidth 120 -bheight 50 -tags PD_heading_orange_button -initial_state hidden \
    -shape rect -fill $::PD_settings(orange) \
    -command {PD_longpress_fix; set ::PD_settings(heading_colour) $::PD_settings(orange); dui item config $::PD_home_pages PD_heading -fill $::PD_settings(orange)}
dui add dbutton $::PD_home_pages 1682 730 \
    -bwidth 120 -bheight 50 -tags PD_heading_yellow_button -initial_state hidden \
    -shape rect -fill $::PD_settings(yellow) \
    -command {PD_longpress_fix; set ::PD_settings(heading_colour) $::PD_settings(yellow); dui item config $::PD_home_pages PD_heading -fill $::PD_settings(yellow)}
dui add dbutton $::PD_home_pages 1826 730 \
    -bwidth 120 -bheight 50 -tags PD_heading_brown_button -initial_state hidden \
    -shape rect -fill $::PD_settings(brown) \
    -command {PD_longpress_fix; set ::PD_settings(heading_colour) $::PD_settings(brown); dui item config $::PD_home_pages PD_heading -fill $::PD_settings(brown)}
dui add dbutton $::PD_home_pages 1970 730 \
    -bwidth 120 -bheight 50 -tags PD_heading_pink_button -initial_state hidden \
    -shape rect -fill $::PD_settings(pink) \
    -command {PD_longpress_fix; set ::PD_settings(heading_colour) $::PD_settings(pink); dui item config $::PD_home_pages PD_heading -fill $::PD_settings(pink)}
dui add dbutton $::PD_home_pages 2114 730 \
    -bwidth 120 -bheight 50 -tags PD_heading_red_button -initial_state hidden \
    -shape rect -fill $::PD_settings(red) \
    -command {PD_longpress_fix; set ::PD_settings(heading_colour) $::PD_settings(red); dui item config $::PD_home_pages PD_heading -fill $::PD_settings(red)}
dui add dbutton $::PD_home_pages 2254 730 \
    -bwidth 120 -bheight 50 -tags PD_heading_off_white_button -initial_state hidden \
    -shape rect -fill $::PD_settings(off_white) \
    -command {PD_longpress_fix; set ::PD_settings(heading_colour) $::PD_settings(off_white); dui item config $::PD_home_pages PD_heading -fill $::PD_settings(off_white)}

###

dui add entry $::PD_home_pages 1530 570 -textvariable ::PD_settings(fav1_label) -tags PD_fav_option_label_fav1 -bg $::PD_settings(off_white) -width 32 -font_size 15 -initial_state hidden
dui add entry $::PD_home_pages 1530 570 -textvariable ::PD_settings(fav2_label) -tags PD_fav_option_label_fav2 -bg $::PD_settings(off_white) -width 32 -font_size +2 -initial_state hidden
dui add entry $::PD_home_pages 1530 570 -textvariable ::PD_settings(fav3_label) -tags PD_fav_option_label_fav3 -bg $::PD_settings(off_white) -width 32 -font_size +2 -initial_state hidden
dui add entry $::PD_home_pages 1530 570 -textvariable ::PD_settings(fav4_label) -tags PD_fav_option_label_fav4 -bg $::PD_settings(off_white) -width 32 -font_size +2 -initial_state hidden
dui add entry $::PD_home_pages 1530 570 -textvariable ::PD_settings(fav5_label) -tags PD_fav_option_label_fav5 -bg $::PD_settings(off_white) -width 32 -font_size +2 -initial_state hidden
dui add entry $::PD_home_pages 1530 570 -textvariable ::PD_settings(fav6_label) -tags PD_fav_option_label_fav6 -bg $::PD_settings(off_white) -width 32 -font_size +2 -initial_state hidden

dui add variable $::PD_home_pages 1250 666 -font [PD_font font 14] -fill $::PD_settings(off_white) -anchor w -tags PD_fav_option_text_line_1 -initial_state hidden -textvariable {[translate "Set a label for the favourite button"]}
dui add variable $::PD_home_pages 1250 800 -font [PD_font font 14] -fill $::PD_settings(off_white) -anchor w -tags PD_fav_option_text_line_2 -initial_state hidden -textvariable {[translate "Set a colour for the favourite button"]}
dui add variable $::PD_home_pages 1250 996 -font [PD_font font 14] -fill $::PD_settings(off_white) -anchor w -tags PD_fav_option_text_line_3 -initial_state hidden -textvariable {[translate "Other favourite settings"]}


dui add dbutton $::PD_home_pages 1250 546 \
    -bwidth 220 -bheight 100 -tags PD_fav_option_use_profile_button -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -labelvariable {[translate "Use profile title"]} -label_font [PD_font font 16] -label_width 210 -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; set ::PD_settings(${::PD_fav_key}_label) $::settings(profile_title)}

dui add dbutton $::PD_home_pages 1250 730 \
    -bwidth 120 -bheight 50 -tags PD_fav_option_blue_button -initial_state hidden \
    -shape rect -fill $::PD_settings(blue) \
    -command {PD_longpress_fix; set ::PD_settings(${::PD_fav_key}_colour) $::PD_settings(blue); set ::PD_settings(${::PD_fav_key}_colour_name) blue; PD_set_option_colour}
dui add dbutton $::PD_home_pages 1394 730 \
    -bwidth 120 -bheight 50 -tags PD_fav_option_green_button -initial_state hidden \
    -shape rect -fill $::PD_settings(green) \
    -command {PD_longpress_fix; set ::PD_settings(${::PD_fav_key}_colour) $::PD_settings(green); set ::PD_settings(${::PD_fav_key}_colour_name) green; PD_set_option_colour}
dui add dbutton $::PD_home_pages 1538 730 \
    -bwidth 120 -bheight 50 -tags PD_fav_option_orange_button -initial_state hidden \
    -shape rect -fill $::PD_settings(orange) \
    -command {PD_longpress_fix; set ::PD_settings(${::PD_fav_key}_colour) $::PD_settings(orange); set ::PD_settings(${::PD_fav_key}_colour_name) orange; PD_set_option_colour}
dui add dbutton $::PD_home_pages 1682 730 \
    -bwidth 120 -bheight 50 -tags PD_fav_option_yellow_button -initial_state hidden \
    -shape rect -fill $::PD_settings(yellow) \
    -command {PD_longpress_fix; set ::PD_settings(${::PD_fav_key}_colour) $::PD_settings(yellow); set ::PD_settings(${::PD_fav_key}_colour_name) yellow; PD_set_option_colour}
dui add dbutton $::PD_home_pages 1826 730 \
    -bwidth 120 -bheight 50 -tags PD_fav_option_brown_button -initial_state hidden \
    -shape rect -fill $::PD_settings(brown) \
    -command {PD_longpress_fix; set ::PD_settings(${::PD_fav_key}_colour) $::PD_settings(brown); set ::PD_settings(${::PD_fav_key}_colour_name) brown; PD_set_option_colour}
dui add dbutton $::PD_home_pages 1970 730 \
    -bwidth 120 -bheight 50 -tags PD_fav_option_pink_button -initial_state hidden \
    -shape rect -fill $::PD_settings(pink) \
    -command {PD_longpress_fix; set ::PD_settings(${::PD_fav_key}_colour) $::PD_settings(pink); set ::PD_settings(${::PD_fav_key}_colour_name) pink; PD_set_option_colour}
dui add dbutton $::PD_home_pages 2114 730 \
    -bwidth 120 -bheight 50 -tags PD_fav_option_red_button -initial_state hidden \
    -shape rect -fill $::PD_settings(red) \
    -command {PD_longpress_fix; set ::PD_settings(${::PD_fav_key}_colour) $::PD_settings(red); set ::PD_settings(${::PD_fav_key}_colour_name) red; PD_set_option_colour}
dui add dbutton $::PD_home_pages 2254 730 \
    -bwidth 120 -bheight 50 -tags PD_fav_option_off_white_button -initial_state hidden \
    -shape rect -fill $::PD_settings(off_white) \
    -command {PD_longpress_fix; set ::PD_settings(${::PD_fav_key}_colour) $::PD_settings(off_white); set ::PD_settings(${::PD_fav_key}_colour_name) off_white; PD_set_option_colour}



dui add dbutton $::PD_home_pages 1250 870 \
    -bwidth 210 -bheight 100 -tags PD_fav_option_label_cup_button -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -labelvariable {$::PD_settings(icon_D_cup)} -label_font [PD_font D-font 40] -label_width 210 -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; set ::PD_settings(fav_cup_labels) [expr {!$::PD_settings(fav_cup_labels)}]; PD_set_fav_label_cup;}

dui add dbutton $::PD_home_pages 1480 870 \
    -bwidth 210 -bheight 100 -tags PD_fav_option_label_colour_button -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -labelvariable {[translate "Colour Labels"]} -label_font [PD_font font 16] -label_width 190 -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; set ::PD_settings(fav_colour_labels) [expr {!$::PD_settings(fav_colour_labels)}]; PD_set_fav_label_colour;}

dui add dbutton $::PD_home_pages 1710 870 \
    -bwidth 210 -bheight 100 -tags PD_fav_option_13_button -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -labelvariable {[translate "hide/show top row"]} -label_font [PD_font font 16] -label_width 200 -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; set ::PD_settings(fav_hide_13) [expr {!$::PD_settings(fav_hide_13)}]; PD_fav_option_hide_13;}

dui add dbutton $::PD_home_pages 1940 870 \
    -bwidth 210 -bheight 100 -tags PD_fav_option_36_button -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -labelvariable {[translate "hide/show bottom row"]} -label_font [PD_font font 16] -label_width 200 -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; set ::PD_settings(fav_hide_46) [expr {!$::PD_settings(fav_hide_46)}]; PD_fav_option_hide_46;}

dui add dbutton $::PD_home_pages 2170 870 \
    -bwidth 210 -bheight 100 -tags PD_fav_option_default -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -labelvariable {[translate "Auto load at wake up"]} -label_font [PD_font font 16] -label_width 210 -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; set ::PD_settings(fav_default) $::PD_fav_key; set ::PD_auto [translate "Set as Auto"]}

set ::PD_auto ""
dui add variable $::PD_home_pages 2380 996 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor e -textvariable {$::PD_auto}












########### Workflow Settings ########
dui add dbutton $::PD_home_pages 0 0 \
    -bwidth 2560 -bheight 1800 -tags PD_workflow_return_button  -initial_state hidden\
    -command {PD_longpress_fix; PD_toggle_workflow_settings}

dui add dbutton $::PD_home_pages 1090 290 \
    -bwidth 1430 -bheight 900 -tags PD_fav_workflow_bg -initial_state hidden \
    -shape round -radius 30 -fill $::PD_settings(dark_grey)


dui add dbutton $::PD_home_pages 1247 320 -tags PD_wf11 -initial_state hidden \
    -bwidth 280 -bheight 96 \
    -labelvariable {[translate "Beans in"]} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {}
dui add dbutton $::PD_home_pages 1548 320 -tags PD_wf12 -initial_state hidden\
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust dose -1}
dui add dbutton $::PD_home_pages 1666 320 -tags PD_wf13 -initial_state hidden\
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust dose -0.1}
dui add variable $::PD_home_pages 1860 370 -tags PD_wf14 -initial_state hidden -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {$::settings(grinder_dose_weight)g}
dui add dbutton $::PD_home_pages 1960 320 -tags PD_wf15 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust dose 0.1}
dui add dbutton $::PD_home_pages 2076 320 -tags PD_wf16 -initial_state hidden\
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust dose 1}



dui add dbutton $::PD_home_pages 1247 464 -tags PD_wf21 -initial_state hidden \
    -bwidth 280 -bheight 96 \
    -labelvariable {[translate "Beverage out"]} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {PD_longpress_fix; }
dui add dbutton $::PD_home_pages 1548 464 -tags PD_wf22 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust saw -10}
dui add dbutton $::PD_home_pages 1666 464 -tags PD_wf23 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust saw -1}
dui add variable $::PD_home_pages 1860 514 -tags PD_wf24 -initial_state hidden -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_saw_switch]g}
dui add dbutton $::PD_home_pages 1960 464 -tags PD_wf25 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust saw 1}
dui add dbutton $::PD_home_pages 2076 464 -tags PD_wf26 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust saw 10}

dui add dbutton $::PD_home_pages 1247 610 -tags PD_wf31 -initial_state hidden \
    -bwidth 280 -bheight 96 \
    -labelvariable {[translate "Ratio"]} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {PD_longpress_fix; }
dui add dbutton $::PD_home_pages 1548 610 -tags PD_wf32 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust er -1}
dui add dbutton $::PD_home_pages 1666 610 -tags PD_wf33 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust er -0.1}
dui add variable $::PD_home_pages 1860 660 -tags PD_wf34 -initial_state hidden -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_extraction_ratio]}
dui add dbutton $::PD_home_pages 1960 610 -tags PD_wf35 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust er  0.1}
dui add dbutton $::PD_home_pages 2076 610 -tags PD_wf36 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust er 1}

dui add dbutton $::PD_home_pages 1247 756 -tags PD_wf41 -initial_state hidden \
    -bwidth 280 -bheight 96 \
    -labelvariable {[translate "Flush"]} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {PD_longpress_fix; }
dui add dbutton $::PD_home_pages 1548 756 -tags PD_wf42 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust flush -10}
dui add dbutton $::PD_home_pages 1666 756 -tags PD_wf43 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust flush -1}
dui add variable $::PD_home_pages 1860 806 -tags PD_wf44 -initial_state hidden -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[round_to_integer $::settings(flush_seconds)]s}
dui add dbutton $::PD_home_pages 1960 756 -tags PD_wf45 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust flush 1}
dui add dbutton $::PD_home_pages 2076 756 -tags PD_wf46 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust flush 10}

dui add dbutton $::PD_home_pages 1247 902 -tags PD_wf51 -initial_state hidden \
    -bwidth 280 -bheight 96 \
    -labelvariable {[translate "Steam"] ([PD_jug_letter])} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {PD_longpress_fix; PD_jug_toggle} -longpress_cmd {PD_steam_toggle;}
dui add dbutton $::PD_home_pages 1548 902 -tags PD_wf52 -initial_state hidden \
    -bwidth 96 -bheight 96 -tags PD_steam_minusminus \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust steam -10}
dui add dbutton $::PD_home_pages 1666 902 -tags PD_wf53 -initial_state hidden \
    -bwidth 96 -bheight 96 -tags PD_steam_minus \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust steam -1}
dui add variable $::PD_home_pages 1860 952 -tags PD_wf54 -initial_state hidden -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_steam_text_s $::settings(steam_timeout)]}
dui add dbutton $::PD_home_pages 1960 902 -tags PD_wf55 -initial_state hidden \
    -bwidth 96 -bheight 96 -tags PD_steam_plus \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_steam_on; PD_adjust steam +1}
dui add dbutton $::PD_home_pages 2076 902 -tags PD_wf56 -initial_state hidden \
    -bwidth 96 -bheight 96 -tags PD_steam_plusplus \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_steam_on; PD_adjust steam +10}



dui add dbutton $::PD_home_pages 1247 1048 -tags PD_wf61 -initial_state hidden \
    -bwidth 280 -bheight 96 \
    -labelvariable {[PD_water_button_text]} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {PD_longpress_fix; PD_adjust_water_toggle}
dui add dbutton $::PD_home_pages 1548 1048 -tags PD_wf62 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust water -10}
dui add dbutton $::PD_home_pages 1666 1048 -tags PD_wf63 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust water -1}
dui add variable $::PD_home_pages 1860 1098 -tags PD_wf64 -initial_state hidden -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_water_dial_text]}
dui add dbutton $::PD_home_pages 1960 1048 -tags PD_wf65 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust water +1}
dui add dbutton $::PD_home_pages 2076 1048 -tags PD_wf66 -initial_state hidden \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust water +10}

add_de1_widget "off espresso hotwaterrinse water" graph 1130 350 {
    set ::PD_home_espresso_graph_1 $widget
    bind $widget [platform_button_press] {
        say [translate {zoom}] $::settings(sound_button_in);
        set_next_page off off_zoomed;
        set_next_page espresso espresso_zoomed;
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
    $widget element create home_steps -xdata espresso_elapsed -ydata espresso_state_change -label "" -linewidth [rescale_x_skin 2] -color $::PD_settings(dark_white)  -pixels 0 ;
    $widget axis configure x -color $::PD_settings(off_white) -tickfont [PD_font font 16] -min 0.0;
    $widget axis configure y -color $::PD_settings(green) -tickfont [PD_font font 16] -min 0.0 -max $::de1(max_pressure) -subdivisions 5 -majorticks {0  2  4  6  8  10  12}  -hide 0;
    $widget axis configure y2 -color $::PD_settings(blue) -tickfont [PD_font font 16] -min 0.0 -max 6 -subdivisions 2 -majorticks {0  1  2  3  4  5  6} -hide 0;
    $widget grid configure -color $::PD_settings(grid_colour) -dashes {5 5} -linewidth 1
} -plotbackground $::PD_settings(bg_colour) -width [rescale_x_skin 1350] -height [rescale_y_skin 740] -borderwidth 1 -background $::PD_settings(bg_colour) -plotrelief flat
dui add variable $::PD_home_pages 0 -20 -textvariable {[PD_restore_live_graphs]}
PD_setup_home_espresso_graph_1


# Steam graph
add_de1_widget "steam" graph 1130 350 {
    set ::PD_home_steam_graph $widget
    bind $widget [platform_button_press] {
        #say [translate {zoom}] $::settings(sound_button_in);
        #set_next_page off off_steam_zoomed;
        #set_next_page steam steam_steam_zoomed;
        #page_show $::de1(current_context);
    }
    $widget element create home_steam_pressure -xdata steam_elapsed -ydata steam_pressure -symbol none -label "" -linewidth [rescale_x_skin 6] -color $::PD_settings(green) -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
    $widget element create home_steam_flow -xdata steam_elapsed -ydata steam_flow -symbol none -label "" -linewidth [rescale_x_skin 6] -color $::PD_settings(blue) -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
    $widget element create home_steam_temperature -xdata steam_elapsed -ydata steam_temperature100th -symbol none -label "" -linewidth [rescale_x_skin 6] -color $::PD_settings(red)  -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
    $widget axis configure x -color $::PD_settings(off_white) -tickfont [PD_font font 16] -min 0.0
    $widget axis configure y -color $::PD_settings(off_white) -tickfont [PD_font font 16] -min 0.0 -subdivisions 1
    $widget axis configure y2 -color $::PD_settings(red) -tickfont [PD_font font 16] -min 130 -max 180 -majorticks {130 135 140 145 150 155 160 165 170 175 180} -hide 0
    $widget grid configure -color $::PD_settings(grid_colour) -dashes {5 5} -linewidth 1
} -plotbackground $::PD_settings(bg_colour) -width [rescale_x_skin 1350] -height [rescale_y_skin 740] -borderwidth 1 -background $::PD_settings(bg_colour) -plotrelief flat

add_de1_widget "off" graph 1130 350 {
    set ::PD_home_steam_graph_1 $widget
    bind $widget [platform_button_press] {
        PD_hide_steam_graph;
        #say [translate {zoom}] $::settings(sound_button_in);
        #set_next_page off off_steam_zoomed;
        #set_next_page steam steam_steam_zoomed;
        #page_show $::de1(current_context);
    }
    $widget element create home_steam_pressure -xdata steam_elapsed -ydata steam_pressure -symbol none -label "" -linewidth [rescale_x_skin 6] -color $::PD_settings(green) -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
    $widget element create home_steam_flow -xdata steam_elapsed -ydata steam_flow -symbol none -label "" -linewidth [rescale_x_skin 6] -color $::PD_settings(blue) -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
    $widget element create home_steam_temperature -xdata steam_elapsed -ydata steam_temperature100th -symbol none -label "" -linewidth [rescale_x_skin 6] -color $::PD_settings(red)  -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
    $widget axis configure x -color $::PD_settings(off_white) -tickfont [PD_font font 16] -min 0.0
    $widget axis configure y -color $::PD_settings(off_white) -tickfont [PD_font font 16] -min 0.0 -subdivisions 1
    $widget axis configure y2 -color $::PD_settings(red) -tickfont [PD_font font 16] -min 130 -max 180 -majorticks {130 135 140 145 150 155 160 165 170 175 180} -hide 0
    $widget grid configure -color $::PD_settings(grid_colour) -dashes {5 5} -linewidth 1
} -plotbackground $::PD_settings(bg_colour) -initial_state hidden -width [rescale_x_skin 1350] -height [rescale_y_skin 740] -borderwidth 1 -background $::PD_settings(bg_colour) -plotrelief flat



if {$::settings(enable_fahrenheit) == 1} {
    $::PD_home_steam_graph_1 axis configure y2 -color $::PD_settings(off_white) -tickfont [PD_font font 16] -min 266 -max 356 -majorticks {266 275 284 293 302 311 320 329 338 347 356}
    $::PD_home_steam_graph_1 axis configure y -max 5 -min 0.0 -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5}
    $::PD_home_steam_graph axis configure y2 -color $::PD_settings(off_white) -tickfont [PD_font font 16] -min 266 -max 356 -majorticks {266 275 284 293 302 311 320 329 338 347 356}
    $::PD_home_steam_graph axis configure y -max 5 -min 0.0 -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5}
} else {
    $::PD_home_steam_graph_1 axis configure y2 -color $::PD_settings(red) -min 130 -max 180 -majorticks {130 135 140 145 150 155 160 165 170 175 180}
    $::PD_home_steam_graph_1 axis configure y -max 5 -min 0.0 -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5}
    $::PD_home_steam_graph axis configure y2 -color $::PD_settings(red) -min 130 -max 180 -majorticks {130 135 140 145 150 155 160 165 170 175 180}
    $::PD_home_steam_graph axis configure y -max 5 -min 0.0 -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5}
}

dui add canvas_item rect off 1150 240 1172 262 -outline $::PD_settings(green) -fill $::PD_settings(green) -tags steam_pressure_icon -initial_state hidden
dui add canvas_item rect off 1346 240 1368 262 -outline $::PD_settings(red) -fill $::PD_settings(red) -tags steam_temperature_icon -initial_state hidden
dui add canvas_item rect off 1592 240 1614 262 -outline $::PD_settings(blue) -fill $::PD_settings(blue) -tags steam_flow_icon -initial_state hidden
dui add variable off 1188 252 -tags steam_pressure_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w  -initial_state hidden -width 880 -textvariable {[translate "Pressure"]}
dui add variable off 1384 252 -tags steam_temperature_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w  -initial_state hidden -width 880 -textvariable {[translate "Temperature"]}
dui add variable off 1630 252 -tags steam_flow_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w  -initial_state hidden -width 880 -textvariable {[translate "Flow in Puck"]}

dui add dbutton off 0 0 \
    -bwidth 2560 -bheight 1600 -tags PD_heading_steam_graph_exit_button -initial_state hidden \
    -command {PD_longpress_fix; PD_hide_steam_graph}

dui add dbutton off 1150 190 \
    -bwidth 190 -bheight 110 -initial_state hidden -tags steam_pressure_button \
    -command {PD_longpress_fix; PD_toggle_graph steam_pressure}
dui add dbutton off 1376 190 \
    -bwidth 190 -bheight 110 -initial_state hidden -tags steam_temperature_button \
    -command {PD_longpress_fix; PD_toggle_graph steam_temperature}
dui add dbutton off 1620 190 \
    -bwidth 190 -bheight 110 -initial_state hidden -tags steam_flow_button \
    -command {PD_longpress_fix; PD_toggle_graph steam_flow}



dui add canvas_item rect steam 1150 240 1172 262 -outline $::PD_settings(green) -fill $::PD_settings(green) -tags steam_steam_pressure_icon -initial_state normal
dui add canvas_item rect steam 1346 240 1368 262 -outline $::PD_settings(red) -fill $::PD_settings(red) -tags steam_steam_temperature_icon -initial_state normal
dui add canvas_item rect steam 1592 240 1614 262 -outline $::PD_settings(blue) -fill $::PD_settings(blue) -tags steam_steam_flow_icon -initial_state normal
dui add variable steam 1188 252 -tags steam_steam_pressure_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w  -initial_state normal -width 880 -textvariable {[translate "Pressure"]}
dui add variable steam 1384 252 -tags steam_steam_temperature_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w  -initial_state normal -width 880 -textvariable {[translate "Temperature"]}
dui add variable steam 1630 252 -tags steam_steam_flow_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w  -initial_state normal -width 880 -textvariable {[translate "Flow in Puck"]}

dui add dbutton steam 1150 190 \
    -bwidth 190 -bheight 110 -initial_state normal -tags steam_steam_pressure_button \
    -command {PD_longpress_fix; PD_toggle_graph steam_pressure}
dui add dbutton steam 1376 190 \
    -bwidth 190 -bheight 110 -initial_state normal -tags steam_steam_temperature_button \
    -command {PD_longpress_fix; PD_toggle_graph steam_temperature}
dui add dbutton steam 1620 190 \
    -bwidth 190 -bheight 110 -initial_state normal -tags steam_steam_flow_button \
    -command {PD_longpress_fix; PD_toggle_graph steam_flow}









proc skins_page_change_due_to_de1_state_change { textstate } {
	page_change_due_to_de1_state_change $textstate

	if {$textstate == "Idle"} {
        set_next_page off off;
    } elseif {$textstate == "Steam"} {
        set_next_page off off;
    } elseif {$textstate == "Espresso"} {
        set_next_page off off;
    } elseif {$textstate == "HotWater"} {
        set_next_page off off;
    } elseif {$textstate == "HotWaterRinse"} {
        set_next_page off off;
    }

}

proc PD_heating_start_button {} {
    if {$::PD_heating == 1} {
        dui item config off PD_heating_button* -state normal
    } else {
        dui item config off PD_heating_button* -state hidden
    }
}
dui add variable off 0 -10 -font [PD_font font_bold 1] -textvariable {[PD_heating_start_button]}

#### startup config ####
if {$::settings(steam_disabled) == 1} {
    dui item config $::PD_home_pages PD_steam_label -fill $::PD_settings(light_grey)
} else {
    dui item config $::PD_home_pages PD_steam_label -fill $::PD_settings(off_white)
}
array set ::settings_backup [array get ::settings]

PD_check_steam_off_button
PD_set_fav_label_colour
PD_set_fav_label_cup
PD_fav_option_hide_13
PD_fav_option_hide_46
PD_load_default_fav
PD_restore_graphs

::de1::event::listener::on_major_state_change_add [lambda {event_dict} {
    if {[dict get $event_dict previous_state] == "saver"} {
        PD_load_default_fav
    }
}]


set ::de1(scale_sensor_weight) 00










