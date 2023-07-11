add_de1_image "weight2steam" 880 1200 "[homedir]/skins/DSx/1280x800/big_scale.png"
add_de1_variable "weight2steam" 1290 1340 -justify center -anchor "n" -text "" -font [PD_font font 40] -fill $::PD_settings(off_white) -textvariable {[round_to_one_digits $::de1(scale_sensor_weight)]g}
add_de1_button "weight2steam" {say [translate {connect}] $::settings(sound_button_in); scale_tare; catch {ble_connect_to_scale}} 1150 1200 1400 1500

set ::cal_instructions "SETUP:\r1. Tare the scale with your empty jug on it, add milk then tap Milk net weight to save the weight. \r2. Steam the milk to your desired temperature taking note of the time, record the time above. \r3. Tare the scale then weight your empty jug/s, tap the relevant empty jug weight slot to save the weight \r\rYou can clear jug slot by tapping the X"

add_de1_variable "weight2steam" 1920 840 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -width [rescale_x_skin 1100] -textvariable {$::cal_instructions}
add_de1_variable "weight2steam" 1280 60 -font [PD_font font 18] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Steam by Weight Setup Page}
add_de1_variable "weight2steam" 600 304 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Empty jug weight}
add_de1_variable "weight2steam" 600 604 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Empty jug weight}
add_de1_variable "weight2steam" 600 904 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Empty jug weight}
add_de1_variable "weight2steam" 1800 304 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Milk net weight}
add_de1_variable "weight2steam" 2000 604 -font [PD_font font 16] -fill $::PD_settings(off_white) -anchor "center" -textvariable {Calibration time}

# jug 1
dui add dbutton "weight2steam" 130 140 \
    -bwidth 670 -bheight 200 \
    -labelvariable {} -label_font [PD_font awesome_light 48] -label_fill $::PD_settings(off_white) -label_pos {0.1 0.5} \
    -command {}
add_de1_image "weight2steam" 180 134 "[homedir]/skins/DSx/1280x800/icons/jug.png"
add_de1_image "weight2steam" 400 140 "[homedir]/skins/DSx/1280x800/icons/button7.png"
add_de1_variable "weight2steam" 270 240 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {S}
add_de1_variable "weight2steam" 760 180 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {X}
add_de1_variable "weight2steam" 600 240 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {[jug_s_cal_text]}
add_de1_button "weight2steam" {say [translate {set jug}] $::settings(sound_button_in); set_jug_s} 180 140 800 340 ""
add_de1_button "weight2steam" {say [translate {clear}] $::settings(sound_button_in); clear_jug_s} 720 120 850 220
# jug 2
add_de1_image "weight2steam" 180 434 "[homedir]/skins/DSx/1280x800/icons/jug.png"
add_de1_image "weight2steam" 400 440 "[homedir]/skins/DSx/1280x800/icons/button7.png"
add_de1_variable "weight2steam" 270 540 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {M}
add_de1_variable "weight2steam" 760 480 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {X}
add_de1_variable "weight2steam" 600 540 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {[jug_m_cal_text]}
add_de1_button "weight2steam" {say [translate {set jug}] $::settings(sound_button_in); set_jug_m} 180 440 800 640 ""
add_de1_button "weight2steam" {say [translate {clear}] $::settings(sound_button_in); clear_jug_m} 720 420 850 520
# jug 3
add_de1_image "weight2steam" 180 734 "[homedir]/skins/DSx/1280x800/icons/jug.png"
add_de1_image "weight2steam" 400 740 "[homedir]/skins/DSx/1280x800/icons/button7.png"
add_de1_variable "weight2steam" 270 840 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {L}
add_de1_variable "weight2steam" 760 780 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {X}
add_de1_variable "weight2steam" 600 840 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {[jug_l_cal_text]}
add_de1_button "weight2steam" {say [translate {set jug}] $::settings(sound_button_in); clear_jug_l} 180 740 800 940 ""
add_de1_button "weight2steam" {say [translate {clear}] $::settings(sound_button_in); clear_jug_l} 720 720 850 820
# jug full
add_de1_image "weight2steam" 1380 134 "[homedir]/skins/DSx/1280x800/icons/jug_full.png"
add_de1_image "weight2steam" 1600 140 "[homedir]/skins/DSx/1280x800/icons/button7.png"
add_de1_variable "weight2steam" 1800 240 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {[round_to_integer $::PD_settings(milk_g)]g}
add_de1_button "weight2steam" {set ::PD_settings(milk_g) $::de1(scale_sensor_weight); PD_save PD_settings} 1600 140 2000 340

# time
add_de1_image "weight2steam" 1380 434 "[homedir]/skins/DSx/1280x800/icons/steam_timer.png"
add_de1_image "weight2steam" 1600 440 "[homedir]/skins/DSx/1280x800/icons/click.png"
add_de1_variable "weight2steam" 2000 540 -justify center -anchor center -font [PD_font font 20] -fill $::PD_settings(off_white) -textvariable {[round_to_integer $::PD_settings(milk_s)]s}
add_de1_button "weight2steam" {say "" $::settings(sound_button_in); horizontal_clicker_int 10 1 ::PD_settings(milk_s) 1 90 %x %y %x0 %y0 %x1 %y1; set_jug} 1600 440 2400 640 ""


dui add dbutton "weight2steam" 2360 0 \
    -bwidth 200 -bheight 200 \
    -labelvariable {X} -label_font [PD_font icons 48] -label_fill $::PD_settings(off_white) -label_pos {0.5 0.5} \
    -command {page_show off; PD_save PD_settings}
