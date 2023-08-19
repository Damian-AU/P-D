############# comment de1_skin_settings.tcl lines 130 & 140 to show SAW settings

#### UI design by Pulak Bhatnagar & Damian Brakel####
#### Coded by Damian Brakel ####
#### Insired by Diaspora Community Contributions ####

package require de1plus 1.0
package require lambda
source "[homedir]/skins/default/standard_includes.tcl"

if {[file exists "[skin_directory]/Damian.start"]} {
    source  [file join "./skins/P&D/" Damian.start]
}
proc check_MySaver_exists {} {
    set dir "[homedir]/MySaver"
    set file_list [glob -nocomplain "$dir/*"]
    if {[llength $file_list] != 0} {
        set_de1_screen_saver_directory "[homedir]/MySaver"
    }
}

check_MySaver_exists
array set ::PD_settings [encoding convertfrom utf-8 [read_binary_file "[skin_directory]/default_settings.tcl"]]

if {[file exists "[skin_directory]/User_Settings/PD_settings.tdb"] == 1} {
    array set ::PD_settings [encoding convertfrom utf-8 [read_binary_file "[skin_directory]/User_Settings/PD_settings.tdb"]]
}

proc PD_join_files_in_dir {dir} {
    set file_name [lsort -dictionary [glob -nocomplain -tails -directory "./skins/P&D/$dir/" *.tcl]]
    foreach fn $file_name {
        set fn [file rootname $fn]
        source  [file join "./skins/P&D/$dir/" $fn.tcl]
    }
}
PD_join_files_in_dir Code
PD_join_files_in_dir Common_pages
PD_join_files_in_dir Themes/$::PD_settings(theme)
PD_join_files_in_dir Plugins

if {[file exists "[skin_directory]/User_Settings/PD_graphs.tdb"]} {
    array set ::PD_graphs [encoding convertfrom utf-8 [read_binary_file "[skin_directory]/User_Settings/PD_graphs.tdb"]]
}
.can configure -bg $::PD_settings(main_background_colour)

set ::settings(export_history_automatically_to_csv) 0
set ::settings(disable_long_press) 0

if {[file exists "[skin_directory]/Damian.end"]} {
    source  [file join "./skins/P&D/" Damian.end]
}
