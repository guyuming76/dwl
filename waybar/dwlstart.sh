#!/bin/sh

#fname="$HOME"/.cache/dwltags$1
fname="$HOME"/.cache/dwltags
#TODO: https://github.com/Alexays/Waybar/issues/1538

gentoo-pipewire-launcher &
fcitx5 -d
waybar &

while 
	read line; do echo $line >> ${fname} ; 
	
	# get the size of file in kb, if it is greater than 100, keep only the last 50 lines
	#https://unix.stackexchange.com/questions/299106/how-keep-last-50-lines-in-logfile
	
	#TODO: we don't have to check the file size every time we have a new line, maybe we can use some trick to improve the performance
        #if we can use one dwltag file for one instance of waybar, we can just keep a in-memory counter for lines readed here and truncate the file if the counter goes large.

	IFS=' ' read -ra lsResultLine <<< $(ls -sk ${fname})
	if [ $((lsResultLine[0])) -gt 100 ]; then 
		echo "$(tail -n 50 ${fname})" > ${fname}
	fi
done
