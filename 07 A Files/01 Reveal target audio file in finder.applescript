##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Reveal target audio file in finder


set editCue to last item of (selected of front workspace as list)
if q type of editCue is "Audio" then
	set fileTarget to file target of editCue
	tell application "Finder"
		reveal fileTarget
		activate
	end tell
end if