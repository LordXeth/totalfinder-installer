property stdout : ""
on run
	set newline to ASCII character 10
	
	set stdout to stdout & "  shutdown Finder ..." & newline
	try
		tell application "Finder" to quit
	on error
		set stdout to stdout & "    Finder was not running prior uninstallation" & newline
	end try
	
	set stdout to stdout & "  remove TotalFinder.app from login items ..." & newline
	try
		tell application "System Events"
			get the name of every login item
			if login item "TotalFinder.app" exists then
				delete login item "TotalFinder.app"
			end if
		end tell
	on error
		set stdout to stdout & "    Encountered problems when removing TotalFinder.app from login items"
	end try
	
	
	-- old version
	set stdout to stdout & "  removing the old TotalFinder files (0.8.2 and earlier) ..." & newline
	try
		do shell script "sudo launchctl unload -w \"/Library/LaunchDaemons/com.binaryage.echelon.launcher.plist\"" with administrator privileges
	end try
	try
		do shell script "sudo rm -f \"/Library/LaunchDaemons/com.binaryage.echelon.launcher.plist\"" with administrator privileges
	end try
	try
		do shell script "sudo kextunload \"/System/Library/Extensions/echelon.kext\"" with administrator privileges
	end try
	try
		do shell script "sudo rm -rf \"/System/Library/Extensions/echelon.kext\"" with administrator privileges
	end try
	try
		do shell script "sudo rm -rf \"/Library/Application Support/SIMBL/Plugins/TotalFinder.bundle\"" with administrator privileges
	end try
	
	
	-- new version
	set stdout to stdout & "  unload TotalFinder.kext ..." & newline
	try
		do shell script "sudo kextunload \"/System/Library/Extensions/TotalFinder.kext\"" with administrator privileges
	on error
		set stdout to stdout & "    TotalFinder.kext not loaded" & newline
	end try
	
	set stdout to stdout & "  remove TotalFinder.app ..." & newline
	try
		do shell script "sudo rm -rf \"/Applications/TotalFinder.app\"" with administrator privileges
	on error
		set stdout to stdout & "    unable to remove /Applications/TotalFinder.app" & newline
	end try
	
	
	set stdout to stdout & "  remove TotalFinder.kext ..." & newline
	try
		do shell script "sudo rm -rf \"/System/Library/Extensions/TotalFinder.kext\"" with administrator privileges
	on error
		set stdout to stdout & "    unable to remove /System/Library/Extensions/TotalFinder.kext" & newline
	end try
	
	set stdout to stdout & "  remove TotalFinder.osax ..." & newline
	try
		do shell script "sudo rm -rf \"/Library/ScriptingAdditions/TotalFinder.osax\"" with administrator privileges
	on error
		set stdout to stdout & "    unable to remove /Library/ScriptingAdditions/TotalFinder.osax" & newline
	end try
	
	set stdout to stdout & "  enable Finder animations again ..." & newline
	try
		do shell script "defaults write com.apple.finder DisableAllAnimations -bool false" with administrator privileges
		do shell script "defaults write com.apple.finder AnimateWindowZoom -bool true" with administrator privileges
		do shell script "defaults write com.apple.finder FXDisableFancyWindowTransition -bool false" with administrator privileges
	on error
		set stdout to stdout & "    unable to enable animations back" & newline
	end try

	set stdout to stdout & "  hide system files in Finder again ..." & newline
	try
		do shell script "defaults write com.apple.finder AppleShowAllFiles -bool false" with administrator privileges
	on error
		set stdout to stdout & "    hide system files in Finder back" & newline
	end try
	
	set stdout to stdout & "  relaunch Finder ..." & newline
	try
		tell application "Finder" to launch
	on error
		set stdout to stdout & "    failed to relaunch Finder" & newline
	end try
	
	-- at this point Finder should start cleanly and with no signs of TotalFinder
	-- you may check Events/Replies tab to see if there were no issues with uninstallation
	
	stdout -- this is needed for platypus to display output in details window
end run