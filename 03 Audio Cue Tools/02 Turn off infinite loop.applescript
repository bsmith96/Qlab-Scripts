##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Turn off infinite loop


tell front workspace
	repeat with eachCue in (selected as list)
		try
			set infinite loop of eachCue to false
		end try
	end repeat
end tell