-- @description Route Soundcheck tracks to template
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.3
-- @testedmacos 10.13.6
-- @testedqlab 4.6.10
-- @about Routes soundcheck songs to specific or additional channels based on templates
-- @separateprocess TRUE

-- @changelog
--   v1.3  + Takes number of output channels from the notes of cues, to streamline editing for new projects
--   v1.2  + Renames script cue with the current routing
--   v1.1  + Toggles template name for additional routing ("+Sub" while off, "-Sub" while on)
--         + Toggles template name for absolute routing (adds  " <-", and sets all additional to "+")


-- USER DEFINED VARIABLES -----------------

set variableCueListName to "Other scripts & utilities" -- cue list containing Script Variables

set templateCueListName to "Other scripts & utilities" -- cue list containing template cues

set templateGroupCueName to "Soundcheck routing templates" -- group cue containing all template cues

set cueListToRoute to "Soundcheck" -- the name of the soundcheck cue list. If this is blank, it will use selected cues

global thisScriptCueNumber
set thisScriptCueNumber to "Route S-Check" -- the number of the cue which runs or triggers this script

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

  if cueListToRoute is not "" then
    set selectedCues to (cues in (first cue list whose q name is cueListToRoute) as list)
  else
    set selectedCues to (selected as list)
  end if

  if (whatTemplate as string) starts with "+" or (whatTemplate as string) starts with "-" then -- for additional routing e.g. add +Subs, +Front Fills.
    repeat with eachCue in selectedCues
      set cueType to q type of eachCue
      if cueType is "Audio" then
        repeat with eachChannel from 1 to audioChannelCount
          set theLevel to getLevel whatTemplateCue row 0 column eachChannel
          if theLevel is greater than -60 then -- checks this is a channel to be affected
            if (getLevel eachCue row 0 column eachChannel) is not theLevel then -- toggles
              setLevel eachCue row 0 column eachChannel db theLevel
              my renameAdditionalTemplate(whatTemplateCue, "-")
              set additional to "add"
            else
              setLevel eachCue row 0 column eachChannel db -120
              my renameAdditionalTemplate(whatTemplateCue, "+")
              set additional to "remove"
            end if
          end if
        end repeat
      end if
    end repeat
    log whatTemplate & " absolute"
  
    try
      set scriptCue to cue thisScriptCueNumber
      set scriptCueOldName to q name of scriptCue

      if additional is "add" then
        set q name of scriptCue to scriptCueOldName & " " & whatTemplate
      else if additional is "remove" then
        set newTemplateName to q name of whatTemplateCue
        set q name of scriptCue to my findAndReplaceInText(scriptCueOldName, " " & newTemplateName, "")
      end if
    end try

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
    my renameAbsoluteTemplate(whatTemplateCue, routingTemplates)

    log whatTemplate & " not absolute"
  end if


end tell


-- FUNCTIONS ------------------------------

-- Rename additional routing template cues based on the current state.
--     If current state is on, prefix becomes "-".
--     If current state is off, prefix becomes "+"

on renameAdditionalTemplate(theTemplate, prefix)
  tell application id "com.figure53.Qlab.4" to tell front workspace
    set oldTemplateName to q name of theTemplate
    set newTemplateName to items 2 thru -1 of (oldTemplateName as string)
    set newTemplateName to prefix & newTemplateName
    set q name of theTemplate to newTemplateName
  end tell
end renameAdditionalTemplate

-- Rename absolute routing template cues based on the current state.
--     Most recently recalled is appended with " <-".
--     All other cues have " <-" cleared, if present.
--     All absolute routing is set to prefix "+", since it will be turned off by the template.

on renameAbsoluteTemplate(theTemplate, allTemplates)
  tell application id "com.figure53.Qlab.4" to tell front workspace
    repeat with eachTemplate in allTemplates
      if q name of eachTemplate ends with " <-" then
        set eachOldName to q name of eachTemplate
        set q name of eachTemplate to (items 1 thru -4 of eachOldName) as string
      else if q name of eachTemplate starts with "+" or q name of eachTemplate starts with "-" then
        my renameAdditionalTemplate(eachTemplate, "+")
      end if
    end repeat

    set oldTemplateName to q name of theTemplate
    set newTemplateName to oldTemplateName as string
    set newTemplateName to newTemplateName & " <-"
    set q name of theTemplate to newTemplateName

    try
      set scriptCue to cue thisScriptCueNumber
      set q name of scriptCue to oldTemplateName
    end try

  end tell
end renameAbsoluteTemplate

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

on findAndReplaceInText(theText, theSearchString, theReplacementString)
	set AppleScript's text item delimiters to theSearchString
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to theReplacementString
	set theText to theTextItems as string
	set AppleScript's text item delimiters to ""
	return theText
end findAndReplaceInText