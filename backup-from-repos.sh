#!/bin/bash

BACKUP_FROM_REPOS="backup-from-repos"

TMP_BACKUP_FROM_REPOS=/tmp/$BACKUP_FROM_REPOS
ZIP_OUTPUT_FOLDER=$HOME/$BACKUP_FROM_REPOS
PUBLIC_ZIP_OUTPUT_FOLDER=$ZIP_OUTPUT_FOLDER/public
PRIVATE_ZIP_OUTPUT_FOLDER=$ZIP_OUTPUT_FOLDER/private

HELP_CMD="--help"
PUBLIC_CMD="public"
PRIVATE_CMD="private"
ALL_CMD="all"

function main {
	if [ -z "$1" ] || [[ "$1" == "$HELP_CMD" ]]; then
        help_message
    elif [[ "$1" == "$PUBLIC_CMD" ]]; then
        backup_public
    elif [[ "$1" == "$PRIVATE_CMD" ]]; then
        backup_private
    elif [[ "$1" == "$ALL_CMD" ]]; then
        backup_all
    else
        command_not_found $1
    fi
}

function backup_public {
	echo -e "Starting to backing up your public repos from GitHub."

	if [ -z "$GITHUB_USERNAME" ]; then
		read -p "Your GitHub user: " GITHUB_USERNAME
	fi

	echo -e "Hitting GitHub API to get all public repos for account '$GITHUB_USERNAME'..."

	local public_repos_payload=$(curl https://api.github.com/users/$GITHUB_USERNAME/repos 2>/dev/null)

	if [[ "Not Found" == "$(echo "$public_repos_payload" | grep -o '"message": "[^"]*' | grep -o '[^"]*$')" ]]; then
		echo -e "$BACKUP_FROM_REPOS: error: Could not found '$GITHUB_USERNAME' user in GitHub."
		echo -e "$BACKUP_FROM_REPOS: error: Please, give a correct GitHub username before continue."

		exit 1
	fi

	local public_repos_full_names=$(echo "$public_repos_payload" | grep -o '"full_name": "[^"]*' | grep -o '[^"]*$')

	if [ -z $public_repos_full_names 2>/dev/null ]; then
		echo -e "User '$GITHUB_USERNAME' does not have any repository in GitHub."
		echo -e "Nothing to do here."

		exit 0;
	fi

	echo -e "Public repos found for account '$GITHUB_USERNAME':\n"

	for public_repo_full_name in $public_repos_full_names
	do
		local public_repo_name=$(echo "$public_repo_full_name" | cut -d/ -f 2)
	   	echo -e "\t$public_repo_name"
	done

	echo -e "\nStarting to clone each repository and zip its content.\n"

	if [ -d $TMP_BACKUP_FROM_REPOS ]; then
		rm -rf $TMP_BACKUP_FROM_REPOS
	fi

	mkdir $TMP_BACKUP_FROM_REPOS
	cd $TMP_BACKUP_FROM_REPOS

	if [ ! -d $PUBLIC_ZIP_OUTPUT_FOLDER ]; then
		mkdir -p $PUBLIC_ZIP_OUTPUT_FOLDER
	fi

	for public_repo_full_name in $public_repos_full_names
	do
		local public_repo_name=$(echo "$public_repo_full_name" | cut -d/ -f 2)

		echo -e "[$public_repo_name]"

		echo -e "Cloning $public_repo_name..."
		git clone https://github.com/$public_repo_full_name.git 2>/dev/null

		echo -e "$public_repo_name has been cloned."
		echo -e "Compressing $public_repo_name..."

		local zip_output_file=$PUBLIC_ZIP_OUTPUT_FOLDER/$public_repo_name.zip
		
		zip -qr $zip_output_file $public_repo_name &> /dev/null
		echo -e "$public_repo_name has been compressed to $zip_output_file.\n"
	done

	rm -rf $TMP_BACKUP_FROM_REPOS

	echo -e "All your public repos from GitHub have been backup."
}

function backup_private {
	if ! source .env 2> /dev/null; then
		echo -e "$BACKUP_FROM_REPOS: error: No .env file found in this folder."
		echo -e "$BACKUP_FROM_REPOS: error: Please, put the .env file in this folder before continue."

		exit 1
	fi

	if [[ "your-fancy-personal-key" == "$GITHUB_PERSONAL_ACCESS_TOKEN" ]]; then
		echo -e "$BACKUP_FROM_REPOS: error: You didn't configured GITHUB_PERSONAL_ACCESS_TOKEN variable in .env file."
		echo -e "$BACKUP_FROM_REPOS: error: Please, configure GITHUB_PERSONAL_ACCESS_TOKEN variable in .env file with your own key before continue."

		exit 1
	fi

	echo -e "Hitting GitHub API to get all private repos from private acess token provided."

	local private_repos_payload=$(curl -H "Authorization: token $GITHUB_PERSONAL_ACCESS_TOKEN" https://api.github.com/user/repos?visibility=private 2>/dev/null)

	if [[ "Bad credentials" == "$(echo "$private_repos_payload" | grep -o '"message": "[^"]*' | grep -o '[^"]*$')" ]]; then
		echo -e "$BACKUP_FROM_REPOS: error: Invalid personal access token credentials."
		echo -e "$BACKUP_FROM_REPOS: error: Please, give a correct GITHUB_PERSONAL_ACCESS_TOKEN in .env file before continue."

		exit 1
	fi

	local private_repos_full_names=$(echo "$private_repos_payload" | grep -o '"full_name": "[^"]*' | grep -o '[^"]*$')

	if [ -z $private_repos_full_names ]; then
		echo -e "Account for provided personal access token does not have any repository in GitHub."
		echo -e "Nothing to do here."

		exit 0;
	fi

	GITHUB_USERNAME=$(echo "$private_repos_payload" | grep -o '"login": "[^"]*' | grep -o '[^"]*$' | head -1)

	echo -e "Private repos found for account '$GITHUB_USERNAME':\n"

	for private_repo_full_name in $private_repos_full_names
	do
		local private_repo_name=$(echo "$private_repo_full_name" | cut -d/ -f 2)
	   	echo -e "\t$private_repo_name"
	done

	echo -e "\nStarting to clone each repository and zip its content.\n"

	if [ -d $TMP_BACKUP_FROM_REPOS ]; then
		rm -rf $TMP_BACKUP_FROM_REPOS
	fi

	mkdir $TMP_BACKUP_FROM_REPOS
	cd $TMP_BACKUP_FROM_REPOS

	if [ ! -d $PRIVATE_ZIP_OUTPUT_FOLDER ]; then
		mkdir -p $PRIVATE_ZIP_OUTPUT_FOLDER
	fi

	for private_repo_full_name in $private_repos_full_names
	do
		local private_repo_name=$(echo "$private_repo_full_name" | cut -d/ -f 2)

		echo -e "[$private_repo_name]"

		echo -e "Cloning $private_repo_name..."
		git clone https://$GITHUB_USERNAME:$GITHUB_PERSONAL_ACCESS_TOKEN@github.com/$private_repo_full_name.git 2>/dev/null

		echo -e "$private_repo_name has been cloned."
		echo -e "Compressing $private_repo_name..."

		local zip_output_file=$PRIVATE_ZIP_OUTPUT_FOLDER/$private_repo_name.zip
		
		zip -qr $zip_output_file $private_repo_name &> /dev/null
		echo -e "$private_repo_name has been compressed to $zip_output_file.\n"
	done

	rm -rf $TMP_BACKUP_FROM_REPOS

	echo -e "All your private repos from GitHub have been backup."
}

function backup_all {
	backup_private
	backup_public
}

function help_message {
    echo -e "A simple script to backup all your GitHub repositories and put then into zips.\n"
    echo -e "Usage: ./backup-from-repos <command>\n"
    echo -e "Available commands:\n"
    echo -e "\t public \tBackup all public repositories for the given user.\n"
    echo -e "\t private \tBackup all public repositories for the given private access token in .env file.\n"
    echo -e "\t all \t\tBackup all repositories, public and private, for the given private access token in .env file.\n"
    echo -e "Type './backup-from-repos --help' to show this info again."
}

function command_not_found {
    if [ -z "$2" ]; then
        echo "$BACKUP_FROM_REPOS: command not found: $1"
    else
        echo "$BACKUP_FROM_REPOS: $1: option not found: $2"
    fi
}

main "$@"

exit 0