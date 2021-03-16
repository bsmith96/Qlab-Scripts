-- @description Increase duration by 0.5s
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Increases duration of selected cue by 0.5s. Can now be accomplished by OSC
-- @separateprocess FALSE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set userDelta to 0.5

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

repeat with eachCue in (selected of front workspace as list)
	try
		set currentDuration to duration of eachCue
		set duration of eachCue to (currentDuration + userDelta)
	end try
end repeat