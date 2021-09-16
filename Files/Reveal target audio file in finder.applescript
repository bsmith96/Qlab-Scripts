-- @description Reveal target audio file in finder
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.1
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Reveals the target audio file of the selected cue in finder
-- @separateprocess TRUE

-- @changelog
--   v1.1  + runs as separate process

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	set editCue to last item of (selected as list)
	
	if q type of editCue is "Audio" then
		set fileTarget to file target of editCue
		tell application "Finder"
			delay 1
			reveal fileTarget
			activate
		end tell
	end if
	
end tell