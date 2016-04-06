#### What for

To update or promote local repos to/from configured (or current) remotes at any time in cli (term)

#### How to

- dublicate this folder as .cfg and customize settings
- setup (add or rename) host folders (ex. rename host1 to myhost)
- setup (add or rename) lib/prj files (ex. in myhost folder rename lib1.lib to mylib.lib. then edit it to setup path to mylib)
- setup (add or rename) host's files (ex. rename host1.default.libs  to myhost.default.libs. then edit it to setup set of libs to mylib only)
- use utilities to pull/push one or set of lib's/prj's, ex.:
	lula 		# to update all default libs on myhost
	lul mylib 	# to update mylib only
	pusa 		# to push all default projects from myhost (setup it before)
