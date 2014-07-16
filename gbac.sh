#!/system/bin/sh
# gbac.sh -- A sh/mksh script to backup all GPS related NVM,Log,XML and *.conf files
#----------------------------------------------------------------------
# Author: E:V:A
# Date:	  2014-07-16
# Notes:  This was made to debug raw SiRFstarIV GPS data coming from 
#         the aGSD4t chip, on a Samusng GT-I9100, running KitKat.
# ROM :   SlimKat 4.4.2b4
#----------------------------------------------------------------------
echo -e "\nStarting $0 with PID: $$"
DATE=`date +%G%m%d`
TIME=`date +%H%M%S`

PWDIR=$(pwd)
DATDIR=/data				# The location of: log and NVM files
SYSETC=/system/etc			# The location of: *.conf files
SDCTMP=/sdcard/tmp			# The location of: staging directory used for tar and gz.
GPSTAR="GPS_${DATE}_${TIME}"

# All the files we need:
GPSLOGFILES="AGPSLog.txt BriefLog.txt CLM*.log DetailedLog.txt ee_download_debug.txt sirf_interface_log.txt SLCLog.gp2"
GPSNVMFILES="NVM0 NVM1 NVM2 NVM3 NVM5 NVM6 NVM13"
#GPSNVMFILES=$(eval echo "NVM{0..13}")				    # Not supported in mksh. Instead use...
#GPSNVMFILES=$(eval echo "NVM{$(seq -s , 0 1 13)}")		# ..this, which depend on Busybox "seq".
GPSCONFILES="gps.conf sirfgps.conf"

if [ -d ${SDCTMP} ]
then 
	echo "Using: ${SDCTMP}"
else 
	echo "Temporary directory: ${SDCTMP} doesn\'t exsist."
	echo "Please create directory or modify this script."
	exit 1
fi

echo "Now copying various log files..." 
for GF in ${GPSLOGFILES}
do 
	if [ -e "${DATDIR}/${GF}" ]
	then 
		echo "Found: ${GF}"
		cp -p ${DATDIR}/${GF} ${SDCTMP}/.
	fi
done

echo "Now copying NVM files..." 
for GF in ${GPSNVMFILES}
do 
	if [ -e "${DATDIR}/${GF}" ]
	then 
		echo "Found: ${GF}"
		cp -p ${DATDIR}/${GF} ${SDCTMP}/.
	fi
done

echo "Now copying *.conf files..." 
for GF in ${GPSCONFILES}
do 
	if [ -e "${SYSETC}/${GF}" ]
	then 
		echo "Found: ${GF}"
		cp -p ${SYSETC}/${GF} ${SDCTMP}/.
	fi
done

#echo "Now looking for gps related XML files on system..." 
#echo "These will not be copied, only shown."
#GPSXML=$(find / -iname "*gps*.xml" 2>/dev/null)
#echo "Found these:"
#echo -e "${GPSXML}\n\n"

echo "Now packing up all files in ${SDCTMP} to:  ${GPSTAR}.tar.gz ..."
cd ${SDCTMP}
tar -zcf ${PWDIR}/${GPSTAR}.tar.gz  *
cd ${PWDIR}

echo "Cleaning up ${SDCTMP} directory..."
rm ${SDCTMP}/*

echo "Done."
exit 0
