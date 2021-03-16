-- @description Start the loop of selected cue
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Loads the selected cue to complete and starts it, leaving only any looping audio playing
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


tell application id "com.figure53.Qlab.4" to tell front workspace
	set theCue to last item of (selected as list)
	set cuePreWait to pre wait of theCue
	set cueDuration to duration of theCue
	set cuePostWait to post wait of theCue
	load theCue time (cuePreWait + cueDuration + cuePostWait)
	start theCue
end tell