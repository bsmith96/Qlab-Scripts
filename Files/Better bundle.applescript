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
global newFilePath, newFileName


---- RUN SCRIPT ---------------------------

-- get user inputs
control()

-- get all cue lists
set theLists to getLists()

repeat with eachList in theLists
	-- get all cues in each cue list
	set theCues to getCues(eachList)
	
	repeat with eachCue in theCues
		-- operate on all cues
		moveSourceFiles(eachCue)
	end repeat
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

on moveSourceFiles(theCue)
	tell application id "com.figure53.Qlab.4" to tell theCue
		if q type is not in cueTypes then
			return
		else
			set fileTarget to file target
			set theFolder to my getFolder(q type, (q display name of parent list))
			log theFolder
		end if
	end tell
	
	tell application "Finder"
		set newTarget to duplicate file fileTarget to folder (theFolder as alias)
	end tell
	
	tell application id "com.figure53.Qlab.4" to tell theCue
		set file target to (newTarget as alias)
	end tell
	
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
