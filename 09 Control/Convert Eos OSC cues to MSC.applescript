-- @description Convert EOS OSC cues to MSC
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.14.6
-- @testedqlab 4.6.10
-- @about Replace programmed Eos OSC cues with MSC cues instead. Replaces any selected cues which are EOS triggers.
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

set lxDeviceID to 1 --         Device ID of lighting console
set commandFormat to 1 --      Lighting (general)
set commandNumber to 1 --      GO


---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

------------------ END OF QLAB VARIABLES --

property util : script "Applescript Utilities"


---- RUN SCRIPT ---------------------------

tell application id "com.figure53.Qlab.4" to tell front workspace
	
	set selectedCues to (selected as list)
	set selectedOSC to {}
	
	repeat with eachCue in selectedCues
		if q type of eachCue is "Network" then
			set end of selectedOSC to eachCue
		end if
	end repeat
	
	repeat with eachCue in selectedOSC
		set selected to eachCue --                               select OSC cue
		
		set oscCommand to custom message of eachCue --           get OSC command
		set oscList to util's splitString(oscCommand, "/") --    get list version
		
		if item 2 of oscList is "eos" and item -1 of oscList is "fire" then
			make type "MIDI" --                                   make midi cue
			set newCue to last item of (selected as list) --      give midi cue a variable
			
			set message type of newCue to msc --                  make midi cue an MSC cue
			
			if (count of oscList) is 6 then --                  > IF THE OSC CUE INCLUDES A CUE LIST
				set cueList to item 4 of oscList --                get cue list no.
				set cueNumber to item 5 of oscList --              get cue number
			else if (count of oscList) is 5 then --             > IF THE OSC CUE DOESN'T INCLUDE A CUE LIST
				set cueNumber to item 4 of oscList --              get cue number
				set cueList to "" --                               leave cue list no. blank
			else --                                             > IF THE OSC CUE IS NOT CORRECTLY FORMATTED FOR THIS SCRIPT
				set q name of newCue to "ERROR - OSC message incorrect"
				set q color of newCue to "red"
				error number -128
			end if
			
			set command format of newCue to commandFormat --      set type to Lighting General
			set command number of newCue to commandNumber --      set go
			set deviceID of newCue to lxDeviceID --               set MSC device ID
			set q_number of newCue to cueNumber --                set cue number
			set q_list of newCue to cueList --                    set cue list
			
			-- name cue to look the same
			set q name of newCue to "MSC: " & (q display name of eachCue)
			
			-- delete original cue
			delete cue id (uniqueID of eachCue) of parent of eachCue
		end if
		
		
	end repeat
	
end tell
