-- @description Better Bundle
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Bundle your Qlab file, keeping files in folders relative to their cue list
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

property cueTypes : {"Audio", "Video"}

---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

------------------ END OF QLAB VARIABLES --


property util : script "Applescript Utilities"
global newFilePath, newFileName, movedFiles
set movedFiles to {}


---- RUN SCRIPT ---------------------------

-- get user inputs
control()

-- get all cue lists
set theLists to getLists()

repeat with eachList in theLists
	-- get all cues in each cue list
	set theCues to getCues(eachList)
	
	operateOnCues(theCues)
end repeat

saveNewFile()


-- FUNCTIONS ------------------------------

on control()
	-- get user's bundle location
	set newFilePath to choose folder with prompt "Bundle workspace in folder:"
	set newFilePath to POSIX path of newFilePath
	
	-- get user's bundle filename
	set newFileName to text returned of (display dialog "Bundle workspace as:" with title "Workspace Name" default answer "")
end control

on getLists()
	tell application id "com.figure53.Qlab.4" to tell front workspace
		set theLists to cue lists
	end tell
	return theLists
end getLists

on getCues(theList)
	tell application id "com.figure53.Qlab.4" to tell front workspace to tell theList
		set theCues to cues
	end tell
	return theCues
end getCues

on operateOnCues(theCues)
	repeat with eachCue in theCues
		tell application id "com.figure53.Qlab.4" to tell eachCue
			if q type is "Group" then
				set newCues to my getCues(eachCue)
				my operateOnCues(newCues)
			else if q type is in cueTypes then
				my moveSourceFiles(eachCue)
			end if
		end tell
	end repeat
end operateOnCues

on moveSourceFiles(theCue)
	tell application id "com.figure53.Qlab.4" to tell theCue
		set fileTarget to file target
		set theFolder to my getFolder(q type, (q display name of parent list))
	end tell
	
	tell application "Finder"
		if fileTarget is not in movedFiles then
			try
				set newTarget to (duplicate file fileTarget to folder (theFolder as alias) without replacing)
			on error
				set fileTargetName to name of (fileTarget as alias)
				set newTarget to (((theFolder as string) & fileTargetName) as alias)
			end try
		else -- ## FIX ME ## need to get this to non-destructively copy conficting files to get rid of this bit
			set fileTargetName to name of (fileTarget as alias)
			set newTarget to (((theFolder as string) & fileTargetName) as alias)
		end if
	end tell
	
	tell application id "com.figure53.Qlab.4" to tell theCue
		set file target to (newTarget as alias)
	end tell
	
	set end of movedFiles to fileTarget
	
end moveSourceFiles

on getFolder(cueType, cueList)
	set baseFolder to (POSIX file newFilePath as alias)
	-- show name
	set showFolder to my checkFolder(baseFolder, newFileName)
	-- cue type
	set typeFolder to my checkFolder(showFolder, cueType)
	-- cue list
	set listFolder to my checkFolder(typeFolder, cueList)
end getFolder

on checkFolder(locationAlias, theName)
	tell application "Finder"
		set theFolder to locationAlias as string
		
		try
			set newFolder to theFolder & theName
			set newFolder to (newFolder as alias)
		on error
			set newFolder to make new folder at (theFolder as alias) with properties {name:theName}
		end try
	end tell
end checkFolder

on saveNewFile()
	tell application id "com.figure53.Qlab.4"
		tell front workspace
			set thePath to (POSIX file newFilePath as alias)
			set thePath to my checkFolder(thePath, newFileName)
			set newFile to save in ((thePath as string) & (newFileName) & ".qlab4")
			
			--set theReply to button returned of (display dialog "Would you to open the bundled file?" with title "Bundle complete!" buttons {"No", "Yes"} default button "Yes")
		end tell
		open ((thePath as string) & newFileName & ".qlab4")
		close back workspace without saving
	end tell
end saveNewFile
