#!/bin/bash

my_array=($(gcloud compute disks list --filter="-users:*" | grep NAME | awk '{print $2}'))
my_array_length=${#my_array[@]}
echo " Total no of disks that would be deleted : ${my_array_length} "
for element in "${my_array[@]}"
do
   echo "Deleting Disk ${element}"
   zone=$(gcloud compute disks list --format=yaml --limit=1 --filter="NAME:${element}" | grep "zone:" | awk '{print $2}')
   gcloud compute disks delete $element --zone=$zone --quiet
done
