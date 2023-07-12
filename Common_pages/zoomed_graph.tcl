dui add dbutton off_zoomed 0 0 \
    -bwidth 2560 -bheight 1600 \
    -command {set_next_page off_zoomed off; page_show $::de1(current_context)}
dui add dbutton espresso_zoomed 0 0 \
    -bwidth 2560 -bheight 1600 \
    -command {set_next_page espresso_zoomed espresso; page_show $::de1(current_context)}