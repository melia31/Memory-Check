# Memory-Check
My first bash scripting. Cheers :)

#!/bin/bash
#Exercise 1. Bash Scripting.

#To get the total memory (in MB) and used memory (in percentage)
TOTAL_MEMORY=$( free -m | grep Mem: | awk '{print $2}' )
USED_MEMORY=$( free | grep Mem: | awk '{print $3/$2 *100}' )
USED_MEMORY=${USED_MEMORY%%.*}

echo "Total Memory is $TOTAL_MEMORY MB"
echo "Used Memory is $USED_MEMORY percent"
echo -e "\n"

#Validate the given parameters

if [ $# -eq 0 ]
then
	echo -e  "Enter value for Critical (-c), Warning (-w) and email (-e)."
exit 100

else

#to get the input for the parameters

while getopts ":c:w:e:" opt; do
 case $opt in
 
  c) critical="$OPTARG" ;;
  w) warning=$OPTARG;;
  e) email="$OPTARG" ;;
  
  \?) echo -e " parameter ";;
  
 esac
done
fi

if ("$warning" -gt "$critical")
echo "Invalid Input, Warning threshold should be less than the Critical threshold"

else if(("$USED_MEMORY" -ge "$warning")) || (("$USED_MEMORY" -lt "$critical")); then 
  echo "WARNING"
  
 exit 1

 fi
 
 if (("$USED_MEMORY" -ge "$critical")); then
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 10 >/tmp/top_proccesses.txt
file=/tmp/top_proccesses.txt
datetime=$(date +%Y%m%d" "%H":"%M)
echo "CRITICAL" | mail -s "$datetime memory check -critcal" -a "$file" "$email"

exit 2

else if ( ("$USED_MEMORY" -lt "$warning" ))

exit 0

fi
