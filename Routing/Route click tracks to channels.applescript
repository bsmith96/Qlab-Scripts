-- @description Route click tracks to channels
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Create a version of this script for each track you are using, and run each using a different hotkey.
-- @separateprocess TRUE


-- USER DEFINED VARIABLES -----------------

set userChannels to {12, 13} -- the qlab output tracks for this stem or click

set userLevel to 0 -- the level for click tracks to route at

---------- END OF USER DEFINED VARIABLES --


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace

  set selectedCues to (selected as list)

  repeat with eachCue in selectedCues
  
    set cueType to q type of eachCue
    if cueType is "Audio" then
      repeat with eachChannel in userChannels
        setLevel eachCue row 0 column eachChannel db userLevel
      end repeat
    end if

  end repeat

end tell