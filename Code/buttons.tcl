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

proc PD_steam_on {} {
    if {$::settings(steam_disabled) == 1} {
        PD_steam_toggle
    }
}

proc PD_check_steam_off_button {} {
    if {$::settings(steam_disabled) == 1} {
        dui item config $::PD_home_pages PD_steam_off_button* -state normal
    } else {
        dui item config $::PD_home_pages PD_steam_off_button* -state hidden
    }
}

proc PD_toggle_workflow {item} {
    if {$::PD_settings(${item}_state) == $::PD_settings(icon_tick)} {
        set ::PD_settings(${item}_state) $::PD_settings(icon_x)
    } else {
        set ::PD_settings(${item}_state) $::PD_settings(icon_tick)
    }
}

set ::PD_workflow_settings 0
proc PD_toggle_workflow_settings {} {
    if {$::PD_workflow_settings == 0} {
        .can itemconfigure $::PD_home_espresso_graph_1 -state hidden
        dui item config $::PD_home_pages PD_workflow_return_button* -state normal
        dui item config $::PD_home_pages PD_rhs_bg_cover -state normal
        dui item config $::PD_home_pages PD_message_profile_button_block -state normal
        dui item config $::PD_home_pages PD_fav_workflow_bg* -state normal
        foreach curve {pressure flow weight temperature resistance steps} {
            dui item config $::PD_home_pages ${curve}_text -state hidden
            dui item config $::PD_home_pages ${curve}_icon -state hidden
        }
        dui item config $::PD_home_pages {PD_wf11* PD_wf12* PD_wf13* PD_wf14 PD_wf15* PD_wf16* PD_wf17*} -state normal
        dui item config $::PD_home_pages {PD_wf21* PD_wf22* PD_wf23* PD_wf24 PD_wf25* PD_wf26*} -state normal
        dui item config $::PD_home_pages {PD_wf31* PD_wf32* PD_wf33* PD_wf34 PD_wf35* PD_wf36*} -state normal
        dui item config $::PD_home_pages {PD_wf41* PD_wf42* PD_wf43* PD_wf44 PD_wf45* PD_wf46*} -state normal
        dui item config $::PD_home_pages {PD_wf51* PD_wf52* PD_wf53* PD_wf54 PD_wf55* PD_wf56*} -state normal
        dui item config $::PD_home_pages {PD_wf61* PD_wf62* PD_wf63* PD_wf64 PD_wf65* PD_wf66*} -state normal
        set ::PD_workflow_settings 1
    } else {
        .can itemconfigure $::PD_home_espresso_graph_1 -state normal
        dui item config $::PD_home_pages PD_workflow_return_button* -state hidden
        dui item config $::PD_home_pages PD_rhs_bg_cover -state hidden
        dui item config $::PD_home_pages PD_message_profile_button_block -state hidden
        dui item config $::PD_home_pages PD_fav_workflow_bg* -state hidden
        foreach curve {pressure flow weight temperature resistance steps} {
            dui item config $::PD_home_pages ${curve}_text -state normal
            dui item config $::PD_home_pages ${curve}_icon -state normal
        }
        dui item config $::PD_home_pages {PD_wf11* PD_wf12* PD_wf13* PD_wf14 PD_wf15* PD_wf16* PD_wf17*} -state hidden
        dui item config $::PD_home_pages {PD_wf21* PD_wf22* PD_wf23* PD_wf24 PD_wf25* PD_wf26*} -state hidden
        dui item config $::PD_home_pages {PD_wf31* PD_wf32* PD_wf33* PD_wf34 PD_wf35* PD_wf36*} -state hidden
        dui item config $::PD_home_pages {PD_wf41* PD_wf42* PD_wf43* PD_wf44 PD_wf45* PD_wf46*} -state hidden
        dui item config $::PD_home_pages {PD_wf51* PD_wf52* PD_wf53* PD_wf54 PD_wf55* PD_wf56*} -state hidden
        dui item config $::PD_home_pages {PD_wf61* PD_wf62* PD_wf63* PD_wf64 PD_wf65* PD_wf66*} -state hidden
        set ::PD_workflow_settings 0
    }
}