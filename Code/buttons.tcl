proc PD_adjust {var value} {
    PD_clear_fav_colour
    if {$var == "flush"} {
        set ::settings(flush_seconds) [round_to_integer [expr $::settings(flush_seconds) + $value]]
        PD_save flush
    }
    if {$var == "steam"} {
        if {$::settings(steam_disabled) == 1 && $::settings(steam_timeout) > 0} {
            #set ::settings(steam_disabled) 0
        } else {
            set ::settings(steam_timeout) [expr $::settings(steam_timeout) + $value]
            #set ::settings(steam_disabled) 0
        }
        PD_save steam
    }
    if {$var == "water"} {
        if {$::PD_settings(water_dial) == "volume"} {
            set ::settings(water_volume) [expr $::settings(water_volume) + $value]
            if {$::settings(water_volume) < 10} {set ::settings(water_volume) 10}
            if {$::settings(water_volume) > 250} {set ::settings(water_volume) 250}
        } else {
            set ::settings(water_temperature) [expr $::settings(water_temperature) + $value]
            if {$::settings(water_temperature) < 20} {set ::settings(water_temperature) 20}
            if {$::settings(water_temperature) > 110} {set ::settings(water_temperature) 110}
        }
        PD_save water
    }
    if {$var == "dose"} {
        set ::settings(grinder_dose_weight) [round_to_one_digits [expr $::settings(grinder_dose_weight) + $value]]
        PD_save settings
    }
    if {$var == "saw"} {
        set ::settings(final_desired_shot_weight_advanced) [round_to_integer [expr $::settings(final_desired_shot_weight_advanced) + $value]]
        PD_save settings
    }
    if {$var == "er"} {
        set y [round_to_one_digits [expr $::settings(final_desired_shot_weight_advanced) / $::settings(grinder_dose_weight)]]
        set new_y [expr $y + $value]
        set saw [expr $::settings(grinder_dose_weight) * $new_y]
        set ::settings(final_desired_shot_weight_advanced) [round_to_one_digits $saw]
        PD_save settings
    }
}

proc PD_adjust_water_toggle {} {
    if {$::PD_settings(water_dial) == "volume"} {
        set ::PD_settings(water_dial) "temperature"
    } else {
        set ::PD_settings(water_dial) "volume"
    }
     PD_save PD_settings
}

set ::de1(steam_disable_toggle) [expr {!$::settings(steam_disabled)}]
proc PD_steam_toggle {} {
    set ::settings(steam_disabled) [expr {!$::settings(steam_disabled)}]
    PD_clear_fav_colour
    PD_check_steam_off_button
    PD_save steam
}

proc PD_check_steam_off_button {} {
    if {$::settings(steam_disabled) == 1} {
        dui item config $::PD_home_pages PD_steam_off_button* -state normal
    } else {
        dui item config $::PD_home_pages PD_steam_off_button* -state hidden
    }
}
