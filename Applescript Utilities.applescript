-- @description Applescript Utilities
-- @author Ben Smith
-- @link bensmithsound.uk
-- @version 1.0
-- @about Common functions to call for other scripts

-- @changelog
--   v1.0  + init


-- USER DEFINED VARIABLES -----------------

---------- END OF USER DEFINED VARIABLES --


-- VARIABLES FROM QLAB NOTES --------------

------------------ END OF QLAB VARIABLES --


---- RUN SCRIPT ---------------------------


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

on findAndReplaceInText(theText, theSearchString, theReplacementString)
	set AppleScript's text item delimiters to theSearchString
	set theTextItems to every text item of theText
	set AppleScript's text item delimiters to theReplacementString
	set theText to theTextItems as string
	set AppleScript's text item delimiters to ""
	return theText
end findAndReplaceInText

on trimLine(theText, trimChars, trimIndicator)
	-- trimIndicator options:
	-- 0 = beginning
	-- 1 = end
	-- 2 = both
	
	set x to the length of the trimChars
	
	
	---- Trim beginning
	
	if the trimIndicator is in {0, 2} then
		repeat while theText begins with the trimChars
			try
				set theText to characters (x + 1) thru -1 of theText as string
			on error
				-- if the text contains nothing but the trim characters
				return ""
			end try
		end repeat
	end if
	
	
	---- Trim ending
	
	if the trimIndicator is in {1, 2} then
		repeat while theText ends with the trimChars
			try
				set theText to characters 1 thru -(x + 1) of theText as string
			on error
				-- if the text contains nothing but the trim characters
				return ""
			end try
		end repeat
	end if
	
	return theText
end trimLine

on insertItemInList(theItem, theList, thePosition)
	set theListCount to length of theList
	if thePosition is 0 then
		return false
	else if thePosition is less than 0 then
		if (thePosition * -1) is greater than theListCount + 1 then return false
	else
		if thePosition is greater than theListCount + 1 then return false
	end if
	if thePosition is less than 0 then
		if (thePosition * -1) is theListCount + 1 then
			set beginning of theList to theItem
		else
			set theList to reverse of theList
			set thePosition to (thePosition * -1)
			if thePosition is 1 then
				set beginning of theList to theItem
			else if thePosition is (theListCount + 1) then
				set end of theList to theItem
			else
				set theList to (items 1 thru (thePosition - 1) of theList) & theItem & (items thePosition thru -1 of theList)
			end if
			set theList to reverse of theList
		end if
	else
		if thePosition is 1 then
			set beginning of theList to theItem
		else if thePosition is (theListCount + 1) then
			set end of theList to theItem
		else
			set theList to (items 1 thru (thePosition - 1) of theList) & theItem & (items thePosition thru -1 of theList)
		end if
	end if
	return theList
end insertItemInList

on sortList(theList)
	set the indexList to {}
	set the sortedList to {}
	set theListNames to {}
	set sortedListNames to {}
	
	-- Create a list with the names of the files
	repeat with i from 1 to (count of theList)
		set eachItem to item i of theList
		tell application "Finder"
			set end of theListNames to (name of eachItem as string)
		end tell
	end repeat
	
	-- Sort the list of filenames alphabetically (by output number)
	repeat (the number of items in theListNames) times
		set the lowItem to ""
		repeat with i from 1 to (number of items in theListNames)
			if i is not in the indexList then
				set thisItem to item i of theListNames
				if the lowItem is "" then
					set the lowItem to thisItem
					set the lowItemIndex to i
				else if thisItem comes before the lowItem then
					set the lowItem to thisItem
					set the lowItemIndex to i
				end if
			end if
		end repeat
		set the end of sortedListNames to the lowItem
		set the end of the indexList to the lowItemIndex
	end repeat
	
	-- Use the index list to create a sorted list of the files themselves
	repeat with eachItem in indexList
		set end of sortedList to item eachItem of theList
	end repeat
	
	return the sortedList
end sortList

on getFileName(theFile)
	tell application "Finder"
		set fileName to name of theFile
	end tell
end getFileName