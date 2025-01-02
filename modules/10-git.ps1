function Invoke-GitRewriteHistory_ResetAuthors {
    [alias("git-reset-authors")]param()
    git rebase -r --root --exec "git commit --amend --no-edit --reset-author"
}