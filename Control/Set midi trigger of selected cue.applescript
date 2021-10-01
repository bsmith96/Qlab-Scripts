-- @description Set midi trigger of selected cue
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Sets the midi trigger of the currently selected cue to a program change
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


---- RUN SCRIPT ---------------------------

-- ask for the value
set theResult to display dialog "What program change value would you like to use to trigger this cue?" default answer ""

-- catch errors in user submission
try
	set midiValue to text returned of theResult as integer
on error
	display dialog "That value was not an integer. Please try again."
	error -128
end try

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	-- get selected cue
	set selectedCue to last item of (selected as list)
	
	-- set midi trigger for selected cue
	tell selectedCue
		set midi trigger to enabled
		set midi command to program_change
		set midi byte one to midiValue
	end tell
	
end tell