-- @description Import scripts to cues
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.2
-- @about Module to retrieve metadata headers

property util : script "Applescript Utilities"

global headerOptions, lineUndefined
set headerOptions to {¬
	"Description", ¬
	"Author", ¬
	"Link", ¬
	"Version", ¬
	"Changelog", ¬
	"About", ¬
	"Tested MacOS", ¬
	"Tested Qlab", ¬
	"Separate Process"}

on retrieveHeaders(theScript)
	set theScriptContents to paragraphs of (read theScript)
	
	set indentLevel to 0
	
	set scriptContents to ""
	
	log "--------"
	
	repeat with eachLine in theScriptContents
		
		-- get tags
		
		repeat with eachOption in headerOptions
			set eachOptionNoSpace to util's splitString(eachOption, " ")
			if eachOption is in eachLine then
				try
					log eachOption & ": " & item 2 of util's splitString(eachLine, eachOption & " ")
				on error
					multilineHeader(theScript, eachOption)
				end try
			else if (eachOptionNoSpace as string) is in eachLine then
				try
					log eachOption & ": " & item 2 of util's splitString(eachLine, (eachOptionNoSpace as string) & " ")
				on error
					multilineHeader(theScript, eachOptionNoSpace)
				end try
			end if
		end repeat
	end repeat
end retrieveHeaders

on multilineHeader(theScript, theHeader)
	set theScriptContents to paragraphs of (read theScript)
	
	set inTheHeader to false
	set theHeaderContents to ""
	global testVar
	
	repeat with eachLine in theScriptContents
		if eachLine is "" then
			set inTheHeader to false
			log "2 " & eachLine
		else if theHeader is in eachLine then
			set inTheHeader to true
			log "1 " & eachLine
		else if inTheHeader is true then
			set theHeaderContents to theHeaderContents & util's trimLine(eachLine, "-- ", 0) & "
"
			log "3 " & eachLine
			set testVar to eachLine
		end if
		(*repeat with eachOption in headerOptions
			if theHeader is in eachLine then
				set inTheHeader to true
			else if eachOption is in eachLine then
				set inTheHeader to false
			else if (util's splitString(eachOption, " ") as string) is in eachLine then
				set inTheHeader to false
			else if eachLine is "" then
				set inTheHeader to false
			else if inTheHeader is true then
				set theHeaderContents to theHeaderContents & "
" & util's trimLine(eachLine, "-- ", 0)
			end if
		end repeat*)
	end repeat
	
	global aGlobalVar
	set aGlobalVar to theHeaderContents
end multilineHeader

-- BUG HERE currently doesn't stop at blank lines, can't stop it.

on findHeaders(theScript)
	
end findHeaders

log headerOptions

set scriptFile to choose file

retrieveHeaders(scriptFile)
