##### QLAB PROGRAMMING SCRIPTS
##### Ben Smith 2020-21
#### Run in separate process: TRUE

### Choose Desk to program


tell application id "com.figure53.Qlab.4" to tell front workspace
	set deskOptions to {"Allen & Heath GLD/SQ", "Yamaha CL/QL"}
	
	set deskToProgram to choose from list deskOptions with title "Choose mixing desk to program"
	
end tell

setDesk(deskToProgram)


on setDesk(desk)
	tell application "QLab 4" to tell front workspace
		if desk is {"Allen & Heath GLD/SQ"} then
			set q_num of cue "Recall" to "ahRecall"
			set q_num of cue "Name" to "ahRecallName"
			set armed of cue "o/s" to false
		end if
		if desk is {"Yamaha CL/QL"} then
			set q_num of cue "Recall" to "yRecall"
			set q_num of cue "Name" to "yRecallName"
			set armed of cue "o/s" to true
		end if
		
	end tell
end setDesk