
proc PD_save {key} {
    if {$key == "" || $key == "all"} {
        save_settings
        PD_save PD_settings
        de1_send_steam_hotwater_settings
    }
    if {$key == "settings"} {
        save_settings
    }
    if {$key == "flush"} {
        save_settings
        de1_send_steam_hotwater_settings
    }
    if {$key == "steam"} {

         if {$::settings(steam_timeout) <= 0} {
            set ::settings(steam_timeout) 1
            set ::settings(steam_disabled) 1
         }
         if {$::settings(steam_timeout) > 255} {
            set ::settings(steam_timeout) 255
         }
         if {$::settings(steam_disabled) == 1} {
            dui item config $::PD_home_pages PD_steam_label -fill $::PD_settings(light_grey)
            dui item config $::PD_home_pages PD_steam_value -fill $::PD_settings(light_grey)
            dui item config $::PD_home_pages PD_steam_minusminus* -state hidden
            dui item config $::PD_home_pages PD_steam_minus* -state hidden
            dui item config $::PD_home_pages PD_steam_plus* -state hidden
            dui item config $::PD_home_pages PD_steam_plusplus* -state hidden
         } else {
            dui item config $::PD_home_pages PD_steam_label -fill $::PD_settings(off_white)
            dui item config $::PD_home_pages PD_steam_value -fill $::PD_settings(off_white)
            dui item config $::PD_home_pages PD_steam_minusminus* -state normal
            dui item config $::PD_home_pages PD_steam_minus* -state normal
            dui item config $::PD_home_pages PD_steam_plus* -state normal
            dui item config $::PD_home_pages PD_steam_plusplus* -state normal
         }
         save_settings
         delay_screen_saver
         de1_send_steam_hotwater_settings
    }
    if {$key == "water"} {
        save_settings
        PD_save PD_settings
        de1_send_steam_hotwater_settings
    }
    if {$key == "PD_settings"} {
        upvar ::PD_settings item
        set data {}
        foreach k [lsort -dictionary [array names item]] {
            set v $item($k)
            append data [subst {[list $k] [list $v]\n}]
        }
        write_file [skin_directory]/User_Settings/$key.tdb $data
    }
    if {$key == "PD_graphs"} {
        upvar ::PD_graphs item
        set data {}
        foreach k [lsort -dictionary [array names item]] {
            set v $item($k)
            append data [subst {[list $k] [list $v]\n}]
        }
        write_file [skin_directory]/User_Settings/$key.tdb $data
    }

    if {$key == "fav1" || $key == "fav2" || $key == "fav3" || $key == "fav4" || $key == "fav5" || $key == "fav6"} {
        set ::PD_settings(fav_key) $key
        set ::PD_settings(fav_profile) $::PD_settings($key)
        set _colour _colour
        set ::PD_settings(fav_colour) $::PD_settings($key$_colour)
        dui item config $::PD_home_pages PD_profile_name -fill $::PD_settings($key$_colour)
        PD_fav_save_message
        set data {}
        append data "settings {\n"
        set vars [PD_favourites_settings_vars]
        foreach k $vars {
            if {[info exists ::settings($k)] == 1} {
                set v $::settings($k)
                append data [subst {[list $k] [list $v]\n}]
            }
        }
        append data "}\n"
        append data "PD_settings {\n"
        set PD_vars [PD_favourite_PD_settings_vars]
        foreach k $PD_vars {
            if {[info exists ::PD_settings($k)] == 1} {
                set v $::PD_settings($k)
                append data [subst {\t[list $k] [list $v]\n}]
            }
        }
        append data "}\n"

        write_file [skin_directory]/User_Settings/$key.fav $data
        update_de1_explanation_chart
        set ::PD_settings($key) $::settings(profile)
        set ::PD_settings(fav_colour) $::PD_settings(${key}_colour)
        set ::PD_settings(fav_profile) $::PD_settings($key)
        PD_clear_fav_colour
        dui item config $::PD_home_pages PD_profile_name -fill $::PD_settings(fav_colour)
        dui item config $::PD_home_pages PD_${key}_label -fill $::PD_settings(fav_colour)
        dui item config $::PD_home_pages PD_${key}_button_on* -state normal
        dui item config $::PD_home_pages PD_${key}_button_on* -initial_state normal

        set colour_name $::PD_settings(${key}_colour_name)
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
        PD_fav_option_hide_13
        PD_fav_option_hide_46

        PD_save PD_settings
    }
    PD_check_steam_off_button
}

proc PD_load {key} {
    if {$key == "fav1" || $key == "fav2" || $key == "fav3" || $key == "fav4" || $key == "fav5" || $key == "fav6"} {
        if {[file exists [skin_directory]/User_Settings/$key.fav]} {
            set ::PD_settings(fav_key) $key
            set ::PD_settings(fav_colour) $::PD_settings(${key}_colour)
            set ::PD_settings(fav_profile) $::PD_settings($key)
            PD_clear_fav_colour
            dui item config $::PD_home_pages PD_profile_name -fill $::PD_settings(fav_colour)
            dui item config $::PD_home_pages PD_${key}_label -fill $::PD_settings(fav_colour)
            dui item config $::PD_home_pages PD_${key}_button_on* -state normal
            dui item config $::PD_home_pages PD_${key}_button_on* -initial_state normal

            set colour_name $::PD_settings(${key}_colour_name)
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

            array unset -nocomplain fav_settings
            array set fav_settings [encoding convertfrom utf-8 [read_binary_file "[skin_directory]/User_Settings/$key.fav"]]
            array set settings $fav_settings(settings)
            set settings_vars [PD_favourites_settings_vars]
            foreach k $settings_vars {
                set ::settings($k) $settings($k)
            }
            array set PD_settings $fav_settings(PD_settings)
            set PD_settings_vars [PD_favourite_PD_settings_vars]
            foreach k $PD_settings_vars {
                set ::PD_settings($k) $PD_settings($k)
            }

            if {$::settings(steam_disabled) == 1} {
                dui item config $::PD_home_pages PD_steam_label -fill $::PD_settings(light_grey)
            } else {
                dui item config $::PD_home_pages PD_steam_label -fill $::PD_settings(off_white)
            }
            save_settings
            save_settings_to_de1
            set ::settings(profile_has_changed) 0
            profile_has_changed_set_colors
            update_de1_explanation_chart
            fill_profiles_listbox
            PD_save steam
            PD_save PD_settings
        } else {
            PD_fav_instructions
        }
    }
    PD_check_steam_off_button
}


