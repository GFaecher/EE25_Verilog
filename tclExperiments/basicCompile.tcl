proc compile {top} {

    puts "Closing any designs that are currently open...\n"
    close_project -quiet
    puts "Continuing..."

    # Create a design for a specific part
    link_design -part xc7vx485tffg1157-1

    #compile any .sv files that exist in the current directory
    if {[glob -nocomplain *.sv] != ""} {
        puts "Reading sv files..."
        read_verilog -sv [glob *.sv]

    }

    puts "Synthesizing design..."
    synth_design -top $top -flatten_hierarchy full

    # Here is how you add a .xdc to the project
    read_xdc $top.xdc

    # Block errors
    set_property CFGBVS VCCO [current_design]
    set_property CONFIG_VOLTAGE 3.3 [current_design]

    #Something about unconstrained pin errors
    set_property BITSTREAM.General.UnconstrainedPins {Allow} [current_design]

    puts "Placing Design..."
    place_design

    puts "Routing_Design..."
    route_design

    puts "Writing Checkpoint"
    write_checkpoint -force $top.dcp

    puts "Writing bitstream"
    write_bitstream -force $top.bitstream

    puts "All done..."
    

}