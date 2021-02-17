##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: False

### Decrease postwait by 0.5s


set userDelta to -0.5
repeat with eachCue in (selected of front workspace as list)
	try
		set currentPostWait to post wait of eachCue
		set post wait of eachCue to (currentPostWait + userDelta)
	end try
end repeat