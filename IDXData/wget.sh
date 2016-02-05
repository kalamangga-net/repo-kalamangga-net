#!/bin/bash

# Konfigurasi
REPO_DIR="/local/mirror"
REPO_APP="IDXData"
REPO_URL="http://www.idxdata.co.id"
REPO_TMP="$REPO_DIR/tmp"

# Pid
mkdir -p $REPO_TMP
PIDFILE="$REPO_TMP/$REPO_APP.pid"

# Cek pid, hentikan proses jika ada
if [ -e "${PIDFILE}" ] && (ps -u $(whoami) -opid= |
                           grep -P "^\s*$(cat ${PIDFILE})$" &> /dev/null); then
  echo "Already running."
  exit 99
fi

# Sinkronisasi, simpan dalam log
mkdir -p $REPO_DIR/$REPO_APP
cd $REPO_DIR/$REPO_APP
wget -m -nH -t 1 -w 1 $REPO_URL > $REPO_TMP/$REPO_APP.log 2>&1 &

# Bersihkan index.html yang terbentuk
for i in `find $REPO_DIR/$REPO_APP/ -name "index.html"`
do
 rm $i
done

# Isi pid
echo $! > "${PIDFILE}"
chmod 644 "${PIDFILE}"
