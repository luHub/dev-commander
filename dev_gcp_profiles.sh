#!/bin/bash

cn='\033[0m'
cg='\033[1;49;32m'
cb='\033[1;34m'
cy='\033[1;33m'
cr='\033[1;31m'

function create_header {
  echo
  echo -e "${cg}--------------------- $1 -------------------${cn}"
  echo
}

function create_profile {
  echo
  create_header "Create New GCP Profile"
  read -p " Profile name (e.g., local-emulator, dev, prod): " prof_name
  if [ -z "$prof_name" ]; then
    echo -e "\n ${cr}Profile name cannot be empty.${cn}"
    sleep 1
    return
  fi

  read -p " GCP Project ID (e.g., my-app-dev or dummy-emulator): " proj_id
  read -p " Account email (leave blank for local emulator): " acct_email

  echo -e "\n ${cg}Creating and activating configuration '$prof_name'...${cn}"
  gcloud config configurations create "$prof_name" --quiet >/dev/null 2>&1 || gcloud config configurations activate "$prof_name" --quiet >/dev/null 2>&1

  if [ -n "$proj_id" ]; then
    gcloud config set project "$proj_id" --quiet >/dev/null 2>&1
  fi

  if [ -n "$acct_email" ]; then
    gcloud config set account "$acct_email" --quiet >/dev/null 2>&1
  else
    gcloud config unset account --quiet >/dev/null 2>&1
  fi

  echo -e " ${cg}Done! Switched to '$prof_name'.${cn}"
  sleep 1
}

function switch_project_in_active {
  echo
  create_header "Fetch & Set GCP Project"
  echo -e " ${cy}Fetching available GCP projects...${cn}"
  
  local projects=()
  local index=1
  while IFS= read -r proj <&3; do
    [ -z "$proj" ] && continue
    projects+=("$proj")
    echo -e " ${cg}$index)${cn} $proj"
    ((index++))
  done 3< <(gcloud projects list --format="value(projectId)" 2>/dev/null | sort)

  if [ ${#projects[@]} -eq 0 ]; then
    echo -e " ${cr}No projects found or not authenticated.${cn}"
    read -p " Enter a custom Project ID manually (or press Enter to cancel): " manual_proj
    if [ -n "$manual_proj" ]; then
      gcloud config set project "$manual_proj" --quiet >/dev/null 2>&1
      echo -e " ${cg}Project set to $manual_proj.${cn}"
    fi
    sleep 1
    return
  fi

  echo
  read -p " Select project number (or type a custom Project ID): " p_opt
  if [[ "$p_opt" =~ ^[0-9]+$ ]] && [ "$p_opt" -ge 1 ] && [ "$p_opt" -le "${#projects[@]}" ]; then
    local chosen="${projects[$((p_opt-1))]}"
    gcloud config set project "$chosen" --quiet >/dev/null 2>&1
    echo -e "\n ${cg}Active project updated to '$chosen'.${cn}"
    sleep 1
  elif [ -n "$p_opt" ]; then
    gcloud config set project "$p_opt" --quiet >/dev/null 2>&1
    echo -e "\n ${cg}Active project updated to '$p_opt'.${cn}"
    sleep 1
  fi
}

function browse_gcp_profiles {
  local filter=""

  while :
  do
    clear
    create_header "GCP Profile & Project Navigator"

    local active_prof active_proj active_acct
    active_prof=$(gcloud config configurations list --filter="is_active=true" --format="value(name)" 2>/dev/null)
    active_proj=$(gcloud config get-value project 2>/dev/null)
    active_acct=$(gcloud config get-value account 2>/dev/null)

    echo -e " Active Profile : ${cy}${active_prof:-none}${cn}"
    echo -e " Active Project : ${cb}${active_proj:-unset}${cn}"
    echo -e " Active Account : ${active_acct:-none (emulator/local)}"
    if [ -n "$filter" ]; then
      echo -e " Filter         : ${cb}*${filter}*${cn}"
    fi
    echo
    echo -e " Options: ${cg}[number]${cn} Switch profile | ${cg}n${cn}: New profile | ${cg}p${cn}: Change project | ${cg}d${cn}: Delete profile | ${cg}f${cn}: Filter | ${cg}c${cn}: Clear | ${cg}q${cn}: Exit"
    echo " --------------------------------------------------------------------------------------------------"

    local profiles=()
    local index=1

    # Format output as: name|is_active|account|project
    while IFS='|' read -r name is_active account project <&3; do
      [ -z "$name" ] && continue

      local search_blob="$name $account $project"
      if [ -n "$filter" ]; then
        if ! echo "$search_blob" | grep -iq "$filter"; then
          continue
        fi
      fi

      profiles+=("$name")

      local status_tag=""
      if [ "$is_active" == "True" ]; then
        status_tag=" ${cy}[ACTIVE]${cn}"
      fi

      local display_proj="${project:-<no-project>}"
      local display_acct="${account:-<no-account/emulator>}"

      echo -e " ${cg}$index)${cn} ${cb}${name}${cn} — Project: ${cy}${display_proj}${cn} (${display_acct})${status_tag}"
      ((index++))
    done 3< <(gcloud config configurations list --format="value[separator='|'](name,is_active,account,properties.core.project)" 2>/dev/null | sort)

    if [ ${#profiles[@]} -eq 0 ]; then
      echo " (No matching GCP profiles found)"
    fi

    echo
    read -p " >>> " opt

    if [ "$opt" == "q" ]; then
      clear
      exit 0
    elif [ "$opt" == "f" ]; then
      echo
      read -p " Enter search text to filter profiles/projects: " filter
    elif [ "$opt" == "c" ]; then
      filter=""
    elif [ "$opt" == "n" ]; then
      create_profile
    elif [ "$opt" == "p" ]; then
      switch_project_in_active
    elif [ "$opt" == "d" ]; then
      echo
      read -p " Enter profile number to delete: " del_idx
      if [[ "$del_idx" =~ ^[0-9]+$ ]] && [ "$del_idx" -ge 1 ] && [ "$del_idx" -le "${#profiles[@]}" ]; then
        local target_del="${profiles[$((del_idx-1))]}"
        if [ "$target_del" == "$active_prof" ]; then
          echo -e "\n ${cr}Cannot delete the currently active profile. Switch first.${cn}"
        else
          gcloud config configurations delete "$target_del" --quiet >/dev/null 2>&1
          echo -e "\n ${cg}Deleted profile '$target_del'.${cn}"
        fi
      else
        echo -e "\n ${cr}Invalid profile number.${cn}"
      fi
      sleep 1
    elif [[ "$opt" =~ ^[0-9]+$ ]] && [ "$opt" -ge 1 ] && [ "$opt" -le "${#profiles[@]}" ]; then
      local selected="${profiles[$((opt-1))]}"
      echo -e "\n ${cg}Switching to GCP profile '$selected'...${cn}"
      gcloud config configurations activate "$selected" --quiet >/dev/null 2>&1
      sleep 1
    else
      echo -e "\n Please select a valid number or option."
      sleep 1
    fi
  done
}

if ! command -v gcloud >/dev/null 2>&1; then
  echo -e "${cr}Error: gcloud CLI is not installed or not in PATH.${cn}"
  exit 1
fi

browse_gcp_profiles
