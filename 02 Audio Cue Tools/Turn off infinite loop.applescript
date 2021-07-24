-- @description Turn off infinite loop
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.1
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Turns off infinite loop for the selected cue [obselete due to OSC]
-- @separateprocess TRUE

-- @changelog
--   v1.1  + runs as separate process


tell application id "com.figure53.Qlab.4" to tell front workspace
	repeat with eachCue in (selected as list)
		try
			set infinite loop of eachCue to false
		end try
	end repeat
end tell