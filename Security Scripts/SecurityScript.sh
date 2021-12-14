#!/bin/bash

#This command is used to get the current date and input it into the today variable so I can use it
#when making the log file.
today=$(date '+%a-%b-%e-%R-%F')

#exec is used to execute the tee command so it can make a file in the home directory using the 
#date variable in the name so it's easier to keep track of when the file was made. Also the 
#2>&1 is used to capture the input of the file up to the 1>&2 at the end of the file.
exec > >(tee "$HOME/Security_Log_$today.log") 2>&1

#This is a red flag for me because I'm usually asleep between these times, so if any logins
#happened during these times it would be suspicous.
echo "Activity from Midnight to 9 AM"
#First I use the last command and then a -i so I can see the ip addresses, then I pipe it to
#grep so I can sort the output of last to get the times between midnight to 9AM. After that
#I sort the output for easier readibility and then use uniq -c to see if there are any repeats
#of a line.
last -i | grep "0[0-9]:[0-9][0-9] -" | sort | uniq -c 

#These blank echos are used to add spaces between the next set of commands for easier readibility.
echo ""
#This is a red flag for me because I'm the only one who has the login information to my server
#so if anybody logged in that was from an outside IP that would be suspicous.
echo "Logins Not From Me"
#This is similar to my previous command except I use grep -v 192.168.220.1 to search for lines
#that don't contain my ip address.
last -i | grep -v "192.168.220.1"  | sort | uniq -c

echo ""
#This is a red flag because no one outside of myself should be trying to login to my server
#so I filtered out my out IP to see any failed attempts.
echo "Failed Login Attempts Not From Me"
#For this command I use sudo lastb which gets the failed login attemps and then sorts it to
#find lines that don't contain my ip address so I easily find sketchy IPs.
sudo lastb | grep -v "192.168.220.1" | sort | uniq -c

echo  ""
echo "Changes made to /etc/"
#First I used the find command combined with -type f to find all of the files in the directory
#then I use the -exec md5sum {}\; to make a hash of all the files in the directory. After that
#I pipe it into another md5sum so it's just 1 hash instead of a bunch of them, and then finally 
#I use the cut command to make cut off the end of the hash line which is what makes it 1 hash
#line.
echo "Original Hash: d8300d2b2a1e8e8087defd3c89d8bde2" 
sudo find /etc -type f -exec md5sum {} \; | md5sum | cut -d ' ' -f 1

#This is the end of the capturing of inputs.
1>&2
