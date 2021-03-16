-- @description Speaker Polarity Check
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Designed to work with the android app "Polarity Checker", with audio files stored in a hidden cue list. This script launches audio files.
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- RUN SCRIPT -----------------------------

-- If there is no audio, check the routing of the audio files (in "Other Scripts")

tell application id "com.figure53.QLab.4" to tell front workspace
	
	set playbackOptions to {"STOP", "Full Range", "80 Hz", "160 Hz", "500 Hz", "1k2 Hz", "4 kHz"}
	
	set polarityCheck to choose from list playbackOptions with title "Sample Selection" with prompt "Select the sample to play"
	if polarityCheck is {"STOP"} then
		if cue "SPC" is running then
			stop cue "SPC"
			return
		else
			return
		end if
	else if polarityCheck is false then
		return
	end if
	
	display dialog "Invert signal?" buttons {"Yes", "No"} default button "No"
	set invertCheck to button returned of result
	
	if polarityCheck is {"Full Range"} then set cueNum to "All"
	if polarityCheck is {"80 Hz"} then set cueNum to "80"
	if polarityCheck is {"160 Hz"} then set cueNum to "160"
	if polarityCheck is {"500 Hz"} then set cueNum to "500"
	if polarityCheck is {"1k2 Hz"} then set cueNum to "1k2"
	if polarityCheck is {"4 Khz"} then set cueNum to "4k"
	
	if invertCheck is "Yes" then set cuePrefix to "i"
	if invertCheck is "No" then set cuePrefix to "n"
	
	set fullCueNumber to cuePrefix & cueNum as string
	
	if cue "SPC" is running then
		if cue fullCueNumber is running then
			stop cue "SPC"
		else
			stop cue "SPC"
			delay 0.1
			start cue fullCueNumber
		end if
	else
		start cue fullCueNumber
	end if
	
	
end tell