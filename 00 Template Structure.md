# Template Cue Cart Structure

My qlab template has the following cue cart layout

## 1. Mixing Desk Programming

### Choose Desk to Program

### [OSC] Create desk scene recall

*Cue number: Recall | Hotkey: X*

**OSC Message** (Qlab): `Cue Number: yRecall | Command: start`

### [OSC] Create scene recall and name

*Cue Number: Name | Hotkey: Z*

**OSC Message** (Qlab): `Cue Number: yRecallName | Command: start`

### Offset midi triggers of selected cues

*Cue number: o/s | Hotkey: ctrl+alt+.*

------

## Group/General cues

### Put selected cues in group

*Hotkey: G*

### Put selected cues in group with name of first cue

*Hotkey: H*

### Set target to the cue above

*Hotkey: shift+T*

### Toggle arming

*Hotkey: A*

### Arm/Disarm through dialog

*Hotkey: ctrl+shift+A*

------

## Audio Cue Tools

### Turn on infinite loop

*Hotkey: shift+L*

### Turn off infinite loop

*Hotkey: shift+alt+L*

### Set autoload on

*Hotkey: ctrl+L*

### Set autoload off

*Hotkey: shift+ctrl+L*

------

## Levels
### [OSC] Bump +6dB

*Hotkey: ctrl+6*

**OSC Message**: `/cue/selected/level/0/0/+ 6`

### [OSC] Bump -6dB

*Hotkey: shift+ctrl+6*

**OSC Message**: `/cue/selected/level/0/0/- 6`

### [OSC] Bump +1dB

*Hotkey: ctrl+1*

**OSC Message**: `/cue/selected/level/0/0/+ 1`

### [OSC] Bump -1dB

*Hotkey: shift+ctrl+1*

**OSC Message**: `/cue/selected/level/0/0/- 1`

### Set crosspoints to current default

*Hotkey: \`*

### 07 Which cues use output x

------

## Fades

### Fade up

*Hotkey: ctrl+U*

### Fade down

*Hotkey: ctrl+D*

### Create neutral fade

*Hotkey: ctrl+alt+G*

### Create fade in

*Hotkey: ctrl+F*

### Create fade out

*Hotkey: ctrl+G*

------

## Durations

### Decrease prewait

*Hotkey: alt+1*

### Increase prewait

*Hotkey: alt+2*

### Decrease duration

*Hotkey: alt+3*

### Increase duration

*Hotkey: alt+4*

### Decrease postwait

*Hotkey: alt+5*

### Increase postwait

*Hotkey: alt+5*

------

## Files

### Reveal target audio file in finder

*Hotkey: ctrl+R*

### Label files in use

### Save new version

------

## Tech Rehearsals

### Preset to before next cue

*Hotkey: ctrl+space*

### Load parent group to current child

### Move to cut list

------

## Cue Lists

### Create start cue in Main Cue list

*Hotkey: ctrl+S*

------

## SFX Variations
### Create selection cue

### Create a variant from audio files

*Hotkey: §*

### Create link to select in Rig Check

------

# Soundcheck Cue Cart

Populated with audio files, and the following scripts.

### Speaker polarity Check

Fires audio files in an "other scripts" cue list to save space on the cue cart

### Route audio to SPECIFIC outputs

### Route audio to ADDITIONAL outputs

------

# Colours cue cart

All available colours are in a cue cart.

**OSC Message** (Qlab): `Cue Number: selected | Command: color | Parameters: puce`

------

# Hidden Desk Recall Scripts

## Create GLD/SQ scene recall

*Cue number: ahRecall*

## Create GLD/SQ scene recall with name

*Cue number: ahRecallName*

## Create CL/QL scene recall

*Cue number: yRecall*

## Create CL/QL scene recall with name

*Cue number: yRecall*

