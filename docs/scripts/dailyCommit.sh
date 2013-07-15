#!/bin/bash

#logger -i -p local5.warning -t testing "this is the first message warning"
repos="
/opt/data/docs
/opt/data/vimConfig
/opt/openshift/api
"
today=`date +"%Y-%m-%d"`
msg="Daily Commit $today by crontab"
#echo $msg; exit 1
err="\033[31m"
blue="\033[34m"
echo.err() {
  echo -ne "${err}$1"; tput sgr0; echo -n " "
}
echo.blue() {
  echo -ne "${blue}$1"; tput sgr0; echo -n " "
}


gitConfig() {
  echo.blue "* [info] Start config git user info.";echo
  git config --global user.name "$username"
  git config --global user.email "$email"
}

preSetting() {
  #username=`whoami`
  #email="${username}@${HOSTNAME}"
  username="gankkank-${HOSTNAME}"
  email="gankkank@gmail.com"
  git config --list | grep user &> /dev/null || gitConfig
}

runCommit() {
  echo.blue "* [info] Checking repo: $repo."
  echo ""
  echo.blue "* [pull]"
  cd $repo
  git pull
  git add .
  git commit -m "$msg"
  [ $? -eq 1 ] && return 1
  git push
}
preSetting
for repo in $repos
do
  runCommit && echo.blue "* [info] Finish." || echo.err "* [notice] Nothing to commit or err occured."
  echo ""
done
