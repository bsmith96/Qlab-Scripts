# QLAB SCRIPTS | README

## Tags

@description Name of the script
@author Most recent author of the script
@link Link to the author's website
@source Where scripts are taken from another source, or adapted from one, that author is listed here
@version Version of the script
@testedmacos The most recent version of MacOS that the script has been tested on
@testedqlab The most recent version of Qlab that the script has been tested on
@about A description of the script
@separateprocess TRUE or FALSE, whether the script needs to run in a separate process within Qlab
@changelog Changes for this version of the script

## Readme

This is a selection of scripts, sourced from various free templates, as well as developed by myself, for programming and using Qlab. I've included OSC cues which I use in the same vein, to automate repetitive parts of the workflow, and formatted this whole README and repository to remain consistent with how my template project is set up.

Each subheading or folder is a row in a "Scripts" cue cart, with the first column taken up by titles (memo cues). Each of the following 7 columns has a script in, which are also numbered here according to which column they are in.

Folders numbered 10-19 are in an "other scripts" cue list, which is called by main scripts, but not accessed in general use.

Folders numbered 20-29 are in the "Soundcheck" cue cart, which also contains soundcheck songs.

Folders numbered 30-39 are scripts which I haven't yet incorporated into my template, but intend to very soon!

## Contents

- [01 Mixing Desk Programming](#01-mixing-desk-programming)
- [02 Group/General Cue Tools](#02-groupgeneral-cue-tools)
- [03 Audio Cue Tools](#03-audio-cue-tools)
- [04 Levels](#04-levels)
- [05 Fades](#05-fades)
- [06 Durations](#06-durations)
- [07 A Files](#07-a-files)
- [07 B Colors](#07-b-colors)
- [08 A Cue Lists](#08-a-cue-lists)
- [08 B Alternate SFX Variations](#08-b-alternate-sfx-variations)
- [10 Mixing Desk Scene Recalls](#10-mixing-desk-scene-recalls)
- [20 Soundcheck](#20-soundcheck)
- [30 Stems](#30-stems)
- [31 Misc](#31-misc)
- [Miscellaneous](#miscellaneous)

------

## 01 Mixing Desk Programming

### 01 Choose Desk to program

Run this when setting up your qlab file; selects which scripts to run when you press "create new cue" based on the desk you chose. Choose between Yamaha consoles (QL/CL) and Allen & Heath consoles (GLD/SQ).

This script chooses which of the scripts in folder "10 A Mixing desk scene recalls" are armed and disarmed. These scripts can be placed in groups, and you can use OSC cues to trigger whichever you have chosen.

### 02 [OSC] Create desk scene recall

*Cue number: Recall | Hotkey: X*

**OSC Message** (Qlab): `Cue Number: yRecall | Command: start`

### 03 [OSC] Create scene recall & name

*Cue number: Name | Hotkey: Z*

**OSC Message** (Qlab): `Cue Number: yRecallName | Command: start`

### 05 Offset midi triggers of selected cues

*Cue number: o/s | Hotkey: ctrl+alt+.*

For when the mixing desk is the show control master, particularly a Yamaha QL/CL series desk. If your Qlab cues are triggering when specific Desk Scenes are recalled, and you press "insert scene" on the desk, select all cues after that point in your Qlab cue list and run this script to offset the midi triggers.

N.B. currently, when a midi trigger goes over into another bank (e.g. higher than 128) it prompts the user to fix this cue.

------

## 02 Group/General Cue Tools

### 01 Put selected cue(s) in a new GROUP Cue

*Hotkey: G*

Puts selected cues into a new unnamed Group cue.

### 02 Put selected cue(s) in a new GROUP Cue with notes & number

*Hotkey: H*

Puts selected cues into a new Group cue, which takes the name and number from the first cue.

### 03 Set target to the cue above

*Hotkey: ctrl+T*

Sets the target of the currently selected cue to the cue above (e.g. insert a fade and target it to the preceding audio or fade cue).

### 04 Toggle ARMING

*Hotkey: A*

Toggles whether currently selected cues are armed or disarmed.

### 06 Arm/Disarm through dialog

*Hotkey: ctrl+shift+A*

Arms, disarms or toggles arming of cues whose name contains a string the user defines, e.g. a prefix.

------

## 03 Audio Cue Tools

### 01 Turn on infinite loop

*Hotkey: shift+L*

Turns on infinite loop for selected cue/s.

### 02 Turn off infinite loop

*Hotkey: shift+alt+L*

Turns off infinite loop for the selected cue/s.

### 03 Set autoload on

*Hotkey: ctrl+L*

Turns on autoload for the selected cue/s.

### 04 Set autoload off

*Hotkey: shift+ctrl+L*

Turns off autoload for the selected cue/s.

------

## 04 Levels

### 01 [OSC] Bump +6dB

*Hotkey: ctrl+6*

**OSC Message**: `/cue/selected/level/0/0/+ 6`

### 02 [OSC] Bump -6dB

*Hotkey: shift+ctrl+6*

**OSC Message**: `/cue/selected/level/0/0/- 6`

### 03 [OSC] Bump +1dB

*Hotkey: ctrl+1*

**OSC Message**: `/cue/selected/level/0/0/+ 1`

### 04 [OSC] Bump -1dB

*Hotkey: shift+ctrl+1*

**OSC Message**: `/cue/selected/level/0/0/- 1`

### 06 Set crosspoints to current default

*Hotkey: \`*

NB: Customise this script before running it.

This is designed for when your PA changes after you've started programming your Qlab – you've got a lot of audio cues already programmed, but now you need to change the crosspoints on every single one to allow you to use every channel available. This script creates a temporary cue, takes the crosspoints from that, and set the crosspoints of every selected cue to those defaults. It doesn't touch main levels (the top row).

### 07 Which cues use output x

**This script needs adapting**

Quickly see which of the selected cues are routed to a specific output, to see how often it is used.

------

## 05 Fades

### 01 Fade up

*Hotkey: ctrl+U*

Creates a cue that fades up the master fader of the currently selected audio, video or fade cue to 3dB higher. The default level can be customised in the script.

Can also be used on a group containing audio cues; in this case it will create a new group and a fade up for each of the audio cues within it.

### 02 Fade down

*Hotkey: ctrl+D*

Creates a cue that fades down the master fader of the currently selected audio, video or fade cue to 3dB lower. The default leve can be customised in the script.

Can also be used on a group containing audio cues; in this case it will create a new group and a fade down for each of the audio cues within it.

### 03 Create neutral fade for this cue

*Hotkey: ctrl+alt+G*

Creates a fade cue targeting the currently selected audio, video or fade cue without any alterations in volume.

Can also be used on a group containing audio cues; in this case it will create a new group and a neutral fade for each of the audio cues within it.

### 04 Create fade in

*Hotkey: ctrl+F*

Creates a fade in for the currently selected audio cue.

Can also be used on a group containing audio cues; in this case it will create a new group and a fade in for each of the audio cues within it.

### 05 Create fade out

*Hotkey: ctrl+G*

Create a fade out for the currently selected audio cue.

Can also be used on a group containing audio cues; in this case it will create a new group and a fade out for each of the audio cues within it.

------

## 06 Durations

### 01 Decrease prewait by 0.5s

*Hotkey: alt+1*

Decreases the pre-wait of the currently selected cue by 0.5s. All following cues in 'Durations' function similarly.

### 02 Increase prewait by 0.5s

*Hotkey: alt+2*

See above.

### 03 Decrease duration by 0.5s

*Hotkey: alt+3*

See above.

### 04 Increase duration by 0.5s

*Hotkey: alt+4*

See above.

### 05 Decrease postwait by 0.5s

*Hotkey: alt+5*

See above.

### 06 Increase postwait by 0.5s

*Hotkey: alt+6*

See above.

### 07 Create adjustable autofollow

*Hotkey shift+ctrl+alt+W*

Sets the postwait of the cue to the same as the duration, and sets the continue mode to auto-continue. This allows you to adjust the resulting post-wait to fine-tune the auto-follow.

------

## 07 A Files

### 01 Reveal target audio file in finder

*Hotkey: ctrl+R*

Opens a finder window and reveals the audio file targetted by the current audio cue.

### 02 Label files in use

Labels all audio files currently used within the project in a colour of your choice in finder.

### Save New Version

Updates the version number in the qlab file name, and saves a new copy (complete with a note if you wish, such as "Dress 1" or "Start of tech") in the same folder.

------

## 07 B Tech Rehearsals

### 01 Preset To Before Next Cue

*Hotkey: ctrl+space*

Starts any cues that would be looping before the next GO, at the correct level. Very useful in technical rehearsals.

### Load Parent Group To Start Of Selected Child

**Needs adapting**

Loads the group containing the selected cue to the time that the selected cue would start (e.g. the end of its pre-wait).

### Move To Cut List

**Needs adapting**

Moves the selected cue/s to a new cue list.

### Start The Loop Of Selected Cue

Loads the currently selected cue to the end of its duration and starts it, entering any infinite loop.

------

## 08 A Cue Lists

### 01 Create start cue in Main Cue List

*Hotkey: ctrl+S*

For cues in another cue list, this creates a 'start' cue in the Main Cue List to trigger it. Can be useful if you want to run MSC cues from a separate cue list, for example.

------

## 08 B Alternate SFX Variations

### 01 Create Selection cue in a separate cue list

Creates a series of cues in a specific cue list for selecting which variation of an SFX/Voiceover you wish to load for the upcoming performance. Can be used for e.g. understudy voiceovers, evening and matinee announcements.

### 02 Create a variant SFX from audio files

*Hotkey: §*

Creates cues in your cue list that can be controlled by the selection cue (see above).

Files names for this are formatted "char.perf.num Cue Title, Performer" where "char" is an abbreviation of the character name, "perf" is an abbreviation of the performer name and "num" is a unique number for that combination. This also works for announcements, e.g. "ann.eve.1 Opening Announcement, Evening"

The cue numbers for this use the first bit of the file name, in this example ann.eve.1.

### 03 Create link to select playback variants in rig check

For use during programming, this creates a cue in the Main Cue List (in the Rig Check section – by default underneath a cue named "   RIG CHECK") to remind you to set which variations you want for this performance, and take you to the cue list.

------

## 10 Mixing desk scene recalls

### 01 A Create GLD/SQ scene recall

*Cue number: ahRecall*

Creates a scene recall midi trigger for Allen & Heath GLD or SQ mixing desks.

### 01 B Create GLD/SQ scene recall with name

*Cue number: ahRecallName*

Creates a scene recall midi trigger for A&H GLD/SQ mixing desks and prompts for a name for this scene.

### 02 A Create CL/QL scene recall

*Cue number: yRecall*

As above.

### 02 B Create CL/QL scene recall with name

*Cue number: yRecallName*

As above.

------

## 20 Soundcheck

### 01 Speaker Polarity Check

Designed to work with files from a free android app, "Polarity Checker", this allows you to choice which impulse to play to check your speakers. They should have the cue number of the Hz range in their title, "All" for full range, with a prefix of n for normal or i for inverted.

### 02 Route audio to SPECIFIC outputs

When you're setting up your document, use as many variations as you need for this script to set all soundcheck cues in the "Soundcheck" cue list/cart to be routed a specific way. An example might be a "PROS PA" script, and a "SOUNDCHECK OUTPUT" script.

Instructions are within to set these up – make sure you 'deactivate' all other scripts you're using by changing their colour.

### 03 Route audio to ADDITIONAL outputs

Similar to above, use these scripts to route the soundcheck audio files to additional outputs. This could be your "FOLDBACK" outputs, your "DELAYS" outputs, or a "REVERB" output.

### 04 Create Spoken Line Check Cues

Input the names of each output in your current configuration, and this script will quickly generate an audio file of the Text To Speech engine saying that name, and create a sequence of cues in a group to check your routing, and that speakers are on etc.

For this script, make sure that in your project folder (the folder containing the Qlab file) you have a folder named "Soundcheck", and within that, another labelled "Line Checks". The Line Checks folder should also contain the sound for the script to use to check subs, since spoken IDs won't work for low frequencies. All newly generated files will be placed in this folder.

You can set the variable `rigCheckTitleCue` to "" if you simply want the script to place the folder at your current playhead position on the main cue list.

------

## 30 Stems

### Target version bump by filename

Automatically bumps target of selected audio cues to the next version. If the filename ends with "v01", then it updates them to point to "v02" in the same folder.

### Target version bump by folder

Allows you to create a new folder of v02 stems, and point the selected cues to identically named files in a new folder.

------

## Miscellaneous

### 00 List of available colors

A list of all the colours Qlab can understand (in OSC or script cues). Far more than the default six!
