-- @description Offset midi triggers of selected cues
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @testedmacos 10.13.6
-- @testedqlab 4.6.9
-- @about Offsets the value of a program change used to trigger the selected cues, based on using scene recalls from a Yamaha QL5 mixing desk to trigger Qlab. If you insert a scene on the desk, run this script with offset "+1" on all cues after that point.
-- @separateprocess TRUE

-- @changelog
--   v1.0  + init


tell application "QLab 4"
	tell front workspace
		set selectedCues to (selected as list)
		
		display dialog "By how much would you like to offset the midi trigger value of the selected cues?" default answer "" buttons {"Offset", "Cancel"} cancel button "Cancel" default button "Offset"
		set offsetAmount to text returned of result as integer
		
		repeat with eachCue in selectedCues
			set oldMidiTrigger to midi trigger of eachCue
			set oldMidiCommand to midi command of eachCue
			set oldByteOne to midi byte one of eachCue
			set oldByteTwo to midi byte two of eachCue
			
			if oldMidiCommand is program_change then
				if (oldByteOne + offsetAmount) is less than or equal to 127 then
					set midi trigger of eachCue to oldMidiTrigger
					--set midi command of eachCue to program_change
					set midi byte one of eachCue to oldByteOne + offsetAmount
					--set midi byte two of eachCue to oldByteTwo + offsetAmount
				else
					set midi trigger of eachCue to oldMidiTrigger
					set midi byte one of eachCue to (oldByteOne + offsetAmount - 128)
					display dialog "ALERT: Cue number " & q number of eachCue & " requires a change of midi channel"
				end if
			end if
			
		end repeat
		
	end tell
end tell