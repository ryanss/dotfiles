on run {input, parameters}

	set fileList to {}
	repeat with i from 1 to count input
		set end of fileList to quoted form of (POSIX path of (item i of input as string)) & space
	end repeat

	set filePath to quoted form of (POSIX path of (get path to home folder))
	if input is not {} then
		set filePath to do shell script "dirname " & quoted form of (POSIX path of (item 1 of input as string))
	end if


	if application "WezTerm" is running then
		do shell script "/opt/homebrew/bin/wezterm cli spawn --new-window --cwd " & filePath & " -- /opt/homebrew/bin/nvim " & fileList & "; exit"
		tell application "WezTerm" to activate
	else
		tell application "WezTerm" to activate
		delay 0.1
		tell application "System Events"
			keystroke "cd " & filePath & "; nvim " & fileList & "; exit"
			keystroke return
		end tell
	end if

	return input
end run
