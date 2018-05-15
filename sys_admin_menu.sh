#!/bin/bash
#Author:Sanket Jabade 
#Date:4/3/2017
#Linux Project:sysadmin_menu.sh: Runs when the user logs in. User context is only in this menu.

#Function to pause and wait till user hits the Enter Key.
pause(){
	read -p "Press [Enter] key to continue..." fackEnterKey
}
#Function for user administration
user(){
	echo "-------------------------------------------------------------------------------------------------"
        echo "------------------------------You have entered User Administration-------------------------------"
        echo "-------------------------------------------------------------------------------------------------"
	echo "			A. Add a user"
	echo "			B. Delete a user"
	echo "			C. Change user GECOS name"
	echo "			D. Lock user account"
	echo "			E. Go back to the previous menu"
	echo "-------------------------------------------------------------------------------------------------"
	read -p "Enter your choice [A-E]:" ch
	case $ch in
		A) echo -n "Enter the username for new user:"
		   read name
		   getent passwd $name > /dev/null
		   if [ $? -ne 0 ]; then
		   	echo -n "Enter full name for that user:"
		   	read fname
		   	adduser --home /home/$name --shell /bin/bash --gecos "$fname" $name
		   	echo "User $name successfully added"
			sleep 5
			clear
		   	user
		   else
		   	echo "The user $name already exists"
			sleep 5
			clear
			user
		   fi
		;;
		B) echo -n "Enter username for deletion:"
		   read name
		   getent passwd $name > /dev/null
		   if [ $? -eq 0 ]; then
		   	userdel -r $name
		   	echo "The user $name has been successfully deleted"
			sleep 5
			clear
			user
		   else
		   	echo "The user $name does not exist"
			sleep 5
			clear
			user
		   fi
		;;
		C) echo -n "Enter username of the user whose GECOS name needs to be changed:"
                   read name
		   getent passwd $name > /dev/null
		   if [ $? -eq 0 ]; then
		   	echo -n "Enter the new GECOS name for $name:"
		   	read gec
		   	usermod -c "$gec" $name
		   	echo "GECOS name for $name has been successfully changed"
			sleep 5
			clear 
		   	user
		   else
			echo "The user $name does not exist"
			sleep 5
			clear
			user
		   fi
		;;
		D) echo -n "Enter username whose account needs to be locked:"
                   read name
		   getent passwd $name > /dev/null
		   if [ $? -eq 0 ]; then
		   	passwd -l $name
		   	echo "Account for $name has been locked"
			sleep 5
			clear
		   	user
		   else
			echo "The user $name does not exist"
			sleep 5
			clear
			user
		   fi
		;;
		E) echo "Exiting..."
		   pause
		;;
		*) echo "Error..Invalid option"
		   sleep 5
		   clear
		   user
	esac
}
#Function for service management
services(){
	echo "-------------------------------------------------------------------------------------------------"
        echo "-------------------------------You have entered Service Management-------------------------------"
        echo "-------------------------------------------------------------------------------------------------"
	echo "			L. List all active daemon services"
	echo "			E. Enable a service"
	echo "			D. Disable a service"
	echo "			S. Start a service"
	echo "			T. Stop a service"
	echo "			R. Restart a service"
	echo "			B. Go back to the previous menu"
	echo "-------------------------------------------------------------------------------------------------"
	read -p "Enter your choice [L|E|D|S|T|R|B]:" ch
	case $ch in
		L) echo "Listing all active daemon services..."
		   printf "\n"
		   systemctl list-unit-files | more
#		   initctl list
		   sleep 5
		   printf "\n"
		   services
		;;
		E) echo "Enter the name of the service to enable"
		   read name
		   echo "Enabling service $name..."
		   printf "\n"
		   systemctl enable $name
		   sleep 5
		   printf "\n"
		   services
		;;
		D) echo "Enter the name of the service to disable"
		   read name
		   echo "Disabling service $name..."
		   printf "\n"
		   systemctl disable $name
		   sleep 5
		   printf "\n"
		   services
		;;
		S) echo "Enter the name of the service to start"
		   read name
		   echo "Starting service $name..."
		   printf "\n"
		   systemctl start $name
		   sleep 5
		   printf "\n"
		   services
		;;
		T) echo "Enter the name of the service to stop"
		   read name
		   echo "Stopping service $name..."
		   printf "\n"
		   systemctl stop $name
		   sleep 5
		   printf "\n"
		   services
		;;
		R) echo "Enter the name of the servce to restart"
		   read name
		   echo "Restarting service $name..."
		   printf "\n"
		   systemctl restart $name
		   sleep 5
		   printf "\n"
		   services
		;;
		B) echo "Exiting..."
		   pause
		;;
		*) echo "Error..Invalid option"
		   sleep 5
		   clear
		   services
	esac 
}
#Function for network administration
network(){
	echo "-------------------------------------------------------------------------------------------------"
	echo "-----------------------------You have entered Network Administration-----------------------------"
	echo "-------------------------------------------------------------------------------------------------"
	echo "          Network Menu:				     Network Configuration Menu:"
	echo "	L. List network interface information	H. Assign hostname"
	echo "	D. Down an interface			N. Assign DNS information"
	echo "	U. Up an interface			I. Assign static IP address & gateway information"
	echo "	R. Restart a network interface		Y. Assign DHCP IP address & gateway information"
	echo "				B. Go back to the previous menu                                        "
	echo "-------------------------------------------------------------------------------------------------"
	read -p "Enter your choice [L|D|U|R|H|D|I|Y|B]:" ch
	case $ch in
		L) printf "Listing network interfaces...\n"
		   ip link show
		   sleep 5
		   printf "\n"
		   network
		;;
		D) echo -n "Enter the interface name (eth0|lo):"
		   read iface
		   out=$(/sbin/ifconfig -a | tr " " : | cut -d : -f1 | xargs -n 1 | grep $iface)
		   if [[ $? -eq 0 ]]; then
        	   	printf "Making $iface down...\n"
			ip link set $iface down
			printf "\nValidating..\n"
			netstat -i
			printf "\nInterface $iface successfully down\n"
			sleep 5
			network
		   else
        		echo "Interface $iface does not exists"
			sleep 5
			network
		   fi
		;;
		U) echo -n "Enter the interface name (eth0|lo):"
		   read iface
		   out=$(/sbin/ifconfig -a | tr " " : | cut -d : -f1 | xargs -n 1 | grep $iface)
                   if [[ $? -eq 0 ]]; then
		   	printf "Making interface $iface up...\n"
		   	ip link set $iface up
		   	printf "\nValidating..\n"
		   	netstat -i
		   	printf "\nInterface $iface is successfully up\n"
		   	sleep 5
		   	network
		   else
			echo "Interface $iface does not exist"
			sleep 5
			network
		   fi
		;;
		R) echo -n "Enter the interface name (eth0|lo):"
		   read iface
		   out=$(/sbin/ifconfig -a | tr " " : | cut -d : -f1 | xargs -n 1 | grep $iface)
                   if [[ $? -eq 0 ]]; then
		   	printf "Restarting interface $iface...\n"
		   	ip link set $iface down && ip link set $iface up
			printf "\nValidating..\n"
		   	netstat -i
		   	printf "\nInterface $iface restarted successfully\n"
		   	sleep 5
		   	network
		   else
			echo "Interface $iface does not exist"
			sleep 5
			network
		   fi
		;;
		H) printf "The current hostname is "
		   hostname
		   echo -n "Enter the new hostname:"
		   read hname
		   printf "\nChanging hostname to $hname...\n"
		   hostname $hname
		   printf "Hostname succesfully changed to "
		   hostname
		   sleep 5
		   network
		;;
		N) echo -n "Enter the IP address for DNS name-server:"
		   read ip
		   if expr "$ip" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
  		   	for i in 1 2 3 4; do
    				if [ $(echo "$ip" | cut -d. -f$i) -gt 255 ]; then
      					echo "Invalid: ($ip)"
      					sleep 5
					network
    				fi
  			done
  			echo "nameserver $ip" >> /etc/resolv.conf
  			printf "DNS information updated\n"
			sleep 5
			network
		   else
  			echo "Invalid: ($ip)"
 			sleep 5
			network
		   fi
		;;
		I) echo -n "Enter the name of the interface for which you need to assign static IP:"
		   read iface
		   echo -n "Enter the static IP address:"
		   read ip
                   if expr "$ip" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
                        for i in 1 2 3 4; do
                                if [ $(echo "$ip" | cut -d. -f$i) -gt 255 ]; then
                                        echo "Invalid: ($ip)"
                                        sleep 5
                                        network
                                fi
                        done
			echo -n "Enter the gateway IP address:"
			read gip
			if expr "$gip" : '[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$' >/dev/null; then
                        	for i in 1 2 3 4; do
                                	if [ $(echo "$gip" | cut -d. -f$i) -gt 255 ]; then
                                        	echo "Invalid: ($gip)"
                                        	sleep 5
                                        	network
                                	fi
                        	done
				ifconfig $iface $ip
				route add default gw $gip
                        	printf "Static IP address and gateway updated.\n"
				printf "\nValidating Static IP...\n"
				sleep 1
				ifconfig $iface
				sleep 2
				printf "Validating gateway...\n"
				ip route | grep default
				sleep 5
				network
                   	else
                        	echo "Invalid: ($gip)"
                        	sleep 5
                        	network
                   	fi
		   else
		   	echo "Invalid: ($ip)"
			sleep 5
			network
		   fi
		;;
		Y) printf "Releasing current IP address...\n"
		   dhclient -r
		   printf "\nGetting IP address from DHCP server...\n"
		   dhclient
		   printf "\nValidating IP address from DHCP...\n"
		   ifconfig
		   sleep 5
		   network
		;;
                B) echo "Exiting..."
                   pause
                ;;
                *) echo "Error..Invalid option"
                   sleep 5
                   clear
                   network
        esac 

}
#Function for Sys_Admin_Menu
sys_admin_menu() {
	clear
	echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"
        echo "-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-S Y S - A D M I N - M E N U-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-"
	echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"
	echo "				U) Run User Administration"
	echo "				S) Run Service Management"
	echo "				N) Run Network Administration"
	echo "				Q) Quit"
	echo "~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~"
}
#Invoke the user() when the user select u from the menu option.
#Invoke the network() when the user select n from the menu option.
#Exit when user select q form the menu option.
#Function to get input from user and invoke the respective function else exit.
options(){
#	local choice
	read -p "Enter your choice [U|S|N|Q]:" choice
	case $choice in
		U) user ;;
		S) services ;;
		N) network ;;
		Q) echo "Quittng..."
		   sleep 1
		   exit 0;;
		*) echo -e "Error !!!" && sleep 5
	esac
}
#Trap CTRL+C (SIGINT), CTRL+Z (SIGTSTP), CTRL+D (SIGQUIT) and other possible exit signals.
trap '' SIGINT SIGQUIT SIGTSTP
while true
do
	sys_admin_menu
	options
done
