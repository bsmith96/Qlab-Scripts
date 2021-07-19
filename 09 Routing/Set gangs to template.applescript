-- @description Set gangs to template
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.1
-- @testedmacos 10.13.6
-- @testedqlab 4.6.10
-- @about Create a version of this script for each track you are using, and run each using a different hotkey.
-- @separateprocess TRUE

-- @changelog
--   v1.1  + takes number of output channels from the notes of cues, to streamline editing for new projects


-- USER DEFINED VARIABLES -----------------

set variableCueListName to "Other scripts & utilities" -- cue list containing Script Variables

set templateCueListName to "Other scripts & utilities" -- cue list containing template cues

set templateGroupCueName to "Gangs routing templates" -- group cue containing all template cues

---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

tell application id "com.figure53.Qlab.4" to tell front workspace
  set audioChannelCount to notes of (first cue of (first cue list whose q name is variableCueListName) whose q name is "Output channel count") -- total number of Qlab output
end tell

------------------ END OF QLAB VARIABLES --


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace

  set containerList to (first cue list whose q name is templateCueListName)

  set containerCue to first cue in containerList whose q name is templateGroupCueName

  set routingTemplates to (cues in containerCue)
  set routingNames to {}

  repeat with eachCue in routingTemplates
    set end of routingNames to (q name of eachCue)
  end repeat

  set whatTemplate to choose from list routingNames

  set whatTemplateCue to first cue in containerCue whose q name is whatTemplate

  set selectedCues to (selected as list)

  -- Get the number of inputs for the selected routing. To only affect the master level of each cue output channel, you can omit this from the template cue name

  set whatTemplateList to my splitString((whatTemplate as string), " - ") -- append the cue name with " - 2" where "2" is the number of cue input channels to affect. To only affect levels and not crosspoints, you can omit this or enter "0".
  try
    set inputCount to item -1 of whatTemplateList as integer
  on error
    set inputCount to 0
  end try

  repeat with eachCue in selectedCues
  
    set cueType to q type of eachCue
    if cueType is "Audio" then
      repeat with eachChannel from 1 to audioChannelCount
        repeat with eachInput from 0 to inputCount
          set theGang to getGang whatTemplateCue row eachInput column eachChannel
          try
            setGang eachCue row eachInput column eachChannel gang theGang
          on error
            setGang eachCue row eachInput column eachChannel gang ""
          end try
        end repeat
      end repeat

    end if

  end repeat

end tell


-- FUNCTIONS ------------------------------

on renameCue(theCue, theTemplate)
  tell application  id "com.figure53.Qlab.4" to tell front workspace
    set oldName to q display name of theCue
    set oldNameList to my splitString(oldName, " | ")
    set oldName to item 1 of oldNameList
    set newName to oldName & " | " & theTemplate
    set q name of theCue to newName
  end tell
end renameCue

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