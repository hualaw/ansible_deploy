#!/bin/sh

echo ">>> checking environments..."

#echo -n "[CONFIRM] Please make sure you want to install deploy_bootstrap. Continue? [y/n] "
#read i
#if [ "$i" != "y" ]
#then
#    exit 1
#fi

echo ">>> install software..."

# exit immediately if any command fails
set -e

echo ">>> check preinst hook..."

if [ -e ./bin/preinst.sh ]; then
    /bin/sh ./bin/preinst.sh
fi

echo ">>> copy data files..."
#rsync -v 

echo ">>> check postinst hook..."

if [ -e ./bin/postinst.sh ]; then
    /bin/sh ./bin/postinst.sh
fi

echo ">>> done."

