# Qlab Scripts

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/F1F120U9I)

## Introduction

This is a collection of scripts for Figure 53's **Qlab** show control software. I started out working with scripts which have been shared freely online, and evolved into editing these scripts, and more recently creating brand new scripts to automate parts of my workflow.

In all scripts that I have adapted from publically available versions, I have credited the original author in the `@source` tag, in the header of the file.

Some scripts are meant for regular use while programming (such as level bumps, creating fades for cues, and creating mixing desk recall midi cues). Some scripts are intended for one-off use (such as creating line-check cues). A few scripts are very specifically designed for my workflow ("choose desk to program" and "speaker polarity check" specifically), so unless you recreate my qlab template directly, these may not be as useful. However, they could still be useful if you would like to adapt them!

## Installation

These scripts can either run within Qlab as script cues, or can be called from script cues and run externally.

To install the scripts as script cues, use the script "~/00 Import scripts to cues.applescript". Run the script from Script Editor with your qlab file open, and it will allow you to select the script or scripts you wish to import. If you import multiple scripts, it will create script cues and write the scripts (with less header information) into the cue. If you import a single script and currently have a script cue selected, it will write the script into that cue.

To install the scripts to your user's Library folder, in "Script Libraries", I suggest you run the script "~/00 Import all to library.applescript" from the script editor. Select the base folder of the repository, and you can now quickly access any script. Within Qlab, call the script (probably from within a `tell application "Qlab" to tell front workspace` block) like so:

`tell script "01 Mixing Desk Programming/Choose Desk to program" to run`

### User Defined Variables

Many scripts also contain User Defined Variables. With these, when you call the script within Qlab, you can declare these variables globally and set them from within Qlab. This is particularly useful for using the same script for different purposes: e.g. you could have 2 versions of `04 Fades/1 Create fade`, one which creates a fade down and one a fade up. The syntax for this would be as follows:

```applescript
global userLevel, userPrefix
set userLevel to 6
set userPrefix to "Fade up: "
```

```applescript
global userLevel, userPrefix
set userLevel to -6
set userPrefix to "Fade down: "
```

### Variables set within Qlab

Many of these variables will stay the same for your template from show to show - some others depend on the design. These are set from within Qlab, as the notes of a cue.

Using the example `03 Levels/Bump level`, the variables from Qlab are `audioChannelCount` and `minAudioLevel`.

To set these variables, you must set as a User Defined Variable `variableCueListName`. This is the cue list that you have stored your notes cues in. I recommend using Memo cues. In this instance, you would name one cue `Output channel count` and the other `Min audio level`. You do not need numbers for those cues.

The total list of Qlab Note variables required for the entire script library is:
- Output channel count
- Min audio level
- Output channel names [this should simply be a list separated by ", "]
- Line Checks: output level [my default is -12]
- Line Checks: sub level [my default is -12]

### Template cues

The current generation of scripts in `09 Routing` work using templates. This means you can quickly and easily set levels, crosspoints, etc. to multiple 'defaults' via a quick dialog box.

To use these, you must set `templateCueListName` and `templateGroupCueName` in User Defined Variables. It will then use every audio file in the group cue as an option, and copy the appropriate routing from there, up to the count of your "Output Channel Count" value.

The options include: 
- __Route tracks to template__: Sets the faders of the audio cue, ignoring master and crosspoints.
- __Set crosspoints to template__: Sets the crosspoints of the audio cue, ignoring master and faders.
  - Append the template name with " - X" where X is the number of inputs of the audio file. e.g. if you run the script on a mono file, send it at 0 to every output; if you run the script on a stereo file, you may have several different options. If there is only one option for the number of tracks on the selected cue, it will set routing automatically.
- __Set gangs to template__: Sets values of gangs.
  - If you append the template name with " - X", then it will also set gangs of X rows of crosspoints. If you leave the template name without this, the script will simple set gangs of faders.

`Route tracks to template` also has an option to append the name of the template onto the end of the cue name: this is designed for Click Track routing primarily.

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
