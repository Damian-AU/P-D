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


proc PD_clear_message {} {
    set ::PD_message ""
    dui item config $::PD_home_pages PD_message_bg* -state hidden
    dui item config $::PD_home_pages PD_rhs_bg_cover -state hidden
    .can itemconfigure $::PD_home_espresso_graph_1 -state normal
}

proc PD_fav_instructions {} {
    set ::PD_message [translate "Hold the button for 2 seconds to save the current Profile, Beans in, Beverage out, Ratio, Flush, Steam and Water settings to the button "]
    dui item config $::PD_home_pages PD_message_bg* -state normal
    dui item config $::PD_home_pages PD_rhs_bg_cover -state normal
    .can itemconfigure $::PD_home_espresso_graph_1 -state hidden
}



proc PD_fav_save_message {} {
    PD_clear_message
    set ::PD_message [translate "FAVOURITE SAVED!"]
    dui item config $::PD_home_pages PD_saved_message_bg* -state normal
    dui item config $::PD_home_pages PD_rhs_bg_cover -state normal
    .can itemconfigure $::PD_home_espresso_graph_1 -state hidden
    after 3000 {
        set ::PD_message ""
        dui item config $::PD_home_pages PD_saved_message_bg* -state hidden
        dui item config $::PD_home_pages PD_rhs_bg_cover -state hidden
        .can itemconfigure $::PD_home_espresso_graph_1 -state normal
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
        #::plugins::D_Flow_Espresso_Profile::demo_graph
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
            set ::settings(steam_timeout) $::DSx_settings(steam_calc)
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