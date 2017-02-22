# The Year 2000
This is a pretty simple web/forensics challenge.

The server has an exposed git directory which lets you get the source code.
You can use DVCS pillage to 'check out' the code. Once you do that, you will
find that there are no flags.

The actual flag is hidden inside an orphaned commit (hinted to by the commit messages).
Not all git-downloading tools will be able to find this.

You need to look at the remote reflog, then download all the neccesary objects from
`.git/objects` to reconstruct the commit.
