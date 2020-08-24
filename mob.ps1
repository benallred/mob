function mob(
    [Parameter(Mandatory)]
    [ValidateSet("go", "next", "squash")]
    [string]
    $Command,
    [Parameter(ValueFromRemainingArguments)]
    $Rest) {
    $wipMessage = "WIP"
    function getRestArg([int]$position, [string]$argDescription, [switch]$optional) {
        if ($Rest.length -gt $position) {
            return $Rest[$position]
        }
        elseif ($optional) {
            return $null
        }
        else {
            throw "Usage:`n`tmob $Command <$argDescription>"
        }
    }
    if ($Command -eq "go") {
        $branch = getRestArg 0 -optional
        if (!$branch) {
            $branch = git rev-parse --abbrev-ref HEAD
            if ($branch -eq "master") {
                throw "Usage:`n`tmob $Command <branch>`nor`n`tgit checkout not-master`n`tmob $Command"
            }
        }
        if (git branch -a -l origin/$branch) {
            git checkout $branch
            git pull
        }
        else {
            git checkout -b $branch
            git push -u origin $branch
        }
    }
    elseif ($Command -eq "next") {
        git add -A
        git commit -m $wipMessage
        git push
    }
    elseif ($Command -eq "squash") {
        $message = getRestArg 0 "commit message"
        $squashFrom = 0
        while ((git log -1 --pretty=format:%B HEAD~$squashFrom) -eq $wipMessage) {
            $squashFrom++
        }
        $coAuthoredBy = git log --pretty=format:"%nCo-authored-by: %an <%ae>" HEAD~$squashFrom.. | select -u
        git reset --soft HEAD~$squashFrom
        git add -A
        git commit -m "$message`n`n$coAuthoredBy"
        git push --force-with-lease
    }
}
