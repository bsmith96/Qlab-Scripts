-- @description Route Soundcheck tracks to template
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.10
-- @about Routes soundcheck songs to specific or additional channels based on templates
-- @separateprocess TRUE


-- USER DEFINED VARIABLES -----------------

set templateCueListName to "Other Scripts" -- cue list containing template cues

set templateGroupCueName to "Soundcheck routing templates" -- group cue containing all template cues

set audioChannelCount to 32 -- total number of Qlab outputs

set cueListToRoute to "Soundcheck" -- the name of the soundcheck cue list. If this is blank, it will use selected cues

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

  if cueListToRoute is not "" then
    set selectedCues to (cues in (first cue list whose q name is cueListToRoute) as list)
  else
    set selectedCues to (selected as list)
  end if

  if (whatTemplate as string) starts with "+" then -- for additional routing e.g. add +Subs, +Front Fills.
    repeat with eachCue in selectedCues
      set cueType to q type of eachCue
      if cueType is "Audio" then
        repeat with eachChannel from 1 to audioChannelCount
          set theLevel to getLevel whatTemplateCue row 0 column eachChannel
          if theLevel is greater than -60 then -- checks this is a channel to be affected
            if (getLevel eachCue row 0 column eachChannel) is not theLevel then -- toggles
              setLevel eachCue row 0 column eachChannel db theLevel
            else
              setLevel eachCue row 0 column eachChannel db -120
            end if
          end if
        end repeat
      end if
    end repeat
    log whatTemplate & " absolute"

  else -- for absolute routing, e.g. pros, a Soundcheck channel
    repeat with eachCue in selectedCues
    
      set cueType to q type of eachCue
      if cueType is "Audio" then
        repeat with eachChannel from 1 to audioChannelCount
          set theLevel to getLevel whatTemplateCue row 0 column eachChannel
          setLevel eachCue row 0 column eachChannel db theLevel
        end repeat
      end if

    end repeat
    log whatTemplate & " not absolute"
  end if


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