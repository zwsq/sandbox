#!/bin/bash

#This function gets information of a new system user from the user
prompt_user () {
        message=${1:-"Please enter the account details"}
        echo "$message"
        read -p "Enter username: " user_name
    while check_user "$user_name" ; do
            prompt_user "The chosen username already exists. Please choose another username."
    done
    get_password
}

get_password () {
    message=${1:-"Please choos a strong password and enter"}
    echo "$message"
        read -sp "Enter a password: " user_password
        echo ""
        read -sp "Enter the password again: " user_password_check
        echo ""
    while [ "$user_password" != "$user_password_check" ] ; do
        get_password "The provided password didn't match. Please re-enter the information"
    done
}
# This function checks whether the entered username already exists or not
check_user () {
    grep -q \^${1}\: /etc/passwd && return 0
}

# This function checks if  the entered passwords are the same and then creates a the new system user account and home directory
create_user () {
    prompt_user "Enter new user's details"
    sudo useradd -m $user_name
    echo "${user_name}:$user_password" | sudo chpasswd
    echo "User account for $user_name created successfully"
}

# This function deletes the entered username and home directory
delete_user () {
    read -p "Enter the user to delete: " user_name
    while ! check_user "$user_name" ; do
        echo "User $user_name not found"
        return 1
    done
    sudo userdel -r $user_name
    echo "The user ${user_name} deleted successfully."
}

# This loop keeps displaying the menu to the user
while true ; do
    clear
    echo "ZWSQ user management script"
    echo ""
    echo "1: Create a new user"
    echo "2: Delete a user"
    echo "3: Show all system users"
    echo "4: Exit"
    read -sn1
    case "$REPLY" in
        1) create_user;;
        2) delete_user;;
        3) cat /etc/passwd;;
        4) exit 0;;
        *) echo "The provided option not recognized."
    esac
    echo ""
    read -n1 -p "press any key to continue"
done