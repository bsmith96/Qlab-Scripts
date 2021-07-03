-- @description Create cues to run external scripts in Qlab
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Run this script in MacOS's "Script Editor" to quickly create script cues using the scripts in this repository. As of Qlab 4.6.9 you cannot set "run in separate process" through applescript. Input your default, and the script will alert you if you need to change it.
-- @separateprocess TRUE


-- RUN SCRIPT -----------------------------

-- Declarations

use framework "Foundation"
use framework "OSAKit"
use scripting additions

-- Get user input: scripts to generate cues for

set scriptFiles to choose file with prompt "Please select the scripts to import" of type {"applescript"} with multiple selections allowed

-- Repeat with each selected script

repeat with eachScript in scriptFiles
	
	-- Compile script
	
	set aURL to (current application's |NSURL|'s fileURLWithPath:(POSIX path of eachScript))
	set destinationURL to (aURL's URLByDeletingPathExtension()'s URLByAppendingPathExtension:"scpt")
	
	-- Create a list of each line of the script
	
	set eachScriptContents to paragraphs of (read eachScript)
	
	set scriptContents to ""
	
	log "-----------"
	
	set userDefinedVariables to false
	
	
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
		
		if eachLine contains "USER DEFINED VARIABLES ---" then
			set userDefinedVariables to true
			set userDefinedVariablesContent to ""
		else if eachLine contains "--- END OF USER DEFINED VARIABLES" then
			set userDefinedVariablesContent to userDefinedVariablesContent & "
			" & eachLine
			set userDefinedVariables to false
		end if
		
		if userDefinedVariables is true then
			set userDefinedVariablesContent to userDefinedVariablesContent & "
" & eachLine
			set eachLine to ""
		end if
		
		-- Get script source
		
		if eachLine does not contain "-- @" and eachLine does not contain "--  " then
			set scriptContents to scriptContents & "
			" & eachLine
		end if
		
		set scriptContents to my trimLine(scriptContents, "
			", 0)
		
		
	end repeat
	
	if eachScriptSeparateProcess is "FALSE" then return -- scripts need to work as a separate process for this method
	
	set {theScript, theError} to (current application's OSAScript's alloc()'s initWithContentsOfURL:aURL |error|:(reference))
	if theScript is missing value then error theError's |description|() as text
	set {theResult, theError} to (theScript's compileAndReturnError:(reference))
	if theResult as boolean is false then return theError's |description|() as text
	set {theResult, theError} to (theScript's writeToURL:destinationURL ofType:"scpt" usingStorageOptions:0 |error|:(reference))
	if theResult as boolean is false then return theError's |description|() as text
	
	set newPathAlias to destinationURL as alias
	set newPath to POSIX path of newPathAlias
	log newPath
	
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
		
		set newScriptSource to "set theScript to load script \"" & (newPath) & "\"
		
		run theScript"
		
		try
			set script source of scriptCue to "-- @version " & eachScriptVersion & "

      "
		on error
			set script source of scriptCue to ""
		end try
		
		set script source of scriptCue to script source of scriptCue & userDefinedVariablesContent & "


" & newScriptSource
		
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