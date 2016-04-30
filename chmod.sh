#!/bin/sh
for i in $(seq 0 $#)
do
 # Ubah hak akses
 find "${!i}" -type d -exec chmod 755 {} \;
 find "${!i}" -type f -exec chmod 644 {} \;
done
