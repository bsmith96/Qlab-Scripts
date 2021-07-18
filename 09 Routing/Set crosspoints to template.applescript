-- @description Set crosspoints to template
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.10
-- @about Set the crosspoints of the selected cue to match a selected template cue
-- @separateprocess TRUE


-- USER DEFINED VARIABLES -----------------

set templateCueListName to "Other Scripts" -- cue list containing template cues

set templateGroupCueName to "Crosspoints routing templates" -- group cue containing all template cues

set audioChannelCount to 32 -- total number of Qlab outputs

---------- END OF USER DEFINED VARIABLES --


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

  -- Get the number of inputs for the selected routing

  set whatTemplateList to my splitString((whatTemplate as string), " - ") -- append the cue name with " - 2" where "2" is the number of cue input channels to affect.
  try
    set inputCount to item -1 of whatTemplateList as integer
  on error
    return
  end try

  repeat with eachCue in selectedCues
  
    set cueType to q type of eachCue
    if cueType is "Audio" then
      repeat with eachChannel from 1 to audioChannelCount
        repeat with eachInput from 1 to inputCount
          set theLevel to getLevel whatTemplateCue row eachInput column eachChannel
          setLevel eachCue row eachInput column eachChannel db theLevel
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