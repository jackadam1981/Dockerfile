@echo off
chcp 65001 > nul
setlocal EnableDelayedExpansion
REM Amend the last commit message

REM Check if the -y flag is provided
IF "%1"=="-y" (
    REM Stage all changes
    git add .

    REM Use the last commit message
    git commit --amend --no-edit
) ELSE (
    REM Stage all changes
    git add .

    REM Prompt the user for a new commit message
    set /p "commitMessage=Enter new commit message: "

    REM Check if the commit message is empty
    IF "!commitMessage!"=="" (
        echo No commit message provided. Exiting.
        exit /b 1
    )

    REM Amend the last commit with the new message
    git commit --amend -m "!commitMessage!"
)

REM Push the amended commit to the remote repository
REM Use --force to overwrite the previous commit
git push --force

echo Commit message amended and pushed successfully.
endlocal