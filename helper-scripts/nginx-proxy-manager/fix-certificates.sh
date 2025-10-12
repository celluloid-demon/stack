#!/bin/bash

cert_fix() { 

   archive=${1/live/archive}
   archive=${archive/.pem/*.pem}
   archive=$(find $archive -type f | tail -n 1)

   if [ -z "$archive" ]; then

      echo "Cannot find valid $1 in archive"

   else

      new_file="$1"
      archive="../../$archive"
      echo "Creating link for $new_file - $archive"
      cp $1 "$1.bak"
      rm "$1"
      ln -s $archive $new_file
      
   fi

}

export -f cert_fix

find live/*/*.pem -type f -xtype f -exec bash -c 'cert_fix "$0"' {} \;
