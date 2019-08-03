@ECHO OFF

ECHO Deploying updates to GitHub...

REM Build the project.
hugo
REM Go To Public folder
cd public
REM Add changes to git.
git add .
REM Commit changes.
SET msg="rebuilding site %DATE%"
if NOT "%1"=="" (
    SET msg=%1
)
git commit -m "$msg"
REM Push source and build repos.
git push origin master
cd ..