# mob

For social coding on separate machines.

Only supports PowerShell right now but it's just a wrapper over `git` commands. A PR converting the boiler plate to Bash or other would be welcome.

## Install

```powershell
git clone https://github.com/benallred/mob
Add-Content $profile "`n. `"$pwd\mob\mob.ps1`""
. $profile
```

## Usage

### Start or continue work

```
mob go <branch>
mob go # if not on master
```

Creates and/or switches to branch and pushes to origin.

### Pass off work

```
mob next
```

Creates a WIP commit and pushes to origin.

### Consolidate work so far into a commit

```
mob squash <message>
```

Squashes WIP commits using the given message and includes the individual authors as co-authors on the squashed commit.

## Usage Example

### Dev 1

```powershell
mob go some-feature
<work>
mob next
```

### Dev 2

```powershell
mob go some-feature
<work>
mob next
```

### Dev 1

```powershell
mob go
<work>
mob squash "A good commit"
<work>
git commit -am "Another good commit"
<work>
mob next
```

### Dev 2

```powershell
mob go
<work>
mob squash "Last good commit"
git checkout master
git merge some-feature
git push
```
