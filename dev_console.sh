#!/bin/bash

cn='\033[0m'
cg='\033[1;49;32m'

function create_header  {
echo
echo -e "${cg}--------------------- $1 -------------------"
echo
}

function initialization {
clear
echo
echo
echo -e "${cg}  Initializing Dev Commander!"
[ ! -d "issues" ] && mkdir -p issues && echo "  Creating issues directory"
echo -e "  Ready to go!"${nc}
sleep 1 
clear
}


function main_menu {
echo
create_header "Welcome to DEV Commander"
echo -e '  Options:'
echo -e '  n: new       t: todo    p:progess        d:done'
echo -e '  f: find      h: help    q:exit '
echo
echo -e '  Select an option and PRESS Enter'
echo
}

function create_issue {
  clear
  create_header "Create new issue"
  read -p "  Name:" issue_name
  read -p "  URL:" issue_url
  issue_file="issues/$issue_name/$issue_name.dnote"
  mkdir "issues/$issue_name"
  touch $issue_file
  echo '[ISSUE]' $issue_name &>> $issue_file
  echo '[DATE]' $(date) &>> $issue_file
  echo '[URL]' $issue_url &>> $issue_file
  echo '[STATUS] TODO' &>> $issue_file 
  echo "" &>> $issue_file
  echo "" &>> $issue_file
  echo "" &>> $issue_file
  echo  
  echo
  echo '[ANALYSIS]' &>> $issue_file
  echo
  echo "  Succesfully Created file! You can start writing on it!"
  echo
  echo -e '  Select and option and PRESS Enter'
  echo "  1:Open $issue_name"
  echo "  2:Back to main menu"
  echo
  read -p "  >>>" opt
  if [ "$opt" == "1" ]; then
   vim $issue_file
  fi
}

function open_issue {
  clear	
  create_header "Issue selection"
  local count=0
  local issues=()
  for entry in "$(pwd)/issues"/*
  do
    local file_name=$(basename $entry) 
    local status=$(grep "\[STATUS\] .*" issues/$file_name/$file_name.dnote)
    if [ "$status" == "[STATUS] $1" ]; then	  
      local file_name=$(basename $entry)
      issues+="$file_name"      
      echo "  $file_name  $(grep "\[STATUS\] .*" issues/$file_name/$file_name.dnote)"
      count=$count+1
    fi
  done
   if [ "$count" == "0" ]; then
	 echo "No Issues $1 found. Returning to main menu"
	 sleep 2
	 return 
   fi
      
   echo
   echo "  Write Issue name and PRESS Enter. Back: r"
   echo
   local open_issue
   read -p "  >>>" open_issue
   if [ "$open_issue" == "r" ]; then 
     return
   elif [[ " $issues{[@]} " =~ "$open_issue" ]]; then 
     vim "issues/$open_issue/$open_issue.dnote"
   else
     clear	   
     echo	   
     echo -e "  Issue $open_issue  not found"
     sleep 2
     open_issue $1 
   fi   
}

function find_issue {
  clear	
  create_header "Find issue"
  local issues
  local issues_validation=()
  local find_pattern
  local issue
  echo
  echo -e "Write Pattern: "
  read -p "  >>>" find_pattern
  readarray  issues <<< "$(grep -rnw 'issues/' -e "$find_pattern")"
  echo
  for entry in "${issues[@]}"
   do
      entry=${entry/"\n"/""}
      entry=$(sed -r 's/(.*)\/(.*)\/(.*)/\3/' <<<  "$entry")
      issues_validation+=($(sed -r s/".dnote".*/""/g <<< "$entry"))
      entry=${entry/".txt"/""}
      echo "  $entry"
  done
  if [ "${#issues_validation[@]}" == 0 ]; then
   echo "  No issue found using $find_pattern"
   sleep 2
   return
  fi
  echo
  echo "  Select issue. PRESS (r) to return to main menu."
  echo  
  read -p "  >>>" issue
  if [ "$issue" == "r" ]; then 
     return
   elif [[ "${issues_validation[@]}" =~ "$issue" ]]; then 
     vim "issues/$issue/$issue.dnote"
   else
     clear	   
     echo	   
     echo -e "  Issue $issue  not found"
     sleep 2
     find_issue 
   fi 
}

initialization
while :
do	
 clear
 issue_file=""
 opt=""
 main_menu
 read -p '  >>> ' opt
 if [ "$opt" == "n" ]; then
   create_issue
 elif [ "$opt" == "p" ]; then
   open_issue "PROGRESS" 
 elif [ "$opt" == "t" ]; then 
   open_issue "TODO"
 elif [ "$opt" == "d" ]; then
   open_issue "DONE"	
 elif [ "$opt" == "f" ]; then
   find_issue	 
 elif [ "$opt" == "q" ]; then
   exit 0    	 
 elif [ "$opt" == "h" ]; then
   echo "Go to help URL"   	 
  else
   echo "  Please use a valid option"
   sleep 1
 fi
done
