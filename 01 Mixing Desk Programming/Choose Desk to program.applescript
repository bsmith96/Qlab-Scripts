-- @description Choose desk to program
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Changes which script cues the OSC "make midi desk recall" cues fire, changing the mixing desk the cues create recalls for. Current options are Allen & Heath mixing desks (GLD, SQ) and Yamaha mixing desks (CL/QL).
-- @separateprocess TRUE


-- @changelog
--   v1.0  + init


-- RUN SCRIPT -----------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	set deskOptions to {"Allen & Heath GLD/SQ", "Yamaha CL/QL"}
	
	set deskToProgram to choose from list deskOptions with title "Choose mixing desk to program"
	
end tell

setDesk(deskToProgram)


-- FUNCTIONS ------------------------------

on setDesk(desk)
	tell application id "com.figure53.Qlab.4" to tell front workspace
		if desk is {"Allen & Heath GLD/SQ"} then
			set q_num of cue "Recall" to "ahRecall"
			set q_num of cue "Name" to "ahRecallName"
			set armed of cue "o/s" to false
		end if
		if desk is {"Yamaha CL/QL"} then
			set q_num of cue "Recall" to "yRecall"
			set q_num of cue "Name" to "yRecallName"
			set armed of cue "o/s" to true
		end if
		
	end tell
end setDesk