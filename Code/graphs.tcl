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
        }
        $::PD_home_espresso_graph_1 element configure home_${curve} -linewidth 0
        dui item config $::PD_home_pages ${curve}_text -fill $::PD_settings(light_grey)
        dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(light_grey) -outline $::PD_settings(light_grey)
    } else {
        set ::PD_settings($curve) 1
        if {$curve == "pressure" || $curve == "temperature" || $curve == "flow"} {
            $::PD_home_espresso_graph_1 element configure home_${curve}_goal -linewidth [rescale_x_skin 4]
        }
        $::PD_home_espresso_graph_1 element configure home_${curve} -linewidth [rescale_x_skin 6]
        dui item config $::PD_home_pages ${curve}_text -fill $::PD_settings(off_white)
        if {$curve == "pressure"} {
            dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(green) -outline $::PD_settings(green)
        }
        if {$curve == "temperature"} {
            dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(red) -outline $::PD_settings(red)
        }
        if {$curve == "flow"} {
            dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(blue) -outline $::PD_settings(blue)
        }
        if {$curve == "weight"} {
            dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(brown) -outline $::PD_settings(brown)
        }
        if {$curve == "resistance"} {
            dui item config $::PD_home_pages ${curve}_icon -fill $::PD_settings(yellow) -outline $::PD_settings(yellow)
        }

    }
}


