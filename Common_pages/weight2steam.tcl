add_de1_image "weight2steam" 880 1200 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/big_scale.png"
add_de1_variable "weight2steam" 1290 1340 -justify center -anchor "n" -text "" -font [PD_font font 40] -fill $::PD_settings(off_white) -textvariable {[round_to_one_digits $::de1(scale_sensor_weight)]g}
add_de1_button "weight2steam" {say [translate {connect}] $::settings(sound_button_in); scale_tare; catch {ble_connect_to_scale}} 1150 1200 1400 1500

set ::cal_instructions "SETUP:\r1. Tare the scale with your empty jug on it, add milk then tap Milk net weight to save the weight. \r2. Steam the milk to your desired temperature taking note of the time, record the time above. \r3. Tare the scale then weight your empty jug/s, tap the relevant empty jug weight slot to save the weight \r\rYou can clear jug slot by tapping the X"

add_de1_variable "weight2steam" 1920 840 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -width [rescale_x_skin 1100] -textvariable {$::cal_instructions}
add_de1_variable "weight2steam" 1280 60 -font [PD_font font 18] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Steam by Weight Setup Page}
add_de1_variable "weight2steam" 600 304 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Empty jug weight}
add_de1_variable "weight2steam" 600 604 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Empty jug weight}
add_de1_variable "weight2steam" 600 904 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Empty jug weight}
add_de1_variable "weight2steam" 2000 304 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Milk net weight}
add_de1_variable "weight2steam" 2000 604 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Calibration time}

# jug 1
dui add dbutton "weight2steam" 130 140 \
    -bwidth 670 -bheight 200 \
    -labelvariable {} -label_font [PD_font awesome_light 48] -label_fill $::PD_settings(off_white) -label_pos {0.1 0.5} \
    -command {}
add_de1_image "weight2steam" 180 134 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/icons/jug.png"
add_de1_image "weight2steam" 400 140 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/icons/button7.png"
add_de1_variable "weight2steam" 270 240 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {S}
add_de1_variable "weight2steam" 760 180 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {X}
add_de1_variable "weight2steam" 600 240 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {[jug_s_cal_text]}
add_de1_button "weight2steam" {say [translate {set jug}] $::settings(sound_button_in); set_jug_s} 180 140 800 340 ""
add_de1_button "weight2steam" {say [translate {clear}] $::settings(sound_button_in); clear_jug_s} 720 120 850 220
# jug 2
add_de1_image "weight2steam" 180 434 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/icons/jug.png"
add_de1_image "weight2steam" 400 440 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/icons/button7.png"
add_de1_variable "weight2steam" 270 540 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {M}
add_de1_variable "weight2steam" 760 480 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {X}
add_de1_variable "weight2steam" 600 540 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {[jug_m_cal_text]}
add_de1_button "weight2steam" {say [translate {set jug}] $::settings(sound_button_in); set_jug_m} 180 440 800 640 ""
add_de1_button "weight2steam" {say [translate {clear}] $::settings(sound_button_in); clear_jug_m} 720 420 850 520
# jug 3
add_de1_image "weight2steam" 180 734 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/icons/jug.png"
add_de1_image "weight2steam" 400 740 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/icons/button7.png"
add_de1_variable "weight2steam" 270 840 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {L}
add_de1_variable "weight2steam" 760 780 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {X}
add_de1_variable "weight2steam" 600 840 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {[jug_l_cal_text]}
add_de1_button "weight2steam" {say [translate {set jug}] $::settings(sound_button_in); clear_jug_l} 180 740 800 940 ""
add_de1_button "weight2steam" {say [translate {clear}] $::settings(sound_button_in); clear_jug_l} 720 720 850 820
# jug full
add_de1_image "weight2steam" 1380 134 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/icons/jug_full.png"
add_de1_image "weight2steam" 1600 140 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/icons/click.png"
add_de1_variable "weight2steam" 2000 240 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {[round_to_integer $::PD_settings(milk_g)]g}
add_de1_button "weight2steam" {horizontal_clicker_int 10 1 ::PD_settings(milk_g) 100 300 %x %y %x0 %y0 %x1 %y1;} 1600 140 2400 340 ""


# time
add_de1_image "weight2steam" 1380 434 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/icons/steam_timer.png"
add_de1_image "weight2steam" 1600 440 "[homedir]/skins/DSx/${::screen_size_width}x${::screen_size_height}/icons/click.png"
add_de1_variable "weight2steam" 2000 540 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {[round_to_integer $::PD_settings(milk_s)]s}
add_de1_button "weight2steam" {horizontal_clicker_int 10 1 ::PD_settings(milk_s) 1 90 %x %y %x0 %y0 %x1 %y1;} 1600 440 2400 640 ""


dui add dbutton "weight2steam" 2360 0 \
    -bwidth 200 -bheight 200 \
    -labelvariable {X} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -command {page_show off; PD_save PD_settings}
# todo replace clicker
proc horizontal_clicker_int {bigincrement smallincrement varname minval maxval x y x0 y0 x1 y1} {

	set x [translate_coordinates_finger_down_x $x]
	set y [translate_coordinates_finger_down_y $y]
	set xrange [expr {$x1 - $x0}]
	set xoffset [expr {$x - $x0}]
	set midpoint [expr {$x0 + ($xrange / 2)}]
	set onequarterpoint [expr {$x0 + ($xrange / 5)}]
	set threequarterpoint [expr {$x1 - ($xrange / 5)}]
	if {[info exists $varname] != 1} {
		# if the variable doesn't yet exist, initialize it with a zero value
		set $varname 0
	}
	set currentval [subst \$$varname]
	set newval $currentval
	if {$x < $onequarterpoint} {
		set newval [expr "1.0 * \$$varname - $bigincrement"]
	} elseif {$x < $midpoint} {
		set newval [expr "1.0 * \$$varname - $smallincrement"]
	} elseif {$x < $threequarterpoint} {
		set newval [expr "1.0 * \$$varname + $smallincrement"]
	} else {
		set newval [expr "1.0 * \$$varname + $bigincrement"]
	}
	set newval [round_to_integer $newval]
	if {$newval > $maxval} {
		set $varname $maxval
	} elseif {$newval < $minval} {
		set $varname $minval
	} else {
		set $varname [round_to_integer $newval]
	}
	update_onscreen_variables
	return
}



dui add dbutton weight2steam 200 1400 \
    -bwidth 330 -bheight 120\
    -labelvariable {Theme = $::PD_settings(theme)} -label_font [PD_font icons 16] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -shape outline -width 2 -arc_offset 20 -outline $::PD_settings(off_white) \
    -command {if {$::PD_settings(theme) == "Damian"} {set ::PD_settings(theme) "Pulak"} else {set ::PD_settings(theme) "Damian"}; PD_save PD_settings}
