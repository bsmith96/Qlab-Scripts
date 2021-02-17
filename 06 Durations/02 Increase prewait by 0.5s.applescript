##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Increase prewait by 0.5s


set userDelta to 0.5
repeat with eachCue in (selected of front workspace as list)
	try
		set currentPreWait to pre wait of eachCue
		set pre wait of eachCue to (currentPreWait + userDelta)
	end try
end repeat