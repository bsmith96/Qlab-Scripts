##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: FALSE

### Create adjustiable autofollow


set userDelta to 0 -- Change this to a negative value to have cues overlap
repeat with eachCue in (selected of front workspace as list)
	set post wait of eachCue to ((duration of eachCue) + userDelta)
	set continue mode of eachCue to auto_continue
end repeat