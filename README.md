# QLAB SCRIPTS | README

Do a little intro here.

## Mixing Desk Programming

### 01 Choose Desk to program

*Cue number: xxx | Hotkey: xxx*

Run this when setting up your qlab file; selects which scripts to run when you press "create new cue" based on the desk you chose. Choose between Yamaha consoles (QL/CL) and Allen & Heath consoles (GLD/SQ).

This script chooses which of the scripts in folder "10 A Mixing desk scene recalls" are armed and disarmed. These scripts can be placed in groups, and you can use OSC cues to trigger whichever you have chosen.

### 05 Offset midi triggers of selected cues

*Cue number: xxx | Hotkey: xxx*

For when the mixing desk is the show control master, particularly a Yamaha QL/CL series desk. If your Qlab cues are triggering when specific Desk Scenes are recalled, and you press "insert scene" on the desk, select all cues after that point in your Qlab cue list and run this script to offset the midi triggers.

N.B. currently, when a midi trigger goes over into another bank (e.g. higher than 128) it prompts the user to fix this cue.

## Group/General Cue Tools

### 01 Put selected cue(s) in a new GROUP Cue

*Cue number: xxx | Hotkey: G*

Puts selected cues into a new unnamed Group cue.

### 02 Put selected cue(s) in a new GROUP Cue with notes & number

*Cue number: xxx | Hotkey: H*

Puts selected cues into a new Group cue, which takes the name and number from the first cue.

### 03 Set target to the cue above

*Cue number: xxx | Hotkey: xxx*

Sets the target of the currently selected cue to the cue above (e.g. insert a fade and target it to the preceding audio or fade cue).

### 04 Toggle ARMING

*Cue number: xxx | Hotkey: xxx*

Toggles whether currently selected cues are armed or disarmed.

### 06 Arm/Disarm through dialog

*Cue number: xxx | Hotkey: xxx*

Arms, disarms or toggles arming of cues whose name contains a string the user defines, e.g. a prefix.

## Audio Cue Tools

*INCOMPLETE*

## Levels

*INCOMPLETE*

## Fades

*INCOMPLETE*

## Durations

*INCOMPLETE*

## Files

*INCOMPLETE*

## Cue Lists

*INCOMPLETE*

## Alternate SFX Variations

This one is exciting, but currently *INCOMPLETE*

## Mixing desk scene recalls

*INCOMPLETE*

## Soundcheck

*INCOMPLETE*

### Create Spoken Output Names and Automated Line Check Cues

Input the names of each output in your current configuration, and this script will quickly generate an audio file of the Text To Speech engine saying that name, and create a sequence of cues in a group to 

## Miscellaneous

### List of available colors

A list of all the colours Qlab can understand (in OSC or script cues). Far more than the default six!