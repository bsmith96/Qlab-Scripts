-- @description Arm/Disarm through dialog
-- @author Ben Smith
-- @link bensmithsound.uk
-- @source Rich Walsh (adapted)
-- @version 1.1
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Set the arm state of cues based on a string in their name
-- @separateprocess TRUE

-- @changelog
--   v1.1  + runs as separate process


-- USER DEFINED VARIABLES -----------------

set userDefaultSearchString to ""

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

-- Define variables

global dialogTitle
set dialogTitle to "Batch Arm/Disarm"

-- Get the search string

set {theText, theButton} to {text returned, button returned} of (display dialog "Arm/disarm cues whose name contains (return an empty string to cancel):" with title dialogTitle with icon 1 default answer userDefaultSearchString buttons {"Toggle", "Arm", "Disarm"} default button "Disarm")

-- Check for cancel

if theText is "" then
	error number -128
end if

-- Copy the search string to the Clipboard and arm/disarm the cues

set the clipboard to theText

tell application id "com.figure53.Qlab.4" to tell front workspace
	set foundCues to every cue whose q name contains theText
	--set foundCuesRef to a reference to foundCues
	repeat with eachCue in reverse of foundCues
		if theButton is "Arm" then
			set armed of eachCue to true
		else if theButton is "Disarm" then
			set armed of eachCue to false
		else
			set armed of eachCue to not armed of eachCue
		end if
	end repeat
end tell