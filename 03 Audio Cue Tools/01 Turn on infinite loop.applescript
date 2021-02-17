##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Turn on infinite loop


tell front workspace
	repeat with eachCue in (selected as list)
		try
			set infinite loop of eachCue to true
		end try
	end repeat
end tell