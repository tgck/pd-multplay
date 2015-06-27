# the message dialog panel is a bit unusual in that it is created directly by
# the Tcl 'pd-gui'. Most dialog panels are created by sending a message to
# 'pd', which then sends a message to 'pd-gui' to create the panel.  This is
# similar to the Find dialog panel.

package provide dialog_message2 0.1

package require pd_bindings

namespace eval ::dialog_message2:: {
    variable message_history {"pd dsp 1"}
    variable history_position 0

    namespace export open_message_dialog2
}

proc ::dialog_message2::get_history {direction} {
}

# mytoplevel isn't used here, but is kept for compatibility with other dialog ok procs
proc ::dialog_message2::ok {mytoplevel} {
    variable message_history
    set message [.message.f.entry get]
    if {$message ne ""} {
        pdsend $message
        lappend message_history $message
        .message.f.entry delete 0 end
    }
}

# mytoplevel isn't used here, but is kept for compatibility with other dialog cancel procs
proc ::dialog_message2::cancel {mytoplevel} {
    wm withdraw .message
}

# the message panel is opened from the menu and key bindings
proc ::dialog_message2::open_message_dialog2 {mytoplevel} {
    if {[winfo exists .message]} {
        wm deiconify .message
        raise .message
    } else {
        create_dialog $mytoplevel
    }
}

proc ::dialog_message2::create_dialog {mytoplevel} {

    global canvas_width canvas_height

    toplevel .message -class DialogWindow
    wm group .message .
    wm transient .message
    wm title .message [_ "(this is a GUI template!!!)"]
    wm geometry .message =280x280 ; #window size
    wm resizable .message 1 0
    wm minsize .message 250 80
    .message configure -menu $::dialog_menubar
    .message configure -padx 10 -pady 5
    ::pd_bindings::dialog_bindings .message "message"
    # not all Tcl/Tk versions or platforms support -topmost, so catch the error
    catch {wm attributes $id -topmost 1}
    
    # TODO this should use something like 'dialogfont' for the font
    frame .message.f

    # for temporary local test
    #set canvas_width aaa
    #set canvas_height zzz
    #label .message.f.l00 -textvariable port
	#label .message.f.l01 -textvariable canvas_width
    #label .message.f.l11 -textvariable canvas_height
    #label .message.f.l100 -textvariable focused_window   ; # .x31bf50
    #label .message.f.l102 -textvariable editmode_button  ; # 0 or 1
	
	#label .message.f.title01 -text "port:"
    #label .message.f.title02 -text "canvas size:"

    #pack .message.f -side top -fill x -expand 1
    #pack .message.f.title01 -fill both -bg blue
	#pack .message.f.l00
    #pack .message.f.title02 -fill both -bg blue
    #pack .message.f.l01
    #pack .message.f.l11
    #pack .message.f.l100
    #pack .message.f.l102
}

# ------------------------------------------------------------------------------
#  functions for debug

proc pdtk_test {} {
	::pdwindow::post this_is_test_message\n
}

proc pdtk_test2 { posx posy } {
	variable name
	variable id

	#::pdwindow::post [format "x: %s y: %s\n" $posx $posy]
	::pdwindow::post [format "x: %s y: %s name: %s id: %s\n" $posx $posy $name $id]
	set ::canvas_width $posx
	set ::canvas_height $posy
	set 
}