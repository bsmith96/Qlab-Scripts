-- @description Reveal target audio file in finder
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Reveals the target audio file of the selected cue in finder
-- @separateprocess FALSE

-- @changelog
--   v1.0  + init


set editCue to last item of (selected of front workspace as list)

if q type of editCue is "Audio" then
	set fileTarget to file target of editCue
	tell application "Finder"
		reveal fileTarget
		activate
	end tell
end if