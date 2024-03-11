#!/usr/bin/bash


#
gui_default="\e[0m"
gui_white_bold="\e[1;37m"
gui_red_bold="\e[1;31m"
gui_red="\e[0;31m"
gui_green_bold="\e[1;32m" # ${gui_green_bold}
gui_green="\e[0;32m" # ${gui_green}
gui_blue_bold="\e[1;34m"
gui_blue="\e[0;34m"
gui_reset="\e[0m"


#
export debug=0 # will pause between 80.wip-steps
export rebootnow=0
export system_code=""
export system_product_name=$(dmidecode -s system-product-name)
export current_build="%current_build%"
export current_rhel_version="%current_rhel_version%"
export install_root=/opt/my_install
configs_root=$install_root/50.configs
scripts_todo=$install_root/70.todo
scripts_wip=$install_root/80.wip
scripts_done=$install_root/90.done
install_incl=$install_root/98.sysincludes
log=$install_root/99.logs
script_pending=""
work_todo=0
#


#
source $install_incl/install_tools.sh


#
# Registered values for system_product_name so far:
#  **to be completed by us for all laptops we have in he pool of Linux developers**
#
#  ...........................................................................................
#  : system-product-name                             : keywords used below : System code     :
#  ..........................................................................................:
#  : 11AWS07900                                      : AWS                 : test_debug      :
#  : HP ZBook Fury 16 G9 Mobile Workstation PC       : ZBook G9            : zbook_g9        :
#  : HP ZBook Fury 16 G10 Mobile Workstation PC      : ZBook G10           : zbook_g10       :
#  : *Any other value                                : n/a                 : not_defined     :
#  :.................................................:.....................:.................:
#
if   [[ "${system_product_name}" == *"AWS"*                                              ]]; then
  system_code="debug_file"
elif [[ "${system_product_name}" == *"ZBook"*  &&  "${system_product_name}" == *"G9"*    ]]; then
  system_code="zbook_g9"
elif [[ "${system_product_name}" == *"ZBook"*  &&  "${system_product_name}" == *"G10"*   ]]; then
  system_code="zbook_g10"
else
  system_code="not_defined"
fi


#
echo -e "${gui_green}..........${gui_green_bold}${current_build}${gui_green}: Installation details:${gui_default}"
echo -e "${gui_green}:${gui_default}"
echo -e "${gui_green}:${gui_default}  Machine . . . . :  ${system_product_name}"
echo -e "${gui_green}:${gui_default}  System code . . :  ${system_code}"
echo -e "${gui_green}:${gui_default}  Software  . . . :  ${current_rhel_version}"
echo -e "${gui_green}:${gui_default}  Build . . . . . :  ${current_build}"
if [ ${debug} -eq 1 ]; then
	echo -e "${gui_green}:${gui_default}  Debug mode  . . :  ${gui_white_bold}ON${gui_white_bold}."
fi
echo -e "${gui_green}:${gui_default}"
echo -e "${gui_green}..........${gui_green_bold}${current_build}${gui_green}: These installations will be executed:${gui_default}"
echo -e "${gui_green}:${gui_default}"
for entry in "$scripts_todo"/*
do
    if [ -f "$entry" ]; then
    	((work_todo++))
    	entry=$(basename "$entry")
        echo -e "${gui_green}:${gui_default}  >> $entry"
    fi
done
if [ "$work_todo" -eq 0 ]; then
		echo -e "${gui_green}:${gui_default} (none)"
fi
for entry in "$scripts_wip"/*
do
    if [ -f "$entry" ]; then
		echo -e "${gui_green}:${gui_default}"
		echo -e "${gui_green}:.........But ${gui_green_bold}this${gui_green} installation will be executed first/again:${gui_default}"
		echo -e "${gui_green}:${gui_default}"
    	((work_todo++))
    	script_pending=$(basename "$entry")
        echo -e "${gui_green}:${gui_default}  ${gui_white_bold}>>${gui_default} $script_pending"
    fi
done
if [ "$work_todo" -ne 0 ]; then
		echo -e "${gui_green}:${gui_default}"
		echo -e "${gui_green}:.........Ready to run the installation steps, press ${gui_green_bold}Enter${gui_green} to continue...${gui_default}"
		echo 
		read -p ""
else
	echo ":.........hmmmm, wait a minute: I should not be experiencing this ..."
fi


#
if [ -n "$script_pending" ]; then
	source $install_incl/install_onescript.sh
   	((work_todo--))
fi
for entry in "$scripts_todo"/*
do
    if [ -f "$entry" ]; then
    	script_pending=$(basename "$entry")
    	source $install_incl/install_onescript.sh
	   	((work_todo--))
    fi
done


# 
if [ "$work_todo" -eq 0 ]; then
	echo ""
    echo -e "${gui_green}:${gui_default}"
    echo -e "${gui_green}:${gui_default}  /opt/install/install.sh: Surely I am not needed here anymore; removed myself from /root/.bashrc ..."
    echo -e "${gui_green}:${gui_default}                           We will reboot and after reboot it is expected you should see a logon screen."
    echo -e "${gui_green}:${gui_default}                           ==> Press ${gui_green_bold}ENTER${gui_default} to continue, or ^C to stop and prevent a reboot ..."
    echo -e "${gui_green}:${gui_default}"
    echo -e "${gui_green}:${gui_default}                           (After you press enter, installation files and configuration files will be removed from disk."
    echo -e "${gui_green}:${gui_default}                            The only way to get back to this phase is to insert the stick, boot it and start over)"
    echo -e "${gui_green}:${gui_default}"
    echo -e "${gui_green}:${gui_default}                           --> info of this install? check ${gui_white_bold}${log}/*${gui_default}"
    echo -e "${gui_green}:${gui_default}"
    echo -e "${gui_green}:.......................${gui_default}"
    read -p ""
    sed -i '/install/d' /root/.bashrc
	source $install_incl/install_cleanup.sh
    reboot
fi
