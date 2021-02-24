set theChannels to {"Proz Left", "Proz Right", "Sub", "Foldback", "Reverb", "Soundcheck"}
set saveLocation to "/Users/Ben/Desktop/Checks/"
set fileType to ".wav"
set outputNumber to count of theChannels

repeat with eachOutput from 1 to outputNumber
	say (item eachOutput of theChannels) using "Daniel" saving to (POSIX file saveLocation & (item eachOutput of theChannels) as string) & fileType
end repeat
