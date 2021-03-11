tell application id "com.figure53.Qlab.4" to tell front workspace
	set theCue to last item of (selected as list)
	set cuePreWait to pre wait of theCue
	set cueDuration to duration of theCue
	set cuePostWait to post wait of theCue
	load theCue time (cuePreWait + cueDuration + cuePostWait)
	start theCue
end tell