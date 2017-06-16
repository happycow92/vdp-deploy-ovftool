#!/bin/bash

# Header

clear

echo -e "***************************************************************\n"
echo -e "           This Script Is Written By Suhas G Savkoor           \n"
echo -e "                       gsuhas@vmware.com                       \n"
echo -e "***************************************************************\n"

# Check for root user

RunUser=root
currentUser=$(whoami)

if [ "$RunUser" != "$currentUser" ]
then
        printf "Run the Script as Root user. Exiting now\n"
else

# Downloading OVF tool from repository

        cd /root

        if ping -q -c 1 -W 1 8.8.8.8 &> /dev/null;
        then
			ovftool --help &> out.txt
			var=$(cat out.txt  | awk '{print $3$4$5}')
			if [ "$var" == "Nosuchfile" ]
			then
				printf "\nOVF Tool Not Present\n"
				printf "Downloading OVF Tool\n"
				wget https://www.dropbox.com/s/wihvc41gzfl7ca8/VMware-ovftool-4.2.0-4586971-lin.x86_64.bundle?dl=0 -O /root/VMware-ovftool-4.2.0-4586971-lin.x86_64.bundle -q
                echo
				
				# Install OVF tool
				printf "Installing OVF Tool\n\n"
				echo -ne '\n' | sudo /bin/sh VMware-ovftool-4.2.0-4586971-lin.x86_64.bundle --eulas-agreed
			else
				printf "\nOVF Tool exists. Not downloading again\n"
			fi
        else
			printf "No network connection. Download OVF tool manually and install it on this appliance"
			exit 1
        fi


# Input parameters
        printf "\nGathering Environment Details\n\n"

        read -p "Enter the name of the datastore where this VDP should reside: " datastore_name
        echo #New Line
        read -p "Enter the network port-group name where VDP appliance must reside: " network_group
        echo #New Line
        read -p "Enter the DNS server IP address: " dns_address
        echo #New Line
        read -p "Enter the VDP server IP address: " management_address
        echo #New Line
		read -p "Enter the VDP server gateway address: " gateway_address
		echo #New Line
		read -p "Enter the VDP server subnet mask: " subnet_mask
		echo #New Line
        read -p "Enter the IP of the vCenter Server in which the appliance should be deployed: " vcenter_address
        echo #New Line
		read -p "Enter the SSO username for the vCenter server this vR will be deployed on: " sso_user
        echo #New Line
        read -p "Enter the password for this SSO user: " sso_password
        echo #New Line
        read -p "Enter the Data Center Name where this VDP should be deployed: " data_center_name
        echo #New Line
        read -p "Enter the cluster name on which VDP should run: " cluster_name
        echo #New Line

# Deployment process

ovftool --acceptAllEulas -ds="$datastore_name" --net:"Isolated Network"="$network_group" --prop:"vami.gateway.vSphere_Data_Protection_6.1"="$gateway_address" --prop:"vami.DNS.vSphere_Data_Protection_6.1"="$dns_address" --prop:"vami.ip0.vSphere_Data_Protection_6.1"="$management_address" --prop:"vami.netmask0.vSphere_Data_Protection_6.1"="$subnet_mask" /root/vSphereDataProtection-6.1.3.ova vi://"$sso_user":$sso_password@$vcenter_address/$data_center_name/host/$cluster_name

fi

rm -f out.txt