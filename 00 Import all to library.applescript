-- @description Import all script to user library
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Run this script in MacOS's "Script Editor" to import all scripts in a folder (including within subfolders) to the user's "Library/Script Libraries"
-- @separateprocess TRUE


-- RUN SCRIPT -----------------------------

-- Declarations

use framework "Foundation"
use framework "OSAKit"
use scripting additions

global scriptFiles
set scriptFiles to {}

-- Get user input: folder to import

set scriptFolder to choose folder with prompt "Please select the scripts to import"

findAllScripts(scriptFolder)

tell application "Finder"
	
	repeat with eachScript in scriptFiles
		set fileName to name of (info for (eachScript as alias) without size)
		if fileName ends with ".applescript" then
			set fileName to (characters 1 thru -(12 + 1) of fileName as string)
		end if
		
		set rootPath to POSIX path of (scriptFolder as alias)
		set originalPath to POSIX path of (eachScript as alias)
		set pathInRoot to my trimLine(originalPath, rootPath, 0)
		set pathInLibrary to my trimLine(pathInRoot, ".applescript", 1)
		
		set newRoot to POSIX path of (path to library folder from user domain) & "Script Libraries/"
		set newPath to newRoot & pathInRoot
		set newPath to my trimLine(newPath, ".applescript", 1) & ".scpt"
		
		-- compile script
		
		set newFolder to my trimLine(newPath, fileName & ".scpt", 1)
		log newFolder
		try
			set testFolder to (POSIX file newFolder as alias)
		on error
			-- if folder doesn't exist
			set theFolderName to my trimLine(newFolder, newRoot, 0)
			set theFolderPath to my splitString(theFolderName, "/")
			repeat with eachFolder from 1 to ((count of theFolderPath) - 1)
				try
					set theFolder to make new folder at (POSIX file newRoot as alias)
					set name of theFolder to (item eachFolder of theFolderPath) as string
				on error
					try
						delete theFolder
					end try
				end try
				set newRoot to newRoot & (item eachFolder of theFolderPath) & "/"
			end repeat
		end try
		
		set osaCommand to "osacompile -o \"" & newPath & "\" \"" & originalPath & "\""
		log osaCommand
		log pathInLibrary
		
		try
			do shell script osaCommand
		end try
	end repeat
	
end tell



-- FUNCTIONS ------------------------------

on findAllScripts(theFolder)
	tell application "Finder"
		set allItems to every item of theFolder
		
		repeat with eachItem in allItems
			if kind of (info for (eachItem as alias) without size) is "folder" then
				my findAllScripts(eachItem)
			else
				if name extension of (info for (eachItem as alias) without size) is "applescript" then
					set end of scriptFiles to eachItem
				end if
			end if
			
		end repeat
		
	end tell
end findAllScripts

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

on splitString(theString, theDelimiter)
	-- save delimiters to restore old settings
	set oldDelimiters to AppleScript's text item delimiters
	-- set delimiters to delimiter to be used
	set AppleScript's text item delimiters to theDelimiter
	-- create the array
	set theArray to every text item of theString
	-- restore old setting
	set AppleScript's text item delimiters to oldDelimiters
	-- return the array
	return theArray
end splitString