#!/bin/bash

cd
wget https://github.com/spieglt/whatfiles/releases/download/v1.0/whatfiles_x64
chmod +x whatfiles_x64

#./whatfiles_x64 -p 22473
#./whatfiles_x64 cat /etc/passwd



sudo apt install -y strace
#strace -fe trace=creat,open,openat,unlink,unlinkat cat /etc/spasswd

echo "TERMINÉ"