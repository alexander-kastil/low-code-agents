# Create a temporary branch from the latest commit
git checkout --orphan latest_branch

# Add all files to the new branch
git add -A

# Commit the files
git commit -am "version 1.0"

# Delete the old branch (usually 'master' or 'master')
git branch -D master

# Rename the new branch to 'master'
git branch -m master

# Force push to update the remote repository
git push -f origin master