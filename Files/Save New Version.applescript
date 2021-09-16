-- @description Save new version
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 3.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Saves a new version of your qlab file, incrementing a 2 digit version number, and allowing notes (such as a date, or "start of tech")
-- @separateprocess TRUE

-- @changelog
--   v3.0  + moved common functions to external script
--   v2.0  + introduced a version of semantic versioning, allowing sub-version numbers for updates
--         + now works if ".qlab4" is visible in the file name in finder


property util : script "Applescript Utilities"


-- RUN SCRIPT -----------------------------

-- NAMING SCHEME: Name v0.0 - note.
-- Ensure your existing project follows this scheme and it will create the new file correctly.

-- Get original filename & path
tell application id "com.figure53.Qlab.4" to tell front workspace
	set originalFileName to q number
	set originalPath to path
end tell

tell application "Finder"
	set originalPathAlias to POSIX file originalPath as alias
	set originalPath to (container of originalPathAlias) as alias
end tell

-- Remove note, if present

if originalFileName contains "-" then
	set theResult to util's splitString(originalFileName, " - ")
	set originalNote to item -1 of theResult
	set originalNameAndVersion to item 1 of theResult
else
	set originalNameAndVersion to originalFileName
end if

-- Remove version number

set theResult to util's splitString(originalNameAndVersion, " v")
set projectName to item 1 of theResult
set originalVersion to item -1 of theResult
set theResult to util's splitString(originalVersion, ".")
set originalMajor to item 1 of theResult
set originalMinor to item 2 of theResult

-- Update version number

set nextMajor to "v" & (originalMajor + 1) & ".0"
set nextMinor to "v" & originalMajor & "." & (originalMinor + 1)
set nextTest to "v" & originalMajor & ".t" & (originalMinor + 1)

-- Ask for new version type

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	set nextVersionChoices to {"Minor (" & nextMinor & ")", "Major (" & nextMajor & ")"}
	set nextVersion to choose from list nextVersionChoices with prompt "How do you want to increment the version number?" default items {"Minor (" & nextMinor & ")"} with title (projectName & " v" & originalVersion)
	
	if nextVersion is {"Minor (" & nextMinor & ")"} then
		set versionNumber to nextMinor
	else if nextVersion is {"Major (" & nextMajor & ")"} then
		set versionNumber to nextMajor
	else if nextVersion is {"Test (" & nextTest & ")"} then
		set versionNumber to nextTest
	end if
	
	-- Ask for note
	
	set newNote to text returned of (display dialog "Would you like to set a note for this version?" with title "Version Note" default answer "")
	
end tell

-- Generate filename

set newFileName to projectName & " " & versionNumber

if newNote is not "" then
	set newFileName to newFileName & " - " & newNote
end if

-- Save a new version

tell application id "com.figure53.Qlab.4"
	tell front workspace
		save in ((originalPath as string) & (newFileName as string))
	end tell
	open ((originalPath as string) & (newFileName as string) & ".qlab4")
	close back workspace without saving
end tell