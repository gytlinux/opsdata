# 服务器硬件信息查询命令

机器基本信息查询

```
dmidecode | grep "Product Name"###查看机器型号

hostname ###查看主机名

dmidecode -t bios ###查看bios信息 system、baseboard、chassis、processor、memory、cache、connector、slot

dmidecode |grep 'Serial Number'###查看所有序列号,第一个序列号为机器序列号

dmidecode -s system-serial-number ###查看机器序列号,和上条命令第一个序列号显示的一样

dmidecode -q###查看所有有用的信息,包括内存位置、BIOS、system信息、SN号等信息

lsb_release -a 
cat /etc/issue
cat /etc/issue.net 
cat /etc/redhat-release ###查看操作系统版本信息

```

查看cpu信息

```

lscpu ###查看cpu信息(支持rhel6)

cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c ###查看CPU型号主频核数

cat /proc/cpuinfo | more

cat /proc/cpuinfo |grep "physical id"|sort |uniq|wc -l###查看CPU个数

cat /proc/cpuinfo| grep "cpu cores"| uniq ###查看每个物理CPU中core的个数(即核数)

cat /proc/cpuinfo| grep "processor"| wc -l###查看逻辑CPU的个数

dmidecode | grep -i CPU###查看CPU个数、型号

dmidecode -t processor###查看cpu个数和位置

```

看内存信息

```

dmidecode -t memory###查看内存信息,内存位置

dmidecode | grep -A 16 "Memory Device$" |grep Size:|grep -v "No Module Installed"|awk '{print "*" $2,$3}'|uniq -c ###查看内存条数

dmidecode|grep -P -A5 "Memory/s+Device"|grep Size|grep -v Range###查看单个内存大小,内存总个数

dmidecode | grep -A16 "Memory Device$"###查看内存个数大小、每个内存的位置、SN和PN号等详细信息

free -m###查看内存大小

查看硬盘信息

fdisk -l###查看逻辑硬盘大小

smartctl -a /dev/sda(做raid不适用)###查看硬盘品牌型号

lsblk###查看硬盘和分区分布

hdparm -i /dev/sda (做raid不适用,会报错)###查看指定硬盘型号

fdisk -l | grep Disk | grep sd ###查看磁盘个数(包括san存储磁盘)

cd /dev/disk/by-id ###此目录里可查看磁盘的wwid号,wwid相当于网卡的mac一样,用来标识磁盘,是独一无二的

cd /dev/disk/by-uuid###查看磁盘的uuid号

```

查看raid信息

```

cat /proc/scsi/scsi ###查看raid卡型号、硬盘品牌型号

dmesg |grep -i raid ###查看raid信息、级别

cat /proc/scsi/mptsas###查看硬raid cat /proc/mdstat###查看软raid

cat /sys/block/sda/device/model

udevadm info --query=all --name=sda --attribute-walk|grep -i "raid_level"###查看raid级别

```

查看网卡信息

```

ifconfig -a ###查看IP地址信息

lspci | grep -i eth ###查看网卡硬件个数型号

ethtool eth0 ###查看eth0网卡接口详细信息

```

查看HBA卡信息

```

lspci | grep -i fibre 或者dmesg|grep -i hba ###查看有几个FC HBA卡

ls /sys/class/fc_host/ ###查看有几个FC HBA卡

cat /sys/class/fc_host/host[4-5]/port_name ###列出4和5光纤卡的wwwn号wwwn号是16位数的

cat /proc/scsi/qla2xxx ###查看HBA卡型号,适用于AS4和SuSE Linux 9

cat /sys/class/fc_host/host*/port_name ###查看HBA卡型号、wwn号,适用于rhel5 6 7和SuSE Linux 10

cat /sys/class/fc_host/host*/port_state###查看HBA卡状态是否在线,适用于rhel5 6 7和SuSE Linux 10

```

查看PCI信息

```

lspci ###查看pci信息,即主板所有硬件槽信息。

lspci -v###查看pci详细信息,即主板所有硬件槽信息。

```

查看iNode和block信息

```

dumpe2fs /dev/sda2|egrep -i "block count|inode count"

其他信息

netstat -rn

netstat -in

tail -f /var/log/messages

cat /var/log/messages

cat /var/log/secure

top

iostat -d 2

ps -aux

df -h

vmstat 2 10

vgs

vgdisplay

```


