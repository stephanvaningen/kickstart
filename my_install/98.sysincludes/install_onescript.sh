export log_file=$log/$script_pending-`date +%Y%m%d-%H%M%S-%N`.log


#
echo
echo -e "${gui_green_bold}............... *START* Install ${script_pending}${gui_default}"
if [ -f "$scripts_todo/$script_pending" ]; then
	mv "$scripts_todo/$script_pending" "$scripts_wip/$script_pending"
fi


#
if [ -n "$scripts_wip/$script_pending" ]; then
	export bundle_directory=$configs_root/$script_pending
	/usr/bin/bash "$scripts_wip/$script_pending" | tee -a $log_file
	mv "$scripts_wip/$script_pending" "$scripts_done/$script_pending"
	if [ -f "/tmp/rebootnow.tmp" ]; then
		. /tmp/rebootnow.tmp > /dev/null 2>&1
		rm /tmp/rebootnow.tmp > /dev/null 2>&1
	fi
fi
echo -e "${gui_green}:.............. *END* Install $script_pending${gui_default}"
echo


# Test/Debug
if [ $debug -eq 1 ]; then
	echo ":"
	echo ":  Check logs or background stuff all you want ..."
	echo ":"
	echo ":  Press ENTER to continue"
	read -p ":"
fi


#
if [ $rebootnow -eq 1 ]; then
	echo ""
	echo ":"
	echo ":"
	echo ":............................................................."
	echo ":                                                            :"
	echo -e ":  Press ENTER to ${gui_white_bold}reboot${gui_default} (make sure there is no external     :"
	echo ":          bootable installation medium attached anymore)    :" 
	echo ":............................................................:"
	echo ""
	echo ""
	read -p ""
	reboot
fi
