-- Finder hands files to a bundle through an Apple Event, not argv, so a shell
-- script cannot receive them. This takes the event and runs nvim in ghostty.
-- __GHOSTTY__ and __NVIM__ are filled in by home/darwin/default.nix.

on run
	launchNvim("")
end run

on open theFiles
	set args to ""
	repeat with f in theFiles
		set args to args & " " & quoted form of POSIX path of f
	end repeat
	launchNvim(args)
end open

on launchNvim(args)
	-- ghostty 1.3.1 also reports paths after -e to AppKit as documents to open,
	-- which pops a confirm dialog. sh -c keeps them out of ghostty's argv.
	-- do shell script waits for the command, so send it to the background
	do shell script "__GHOSTTY__ -e /bin/sh -c " & quoted form of ("__NVIM__" & args) & " >/dev/null 2>&1 &"
end launchNvim
