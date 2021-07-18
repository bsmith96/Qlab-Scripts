-- @description Automatically route click tracks
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Run this script with click tracks selected, it will automatically route them based on the filename.
-- @separateprocess TRUE


-- USER DEFINED VARIABLES -----------------

set userChannels to {"Track, 13, 14"} -- strings of each channel with the name followed by each track number, separated by ", "

set clickChannel to {15}

set userLevel to 0 -- the level for click tracks to route at

---------- END OF USER DEFINED VARIABLES --


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace

  set selectedCues to (selected as list)

  repeat with eachChannel in userChannels
    set theResult to my splitString(eachChannel, ", ")
    set channelName to item 1 of theResult
    set channelNumbers to rest of theResult

    repeat with eachCue in selectedCues

      set cueType to q type of eachCue
      if cueType is "Audio" then
        set eachCueTarget to target of eachCue

        -- set targetFilename to file name of eachCueTarget
        
        if channelName is in targetFilename then 
          routeToChannel(eachChannel, userLevel)
        else if "click" is in targetFilename then
          routeToChannel(clickChannel, userLevel)
        end if
      end if
    end repeat
  end repeat

  if "click" is in targetFilename then

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

on routeToChannel(theChannels, theLevel)

  tell application id "com.figure53.Qlab.4" to tell front workspace

    set selectedCues to (selected as list)

    repeat with eachCue in selectedCues
    
      set cueType to q type of theCue
      if cueType is "Audio" then
        repeat with eachChannel in theChannels
          setLevel theCue row 0 column eachChannel db theLevel
        end repeat
      end if

    end repeat

  end tell

end routeToChannel