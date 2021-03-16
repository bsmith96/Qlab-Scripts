-- @description Create adjustable autofollow
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Makes the current cue autocontinue with a post-wait of the duration of the cue
-- @separateprocess FALSE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set userDelta to 0 -- Change this to a negative value to have cues overlap

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

repeat with eachCue in (selected of front workspace as list)
	set post wait of eachCue to ((duration of eachCue) + userDelta)
	set continue mode of eachCue to auto_continue
end repeat