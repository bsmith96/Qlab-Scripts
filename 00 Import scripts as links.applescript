-- @description Create cues to run external scripts in Qlab
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Run this script in MacOS's "Script Editor" to quickly create script cues using the scripts in this repository. As of Qlab 4.6.9 you cannot set "run in separate process" through applescript. Input your default, and the script will alert you if you need to change it.
-- @separateprocess TRUE


-- USER DEFINED VARIABLES -----------------

set versionWarnings to true -- set to false if you do not with to be notified about version differences between your system and the system the scripts have been tested on

---------- END OF USER DEFINED VARIABLES --


-- RUN SCRIPT -----------------------------

-- Get user input: scripts to generate cues for

set scriptFiles to choose file with prompt "Please select the scripts to import" of type {"public.text"} with multiple selections allowed

-- Repeat with each selected script

repeat with eachScript in scriptFiles
	
	-- Create a list of each line of the script
	
	set eachScriptContents to paragraphs of (read eachScript)
	
	set scriptContents to ""

	log "-----------"
	
	repeat with eachLine in eachScriptContents
		
		-- Get tags
		
		if eachLine contains "@description" then
			set eachScriptDescription to trimLine(eachLine, "-- @description ", 0)
			log "Description: " & eachScriptDescription
		else if eachLine contains "@author" then
			set eachScriptAuthor to trimLine(eachLine, "-- @author ", 0)
			log "Author: " & eachScriptAuthor
		else if eachLine contains "@source" then
			set eachScriptSource to trimLine(eachLine, "-- @source ", 0)
			log "Source: " & eachScriptSource
		else if eachLine contains "@version" then
			set eachScriptVersion to trimLine(eachLine, "-- @version ", 0)
			log "Version: " & eachScriptVersion
		else if eachLine contains "@testedmacos" then
			set eachScriptMacOS to trimLine(eachLine, "-- @testedmacos ", 0)
			log "MacOS: " & eachScriptMacOS
		else if eachLine contains "@testedqlab" then
			set eachScriptQlab to trimLine(eachLine, "-- @testedqlab ", 0)
			log "Qlab: " & eachScriptQlab
		else if eachLine contains "@about" then
			set eachScriptAbout to trimLine(eachLine, "-- @about ", 0)
			log "About: " & eachScriptAbout
		else if eachLine contains "@separateprocess" then
			set eachScriptSeparateProcess to trimLine(eachLine, "-- @separateprocess ", 0)
			log "Separate Process: " & eachScriptSeparateProcess
		end if
		
	end repeat
	
	tell application id "com.figure53.Qlab.4" to tell front workspace
		
		-- Get cue to write, or create cue
		
		set selectedCues to (selected as list)
		
		if (length of scriptFiles is 1) and (length of selectedCues is 1) and (q type of item 1 of selectedCues is "Script") then
			set scriptCue to last item of (selected as list)
		else
			make type "Script"
			set scriptCue to last item of (selected as list)
		end if
		
		-- Set cue name
		
		try
			set q name of scriptCue to eachScriptDescription
		on error
			tell application "System Events"
				set cueName to name of eachScript
				set cueName to my trimLine(cueName, ".applescript", 1)
			end tell
			set q name of scriptCue to cueName
		end try
		
		-- Set cue note
		
		try
			set cueNote to eachScriptAbout
			try
				set cueNote to cueNote & " (" & eachScriptAuthor
				try
					set cueNote to cueNote & " // " & eachScriptSource & ")"
				on error
					set cueNote to cueNote & ")"
				end try
			end try
			set notes of scriptCue to cueNote
		end try
		
		-- Set script source
		
		(*try
			set script source of scriptCue to "-- @version " & eachScriptVersion & "
    
    	" & scriptContents
		on error
			set script source of scriptCue to scriptContents
		end try*)

    set newScriptSource to "tell application id \"com.figure53.Qlab.4\" to tell front workspace

    run script 

    try
      set script source of scriptCue to "-- @version " & eachScriptVersion & "

      "
    on error
      set script source of scriptCue to ""
    end try

    set script scrout of scriptCue to 


		
		-- Alert user if "run in separate process" should be off
		
		try
			if eachScriptSeparateProcess is not defaultSeparateProcess then
				display dialog "The script \"" & eachScriptDescription & "\" requires you to change the state of \"Run in separate process\" in the script tab of the inspector"
			end if
		end try
		
		-- Get current version of Qlab
		
		set currentQlabVersion to version of application id "com.figure53.Qlab.4"
		log "Current Qlab Version: " & currentQlabVersion
		
		-- Get current version of MacOS
		
		set currentMacOSVersion to system version of (system info)
		log "Current MacOS Version: " & currentMacOSVersion
		
		-- Warn user of version differences
		
		if versionWarnings is true then
			
			try
				
				if currentMacOSVersion is not eachScriptMacOS then
					set versionIssueMacOS to true
				else
					set versionIssueMacOS to false
				end if
				
				if currentQlabVersion is not eachScriptQlab then
					set versionIssueQlab to true
				else
					set versionIssueQlab to false
				end if
				
				
				if versionIssueMacOS is true and versionIssueQlab is false then
					-- Issue with MacOS version
					display notification "Be aware that this script has not been tested with your version of MacOS" with title eachScriptDescription
					log "The script \"" & eachScriptDescription & "\" has not been tested with your current version of MacOS. TESTED: " & eachScriptMacOS & ", CURRENT: " & currentMacOSVersion
				else if versionIssueMacOS is false and versionIssueQlab is true then
					-- Issue with Qlab version
					display notification "Be aware that this script has not been tested with your version of Qlab" with title eachScriptDescription
					log "The script \"" & eachScriptDescription & "\" has not been tested with your current version of Qlab. TESTED: " & eachScriptQlab & ", CURRENT: " & currentQlabVersion
				else if versionIssueMacOS is true and versionIssueQlab is true then
					-- Issue with MacOS and Qlab versions
					display notification "Be aware this this script has not been tested with your version of MacOS or your version of Qlab" with title eachScriptDescription
					log "The script \"" & eachScriptDescription & "\" has not been tested with your current version or MacOS or your current version of Qlab. MACOS TESTED: " & eachScriptMacOS & ", CURRENT: " & currentMacOSVersion & ". QLAB TESTED: " & eachScriptQlab & ", CURRENT: " & currentQlabVersion
				end if
			end try
			
		end if
		
	end tell
	
end repeat


-- FUNCTIONS ------------------------------

on trimLine(theText, trimChars, trimIndicator)
	-- trimIndicator options:
	-- 0 = beginning
	-- 1 = end
	-- 2 = both

	set x to the length of the trimChars


	---- Trim beginning

	if the trimIndicator is in {0, 2} then
		repeat while theText begins with the trimChars
			try
				set theText to characters (x + 1) thru -1 of theText as string
			on error
				-- if the text contains nothing but the trim characters
				return ""
			end try
		end repeat
	end if


	---- Trim ending

	if the trimIndicator is in {1, 2} then
		repeat while theText ends with the trimChars
			try
				set theText to characters 1 thru -(x + 1) of theText as string
			on error
				-- if the text contains nothing but the trim characters
				return ""
			end try
		end repeat
	end if

	return theText
end trimLine