-- @description Locate to Reaper Marker
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.10
-- @about Sends an OSC message to Reaper (running a multitrack of the show) to recall the marker with the same cue number as the current selection.
-- @separateprocess TRUE


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
	set custom message of oscCue to "/reaper/marker_cue " & (cueNumber as string)
	preview oscCue
	
end tell
