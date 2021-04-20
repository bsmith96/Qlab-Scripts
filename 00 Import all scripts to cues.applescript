-- @description Import All Scripts To Qlab Cue List
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Creates a cue list in your Qlab file and imports all scripts in the repository to script cues. If the cue list already exists, checks script cues for updates and updates them when necessary.
-- @separateprocess TRUE


-- USER DEFINED VARIABLES -----------------

set cueListName to "~~ SCRIPTS ~~"

---------- END OF USER DEFINED VARIABLES --


---- RUN SCRIPT ---------------------------

-- Potentially add user-defined url; for now just use my own scripts.

tell application id "com.figure53.Qlab.4" to tell front workspace

  -- Check if scripts cue list exists, and make it if necessary
  try
    set theCueList to (first cue list whose q name is cueListName)
    set didListExist to true
  on error
    make type "Cue list"
    set theCueList to last cue list whose q name is "Cue List"
    set q name of theCueList to cueListName
    set didListExist to false
  end try
  log "Did cue list already exist? - " & didListexist

  -- Template for making the script cues
  set current cue list to theCueList
  make type "Script"
  set theCue to last item of (selected as list)
  set q number of theCue to ""

end tell