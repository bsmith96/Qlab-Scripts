-- @description Save new version
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @about Saves a new version of your qlab file, incrementing a 2 digit version number, and allowing notes (such as a date, or "start of tech")
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- RUN SCRIPT -----------------------------

-- NAMING SCHEME: Name v00 - note.
-- Ensure your existing project follows this scheme and it will create the new file correctly.

-- Get original filename & path
tell application "QLab 4" to tell front workspace
	set originalFileName to q number
	set originalPath to path
end tell

tell application "Finder"
	set originalPathAlias to POSIX file originalPath as alias
	set originalPath to (container of originalPathAlias) as alias
end tell

-- Remove note, if present

if originalFileName contains "-" then
	set theResult to splitString(originalFileName, " - ")
	set originalNote to item -1 of theResult
	set originalNameAndVersion to item 1 of theResult
else
	set originalNameAndVersion to originalFileName
end if

-- Remove version number

set theResult to splitString(originalNameAndVersion, " v")
set projectName to item 1 of theResult
set originalVersion to item -1 of theResult

-- Update version number

set versionNumber to checkDigits(originalVersion + 1, 2)

-- Ask for note

set newNote to text returned of (display dialog "Would you like to set a note for this version?" with title "Version Note" default answer "")

-- Generate filename

set newFileName to projectName & " v" & versionNumber

if newNote is not "" then
	set newFileName to newFileName & " - " & newNote
end if

-- Save a new version

tell application "QLab 4"
	tell front workspace
		save in ((originalPath as string) & (newFileName as string))
	end tell
	open ((originalPath as string) & (newFileName as string) & ".qlab4")
	close back workspace
end tell


-- FUNCTIONS ------------------------------

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

on checkDigits(num, howLong)
	set num to text -howLong thru -1 of ("00" & num)
	return num
end checkDigits
