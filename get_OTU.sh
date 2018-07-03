#!/bin/bash

echo 'type file name' 
read A

sed s/:/_/g $A |  awk '$3 >= 95 && $4 >= 150 { print $0}'  > $A.filegood

./APIPE -i $A.filegood -j RDP_1 -o $A.filegood_OTU -n 1



