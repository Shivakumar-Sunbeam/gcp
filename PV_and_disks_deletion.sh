disk_array=($(kubectl get pv -o=custom-columns=Name:metadata.name,Status:status.phase,Disk:spec.gcePersistentDisk.pdName | grep "Available" | awk '{print $3}'))
pv_array=($(kubectl get pv -o=custom-columns=Name:metadata.name,Status:status.phase,Disk:spec.gcePersistentDisk.pdName | grep "Available" | awk '{print $1}'))

# Delete PV resources 
for element in "${pv_array[@]}"
do
   echo "Deleting PV ${element}"
   kubectl delete pv ${element}
done
# Deleting Disks
for element in "${disk_array[@]}"
do
   echo "Deleting Disk ${element}"
   zone=$(gcloud compute disks list --format=yaml --limit=1 --filter="NAME:${element}" | grep "zone:" | awk '{print $2}')
   gcloud compute disks delete $element --zone=$zone --quiet
done
