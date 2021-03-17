# Qlab Scripts

## Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Tags](#tags)
- [01 Mixing Desk Programming](#mixing-desk-programming)
- [02 Audio Cue Tools](#audio-cue-tools)
- [03 Levels](#levels)
- [04 Fades](#fades)
- [05 Files](#files)
- [06 Tech Rehearsals](#tech-rehearsals)
- [07 SFX Variations](#sfx-variations)
- [08 Soundcheck](#soundcheck)
- [10 Adapted from others](#adapted-from-others)
  - [11 Rich Walsh](#rich-walsh)
  - [12 Sam Schloegel](#sam-schloegel)
- [Miscellaneous](#Miscellaneous)

------

## Introduction

This is a collection of scripts for Figure 53's **Qlab** show control software. I started out working with scripts which have been shared freely online, and evolved into editing these scripts, and more recently creating brand new scripts to automate parts of my workflow.

Since my current set of scripts includes a collection of scripts from others which have not been meaningfully adapted, I have put these in a separate folder, "Adapted from others". This is primarily so that this repository is an up-to-date list of the scripts that I use, and I can work from any of them when adapting new ones. However, if these are your scripts and you'd prefer I didn't have versions avaiable publically, please don't hesitate to let me know!

In all scripts that I have adapted from publically available versions, I have credited the original author in the `@source` tag, in the header of the file.

Some scripts are meant for regular use while programming (such as level bumps, creating fades for cues, and creating mixing desk recall midi cues). Some scripts are intended for one-off use (such as creating line-check cues, or updating the crosspoints of all programmed cues). A few scripts are very specifically designed for my workflow ("choose desk to program" and "speaker polarity check" specifically), so unless you recreate my qlab template directly, these may not be as useful. However, they could still be useful if you would like to adapt them!

## Installation

Most of these scripts are intended to run within Qlab, as script cues. The intention is that you define hotkeys to them, and then you can run the scripts easily when you need them. You can either put them in a separate cue list, or in a cue cart, and have labelled buttons for each scripts.

Qlab script cues allow you to choose whether to "Run [the script] in separate process". This, largely, means you have to `tell application "Qlab"` if the box is ticked, and simply `tell front workspace` if it is not; it is always telling Qlab. The `@separateprocess` tag gives a true or false value to whether the checkbox should be ticked.

You can also use the script "~/00 Import scripts to cues.applescript". Run the script from Script Editor with your qlab file open, and it will allow you to select the script or scripts you wish to import. If you import multiple scripts, it will create script cues and write the scripts (with less header information) into the cue. If you import a single script and currently have a script cue selected, it will write the script into that cue.

The importer script will also populate - from the tags - the Cue Name (`@description`) and Notes (`@about`). Set your cue default setting for "Run in separate process", and it will alert you when you need to change this - sadly it is not currently possible to script this setting. You can also choose whether you want notifications of discrepancies between the most recent versions of MacOS and Qlab the scripts have been tested on, and your current system versions.

## Tags

- `@description` Name of the script
- `@author` Most recent author of the script
- `@link` Link to the author's website
- `@source` Where scripts are taken from another source, or adapted from one, that author is listed here
- `@version` Version of the script
- `@testedmacos` The most recent version of MacOS that the script has been tested on
- `@testedqlab` The most recent version of Qlab that the script has been tested on
- `@about` A description of the script
- `@separateprocess` TRUE or FALSE, whether the script needs to run in a separate process within Qlab
- `@changelog` Changes for this version of the script

------

## Mixing Desk Programming

### Choose Desk to program

Run this when setting up your qlab file; selects which scripts to run when you press "create new cue" based on the desk you chose. Choose between Yamaha consoles (QL/CL) and Allen & Heath consoles (GLD/SQ).

This script is specifically designed for my template, and chooses which of the "create scene recall" scripts are armed and disarmed. These scripts can be placed in groups, and you can use OSC cues to trigger whichever you have chosen.

### Create GLD/SQ scene recall

Creates a scene recall midi trigger for Allen & Heath GLD or SQ mixing desks.

### Create GLD/SQ scene recall with name

Creates a scene recall midi trigger for A&H GLD/SQ mixing desks and prompts for a name for this scene.

### Create CL/QL scene recall

Creates a scene recall midi trigger for Yamaha CL and QL mixing desks.

### 02 B Create CL/QL scene recall with name

Creates a scene recall midi trigger for Yamaha CL and QL mixing desks and prompts for a name for this scene.

### Offset midi triggers of selected cues

For when the mixing desk is the show control master, particularly a Yamaha QL/CL series desk. If your Qlab cues are triggering when specific Desk Scenes are recalled, and you press "insert scene" on the desk, select all cues after that point in your Qlab cue list and run this script to offset the midi triggers.

N.B. currently, when a midi trigger goes over into another bank (e.g. higher than 128) it prompts the user to fix this cue.

------

## Audio Cue Tools

### Turn on infinite loop

Turns on infinite loop for selected cue/s.

### Turn off infinite loop

Turns off infinite loop for the selected cue/s.

### Set autoload on

Turns on autoload for the selected cue/s.

### Set autoload off

Turns off autoload for the selected cue/s.

------

## Levels

### Set crosspoints to current default

NB: Customise this script before running it.

This is designed for when your PA changes after you've started programming your Qlab – you've got a lot of audio cues already programmed, but now you need to change the crosspoints on every single one to allow you to use every channel available. This script creates a temporary cue, takes the crosspoints from that, and set the crosspoints of every selected cue to those defaults. It doesn't touch main levels (the top row).

------

## Fades

### 1 Fade up

Creates a cue that fades up the master fader of the currently selected audio, video or fade cue to 3dB higher. The default level can be customised in the script.

Can also be used on a group containing audio cues; in this case it will create a new group and a fade up for each of the audio cues within it.

### 2 Fade down

Creates a cue that fades down the master fader of the currently selected audio, video or fade cue to 3dB lower. The default leve can be customised in the script.

Can also be used on a group containing audio cues; in this case it will create a new group and a fade down for each of the audio cues within it.

### 3 Create neutral fade for this cue

Creates a fade cue targeting the currently selected audio, video or fade cue without any alterations in volume.

Can also be used on a group containing audio cues; in this case it will create a new group and a neutral fade for each of the audio cues within it.

### 4 Create fade in

Creates a fade in for the currently selected audio cue.

Can also be used on a group containing audio cues; in this case it will create a new group and a fade in for each of the audio cues within it.

### 5 Create fade out

Create a fade out for the currently selected audio cue.

Can also be used on a group containing audio cues; in this case it will create a new group and a fade out for each of the audio cues within it.

------

## Files

### Save New Version

Updates the version number in the qlab file name, and saves a new copy (complete with a note if you wish, such as "Dress 1" or "Start of tech") in the same folder.

------

## Tech Rehearsals

### Move To Cut List

Moves the selected cue/s to a new cue list, changes the number and disarms it (and all triggers) to avoid accidental firing.

### Preset To Before Next Cue

Starts any cues that would be looping before the next GO, at the correct level. Very useful in technical rehearsals.

### Start The Loop Of Selected Cue

Loads the currently selected cue to the end of its duration and starts it, entering any infinite loop.

------

## SFX Variations

### Create a variant SFX from audio files

Creates cues in your cue list that can be controlled by the selection cue (see above).

Files names for this are formatted "char.perf.num Cue Title, Performer" where "char" is an abbreviation of the character name, "perf" is an abbreviation of the performer name and "num" is a unique number for that combination. This also works for announcements, e.g. "ann.eve.1 Opening Announcement, Evening"

The cue numbers for this use the first bit of the file name, in this example ann.eve.1.

### Create link to select playback variants in rig check

For use during programming, this creates a cue in the Main Cue List (in the Rig Check section – by default underneath a cue named "   RIG CHECK") to remind you to set which variations you want for this performance, and take you to the cue list.

### Create Selection cue in a separate cue list

Creates a series of cues in a specific cue list for selecting which variation of an SFX/Voiceover you wish to load for the upcoming performance. Can be used for e.g. understudy voiceovers, evening and matinee announcements.

------

## Soundcheck

### Create Spoken Line Check Cues

Input the names of each output in your current configuration, and this script will quickly generate an audio file of the Text To Speech engine saying that name, and create a sequence of cues in a group to check your routing, and that speakers are on etc.

For this script, make sure that in your project folder (the folder containing the Qlab file) you have a folder named "Soundcheck", and within that, another labelled "Line Checks". The Line Checks folder should also contain the sound for the script to use to check subs, since spoken IDs won't work for low frequencies. All newly generated files will be placed in this folder.

You can set the variable `rigCheckTitleCue` to "" if you simply want the script to place the folder at your current playhead position on the main cue list.

### Route audio to SPECIFIC outputs

When you're setting up your document, use as many variations as you need for this script to set all soundcheck cues in the "Soundcheck" cue list/cart to be routed a specific way. An example might be a "PROS PA" script, and a "SOUNDCHECK OUTPUT" script.

Instructions are within to set these up – make sure you 'deactivate' all other scripts you're using by changing their colour.

### Route audio to ADDITIONAL outputs

Similar to above, use these scripts to route the soundcheck audio files to additional outputs. This could be your "FOLDBACK" outputs, your "DELAYS" outputs, or a "REVERB" output.

### Speaker Polarity Check

Designed to work with files from a free android app, "Polarity Checker", this allows you to choice which impulse to play to check your speakers. They should have the cue number of the Hz range in their title, "All" for full range, with a prefix of n for normal or i for inverted.

------

## Adapted from others

### Rich Walsh

#### Group / General Cue Tools

##### 1 Put selected cue(s) in a new GROUP Cue with notes & number

Puts selected cues into a new Group cue, which takes the name and number from the first cue.

##### 1 Put selected cue(s) in a new GROUP Cue

Puts selected cues into a new unnamed Group cue.

##### 2 Set target to the cue above

Sets the target of the currently selected cue to the cue above (e.g. insert a fade and target it to the preceding audio or fade cue).

##### 3 Arm/Disarm through dialog

Arms, disarms or toggles arming of cues whose name contains a string the user defines, e.g. a prefix.

##### 3 Toggle ARMING

Toggles whether currently selected cues are armed or disarmed.

------

#### Durations

##### 01 Decrease prewait by 0.5s

Decreases the pre-wait of the currently selected cue by 0.5s. All following cues in 'Durations' function similarly.

##### 02 Increase prewait by 0.5s

See above.

##### 03 Decrease duration by 0.5s

See above.

##### 04 Increase duration by 0.5s

See above.

##### 05 Decrease postwait by 0.5s

See above.

##### 06 Increase postwait by 0.5s

See above.

##### 07 Create adjustable autofollow

Sets the postwait of the cue to the same as the duration, and sets the continue mode to auto-continue. This allows you to adjust the resulting post-wait to fine-tune the auto-follow.

------

#### Files

##### Label files in use

Labels all audio files currently used within the project in a colour of your choice in finder.

##### Reveal target audio file in finder

Opens a finder window and reveals the audio file targetted by the current audio cue.

------

#### Cue Lists

##### Create start cue in Main Cue List

For cues in another cue list, this creates a 'start' cue in the Main Cue List to trigger it. Can be useful if you want to run MSC cues from a separate cue list, for example.

------

### Sam Schloegel

#### Levels

##### Which cues use output x

Quickly see which of the selected cues are routed to a specific output, to see how often it is used.

------

#### Tech Rehearsals

##### Load Parent Group To Start Of Selected Child

Loads the group containing the selected cue to the time that the selected cue would start (e.g. the end of its pre-wait).

------

#### Stems

##### Target version bump by filename

Automatically bumps target of selected audio cues to the next version. If the filename ends with "v01", then it updates them to point to "v02" in the same folder.

##### Target version bump by folder

Allows you to create a new folder of v02 stems, and point the selected cues to identically named files in a new folder.

------

## Miscellaneous

### 00 Import scripts to cues

A quick way to generate Qlab "script" cues from this repository, this imports chosen scripts into cues. You can then set hotkeys and work with them easily!

### 00 List of available colors

A list of all the colours Qlab can understand (in OSC or script cues). Far more than the default six!

### 00 Template Structure

A document describing how my Qlab template is laid out.
