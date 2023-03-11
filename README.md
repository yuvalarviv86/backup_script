# Backup Script
This script is let you copy files from your local Linux to 
a another server or a local directory.

# How it's working
1) The script prompts the user to select file(s) to copy.

2) The script prompts the user to specify the destination, either a local directory or another server using SFTP or FTP.

3) The script executes the appropriate command to copy the files to the specified destination based on the user's choice.

4) If the user chooses to copy the files to another server, the script checks if the server is reachable before attempting to copy the files.

5) If the server is not reachable, the script prints an error message indicating that it could not connect to the server.
