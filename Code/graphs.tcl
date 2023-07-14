add_de1_variable "off espresso" 0 2000 -font [PD_font font 6] -fill #000 -textvariable {
    [pressure_text]
    [waterflow_text]
    [waterweight_text]
    [waterweightflow_text]
    [watervolume_text]
    [watertemp_text]
    [mixtemp_text]
    [steamtemp_text]
    [group_head_heater_temperature_text]
    [espresso_goal_temp_text]
    [pour_volume]
    [preinfusion_volume]
    [profile_type_text]
}

blt::vector create PD_espresso_temperature_basket PD_espresso_temperature_mix PD_espresso_temperature_goal
blt::vector create PD_pressure_goal PD_flow_goal PD_temperature_goal PD_pressure PD_flow PD_weight PD_temperature PD_resistance


proc PD_live_graph_list {} {
	return [list PD_espresso_temperature_basket PD_espresso_temperature_mix PD_espresso_temperature_goal espresso_elapsed espresso_pressure espresso_weight espresso_weight_chartable espresso_flow espresso_flow_weight espresso_flow_weight_raw espresso_water_dispensed espresso_flow_weight_2x espresso_flow_2x espresso_resistance espresso_resistance_weight espresso_pressure_delta espresso_flow_delta espresso_flow_delta_negative espresso_flow_delta_negative_2x espresso_temperature_mix espresso_temperature_basket espresso_state_change espresso_pressure_goal espresso_flow_goal espresso_flow_goal_2x espresso_temperature_goal espresso_de1_explanation_chart_flow espresso_de1_explanation_chart_elapsed_flow espresso_de1_explanation_chart_flow_2x espresso_de1_explanation_chart_flow_1_2x espresso_de1_explanation_chart_flow_2_2x espresso_de1_explanation_chart_flow_3_2x espresso_de1_explanation_chart_pressure espresso_de1_explanation_chart_temperature espresso_de1_explanation_chart_temperature_10 espresso_de1_explanation_chart_pressure_1 espresso_de1_explanation_chart_pressure_2 espresso_de1_explanation_chart_pressure_3 espresso_de1_explanation_chart_elapsed_flow espresso_de1_explanation_chart_elapsed_flow_1 espresso_de1_explanation_chart_elapsed_flow_2 espresso_de1_explanation_chart_elapsed_flow_3 espresso_de1_explanation_chart_elapsed espresso_de1_explanation_chart_elapsed_1 espresso_de1_explanation_chart_elapsed_2 espresso_de1_explanation_chart_elapsed_3]
}

proc PD_backup_live_graph {} {
	foreach lg [PD_live_graph_list] {
	unset -nocomplain ::PD_settings(live_graph_$lg)
		if {[$lg length] > 0} {
			set ::PD_graphs(live_graph_$lg) [$lg range 0 end]
			set ::PD_graphs(live_graph_profile) $::settings(profile_title)
		    set ::PD_graphs(live_graph_time) $::settings(espresso_clock)
		    set ::PD_graphs(live_graph_beans) $::settings(grinder_dose_weight)
		    set ::PD_graphs(live_graph_weight) $::settings(drink_weight)
		    set ::PD_graphs(live_graph_pi_water) [round_to_integer $::de1(preinfusion_volume)]
		    set ::PD_graphs(live_graph_pour_water) [round_to_integer $::de1(pour_volume)]
		    set ::PD_graphs(live_graph_water) [expr {[round_to_integer $::de1(preinfusion_volume)] + [round_to_integer $::de1(pour_volume)]}]
		    set ::PD_graphs(live_graph_pi_time) [espresso_preinfusion_timer]
		    set ::PD_graphs(live_graph_pour_time) [espresso_pour_timer]
		    set ::PD_graphs(live_graph_shot_time) [espresso_elapsed_timer]
		} else {
			set ::PD_graphs(live_graph_$lg) {}
		}
	}

	PD_save PD_graphs
}

::de1::event::listener::after_flow_complete_add [lambda {event_dict} {
    if { [dict get $event_dict previous_state] == "Espresso" } {
        PD_backup_live_graph
    }
}]



proc PD_restore_live_graphs {} {
	set last_elapsed_time_index [expr {[espresso_elapsed length] - 1}]
	if {$last_elapsed_time_index > 1} {
	    return
	}
	foreach lg [PD_live_graph_list] {
		$lg length 0
		if {[info exists ::PD_graphs(live_graph_$lg)] == 1} {
			$lg append $::PD_graphs(live_graph_$lg)
		}
	}
}

proc PD_restore_graphs {} {
    after 1 {PD_restore_live_graphs}
}



set {} {
proc PD_steam_graph_list {} {
	return [list steam_elapsed steam_temperature steam_flow steam_pressure]
}

proc PD_backup_steam_graph {} {
	foreach sg [PD_steam_graph_list] {
	unset -nocomplain ::PD_graphs(steam_graph_$sg)
		if {[$sg length] > 0} {
			set ::PD_graphs(steam_graph_$sg) [$sg range 0 end]
		} else {
			set ::PD_graphs(steam_graph_$sg) {}
		}
	}
    PD_save PD_graphs
}

::de1::event::listener::on_major_state_change_add [lambda {event_dict} {
    if { [dict get $event_dict previous_state] == "Steam" } {
        PD_backup_steam_graph
    }
}]
proc PD_restore_steam_graph {} {
	set last_elapsed_time_index [expr {[espresso_elapsed length] - 1}]
	foreach sg [PD_steam_graph_list] {
		$sg length 0
		if {[info exists ::PD_settings(steam_graph_$sg)] == 1} {
			$sg append $::PD_settings(steam_graph_$sg)
		}

	}
}

proc PD_restore_graphs {} {
    after 1 {PD_restore_live_graphs; PD_restore_steam_graph}
}

}


proc clear_temp_data {args} {
	PD_espresso_temperature_basket length 0
    PD_espresso_temperature_basket append [PD_temperature_units $::settings(espresso_temperature)]
    PD_espresso_temperature_mix length 0
    PD_espresso_temperature_mix append [PD_temperature_units $::settings(espresso_temperature)]
    PD_espresso_temperature_goal length 0
    PD_espresso_temperature_goal append [PD_temperature_units $::settings(espresso_temperature)]
}

## probably don't need this  or rename ::clear_espresso_chart##
rename start_espresso_timers start_espresso_timers_orig
proc start_espresso_timers {} {
    clear_temp_data
    start_espresso_timers_orig
}
##
rename ::clear_espresso_chart ::skin::PD::clear_espresso_chart_orig
proc ::clear_espresso_chart {args} {
	clear_temp_data
	::skin::PD::clear_espresso_chart_orig {*}$args
}

rename ::gui::update::append_live_data_to_espresso_chart \
    ::skin::PD::append_live_data_to_espresso_chart_orig

proc ::gui::update::append_live_data_to_espresso_chart {event_dict args} {

    if { ! [::de1::state::is_flow_state \
            [dict get $event_dict this_state] \
            [dict get $event_dict this_substate]] } { return }

    ::skin::PD::append_live_data_to_espresso_chart_orig $event_dict {*}$args

    dict with event_dict {

        # PD chooses p/f, rather than p/(f^2)

        set ::espresso_resistance(end) \
            [round_to_two_digits \
                 [expr { $GroupFlow > 0 &&  $GroupPressure > 0 ? \
                         (1/$GroupFlow)*($GroupPressure) : 0 }]]

        PD_espresso_temperature_basket append \
            [PD_temperature_units $HeadTemp]

        PD_espresso_temperature_goal append \
            [PD_temperature_units $SetHeadTemp]

        PD_espresso_temperature_mix append \
            [PD_temperature_units $MixTemp]
    }
}



proc PD_toggle_graph {curve} {
    if {$::PD_settings($curve) > 0} {
        set ::PD_settings($curve) 0
        if {$curve == "pressure" || $curve == "temperature" || $curve == "flow"} {
            $::PD_home_espresso_graph_1 element configure home_${curve}_goal -linewidth 0
            $::PD_espresso_zoomed_graph element configure home_${curve}_goal -linewidth 0
        }
        $::PD_home_espresso_graph_1 element configure home_${curve} -linewidth 0
        $::PD_espresso_zoomed_graph element configure home_${curve} -linewidth 0
        dui item config $::PD_home_pages ${curve}_text -fill $::PD_settings(light_grey)
        dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(light_grey) -outline $::PD_settings(light_grey)
        dui item config "off_zoomed espresso_zoomed" ${curve}_text -fill $::PD_settings(light_grey)
        dui item config "off_zoomed espresso_zoomed" ${curve}_icon -fill $::PD_settings(light_grey) -outline $::PD_settings(light_grey)
    } else {
        set ::PD_settings($curve) 1
        if {$curve == "pressure" || $curve == "temperature" || $curve == "flow"} {
            $::PD_home_espresso_graph_1 element configure home_${curve}_goal -linewidth [rescale_x_skin 4]
            $::PD_espresso_zoomed_graph element configure home_${curve}_goal -linewidth [rescale_x_skin 4]
        }
        $::PD_home_espresso_graph_1 element configure home_${curve} -linewidth [rescale_x_skin 6]
        $::PD_espresso_zoomed_graph element configure home_${curve} -linewidth [rescale_x_skin 6]
        dui item config $::PD_home_pages ${curve}_text -fill $::PD_settings(off_white)
        dui item config "off_zoomed espresso_zoomed" ${curve}_text -fill $::PD_settings(off_white)
        if {$curve == "pressure"} {
            dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(green) -outline $::PD_settings(green)
            dui item config "off_zoomed espresso_zoomed" ${curve}_icon -fill $::PD_settings(green) -outline $::PD_settings(green)
        }
        if {$curve == "temperature"} {
            dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(red) -outline $::PD_settings(red)
            dui item config "off_zoomed espresso_zoomed" ${curve}_icon -fill $::PD_settings(red) -outline $::PD_settings(red)
        }
        if {$curve == "flow"} {
            dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(blue) -outline $::PD_settings(blue)
            dui item config "off_zoomed espresso_zoomed" ${curve}_icon -fill $::PD_settings(blue) -outline $::PD_settings(blue)
        }
        if {$curve == "weight"} {
            dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(brown) -outline $::PD_settings(brown)
            dui item config "off_zoomed espresso_zoomed" ${curve}_icon -fill $::PD_settings(brown) -outline $::PD_settings(brown)
        }
        if {$curve == "resistance"} {
            dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(yellow) -outline $::PD_settings(yellow)
            dui item config "off_zoomed espresso_zoomed" ${curve}_icon -fill $::PD_settings(yellow) -outline $::PD_settings(yellow)
        }

    }
}








### Graph zoom and pan
proc PD_reset_graphs {} {
    set ::PDv 0;
    set ::PD_settings(zoomed_y_axis_max) $::PD_settings(zoomed_y_axis_scale_default);
    set ::PD_settings(zoomed_y_axis_min) 0
    set ::PD_settings(zoomed_y2_axis_max) [expr {$::PD_settings(zoomed_y_axis_max)*0.5}]
    set ::PD_settings(zoomed_y2_axis_min) [expr {$::PD_settings(zoomed_y_axis_min)*0.5}]
    $::PD_espresso_zoomed_graph axis configure y -color #008c4c -max $::PD_settings(zoomed_y_axis_max) -min $::PD_settings(zoomed_y_axis_min) -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
    $::PD_espresso_zoomed_graph axis configure y2 -max $::PD_settings(zoomed_y2_axis_max) -min $::PD_settings(zoomed_y2_axis_min) -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8}
    #$::PD_history_left_graph axis configure y -max $::PD_settings(zoomed_y_axis_max) -min $::PD_settings(zoomed_y_axis_min) -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
    #$::PD_history_left_graph axis configure y2 -max $::PD_settings(zoomed_y2_axis_max) -min $::PD_settings(zoomed_y2_axis_min) -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8}
    #$::PD_history_right_graph axis configure y -max $::PD_settings(zoomed_y_axis_max) -min $::PD_settings(zoomed_y_axis_min) -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
    #$::PD_history_right_graph axis configure y2 -max $::PD_settings(zoomed_y2_axis_max) -min $::PD_settings(zoomed_y2_axis_min) -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8}
    #PD_past2_config
}

proc PD_zoom_in {} {
    if {($::PD_settings(zoomed_y_axis_max) - $::PD_settings(zoomed_y_axis_min) > 1)} {
        incr ::PD_settings(zoomed_y_axis_max) -1
        set ::PD_settings(zoomed_y2_axis_max) [expr {$::PD_settings(zoomed_y_axis_max)*0.5}]
        $::PD_espresso_zoomed_graph axis configure y -max $::PD_settings(zoomed_y_axis_max)
        $::PD_espresso_zoomed_graph axis configure y2 -max $::PD_settings(zoomed_y2_axis_max)
    }
    if {($::PD_settings(zoomed_y_axis_max) - $::PD_settings(zoomed_y_axis_min) < 6)} {
        $::PD_espresso_zoomed_graph axis configure y -majorticks {0 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.6 3.8 4 4.2 4.4 4.6 4.8 5 5.2 5.4 5.6 5.8 6 6.2 6.4 6.6 6.8 7 7.2 7.4 7.6 7.8 8 8.2 8.4 8.6 8.8 9 9.2 9.4 9.6 9.8 10 10.2 10.4 10.6 10.8 11 11.2 11.4 11.6 11.8 12 12.2 12.4 12.6 12.8 13 13.2 13.4 13.6 13.8 14 14.2 14.4 14.6 14.8 15}
        $::PD_espresso_zoomed_graph axis configure y2 -majorticks {0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3 0.1 0.2 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6 6.1 6.2 6.3 6.4 6.5 6.6 6.7 6.8 6.9 7 7.1 7.2 7.3 7.4 7.5}

    }
}

proc PD_zoom_out {} {
    if {($::PD_settings(zoomed_y_axis_max) - $::PD_settings(zoomed_y_axis_min) < 15)} {
        # 15 is the max Y axis allowed
        if {$::PD_settings(zoomed_y_axis_max) > 14} {
            incr ::PD_settings(zoomed_y_axis_min) -1
            set ::PD_settings(zoomed_y2_axis_max) [expr {$::PD_settings(zoomed_y_axis_max)*0.5}]
            } else {
            incr ::PD_settings(zoomed_y_axis_max)
            set ::PD_settings(zoomed_y2_axis_max) [expr {$::PD_settings(zoomed_y_axis_max)*0.5}]
        }
        $::PD_espresso_zoomed_graph axis configure y -max $::PD_settings(zoomed_y_axis_max) -min $::PD_settings(zoomed_y_axis_min)
        $::PD_espresso_zoomed_graph axis configure y2 -max $::PD_settings(zoomed_y2_axis_max) -min $::PD_settings(zoomed_y2_axis_min)
    }
    if {($::PD_settings(zoomed_y_axis_max) - $::PD_settings(zoomed_y_axis_min) > 5)} {
        $::PD_espresso_zoomed_graph axis configure y -majorticks {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
        $::PD_espresso_zoomed_graph axis configure y2 -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8}
    }
}

proc PD_scroll_up {} {
    if {$::PD_settings(zoomed_y_axis_min) < 14 && $::PD_settings(zoomed_y_axis_max) < 15 && ($::PD_settings(zoomed_y_axis_max) - $::PD_settings(zoomed_y_axis_min)) >= 1} {
        # 15 is the max Y axis allowed
        incr ::PD_settings(zoomed_y_axis_min) 1
        incr ::PD_settings(zoomed_y_axis_max) 1
        set ::PD_settings(zoomed_y2_axis_max) [expr {$::PD_settings(zoomed_y_axis_max)*0.5}]
        set ::PD_settings(zoomed_y2_axis_min) [expr {$::PD_settings(zoomed_y_axis_min)*0.5}]
        $::PD_espresso_zoomed_graph axis configure y -max $::PD_settings(zoomed_y_axis_max) -min $::PD_settings(zoomed_y_axis_min)
        $::PD_espresso_zoomed_graph axis configure y2 -max $::PD_settings(zoomed_y2_axis_max) -min $::PD_settings(zoomed_y2_axis_min)
    }
}

proc PD_scroll_down {} {
    if {$::PD_settings(zoomed_y_axis_min) > 0 && $::PD_settings(zoomed_y_axis_max) > 1 && ($::PD_settings(zoomed_y_axis_max) - $::PD_settings(zoomed_y_axis_min)) >= 1} {
        incr ::PD_settings(zoomed_y_axis_min) -1
        incr ::PD_settings(zoomed_y_axis_max) -1
        set ::PD_settings(zoomed_y2_axis_max) [expr {$::PD_settings(zoomed_y_axis_max)*0.5}]
        set ::PD_settings(zoomed_y2_axis_min) [expr {$::PD_settings(zoomed_y_axis_min)*0.5}]
        $::PD_espresso_zoomed_graph axis configure y -max $::PD_settings(zoomed_y_axis_max) -min $::PD_settings(zoomed_y_axis_min)
        $::PD_espresso_zoomed_graph axis configure y2 -max $::PD_settings(zoomed_y2_axis_max) -min $::PD_settings(zoomed_y2_axis_min)
    }
}


### Graph buttons
proc PD_graph_reset_button_text {} {
    if {$::PD_settings(zoomed_y_axis_max) == $::PD_settings(zoomed_y_axis_scale_default) && $::PD_settings(zoomed_y_axis_min) == 0 && $::PD_settings(glt2) > 0} {
        dui item config "off_zoomed espresso_zoomed" PD_graph_reset_button_text -fill $::PD_settings(red)
        return "Temp Zoom"
    } else {
        dui item config "off_zoomed espresso_zoomed" PD_graph_reset_button_text -fill $::PD_settings(off_white)
        return "RESET"
    }
}

proc PD_graph_reset_button {} {
    if {$::PD_settings(zoomed_y_axis_max) == $::PD_settings(zoomed_y_axis_scale_default) && $::PD_settings(zoomed_y_axis_min) == 0 && $::PD_settings(glt2) > 0} {
    set ::PD_settings(zoomed_y_axis_max) 10
    set ::PD_settings(zoomed_y_axis_min) 8
    set ::PD_settings(zoomed_y2_axis_max) [expr {$::PD_settings(zoomed_y_axis_max)*0.5}]
    set ::PD_settings(zoomed_y2_axis_min) [expr {$::PD_settings(zoomed_y_axis_min)*0.5}]
    $::PD_espresso_zoomed_graph axis configure y -color #e73249 -max $::PD_settings(zoomed_y_axis_max) -min $::PD_settings(zoomed_y_axis_min) -majorticks {7 7.2 7.4 7.6 7.8 8 8.2 8.4 8.6 8.8 9 9.2 9.4 9.6 9.8 10}
    $::PD_espresso_zoomed_graph axis configure y2 -max $::PD_settings(zoomed_y2_axis_max) -min $::PD_settings(zoomed_y2_axis_min) -majorticks {0 0.5 1 1.5 2 2.5 3 3.5 4 4.5 5 5.5 6 6.5 7 7.5 8}


    } else {
        PD_reset_graphs;
    }
}

proc PD_last_extraction_ratio {} {
    catch {
        set r [round_to_one_digits [expr $::PD_graphs(live_graph_weight)/$::PD_graphs(live_graph_beans)]]
    }
    return 1:$r
}
proc PD_live_extraction_ratio {} {
    catch {
        set r [round_to_one_digits [expr $::de1(scale_sensor_weight)/$::settings(grinder_dose_weight)]]
    }
    return 1:$r
}