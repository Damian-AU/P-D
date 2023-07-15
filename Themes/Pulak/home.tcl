##### temperary patch for longpress#####
### todo remove patch if DUI is fixed

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

#       note: PD_longpress_fix; added to all dbutton -command options


##### end patch #####




# left side
set ::PD_home_pages "off espresso steam flush water"
dui add dbutton $::PD_home_pages 40 40 \
    -bwidth 1010 -bheight 1520 \
    -shape round -radius 30 -fill $::PD_settings(dark_grey)
#add_de1_image "off" 0 0 "[skin_directory]/2.jpeg"
dui add canvas_item line $::PD_home_pages 100 172 970 172 -fill $::PD_settings(light_grey) -width 2
dui add canvas_item line $::PD_home_pages 100 1116 970 1116 -fill $::PD_settings(light_grey) -width 2

dui add dtext $::PD_home_pages 104 110 -text [translate "PROFILE"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify left
dui add variable $::PD_home_pages 970 110 -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor e -justify right -width 650 -tags PD_profile_name -textvariable {[PD_fav_colour_change]$::settings(profile_title)}

dui add variable $::PD_home_pages 970 150 -font [PD_font font 16] -fill $::PD_settings(red) -anchor e -justify right -textvariable {$::PD_profile_not_saved}
dui add dbutton $::PD_home_pages 40 40 \
    -bwidth 1010 -bheight 140 \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; set ::settings(active_settings_tab) settings_1; show_settings} -longpress_cmd {PD_goto_profile_wizard}

dui add dbutton $::PD_home_pages 47 220 \
    -bwidth 280 -bheight 96 \
    -labelvariable {[translate "Beans in"]} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {PD_longpress_fix; }
dui add dbutton $::PD_home_pages 348 220 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust dose -1}
dui add dbutton $::PD_home_pages 466 220 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust dose -0.1}
dui add variable $::PD_home_pages 660 270 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {$::settings(grinder_dose_weight)g}
dui add dbutton $::PD_home_pages 760 220 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust dose 0.1}
dui add dbutton $::PD_home_pages 876 220 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust dose 1}

dui add dbutton $::PD_home_pages 47 364 \
    -bwidth 280 -bheight 96 \
    -labelvariable {[translate "Beverage out"]} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {PD_longpress_fix; }
dui add dbutton $::PD_home_pages 348 364 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust saw -10}
dui add dbutton $::PD_home_pages 466 364 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust saw -1}
dui add variable $::PD_home_pages 660 414 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_saw_switch]g}
dui add dbutton $::PD_home_pages 760 364 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust saw 1}
dui add dbutton $::PD_home_pages 876 364 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust saw 10}

dui add dbutton $::PD_home_pages 47 510 \
    -bwidth 280 -bheight 96 \
    -labelvariable {[translate "Ratio"]} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {PD_longpress_fix; }
dui add dbutton $::PD_home_pages 348 510 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust er -1}
dui add dbutton $::PD_home_pages 466 510 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust er -0.1}
dui add variable $::PD_home_pages 660 560 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_extraction_ratio]}
dui add dbutton $::PD_home_pages 760 510 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust er  0.1}
dui add dbutton $::PD_home_pages 876 510 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust er 1}

dui add dbutton $::PD_home_pages 47 656 \
    -bwidth 280 -bheight 96 \
    -labelvariable {[translate "Flush"]} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {PD_longpress_fix; }
dui add dbutton $::PD_home_pages 348 656 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust flush -10}
dui add dbutton $::PD_home_pages 466 656 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust flush -1}
dui add variable $::PD_home_pages 660 706 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[round_to_integer $::settings(flush_seconds)] sec}
dui add dbutton $::PD_home_pages 760 656 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust flush 1}
dui add dbutton $::PD_home_pages 876 656 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust flush 10}

dui add variable $::PD_home_pages 100 852 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor w -justify center -tags PD_steam_label -textvariable {[translate "Steam"] [PD_jug_label]}
dui add dbutton $::PD_home_pages 47 802 \
    -bwidth 280 -bheight 96 \
    -command {PD_longpress_fix; PD_jug_toggle} -longpress_cmd {PD_steam_toggle}
dui add dbutton $::PD_home_pages 47 802 \
    -bwidth 280 -bheight 96 -tags PD_steam_off_button -initial_state hidden\
    -command {PD_longpress_fix; PD_steam_toggle} -longpress_cmd {}



dui add dbutton $::PD_home_pages 348 802 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(light_grey) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; PD_steam_toggle}
dui add dbutton $::PD_home_pages 466 802 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(light_grey) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; PD_steam_toggle}
dui add dbutton $::PD_home_pages 760 802 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(light_grey) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; PD_steam_toggle}
dui add dbutton $::PD_home_pages 876 802 \
    -bwidth 96 -bheight 96  \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(light_grey) -label_pos {0.5 0.5} \
    -command {PD_longpress_fix; PD_steam_toggle}


dui add dbutton $::PD_home_pages 348 802 \
    -bwidth 96 -bheight 96 -tags PD_steam_minusminus \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust steam -10}
dui add dbutton $::PD_home_pages 466 802 \
    -bwidth 96 -bheight 96 -tags PD_steam_minus \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust steam -1}
dui add variable $::PD_home_pages 660 852 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center  -tags PD_steam_value -textvariable {[PD_steam_text $::settings(steam_timeout)]}
dui add dbutton $::PD_home_pages 760 802 \
    -bwidth 96 -bheight 96 -tags PD_steam_plus \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust steam +1}
dui add dbutton $::PD_home_pages 876 802 \
    -bwidth 96 -bheight 96 -tags PD_steam_plusplus \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust steam +10}

dui add dbutton $::PD_home_pages 47 948 \
    -bwidth 280 -bheight 96 \
    -labelvariable {[PD_water_button_text]} -label_font [PD_font font 16] -label_fill $::PD_settings(off_white) -label_pos {0.2 0.5} -label_anchor w \
    -command {PD_longpress_fix; PD_adjust_water_toggle}
dui add dbutton $::PD_home_pages 348 948 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_--)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust water -10}
dui add dbutton $::PD_home_pages 466 948 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_-)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust water -1}
dui add variable $::PD_home_pages 660 998 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -textvariable {[PD_water_dial_text]}
dui add dbutton $::PD_home_pages 760 948 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_+)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust water +1}
dui add dbutton $::PD_home_pages 876 948 \
    -bwidth 96 -bheight 96 \
    -labelvariable {$::PD_settings(icon_++)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_adjust water +10}


#### upper row favourites
dui add variable $::PD_home_pages 240 1250 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav1_label -textvariable {$::PD_settings(fav1)}
dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_save fav1}
dui add dbutton $::PD_home_pages 104 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav1_button_on -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(fav1_colour) \
    -command {PD_longpress_fix; PD_load fav1} -longpress_cmd {PD_save fav1}

dui add variable $::PD_home_pages 540 1250 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav2_label -textvariable {$::PD_settings(fav2)}
dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_save fav2}
dui add dbutton $::PD_home_pages 404 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav2_button_on -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(fav2_colour) \
    -command {PD_longpress_fix; PD_load fav2} -longpress_cmd {PD_save fav2}


dui add variable $::PD_home_pages 840 1250 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav3_label -textvariable {$::PD_settings(fav3)}
dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_save fav3}
dui add dbutton $::PD_home_pages 704 1180 \
    -bwidth 272 -bheight 140 -tags PD_fav3_button_on -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(fav3_colour) \
    -command {PD_longpress_fix; PD_load fav3} -longpress_cmd {PD_save fav3}

#### lower row favourites
dui add variable $::PD_home_pages 240 1440 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav4_label -textvariable {$::PD_settings(fav4)}
dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_save fav4}
dui add dbutton $::PD_home_pages 104 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav4_button_on -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(fav4_colour) \
    -command {PD_longpress_fix; PD_load fav4} -longpress_cmd {PD_save fav4}

dui add variable $::PD_home_pages 540 1440 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav5_label -textvariable {$::PD_settings(fav5)}
dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_save fav5}
dui add dbutton $::PD_home_pages 404 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav5_button_on -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(fav5_colour) \
    -command {PD_longpress_fix; PD_load fav5} -longpress_cmd {PD_save fav5}

dui add variable $::PD_home_pages 840 1440 -font [PD_font font 16] -fill $::PD_settings(off_white) -width 250 -anchor center -justify center -tags PD_fav6_label -textvariable {$::PD_settings(fav6)}
dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_save fav6}
dui add dbutton $::PD_home_pages 704 1370 \
    -bwidth 272 -bheight 140 -tags PD_fav6_button_on -initial_state hidden \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(fav6_colour) \
    -command {PD_longpress_fix; PD_load fav6} -longpress_cmd {PD_save fav6}





# right side
dui add dbutton $::PD_home_pages 1090 40 \
    -bwidth 1430 -bheight 1076 \
    -shape round -radius 30 -fill $::PD_settings(dark_grey)

dui add canvas_item line $::PD_home_pages 1150 172 2460 172 -fill $::PD_settings(light_grey) -width 2
dui add canvas_item line $::PD_home_pages 1150 308 2460 308 -fill $::PD_settings(light_grey) -width 2
dui add canvas_item line $::PD_home_pages 1302 40 1302 172 -fill $::PD_settings(light_grey) -width 2
dui add canvas_item line $::PD_home_pages 1524 40 1524 172 -fill $::PD_settings(light_grey) -width 2
dui add canvas_item line $::PD_home_pages 1976 40 1976 172 -fill $::PD_settings(light_grey) -width 2


dui add dtext $::PD_home_pages 1150 110 -text [translate "DATA"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify left
dui add variable $::PD_home_pages 1412 94 -font [PD_font font_bold 16] -fill $::PD_settings(blue) -anchor center -justify center -width 880 -textvariable {READY}
dui add variable $::PD_home_pages 1412 132 -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center -width 880 -textvariable {state}

dui add variable $::PD_home_pages 1610 94 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -width 880 -textvariable {[PD_group_head_heater_temperature_text]}
dui add variable $::PD_home_pages 1736 94 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -width 880 -textvariable {[PD_steamtemp_text]}
dui add variable $::PD_home_pages 1880 94 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -width 880 -textvariable {[PD_low_water]}
dui add dtext $::PD_home_pages 1610 132 -text [translate "Group"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext $::PD_home_pages 1736 132 -text [translate "Steam"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext $::PD_home_pages 1880 132 -text [translate "Tank"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center

dui add variable espresso 0 -10 -font [PD_font font_bold 1] -textvariable {[PD_backup_live_graph]}

dui add variable $::PD_home_pages 2100 94 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -width 880 -textvariable {[PD_live_graph_pi_time]}
dui add variable $::PD_home_pages 2250 94 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -width 880 -textvariable {[PD_live_graph_pour_time]}
dui add variable $::PD_home_pages 2400 94 -font [PD_font font_bold 16] -fill $::PD_settings(off_white) -anchor center -justify center -width 880 -textvariable {[PD_live_graph_shot_time]}
dui add dtext $::PD_home_pages 2100 132 -text [translate "Infusion"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext $::PD_home_pages 2250 132 -text [translate "Pour"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center
dui add dtext $::PD_home_pages 2400 132 -text [translate "Total time"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor center -justify center


dui add canvas_item rect $::PD_home_pages 1150 228 1172 250 -outline $::PD_settings(green) -fill $::PD_settings(green) -tags pressure_icon
dui add canvas_item rect $::PD_home_pages 1346 228 1368 250 -outline $::PD_settings(red) -fill $::PD_settings(red) -tags temperature_icon
dui add canvas_item rect $::PD_home_pages 1592 228 1614 250 -outline $::PD_settings(blue) -fill $::PD_settings(blue) -tags flow_icon
dui add canvas_item rect $::PD_home_pages 1834 228 1856 250 -outline $::PD_settings(brown) -fill $::PD_settings(brown) -tags weight_icon
dui add canvas_item rect $::PD_home_pages 2066 228 2088 250 -outline $::PD_settings(yellow) -fill $::PD_settings(yellow) -tags resistance_icon
dui add variable $::PD_home_pages 1188 240 -tags pressure_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Pressure"]}
dui add variable $::PD_home_pages 1384 240 -tags temperature_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Temperature"]}
dui add variable $::PD_home_pages 1630 240 -tags flow_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Flow in Puck"]}
dui add variable $::PD_home_pages 1872 240 -tags weight_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Flow in Cup"]}
dui add variable $::PD_home_pages 2104 240 -tags resistance_text -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -width 880 -textvariable {[translate "Puck Resistance"]}
dui add dbutton $::PD_home_pages 1150 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph pressure}
dui add dbutton $::PD_home_pages 1376 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph temperature}
dui add dbutton $::PD_home_pages 1620 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph flow}
dui add dbutton $::PD_home_pages 1862 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph weight}
dui add dbutton $::PD_home_pages 2094 190 \
    -bwidth 190 -bheight 110 \
    -command {PD_longpress_fix; PD_toggle_graph resistance}


dui add dbutton $::PD_home_pages 1090 1180 \
    -bwidth 740 -bheight 140 \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey)
dui add canvas_item line $::PD_home_pages 1232 1180 1232 1320 -fill $::PD_settings(light_grey) -width 2
dui add canvas_item line $::PD_home_pages 1544 1180 1544 1320 -fill $::PD_settings(light_grey) -width 2
dui add canvas_item line $::PD_home_pages 1688 1180 1688 1320 -fill $::PD_settings(light_grey) -width 2




dui add dbutton $::PD_home_pages 1090 1370 \
    -bwidth 1116 -bheight 140 \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey)
dui add canvas_item line $::PD_home_pages 1230 1370 1230 1510 -fill $::PD_settings(light_grey) -width 2
dui add canvas_item line $::PD_home_pages 1544 1370 1544 1510 -fill $::PD_settings(light_grey) -width 2
dui add canvas_item line $::PD_home_pages 1872 1370 1872 1510 -fill $::PD_settings(light_grey) -width 2


dui add dtext $::PD_home_pages 1280 1418 -text [translate "Profile"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1592 1418 -text [translate "Machine"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1930 1418 -text [translate "App"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center

dui add dtext $::PD_home_pages 1280 1464 -text [translate "Edit Shot Steps"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1592 1464 -text [translate "Hardware Settings"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center
dui add dtext $::PD_home_pages 1930 1464 -text [translate "Software Settings"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center


dui add variable $::PD_home_pages 1280 1228 -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center -textvariable {[round_to_one_digits $::de1(scale_sensor_weight)]g}
dui add variable $::PD_home_pages 1280 1274 -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center -textvariable {[PD_scale_disconnected]}

dui add dbutton $::PD_home_pages 1090 1180 \
    -bwidth 140 -bheight 140 \
    -labelvariable {$::PD_settings(icon_scale)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; scale_tare; catch {ble_connect_to_scale}}

dui add dbutton $::PD_home_pages 1230 1180 \
    -bwidth 300 -bheight 140 \
    -command {PD_longpress_fix; scale_tare; catch {ble_connect_to_scale}}

dui add dbutton $::PD_home_pages 1546 1180 \
    -bwidth 140 -bheight 140 \
    -labelvariable {$::PD_settings(icon_bean)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; PD_set_dose}

dui add dbutton $::PD_home_pages 1688 1180 \
    -bwidth 140 -bheight 140 \
    -labelvariable {$::PD_settings(icon_steam)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; PD_steam_time_calc}

#start for nonGHC
if {[ghc_required]} {
    dui add dbutton $::PD_home_pages 1870 1180 \
        -bwidth 650 -bheight 140 \
        -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey)
    dui add canvas_item line $::PD_home_pages 2012 1180 2012 1320 -fill $::PD_settings(light_grey) -width 2
    dui add canvas_item line $::PD_home_pages 2290 1180 2290 1320 -fill $::PD_settings(light_grey) -width 2

    dui add dtext $::PD_home_pages 2060 1228 -text [translate "Describe"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center
    dui add dtext $::PD_home_pages 2340 1228 -text [translate "Plan"] -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor w -justify center

    dui add dtext $::PD_home_pages 2060 1274 -text [translate "Previous Shot"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center
    dui add dtext $::PD_home_pages 2340 1274 -text [translate "Next Shot"] -font [PD_font font 13] -fill $::PD_settings(off_white) -anchor w -justify center

    dui add dbutton $::PD_home_pages 1870 1180 \
        -bwidth 140 -bheight 140 \
        -labelvariable {$::PD_settings(icon_espresso)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
        -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
        -command {PD_longpress_fix; }
} else {
    dui add variable $::PD_home_pages 1758 1246 -font [PD_font awesome_light 18] -fill #c8c8c8 -anchor center -justify center -textvariable {$::PD_settings(icon_timer)}

    dui add dbutton $::PD_home_pages 1870 1180 \
        -bwidth 140 -bheight 140 \
        -labelvariable {$::PD_settings(icon_espresso)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
        -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
        -command {PD_longpress_fix; start_espresso}
    dui add dbutton "espresso" 1870 1180 \
        -bwidth 140 -bheight 140 \
        -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
        -command {PD_longpress_fix; start_idle}

    dui add dbutton $::PD_home_pages 2022 1180 \
        -bwidth 140 -bheight 140 \
        -labelvariable {$::PD_settings(icon_flush)} -label_font [PD_font awesome_light 40] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
        -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
        -command {PD_longpress_fix; start_flush}
    dui add dbutton $::PD_home_pages 2174 1180 \
        -bwidth 140 -bheight 140 \
        -labelvariable {$::PD_settings(icon_steam)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
        -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
        -command {PD_longpress_fix; start_steam}
    dui add dbutton $::PD_home_pages 2326 1180 \
        -bwidth 140 -bheight 140 \
        -labelvariable {$::PD_settings(icon_water)} -label_font [PD_font awesome_light 40] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
        -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(light_grey) \
        -command {PD_longpress_fix; start_hot_water_rinse}
}






dui add dbutton $::PD_home_pages 1090 1370 \
    -bwidth 140 -bheight 140 \
    -labelvariable {$::PD_settings(icon_settings)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; PD_steam_time_calc}

dui add dbutton $::PD_home_pages 1240 1370 \
    -bwidth 300 -bheight 140 \
    -command {PD_longpress_fix; PD_goto_profile_wizard}

dui add dbutton $::PD_home_pages 1560 1370 \
    -bwidth 300 -bheight 140 \
    -command {PD_longpress_fix; set ::settings(active_settings_tab) settings_3; show_settings}

dui add dbutton $::PD_home_pages 1880 1370 \
    -bwidth 300 -bheight 140 \
    -command {PD_longpress_fix; set ::settings(active_settings_tab) settings_4; show_settings}





dui add dbutton $::PD_home_pages 2280 1366 \
    -bwidth 200 -bheight 140 \
    -labelvariable {$::PD_settings(icon_power)} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 1 -outline $::PD_settings(tap_zone) \
    -command {PD_longpress_fix; PD_power}






set ::PD_message ""
dui add canvas_item rect $::PD_home_pages 1060 0 2560 1600 -outline $::PD_settings(main_background_colour) -fill $::PD_settings(main_background_colour) -tags PD_rhs_bg_cover -initial_state hidden

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

dui add variable $::PD_home_pages 1820 800 -font [PD_font font_bold 20] -fill $::PD_settings(off_white) -anchor center -justify center -width 880 -textvariable {$::PD_message}


add_de1_widget "off espresso" graph 1130 350 {
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
    $widget axis configure x -color $::PD_settings(off_white) -tickfont [PD_font font 16] -min 0.0;
    $widget axis configure y -color $::PD_settings(green) -tickfont [PD_font font 16] -min 0.0 -max $::de1(max_pressure) -subdivisions 5 -majorticks {0  2  4  6  8  10  12}  -hide 0;
    $widget axis configure y2 -color $::PD_settings(blue) -tickfont [PD_font font 16] -min 0.0 -max 6 -subdivisions 2 -majorticks {0  1  2  3  4  5  6} -hide 0;
    $widget grid configure -color $::PD_settings(grid_colour) -dashes {5 5} -linewidth 1
} -plotbackground $::PD_settings(bg_colour) -width [rescale_x_skin 1350] -height [rescale_y_skin 740] -borderwidth 1 -background $::PD_settings(bg_colour) -plotrelief flat
dui add variable $::PD_home_pages 0 -20 -textvariable {[PD_restore_live_graphs]}


#### startup config ####
if {$::settings(steam_disabled) == 1} {
    dui item config $::PD_home_pages PD_steam_label -fill $::PD_settings(light_grey)
} else {
    dui item config $::PD_home_pages PD_steam_label -fill $::PD_settings(off_white)
}
array set ::settings_backup [array get ::settings]

PD_check_steam_off_button



set ::de1(scale_sensor_weight) 34