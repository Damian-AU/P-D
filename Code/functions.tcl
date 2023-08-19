proc PD_load_font {name fn pcsize {androidsize {}} } {
    if {$::android == 1} {
        set f 2.19
    } else {
        set f 2
    }
    if {($::android == 1 || $::undroid == 1) && $androidsize != ""} {
        set pcsize $androidsize
    }
    set platform_font_size [expr {int(1.0 * $::fontm * $pcsize * $f * 0.4)}]
    if {[info exists ::loaded_fonts] != 1} {
        set ::loaded_fonts list
    }
    set fontindex [lsearch $::loaded_fonts $fn]
    if {$fontindex != -1} {
        set familyname [lindex $::loaded_fonts [expr $fontindex + 1]]
    } elseif {($::android == 1 || $::undroid == 1) && $fn != ""} {
        catch {
            set familyname [lindex [sdltk addfont $fn] 0]
        }
        lappend ::loaded_fonts $fn $familyname
    }
    if {[info exists familyname] != 1 || $familyname == ""} {
        msg "Font familyname not available; using name '$name'."
        set familyname $name
    }
    catch {
        font create $name -family $familyname -size $platform_font_size
    }
    msg "added font name: \"$name\" family: \"$familyname\" size: $platform_font_size filename: \"$fn\""
}

proc PD_font {font_name size} {
    if {$font_name == "font"} {
        set font_name $::PD_settings(font_name)
    }
    if {$font_name == "font_bold"} {
        set font_name $::PD_settings(font_name_bold)
    }
    if {$font_name == "awesome"} {
        set font_name $::PD_settings(font_awesome)
    }
    if {$font_name == "awesome_light"} {
        set font_name $::PD_settings(font_awesome_light)
    }
    if {$font_name == "icons"} {
        set font_name $::PD_settings(icons)
    }

    if {[info exists ::skin_fonts] != 1} {
        set ::skin_fonts list
    }
    set font_key "$font_name $size PD"
    set font_index [lsearch $::skin_fonts $font_key]
    if {$font_index == -1} {
        # support for both OTF and TTF files
        if {[file exists "[skin_directory]/Fonts/$font_name.otf"] == 1} {
            PD_load_font $font_key "[skin_directory]/Fonts/$font_name.otf" $size
            lappend ::skin_fonts $font_key
        } elseif {[file exists "[skin_directory]/Fonts/$font_name.ttf"] == 1} {
            PD_load_font $font_key "[skin_directory]/Fonts/$font_name.ttf" $size
            lappend ::skin_fonts $font_key
        } else {
            msg "Unable to load font '$font_key'"
        }
    }
    return $font_key
}
set ::PD_profile_not_saved ""



proc PD_saw_switch {} {
    if {$::settings(settings_profile_type) == "settings_2c" || $::settings(settings_profile_type) == "settings_2c2"} {
        return $::settings(final_desired_shot_weight_advanced)
    } else {
        set ::settings(final_desired_shot_weight) $::settings(final_desired_shot_weight_advanced)
    }
}

proc PD_extraction_ratio {} {
    set y [round_to_one_digits [expr $::settings(final_desired_shot_weight_advanced) / $::settings(grinder_dose_weight)]]
    set d "1:"
    return $d$y
}

proc PD_steam_text {time} {
	if {$time == 0 || $::settings(steam_disabled) == 1} {
		return [translate "off"]
	} else {
		set t [round_to_integer $time]
		set s " "
		set u [translate "sec"]
		return $t$s$u
	}
}
proc PD_steam_text_s {time} {
	if {$time == 0 || $::settings(steam_disabled) == 1} {
		return [translate "off"]
	} else {
		set t [round_to_integer $time]
		set u [translate "s"]
		return $t$u
	}
}

proc PD_return_liquid_measurement {in} {
    if {$::de1(language_rtl) == 1} {
		return [subst {[translate "mL"] [round_to_integer $in] }]
    }

	if {$::settings(enable_fluid_ounces) != 1} {
		return [subst {[round_to_integer $in] [translate "mL"]}]
	} else {
		return [subst {[round_to_integer [ml_to_oz $in]] oz}]
	}
}

proc PD_return_weight_measurement {in} {
    if {$::de1(language_rtl) == 1} {
		return [subst {[translate "g"][round_to_one_digits $in]}]
    }

	if {$::settings(enable_fluid_ounces) != 1} {
		return [subst {[round_to_integer $in][translate "g"]}]
	} else {
		return [subst {[round_to_integer [ml_to_oz $in]] oz}]
	}
}


proc PD_water_dial_text {} {
    if {$::PD_settings(water_dial) == "temperature"} {
        if {$::settings(enable_fahrenheit) == 1} {
            set wt [round_to_integer [celsius_to_fahrenheit $::settings(water_temperature)]]\u00B0F
        } else {
            set wt [round_to_integer $::settings(water_temperature)]\u00B0C
        }
        return $wt
    } else {
        if {$::settings(scale_bluetooth_address) != ""} {
            set wv [PD_return_weight_measurement $::settings(water_volume)]
        } else {
            set wv [PD_return_liquid_measurement $::settings(water_volume)]
        }
        return $wv
    }
}

proc PD_water_button_text {} {
    set l [translate "Water"]
    set s " "
    if {$::PD_settings(water_dial) == "volume"} {
        if {$::settings(enable_fahrenheit) == 1} {
            set wt [round_to_integer [celsius_to_fahrenheit $::settings(water_temperature)]]\u00B0F
        } else {
            set wt [round_to_integer $::settings(water_temperature)]\u00B0C
        }
        return $l$s$wt
    } else {
        if {$::settings(scale_bluetooth_address) != ""} {
            set wv [PD_return_weight_measurement $::settings(water_volume)]
        } else {
            set wv [PD_return_liquid_measurement $::settings(water_volume)]
        }
        return $l$s$wv
    }
}
proc PD_water_button_text_2 {} {
    set s " "
    if {$::settings(enable_fahrenheit) == 1} {
        set wt [round_to_integer [celsius_to_fahrenheit $::settings(water_temperature)]]\u00B0F
    } else {
        set wt [round_to_integer $::settings(water_temperature)]\u00B0C
    }
    if {$::settings(scale_bluetooth_address) != ""} {
        set wv [PD_return_weight_measurement $::settings(water_volume)]
    } else {
        set wv [PD_return_liquid_measurement $::settings(water_volume)]
    }
    return $s$wt$s$s$wv
}

proc PD_clear_message {} {
    set ::PD_message ""
    set ::PD_message_fav_instructions ""
    dui item config $::PD_home_pages PD_message_bg* -state hidden
    dui item config $::PD_home_pages PD_rhs_bg_cover -state hidden
    .can itemconfigure $::PD_home_espresso_graph_1 -state normal
}

proc PD_fav_instructions {} {
    set ::PD_message_fav_instructions [translate "1. Make adjustments to your desired settings for the Shot."]\r\r[translate "2. Long press the button to save settings to, for 2 seconds."]\r\r[translate "3. You’ll get a confirmation message that the profile has been saved."]
    dui item config $::PD_home_pages PD_message_bg* -state normal
    dui item config $::PD_home_pages PD_rhs_bg_cover -state normal
    .can itemconfigure $::PD_home_espresso_graph_1 -state hidden
}

proc PD_clear_workflow {} {
    if {$::PD_workflow_settings == 1} {
        .can itemconfigure $::PD_home_espresso_graph_1 -state normal
        foreach curve {pressure flow weight temperature resistance steps} {
            dui item config $::PD_home_pages ${curve}_text -state normal
            dui item config $::PD_home_pages ${curve}_icon -state normal
        }
        dui item config $::PD_home_pages PD_workflow_return_button* -state hidden

        dui item config $::PD_home_pages PD_fav_workflow_bg* -state hidden
        dui item config $::PD_home_pages {PD_wf11* PD_wf12* PD_wf13* PD_wf14 PD_wf15* PD_wf16* PD_wf17*} -state hidden
        dui item config $::PD_home_pages {PD_wf21* PD_wf22* PD_wf23* PD_wf24 PD_wf25* PD_wf26*} -state hidden
        dui item config $::PD_home_pages {PD_wf31* PD_wf32* PD_wf33* PD_wf34 PD_wf35* PD_wf36*} -state hidden
        dui item config $::PD_home_pages {PD_wf41* PD_wf42* PD_wf43* PD_wf44 PD_wf45* PD_wf46*} -state hidden
        dui item config $::PD_home_pages {PD_wf51* PD_wf52* PD_wf53* PD_wf54 PD_wf55* PD_wf56*} -state hidden
        dui item config $::PD_home_pages {PD_wf61* PD_wf62* PD_wf63* PD_wf64 PD_wf65* PD_wf66*} -state hidden
        set ::PD_workflow_settings 0
        dui item config $::PD_home_pages PD_message_profile_button_block* -state hidden
    }
    after cancel {
        set ::PD_message ""
        set ::PD_message_fav_instructions ""_fav_instructions
        dui item config $::PD_home_pages PD_saved_message_bg* -state hidden
        dui item config $::PD_home_pages PD_rhs_bg_cover -state hidden
        .can itemconfigure $::PD_home_espresso_graph_1 -state normal
    }
}



set ::PD_fav_key ""
proc PD_fav_options {key} {
    if {$key == $::PD_settings(fav_default)} {
        set ::PD_auto [translate "Set as Auto"]
    }
    PD_clear_workflow
    PD_clear_message
    set ::PD_fav_key $key
    .can itemconfigure PD_fav_option_text_line_1 -state normal
    .can itemconfigure PD_fav_option_text_line_2 -state normal
    .can itemconfigure PD_fav_option_text_line_3 -state normal
    dui item config $::PD_home_pages PD_fav_option_left_cover* -state normal
    dui item config $::PD_home_pages PD_message_profile_button_block* -state normal
    dui item config $::PD_home_pages PD_fav_option_blue_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_green_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_orange_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_yellow_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_brown_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_pink_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_red_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_off_white_button* -state normal

    .can itemconfigure PD_fav_option_label_${key} -state normal
    dui item config $::PD_home_pages PD_fav_option_bg* -state normal
    dui item config $::PD_home_pages PD_rhs_bg_cover -state normal
    dui item config $::PD_home_pages PD_fav_option_use_profile_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_label_colour_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_label_cup_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_13_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_36_button* -state normal
    dui item config $::PD_home_pages PD_fav_option_default* -state normal
    .can itemconfigure $::PD_home_espresso_graph_1 -state hidden
    PD_clear_fav_colour
    PD_set_option_colour
}

proc PD_hide_fav_options {} {
    set ::PD_auto ""
    .can itemconfigure PD_fav_option_text_line_1 -state hidden
    .can itemconfigure PD_fav_option_text_line_2 -state hidden
    .can itemconfigure PD_fav_option_text_line_3 -state hidden
    dui item config $::PD_home_pages PD_fav_option_left_cover* -state hidden
    dui item config $::PD_home_pages PD_message_profile_button_block* -state hidden
    dui item config $::PD_home_pages PD_fav_option_blue_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_green_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_orange_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_yellow_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_brown_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_pink_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_red_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_off_white_button* -state hidden

    .can itemconfigure PD_fav_option_label_${::PD_fav_key} -state hidden
    dui item config $::PD_home_pages PD_fav_option_bg* -state hidden
    dui item config $::PD_home_pages PD_rhs_bg_cover -state hidden
    dui item config $::PD_home_pages PD_fav_option_use_profile_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_label_colour_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_label_cup_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_13_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_36_button* -state hidden
    dui item config $::PD_home_pages PD_fav_option_default* -state hidden
    .can itemconfigure $::PD_home_espresso_graph_1 -state normal
}

proc PD_set_option_colour {} {
    set key $::PD_fav_key
    set colour_name $::PD_settings(${::PD_fav_key}_colour_name)
    dui item config $::PD_home_pages PD_profile_name -fill $::PD_settings(${key}_colour)
    dui item config $::PD_home_pages PD_${key}_label -fill $::PD_settings(${key}_colour)

    #.can itemconfigure PD_${key}_button_on -outline $::PD_settings($colour)

    dui item config $::PD_home_pages PD_${key}_button_blue* -state hidden
    dui item config $::PD_home_pages PD_${key}_button_green* -state hidden
    dui item config $::PD_home_pages PD_${key}_button_orange* -state hidden
    dui item config $::PD_home_pages PD_${key}_button_yellow* -state hidden
    dui item config $::PD_home_pages PD_${key}_button_brown* -state hidden
    dui item config $::PD_home_pages PD_${key}_button_pink* -state hidden
    dui item config $::PD_home_pages PD_${key}_button_red* -state hidden
    dui item config $::PD_home_pages PD_${key}_button_off_white* -state hidden
    dui item config $::PD_home_pages PD_${key}_button_blue* -initial_state hidden
    dui item config $::PD_home_pages PD_${key}_button_green* -initial_state hidden
    dui item config $::PD_home_pages PD_${key}_button_orange* -initial_state hidden
    dui item config $::PD_home_pages PD_${key}_button_yellow* -initial_state hidden
    dui item config $::PD_home_pages PD_${key}_button_brown* -initial_state hidden
    dui item config $::PD_home_pages PD_${key}_button_pink* -initial_state hidden
    dui item config $::PD_home_pages PD_${key}_button_red* -initial_state hidden
    dui item config $::PD_home_pages PD_${key}_button_off_white* -initial_state hidden

    dui item config $::PD_home_pages PD_${key}_button_${colour_name}* -state normal
    dui item config $::PD_home_pages PD_${key}_button_${colour_name}* -initial_state normal
}

proc PD_fav_option_hide_13 {} {
    foreach key {fav1 fav2 fav3} {
        if {$::PD_settings(fav_hide_13) == 1} {
            dui item config $::PD_home_pages PD_${key}_label -state hidden
            dui item config $::PD_home_pages PD_${key}_cup -state hidden
            dui item config $::PD_home_pages PD_${key}_button* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_blue* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_green* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_orange* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_yellow* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_brown* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_pink* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_red* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_off_white* -state hidden
            dui item config $::PD_home_pages PD_${key}_label -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_cup -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_blue* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_green* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_orange* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_yellow* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_brown* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_pink* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_red* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_off_white* -initial_state hidden
            if {$::PD_settings(fav_hide_46) == 1} {
                set ::PD_settings(fav_hide_46) 0
                PD_fav_option_hide_46
            }
            if {$::PD_settings(fav_key) == "fav1" || $::PD_settings(fav_key) == "fav2" || $::PD_settings(fav_key) == "fav3"} {
                PD_clear_fav_colour
            }
        } else {
            if {$::PD_settings(fav_cup_labels) == 0} {
                dui item config $::PD_home_pages PD_${key}_label -state normal
                dui item config $::PD_home_pages PD_${key}_label -initial_state normal
            } else {
                dui item config $::PD_home_pages PD_${key}_cup -state normal
                dui item config $::PD_home_pages PD_${key}_cup -initial_state normal
            }
            dui item config $::PD_home_pages PD_${key}_button* -state normal
            dui item config $::PD_home_pages PD_${key}_button* -initial_state normal

            set key $::PD_settings(fav_key)
            set colour_name $::PD_settings(${key}_colour_name)
            dui item config $::PD_home_pages PD_${key}_button_${colour_name}* -state normal
            dui item config $::PD_home_pages PD_${key}_button_${colour_name}* -initial_state normal
        }
    }
}
proc PD_fav_option_hide_46 {} {

    foreach key {fav4 fav5 fav6} {
        if {$::PD_settings(fav_hide_46) == 1} {
            dui item config $::PD_home_pages PD_${key}_label -state hidden
            dui item config $::PD_home_pages PD_${key}_cup -state hidden
            dui item config $::PD_home_pages PD_${key}_button* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_blue* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_green* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_orange* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_yellow* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_brown* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_pink* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_red* -state hidden
            dui item config $::PD_home_pages PD_${key}_button_off_white* -state hidden
            dui item config $::PD_home_pages PD_${key}_label -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_cup -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_blue* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_green* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_orange* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_yellow* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_brown* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_pink* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_red* -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_button_off_white* -initial_state hidden
            if {$::PD_settings(fav_hide_13) == 1} {
                set ::PD_settings(fav_hide_13) 0
                PD_fav_option_hide_13
            }
            if {$::PD_settings(fav_key) == "fav4" || $::PD_settings(fav_key) == "fav5" || $::PD_settings(fav_key) == "fav6"} {
                PD_clear_fav_colour
            }
        } else {
            if {$::PD_settings(fav_cup_labels) == 0} {
                dui item config $::PD_home_pages PD_${key}_label -state normal
                dui item config $::PD_home_pages PD_${key}_label -initial_state normal
            } else {
                dui item config $::PD_home_pages PD_${key}_cup -state normal
                dui item config $::PD_home_pages PD_${key}_cup -initial_state normal
            }
            dui item config $::PD_home_pages PD_${key}_button* -state normal
            dui item config $::PD_home_pages PD_${key}_button* -initial_state normal

            set key $::PD_settings(fav_key)
            set colour_name $::PD_settings(${key}_colour_name)
            dui item config $::PD_home_pages PD_${key}_button_${colour_name}* -state normal
            dui item config $::PD_home_pages PD_${key}_button_${colour_name}* -initial_state normal

        }
    }
}

proc PD_set_fav_label_colour {} {
    foreach key {fav1 fav2 fav3 fav4 fav5 fav6} {
        if {$::PD_settings(fav_colour_labels) == 1} {
            dui item config $::PD_home_pages PD_${key}_label -fill $::PD_settings(${key}_colour)
            dui item config $::PD_home_pages PD_${key}_cup -fill $::PD_settings(${key}_colour)
        } else {
            dui item config $::PD_home_pages PD_${key}_label -fill $::PD_settings(off_white)
            dui item config $::PD_home_pages PD_${key}_cup -fill $::PD_settings(off_white)
        }
    }
}
proc PD_set_fav_label_cup {} {
    foreach key {fav1 fav2 fav3 fav4 fav5 fav6} {
        if {$::PD_settings(fav_cup_labels) == 1} {
            dui item config $::PD_home_pages PD_${key}_label -state hidden
            dui item config $::PD_home_pages PD_${key}_label -initial_state hidden
            dui item config $::PD_home_pages PD_${key}_cup -state normal
            dui item config $::PD_home_pages PD_${key}_cup -initial_state normal
        } else {
            dui item config $::PD_home_pages PD_${key}_label -state normal
            dui item config $::PD_home_pages PD_${key}_label -initial_state normal
            dui item config $::PD_home_pages PD_${key}_cup -state hidden
            dui item config $::PD_home_pages PD_${key}_cup -initial_state hidden
        }
    }
}

proc PD_load_default_fav {} {
    PD_clear_fav_colour
    if {($::PD_settings(fav_default) == "fav1" || $::PD_settings(fav_default) == "fav2" || $::PD_settings(fav_default) == "fav3") && $::PD_settings(fav_hide_13) == 0} {
        PD_load $::PD_settings(fav_default)
    }
    if {($::PD_settings(fav_default) == "fav4" || $::PD_settings(fav_default) == "fav5" || $::PD_settings(fav_default) == "fav6") && $::PD_settings(fav_hide_46) == 0} {
        PD_load $::PD_settings(fav_default)
    }
}

proc PD_fav_save_message {} {
    PD_clear_message
    set ::PD_message [translate "FAVOURITE SAVED!"]
    dui item config $::PD_home_pages PD_message_button_block* -state normal
    dui item config $::PD_home_pages PD_saved_message_bg* -state normal
    dui item config $::PD_home_pages PD_rhs_bg_cover -state normal
    .can itemconfigure $::PD_home_espresso_graph_1 -state hidden
    after 2000 {
        set ::PD_message ""
        dui item config $::PD_home_pages PD_message_button_block* -state hidden
        dui item config $::PD_home_pages PD_saved_message_bg* -state hidden
        dui item config $::PD_home_pages PD_rhs_bg_cover -state hidden
        .can itemconfigure $::PD_home_espresso_graph_1 -state normal
    }
}

proc PD_setting_updated_message {} {
    PD_clear_message
    set ::PD_message [translate "SETTING UPDATED!"]
    dui item config $::PD_home_pages PD_message_button_block* -state normal
    dui item config $::PD_home_pages PD_saved_message_bg* -state normal
    dui item config $::PD_home_pages PD_rhs_bg_cover -state normal
    .can itemconfigure $::PD_home_espresso_graph_1 -state hidden
    after 2000 {
        set ::PD_message ""
        dui item config $::PD_home_pages PD_message_button_block* -state hidden
        dui item config $::PD_home_pages PD_saved_message_bg* -state hidden
        dui item config $::PD_home_pages PD_rhs_bg_cover -state hidden
        .can itemconfigure $::PD_home_espresso_graph_1 -state normal
    }
}


proc PD_edit_heading {} {
    .can itemconfigure PD_heading_text_line_1 -state normal
    .can itemconfigure PD_heading_text_line_2 -state normal
    dui item config $::PD_home_pages PD_heading_editor_exit_button* -state normal

    .can itemconfigure PD_heading_entry -state normal
    dui item config $::PD_home_pages PD_fav_option_bg* -state normal
    dui item config $::PD_home_pages PD_rhs_bg_cover -state normal

    .can itemconfigure $::PD_home_espresso_graph_1 -state hidden

    dui item config $::PD_home_pages PD_heading_blue_button* -state normal
    dui item config $::PD_home_pages PD_heading_green_button* -state normal
    dui item config $::PD_home_pages PD_heading_orange_button* -state normal
    dui item config $::PD_home_pages PD_heading_yellow_button* -state normal
    dui item config $::PD_home_pages PD_heading_brown_button* -state normal
    dui item config $::PD_home_pages PD_heading_pink_button* -state normal
    dui item config $::PD_home_pages PD_heading_red_button* -state normal
    dui item config $::PD_home_pages PD_heading_off_white_button* -state normal

}

proc PD_hide_heading_editor {} {
    .can itemconfigure PD_heading_text_line_1 -state hidden
    .can itemconfigure PD_heading_text_line_2 -state hidden
    dui item config $::PD_home_pages PD_heading_editor_exit_button* -state hidden

    .can itemconfigure PD_heading_entry -state hidden
    dui item config $::PD_home_pages PD_fav_option_bg* -state hidden
    dui item config $::PD_home_pages PD_rhs_bg_cover -state hidden

    .can itemconfigure $::PD_home_espresso_graph_1 -state normal

    dui item config $::PD_home_pages PD_heading_blue_button* -state hidden
    dui item config $::PD_home_pages PD_heading_green_button* -state hidden
    dui item config $::PD_home_pages PD_heading_orange_button* -state hidden
    dui item config $::PD_home_pages PD_heading_yellow_button* -state hidden
    dui item config $::PD_home_pages PD_heading_brown_button* -state hidden
    dui item config $::PD_home_pages PD_heading_pink_button* -state hidden
    dui item config $::PD_home_pages PD_heading_red_button* -state hidden
    dui item config $::PD_home_pages PD_heading_off_white_button* -state hidden
}

proc PD_flush_timer {} {
    set t [round_to_integer [expr {$::settings(flush_seconds) - [flush_pour_timer]}]]
    set s s
    if {$t < 0} {
        return 0s
    } else {
        return $t$s
    }
}

proc PD_steam_timer {} {
    set t [round_to_integer [expr {$::settings(steam_timeout) - [steam_pour_timer]}]]
    set s s
    if {$t < 0} {
        return 0s
    } else {
        return $t$s
    }
}

proc PD_water_timer {} {
    set t [round_to_integer [expr {$::settings(water_timeout) - [water_pour_timer]}]]
    set s s
    if {$t < 0} {
        return 0s
    } else {
        return $t$s
    }
}

proc PD_temperature_units {in} {
	if {$::settings(enable_fahrenheit) == 1} {
		return [round_to_two_digits [expr {[celsius_to_fahrenheit $in] * 0.05}]]
	} else {
		return [round_to_two_digits [expr {$in * 0.1}]]
	}
}

proc PD_goto_profile_wizard {} {
    set title_test [string range [ifexists ::settings(profile_title)] 0 7]
    if {$title_test == "D-Flow /" } {
        ::plugins::D_Flow_Espresso_Profile::prep
        ::plugins::D_Flow_Espresso_Profile::demo_graph
        dui page load Dflowset
        } else {
        after 500 update_de1_explanation_chart
        set_next_page off $::settings(settings_profile_type)
        page_show off
        set ::settings(active_settings_tab) $::settings(settings_profile_type)
        fill_advanced_profile_steps_listbox
        set_advsteps_scrollbar_dimensions
    }
}

proc PD_jug_toggle {} {
    PD_clear_fav_colour
    if {$::PD_settings(jug_size) == "S"} {
        if {$::PD_settings(jug_m) > 0} {
            set ::PD_settings(jug_size) M
            set ::PD_settings(jug_g) $::PD_settings(jug_m)
        } elseif {$::PD_settings(jug_l) > 0} {
            set ::PD_settings(jug_size) L
            set ::PD_settings(jug_g) $::PD_settings(jug_l)
        }
    } elseif {$::PD_settings(jug_size) == "M"} {
        if {$::PD_settings(jug_l) > 0} {
            set ::PD_settings(jug_size) L
            set ::PD_settings(jug_g) $::PD_settings(jug_l)
        } elseif {$::PD_settings(jug_s) > 0} {
            set ::PD_settings(jug_size) S
            set ::PD_settings(jug_g) $::PD_settings(jug_s)
        }
    } elseif {$::PD_settings(jug_size) == "L"} {
        set ::PD_settings(jug_size) "none"
        set ::PD_settings(jug_g) 0
    } elseif {$::PD_settings(jug_size) == "none"} {
        if {$::PD_settings(jug_s) > 0} {
            set ::PD_settings(jug_size) S
            set ::PD_settings(jug_g) $::PD_settings(jug_s)
        } elseif {$::PD_settings(jug_m) > 0} {
            set ::PD_settings(jug_size) M
            set ::PD_settings(jug_g) $::PD_settings(jug_m)
        }
    } else {
        page_show PD_steam_setup
    }
    #set ::settings(PD_jug_size) $::PD_settings(jug_size)
    #PD_save PD_settings
}

proc PD_jug_label {} {
    if {$::PD_settings(jug_size) == "S"} {
        return [translate "small"]
    }
    if {$::PD_settings(jug_size) == "M"} {
        return [translate "medium"]
    }
    if {$::PD_settings(jug_size) == "L"} {
        return [translate "large"]
    }
    if {$::PD_settings(jug_size) == "none"} {
        return ""
    }
}
proc PD_jug_letter {} {
    if {$::PD_settings(jug_size) == "S"} {
        return [translate "S"]
    }
    if {$::PD_settings(jug_size) == "M"} {
        return [translate "M"]
    }
    if {$::PD_settings(jug_size) == "L"} {
        return [translate "L"]
    }
    if {$::PD_settings(jug_size) == "none"} {
        return ""
    }
}

set ::PD_blink2 1
proc PD_low_water {} {
    if {[expr $::de1(water_level) < {$::settings(water_refill_point) + 3}]} {
        if {$::PDx_blink2 == 1} {
                after 400 {set ::PDx_blink2 0}
                return ""
            } else {
                set ::PDx_blink2 1
                return "[water_tank_level_to_milliliters $::de1(water_level)] [translate mL]"
            }
	    }
	return "[water_tank_level_to_milliliters $::de1(water_level)][translate mL] "
}

proc PD_steamtemp_text {} {
	return [return_steam_temperature_measurement [steam_heater_temperature]]
}

proc PD_group_head_heater_temperature_text {} {
	return [return_steam_temperature_measurement [group_head_heater_temperature]]
}

proc PD_live_graph_shot_time {} {
    if {$::de1_num_state($::de1(state)) == "Espresso"} {
        return [espresso_elapsed_timer]
    } else {
        return $::PD_graphs(live_graph_shot_time)s
    }
}

proc PD_live_graph_pour_time {} {
    if {$::de1_num_state($::de1(state)) == "Espresso"} {
        return [espresso_pour_timer]
    } else {
        return $::PD_graphs(live_graph_pour_time)s
    }
}

proc PD_live_graph_pi_time {} {
    if {$::de1_num_state($::de1(state)) == "Espresso"} {
        return [espresso_preinfusion_timer]
    } else {
        return $::PD_graphs(live_graph_pi_time)s
    }
}

set ::PD_blink 1
proc PD_scale_disconnected {} {
	if {$::android == 1 && [ifexists ::settings(scale_bluetooth_address)] == ""} {
		#return ""
	}
	if {$::de1(scale_device_handle) == "0" && $::android == 1} {
		if {$::PD_blink == 1} {
		    after 300 {set ::PD_blink 0}
		    return [translate "reconnect"]
		} else {
		    set ::PD_blink 1
		    return ""
		}
	}
	return [translate "Scale Connected"]
}


proc PD_set_dose {} {
    if {$::de1(scale_sensor_weight) > 5} {
        set ::settings(grinder_dose_weight) $::de1(scale_sensor_weight)
        PD_save settings
    }
}


proc PD_steam_time_calc {} {
    if {$::PD_settings(jug_g) == {} || $::PD_settings(jug_g) < 2 || $::PD_settings(milk_g) < 2 || $::PD_settings(milk_g) == {} || $::PD_settings(milk_s) < 2 || $::PD_settings(milk_s) == {}} {
        page_show weight2steam
    } else {
        set t [expr {$::PD_settings(milk_s)*1000}]
        set m $::PD_settings(milk_g)
        set j $::PD_settings(jug_g)
        set s $::de1(scale_sensor_weight)
        set a [expr {($t/$m*($s-$j))/1000}]
        set ::PD_settings(steam_calc) [round_to_integer $a]
        if {[expr ($::PD_settings(steam_calc) > 0)]} {
            if {$::settings(steam_disabled) == 1} {
                set ::settings(steam_disabled) 0
            }
            set ::settings(steam_timeout) $::PD_settings(steam_calc)
            save_settings
            de1_send_steam_hotwater_settings
        }
    }
}




proc set_jug_s {} {
    set ::PD_settings(jug_s) [round_to_one_digits $::de1(scale_sensor_weight)]
    if {$::PD_settings(jug_s) > 20} {
        set ::PD_settings(jug_size) S
        set ::PD_settings(jug_g) $::PD_settings(jug_s)
    }
    PD_save PD_settings
}
proc clear_jug_s {} {
    set ::PD_settings(jug_s) 0
}
proc set_jug_m {} {
    set ::PD_settings(jug_m) [round_to_one_digits $::de1(scale_sensor_weight)]
    if {$::PD_settings(jug_s) > 20} {
        set ::PD_settings(jug_size) M
        set ::PD_settings(jug_g) $::PD_settings(jug_m)
    }
}
proc clear_jug_m {} {
    set ::PD_settings(jug_m) 0
}
proc set_jug_l {} {
    set ::PD_settings(jug_l) [round_to_one_digits $::de1(scale_sensor_weight)]
    if {$::PD_settings(jug_s) > 20} {
        set ::PD_settings(jug_size) L
        set ::PD_settings(jug_g) $::PD_settings(jug_l)
    }
}
proc clear_jug_l {} {
    set ::PD_settings(jug_l) 0
}
proc jug_s_cal_text {} {
    if {$::PD_settings(pre_tare) == 1} {
        return "off"
    } elseif {$::PD_settings(jug_s) > 0} {
        return "[round_to_integer $::PD_settings(jug_s)]g"
    } else {
        return "off"
    }
}
proc jug_m_cal_text {} {
    if {$::PD_settings(pre_tare) == 1} {
        return "off"
    } elseif {$::PD_settings(jug_m) > 0} {
        return "[round_to_integer $::PD_settings(jug_m)]g"
    } else {
        return "off"
    }
}
proc jug_l_cal_text {} {
    if {$::PD_settings(pre_tare) == 1} {
        return "off"
    } elseif {$::PD_settings(jug_l) > 0} {
        return "[round_to_integer $::PD_settings(jug_l)]g"
    } else {
        return "off"
    }
}

proc PD_milk_weight {} {
    if {[expr ($::de1(scale_sensor_weight) > $::PD_settings(jug_g))] && $::PD_settings(jug_g) > 20} {
        set in [expr ($::de1(scale_sensor_weight) - $::PD_settings(jug_g))]
        set g g
        set x 0
        catch {
            set x [expr {round($in)}]
        }
        return $x$g
    } else {
        return ""
    }
}


set ::PD_sleep_timer_start 0
set ::PD_sleep_countdown 0
set ::PD_sleep_timer_on 0

proc PD_power {} {
    set_next_page off power;
    set ::PD_sleep_timer_start [expr [clock seconds] + 5]
    set ::PD_sleep_timer_on 1
    PD_power_off_timer
    page_show PD_power;
}

proc PD_power_off_timer {} {
    set ::PD_sleep_countdown [expr $::PD_sleep_timer_start - [clock seconds]]
    if {$::PD_sleep_countdown < 0} {
        set ::PD_sleep_countdown 0
    }
    if {$::PD_sleep_timer_on == 1} {
        if {$::PD_sleep_countdown == 0} {
            set ::PD_sleep_timer_on 0
            set_next_page off off
            set ::current_espresso_page "off"
            start_sleep
        }
    }

    return $::PD_sleep_countdown
}
proc PD_exit {} {
    app_exit
}
proc PD_sleep {} {
    set ::PD_sleep_timer_start 0
}

proc PD_skip_to_next_step {} {
    de1_send_state "skip to next" $::de1_state(SkipToNext)
}






proc PD_day {} {
    if {$::PD_settings(clock_hide) != 1} {
        #set a [clock format [clock seconds] -format "%a, %d %b"]
        set a [clock format [clock seconds] -format "%a"]
        } else {
        set a ""
    }
    return $a
}

proc PD_date {} {
    if {$::PD_settings(clock_hide) != 1} {
        #set a [clock format [clock seconds] -format "%a, %d %b"]
        set a [clock format [clock seconds] -format "%d"]
        } else {
        set a ""
    }
    return $a
}


proc PD_clock {} {
    if {$::PD_settings(clock_hide) != 1} {
        if {$::settings(enable_ampm) == 0} {
            set a [clock format [clock seconds] -format "%H"]
            set b [clock format [clock seconds] -format ":%M"]
            set c $a
            } else {
            set a [clock format [clock seconds] -format "%I"]
            set b [clock format [clock seconds] -format ":%M"]
            set c $a
            regsub {^[0]} $c {\1} c
            }
        } else {
        set c ""
        set b ""
    }
    return $c$b
}

proc PD_clock_ap {} {
    if {$::PD_settings(clock_hide) != 1 && $::settings(enable_ampm) == 1} {
        set a [clock format [clock seconds] -format %P]
        } else {
        set a ""
    }
    return $a
}

proc PD_clock_s {} {
    if {$::PD_settings(clock_hide) != 1} {
        set a [clock format [clock seconds] -format %S]
    } else {
        set a ""
    }
    return $a
}

set ::PD_heating 1
proc PD_start_button_ready {} {
	set num $::de1(substate)
	set substate_txt $::de1_substate_types($num)
    if {[info exists ::de1(in_eco_steam_mode)] == 1} {
        if {$substate_txt == "ready" && $::de1(in_eco_steam_mode) == 1} {
            set ::PD_heating 0
            return [translate "READY"]
        }
    }
	if {$substate_txt == "ready" && $::de1(device_handle) != 0} {
		if {$::settings(steam_timeout) > 0 && [steamtemp] > [expr {$::settings(steam_temperature) - 11}]} {
		    set ::PD_heating 0
		    return [translate "READY"]
		} elseif {$::settings(steam_timeout) == 0} {
		    set ::PD_heating 0
		    return [translate "READY"]
		}
	}
	set ::PD_heating 1
	return [translate "WAIT"]
}


