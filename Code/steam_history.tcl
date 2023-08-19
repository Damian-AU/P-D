proc PD_steam_graph_list {} {
	return [list steam_elapsed steam_temperature steam_flow steam_pressure]
}

proc PD_backup_steam_graph {} {
	foreach sg [PD_steam_graph_list] {
	unset -nocomplain ::PD_settings(steam_graph_$sg)
		if {[$sg length] > 0} {
			set ::PD_settings(steam_graph_$sg) [$sg range 0 end]
		} else {
			set ::PD_settings(steam_graph_$sg) {}
		}
	}
	PD_save PD_settings

}

proc PD_restore_steam_graph {} {
	set last_elapsed_time_index [expr {[espresso_elapsed length] - 1}]
	foreach sg [PD_steam_graph_list] {
		$sg length 0
		if {[info exists ::PD_settings(steam_graph_$sg)] == 1} {
			$sg append $::PD_settings(steam_graph_$sg)
		}

	}
}
set ::PD_settings(save_steam_history) 1
proc PD_save_steam_history {unused_old_state unused_new_state} {

    if {[expr {[steam_pour_millitimer]}] < 3000} {
        return
    }
    if {$::PD_settings(save_steam_history) != 1} {
        return
    }
    if {[info exists [homedir]/PD_steam_history] != 1} {
        set path [homedir]/history_steam
        file mkdir $path
        file attributes $path
    }
    PD_backup_steam_graph
    if {[catch {
        set clock [clock seconds]
        set name [clock format $clock]

        set steam_data {}
        append steam_data "$name\n"
        append steam_data "clock $clock\n"
        append steam_data "\n"
        append steam_data "steam_elapsed {[steam_elapsed range 0 end]}\n"
        append steam_data "steam_pressure {[steam_pressure range 0 end]}\n"
        append steam_data "steam_flow {[steam_flow range 0 end]}\n"
        if {$::settings(enable_fahrenheit) == 1} {
            append steam_data "steam_temperature {[steam_temperature range 0 end]}\n"
            } else {
            append steam_data "steam_temperature {[steam_temperature range 0 end]}\n"
        }
        append steam_data "\n"
        append steam_data "steaming_count_setting $::settings(steaming_count)\n"
        append steam_data "steam_timeout_setting $::settings(steam_timeout)\n"
        append steam_data "steam_temperature_setting $::settings(steam_temperature)\n"
        append steam_data "steam_flow_setting $::settings(steam_flow)\n"
        append steam_data "steam_highflow_start_setting $::settings(steam_highflow_start)\n"
    } err]} {
        msg "Steam history not saved, $err"
    } else {
        set fn "[homedir]/history_steam/[clock format $clock -format "%Y%m%dT%H%M%S"].steam"
        write_file $fn $steam_data
        msg "Save this steam to history"
    }
}


::de1::event::listener::on_major_state_change_add [lambda {event_dict} {
    set ps [dict get $event_dict previous_state]
    set ts [dict get $event_dict this_state]
    if { $ps == "Steam" && $ts == "Idle" } {
        PD_save_steam_history $ps $ts}
}]

proc PD_show_steam_graph {} {
    .can itemconfigure $::PD_home_espresso_graph_1 -state hidden
    .can itemconfigure $::PD_home_steam_graph_1 -state normal
    dui item config $::PD_home_pages PD_heading_steam_graph_exit_button* -state normal
    foreach curve {pressure flow weight temperature resistance steps} {
        dui item config $::PD_home_pages ${curve}_text -state hidden
        dui item config $::PD_home_pages ${curve}_icon -state hidden
    }
    foreach curve {steam_pressure steam_flow steam_temperature} {
        dui item config $::PD_home_pages ${curve}_text -state normal
        dui item config $::PD_home_pages ${curve}_icon -state normal
        dui item config $::PD_home_pages ${curve}_button* -state normal
    }
}
proc PD_hide_steam_graph {} {
    .can itemconfigure $::PD_home_espresso_graph_1 -state normal
    .can itemconfigure $::PD_home_steam_graph_1 -state hidden
    dui item config $::PD_home_pages PD_heading_steam_graph_exit_button* -state hidden
    foreach curve {pressure flow weight temperature resistance steps} {
        dui item config $::PD_home_pages ${curve}_text -state normal
        dui item config $::PD_home_pages ${curve}_icon -state normal
    }
    foreach curve {steam_pressure steam_flow steam_temperature} {
        dui item config $::PD_home_pages ${curve}_text -state hidden
        dui item config $::PD_home_pages ${curve}_icon -state hidden
        dui item config $::PD_home_pages ${curve}_button* -state hidden
    }
}