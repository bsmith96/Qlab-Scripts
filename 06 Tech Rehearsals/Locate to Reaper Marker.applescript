-- @description Locate to Reaper Marker
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.1
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Sends an OSC message to Reaper (running a multitrack of the show) to recall the marker with the same cue number as the current selection.
-- @separateprocess TRUE

-- @changelog
--   v1.1  + added user defined variable for reaper's OSC command


-- USER DEFINED VARIABLES -----------------

try -- if global variables are given when this script is called by another, use those variables
	reaperOscCommand
on error
	set reaperOscCommand to "/reaper/marker_cue"
end try

---------- END OF USER DEFINED VARIABLES --


tell application id "com.figure53.Qlab.4" to tell front workspace
	
	-- Get currently selected cue
	set cueNumberString to q number of (last item of (selected as list))
	
	-- Convert string cue number into integer (Reaper only accepts Integers as Marker IDs)
	try
		set cueNumber to cueNumberString as integer
	on error
		display dialog "Cue number is not an integer" giving up after 2
		return
	end try
	
	-- Put the cue number between 0 and 1 (999 available – ReaScript can only interpret values sent by OSC if they are floating point)
	set cueNumber to cueNumber / 1000
	
	-- Assign the OSC cue which sends this command to a variable
	set oscCue to cue "LocateReaper"
	
	-- Set the message of the OSC cue and send this message
	set custom message of oscCue to reaperOscCommand & " " & (cueNumber as string)
	preview oscCue
	
end tell
