##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

###ÊIncrease duration by 0.5s


set userDelta to 0.5
repeat with eachCue in (selected of front workspace as list)
	try
		set currentDuration to duration of eachCue
		set duration of eachCue to (currentDuration + userDelta)
	end try
end repeat