#!/bin/bash

#I use the command inotifywait to monitor (-m) the server constantly and then I use -t so it 
#monitors all of the subdirectories also. Finally I use the -e to watch events, ie. someone
#creates a file or modifys a file in the /usr/sbin directory.
inotifywait -m -r -e create,modify /usr/sbin

#Also you can use the keys ctrl + alt + f2 to open a new terminal window so this command
#can be running constantly. Then you can use the command stat (path_to/file) to see what 
#changes have been made.
