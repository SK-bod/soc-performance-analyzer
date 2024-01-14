set_global_assignment -entity "system_id" -library "lib_system_id" -name IP_TOOL_NAME "altchip_id"
set_global_assignment -entity "system_id" -library "lib_system_id" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "system_id" -library "lib_system_id" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_system_id" -name SPD_FILE [file join $::quartus(sip_path) "system_id.spd"]

set_global_assignment -library "lib_system_id" -name MISC_FILE [file join $::quartus(sip_path) "system_id_sim/system_id.v"]
set_global_assignment -library "lib_system_id" -name MISC_FILE [file join $::quartus(sip_path) "system_id_sim/altchip_id/altchip_id.v"]
