-- @description Turn on infinite loop
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Turns on infinite loop for the selected cue
-- @separateprocess FALSE

-- @changelog
--   v1.0  + init


tell front workspace
	repeat with eachCue in (selected as list)
		try
			set infinite loop of eachCue to true
		end try
	end repeat
end tell