# shcode
some pieces shell code from work.

#### hackssh.sh                         
ssh use /etc/hosts file to transform host to real ip,but when we have multi remote host with the same hostname,we have to edit hosts file everytime. so i write this sh file to hack ssh using anothoer file ,e.g /etc/hosts_finance to loopup host-ip pair.
you can then user alias command to alia this sh to let'ssay ssh2 for easy using.

