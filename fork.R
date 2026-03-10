
system("git remote add upstream https://github.com/micdimu/DataManCons.git")

system("git config --global --list")

system("git remote -v")

system("git fetch upstream")

system("git merge upstream/main")

system("git status")
