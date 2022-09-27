#!/bin/bash
echo "
   	         | ------------ |
   	         |   Security   |
    .--.  ---    	Audit   | 
   |o_o |    |   Tool       |
   |:_/ |    | ------------ |
  //   \ \ 
 (|     | )
/'|_   _/'\ 
\___)=(___/
 
 "
 

echo "------------------"
echo "Security Audit Tool"
echo "------------------"
echo " "
echo " "
 
PS3='Please Select a Tool to Run: '
choices=(
   "General Sys Info"
   "Permission Checker"
   "Password Policy "
   "Quit"
)
select choice in "${choices[@]}"
do
   case $choice in
       "${choices[0]}")
         echo " " 
         echo "Security Audit Tool"
         echo "------------------"
	 echo "General Sys Info" 
	 echo "------------------"
	 echo " " 
         echo -e "Hostname:\t\t"`hostname`
         echo -e "uptime:\t\t\t"`uptime | awk '{print $3,$4}' | sed 's/,//'`
         echo -e "Manufacturer:\t\t"`cat /sys/class/dmi/id/chassis_vendor`
         echo -e "Product Name:\t\t"`cat /sys/class/dmi/id/product_name`
         echo -e "Version:\t\t"`cat /sys/class/dmi/id/product_version`
         echo -e "Serial Number:\t\t"`cat /sys/class/dmi/id/product_serial`
         echo -e "Machine Type:\t\t"`vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi`
         echo -e "Operating System:\t"`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`
         echo -e "Kernel:\t\t\t"`uname -r`
         echo -e "Architecture:\t\t"`arch`
         echo -e "Processor Name:\t\t"`awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'`
         echo -e "Active User:\t\t"`w | cut -d ' ' -f1 | grep -v USER | xargs -n1`
         echo -e "System Main IP:\t\t"`hostname -I`
         echo ""
         ;;
       "${choices[1]}")  
         echo " " 
         echo "Security Audit Tool"
         echo "------------------"
	 echo "Permission Checker" 
	 echo "------------------"
	 echo " " 
	# Loads directories for analysis
	for fList in "root" "sys" "etc" "lib" "bin" "sbin" "home" "dev" "var"
	do
   	echo -e $fList permissions are being listed in "/"$fList"fileList.txt"
	#Change directory to one of the directories listed above
        cd "/"$fList"/"
	# List the file permission within the directory outputting them to a file in the / directory
        ls -l -a > "/"$fList"fileList.txt"
	# Goes back to the user home directory
        cd ~ 
	done
	echo -e "The files are located in the / directory"
 
        ;;
       "${choices[2]}")
            echo " " 
        echo "Security Audit Tool"
        echo "------------------"
	echo "Password Policy" 
	echo "------------------"
	echo " " 
	# Extracts the usernames
	getent passwd | while IFS=: read -r name password uid 
	do
	# Displays the username
        echo -e "Username: " $name
	# Displays the password policy per user
               chage -l "$name"
 done

           ;;
       "${choices[3]}")
           break
           ;;
       *)
       echo "invalid option $REPLY"
       ;;
   esac
done
