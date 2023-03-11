#!/bin/bash
# Coded by Yuval Arviv

# Function to check if an FTP server is reachable
function check_ftp_server {
  if nc -w 5 -z $1 21 &>/dev/null; then
    return 0
  else
    return 1
  fi
}

# Function to check if an SFTP server is reachable
function check_sftp_server {
  if nc -w 5 -z $1 22 &>/dev/null; then
    return 0
  else
    return 1
  fi
}

# Prompt user to select file(s) to copy
read -p "Enter the filename(s) you wish to copy (separated by spaces): " file_names

# Prompt user to specify destination
echo "Where do you want to move the files?"
echo "1. Local directory"
echo "2. Another server using SFTP"
echo "3. Another server using FTP"
read -p "Enter your choice [1-3]: " choice

# Execute command based on user's choice
case $choice in
  1)
    read -p "Enter the destination directory: " dest_dir
    cp $file_names $dest_dir
    echo "Files copied to $dest_dir"
    ;;
  2)
    read -p "Enter the SFTP server address: " server_address
    read -p "Enter the SFTP username: " username
    read -s -p "Enter the SFTP password: " password
    echo ""
    read -p "Enter the destination directory: " dest_dir

    # Check if SFTP server is reachable
    if check_sftp_server $server_address; then
      # Copy files using SFTP
      sftp $username@$server_address << EOF
        cd $dest_dir
        put $file_names
        bye
EOF
      echo "Files copied to $server_address:$dest_dir"
    else
      echo "Error: Could not connect to SFTP server."
    fi
    ;;
  3)
    read -p "Enter the FTP server address: " server_address
    read -p "Enter the FTP username: " username
    read -s -p "Enter the FTP password: " password
    echo ""
    read -p "Enter the destination directory: " dest_dir

    # Check if FTP server is reachable
    if check_ftp_server $server_address; then
      # Copy files using FTP
      ftp -n $server_address << EOF
        user $username $password
        cd $dest_dir
        put $file_names
        bye
EOF
      echo "Files copied to $server_address:$dest_dir"
    else
      echo "Error: Could not connect to FTP server."
    fi
    ;;
  *)
    echo "Invalid choice. Please try again."
    ;;
esac
