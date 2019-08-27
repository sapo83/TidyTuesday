#!/bin/bash

less /mnt/NAS/yinlab/sarah/A.flav.homeobox/ncRNA.analysis/CPC2.res/noncoding.2.ID.list |
while read -r line
do
  echo $line
done
