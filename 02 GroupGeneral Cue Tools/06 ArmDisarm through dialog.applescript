##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Arm/Disarm through dialog


set userDefaultSearchString to "" -- Use this to specify the default search string

-- Declarations

global dialogTitle
set dialogTitle to "Batch Arm/Disarm"

-- Get the search string

set {theText, theButton} to {text returned, button returned} of (display dialog Â
	"Arm/disarm cues whose name contains (return an empty string to cancel):" with title dialogTitle with icon 1 Â
	default answer userDefaultSearchString buttons {"Toggle", "Arm", "Disarm"} default button "Disarm")

-- Check for cancel

if theText is "" then
	error number -128
end if

-- Copy the search string to the Clipboard and arm/disarm the cues

set the clipboard to theText

tell front workspace
	set foundCues to every cue whose q name contains theText
	set foundCuesRef to a reference to foundCues
	repeat with eachCue in reverse of foundCuesRef -- Reversed so as to do a Group Cue's children before it
		if theButton is "Arm" then
			set armed of eachCue to true
		else if theButton is "Disarm" then
			set armed of eachCue to false
		else
			set armed of eachCue to not armed of eachCue
		end if
	end repeat
end tell