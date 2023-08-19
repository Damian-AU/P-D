dui add variable $::PD_home_pages 0 100 -font [PD_font font 18] -fill $::PD_settings(off_white) -anchor w -textvariable {[PD_neg_tare]}

proc PD_neg_tare {} {
    if {$::de1(scale_sensor_weight) < 0} {
        scale_tare
    }
}
