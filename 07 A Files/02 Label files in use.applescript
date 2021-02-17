##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Label files in use


property defaultColor : "Red"

set theColors to {"No color", "Orange", "Red", "Yellow", "Blue", "Purple", "Green", "Gray"}

set userColor to choose from list theColors with title "Which color?" with prompt "Label files with this color:" default items {defaultColor}
repeat with n from 1 to (count theColors)
	if ((item n of theColors) as string) is equal to (userColor as string) then
		set labelColor to n - 1
	end if
end repeat

set mySel to cues of front workspace
repeat with myCue in mySel
	if q type of myCue is "Audio" or q type of myCue is "Video" then
		set theFile to file target of myCue
		tell application "Finder"
			set the label index of item theFile to labelColor
		end tell
	end if
end repeat