-- @description Set autoload off
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Turns off autoload for the selected cue
-- @separateprocess FALSE

-- @changelog
--   v1.0  + init


tell front workspace
	
	repeat with eachCue in (selected as list)
		set autoload of eachCue to false
	end repeat
	
end tell