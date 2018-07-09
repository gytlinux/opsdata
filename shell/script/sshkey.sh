#!/bin/bash
#SSH free key transfer

#Connect server IP and root,many IP use Space separation

rpm -q expect &>/dev/null || yum -y install expect &>/dev/null
if [ ! -f $HOME/.ssh/id_rsa.pub ]
then 
/usr/bin/expect<<!
spawn ssh-keygen -t rsa
set timeout 30
expect "id_rsa):"
send "\r"
expect "passphrase):"
send "\r"
expect "passphrase again:"
send "\r"
expect eof
!
fi


/usr/bin/expect <<!
spawn ssh $1@$2
set timeout 30
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "\003\r"}
"]# "  { exit }
"]$ "  { exit }
}
spawn ssh-copy-id -i $HOME/.ssh/id_rsa.pub $1@$2
set timeout 30
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "$3\r" }
}
expect { 
"Permission denied, please try again." { send "\003\r" }
"Connection refused" { send "\003\r" }
}
catch wait result
exit [ lindex \$result 3 ]

!

