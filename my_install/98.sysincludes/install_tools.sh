#
#
#
#  Usage:
#  your_command &
#  progress_indicator $!
#
#  Example:
#  sleep 3 | tee -a $log_file &
#  progress_indicator $!


# Progress indicator
spinner() {
    local pid=$1
    local delay=0.1
    local animation_rotate='|/-\'
    local animation_heartbeat='_ - ^ -'
    local animation=$animation_rotate
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${animation#?}
        printf " (${gui_green_bold}%c${gui_default})" "$animation"
        local animation=$temp${animation%"$temp"}
        sleep $delay
        printf "\b\b\b\b"
    done
    printf "    \b\b\b\b"
}
progress_indicator() {
	local PID=$1
	spinner $PID
	wait $PID
	echo 
}
