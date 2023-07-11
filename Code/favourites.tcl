proc PD_favourites_settings_vars {} {
    set PD_favourites_settings_vars {
        advanced_shot
        author
        beverage_type
        espresso_decline_time
        espresso_hold_time
        espresso_max_time
        espresso_pressure
        espresso_step_1
        espresso_step_2
        espresso_step_3
        espresso_temperature
        espresso_temperature_1
        espresso_temperature_2
        espresso_temperature_3
        espresso_temperature_steps_enabled
        final_desired_shot_volume
        final_desired_shot_volume_advanced
        final_desired_shot_volume_advanced_count_start
        final_desired_shot_weight
        final_desired_shot_weight_advanced
        flow_profile_decline
        flow_profile_decline_time
        flow_profile_hold
        flow_profile_hold_time
        flow_profile_minimum_pressure
        flow_profile_preinfusion
        flow_profile_preinfusion_time
        grinder_dose_weight
        maximum_flow
        maximum_flow_range_advanced
        maximum_flow_range_default
        maximum_pressure
        maximum_pressure_range_advanced
        maximum_pressure_range_default
        original_profile_title
        preheat_temperature
        preinfusion_enabled
        preinfusion_flow_rate
        preinfusion_flow_rate2
        preinfusion_stop_flow_rate
        preinfusion_guarantee
        preinfusion_stop_pressure
        preinfusion_stop_timeout
        preinfusion_stop_volumetric
        preinfusion_temperature
        preinfusion_time
        pressure_decline_stop_volumetric
        pressure_end
        pressure_hold_stop_volumetric
        pressure_hold_time
        pressure_rampup_stop_volumetric
        pressure_rampup_timeout
        profile
        profile_filename
        profile_hide
        profile_language
        profile_notes
        profile_step
        profile_title
        read_only
        settings_profile_type
        steam_disabled
        steam_timeout
        tank_desired_water_temperature
        temperature_target
        water_temperature
        water_volume
    }
}

proc PD_favourite_PD_settings_vars {} {
    set PD_favourite_PD_settings_vars {
        fav_button_label
        jug_size

    }
}


proc PD_fav_colour_change {} {
	if {$::settings(profile) != $::PD_settings(fav_profile)} {
	    PD_clear_fav_colour
	}
	if {$::settings(profile_has_changed) == 1} {
		set ::PD_profile_not_saved [translate "has unsaved changes"]
		dui item config $::PD_home_pages PD_profile_name -fill $::PD_settings(off_white)
	} else {
	    set ::PD_profile_not_saved ""
	}
}

proc PD_clear_fav_colour {} {
    dui item config $::PD_home_pages PD_profile_name -fill $::PD_settings(off_white)
    set keys {fav1 fav2 fav3 fav4 fav5 fav6}
    foreach key $keys {
        dui item config $::PD_home_pages PD_${key}_label -fill $::PD_settings(off_white)
        dui item config $::PD_home_pages PD_${key}_button_on* -state hidden
        dui item config $::PD_home_pages PD_${key}_button_on* -initial_state hidden
    }
}



