# dmidecode 命令

>> 可以让你在Linux系统下获取有关硬件方面的信息。dmidecode的作用是将DMI数据库中的信息解码，以可读的文本方式显示。由于DMI信息可以人为修改，因此里面的信息不一定是系统准确的信息。dmidecode遵循SMBIOS/DMI标准，其输出的信息包括BIOS、系统、主板、处理器、内存、缓存等等。

>> DMI（Desktop Management Interface,DMI）就是帮助收集电脑系统信息的管理系统，DMI信息的收集必须在严格遵照SMBIOS规范的前提下进行。SMBIOS（System Management BIOS）是主板或系统制造者以标准格式显示产品管理信息所需遵循的统一规范。SMBIOS和DMI是由行业指导机构Desktop Management Task Force(DMTF)起草的开放性的技术标准，其中DMI设计适用于任何的平台和操作系统。

>> DMI充当了管理工具和系统层之间接口的角色。它建立了标准的可管理系统更加方便了电脑厂商和用户对系统的了解。DMI的主要组成部分是Management Information Format(MIF)数据库。这个数据库包括了所有有关电脑系统和配件的信息。通过DMI，用户可以获取序列号、电脑厂商、串口信息以及其它系统配件信息。


## 选项

```

dmidecode [options]

-d : (default:/dev/mem)从设备文件读取信息，输出内容与不加参数标准输出相同。
-h : 显示帮助信息。
-s : 只显示指定DMI字符串的信息。(string)
-t : 只显示指定条目的信息。(type)
-u : 显示未解码的原始条目内容。
--dump-bin file : 将DMI数据转储到一个二进制文件中。
--from-dump FILE : 从一个二进制文件读取DMI数据。
-V : 显示版本信息。

```

## 有效参数

* -s 参数string
  - bios-vendor
  - bios-version
  - bios-release-date
  - system-manufacturer
  - system-product-name
  - system-version
  - system-serial-number
  - system-uuid
  - baseboard-manufacturer
  - baseboard-product-name
  - baseboard-version
  - baseboard-serial-number
  - baseboard-asset-tag
  - chassis-manufacturer
  - chassis-type
  - chassis-version
  - chassis-serial-number
  - chassis-asset-tag
  - processor-family
  - processor-manufacturer
  - processor-version
  - processor-frequency

* -t参数type
  - bios
  - system
  - baseboard
  - chassis
  - processor
  - memory
  - Cache
  - connector
  - slot

* type全部编码列表
  - BIOS
  - System
  - Base Board
  - Chassis
  - Processor
  - Memory Controller
  - Memory Module
  - Cache
  - Port Connector
  - System Slots
  - On Board Devices
  - OEM Strings
  - System Configuration Options
  - BIOS Language
  - Group Associations
  - System Event Log
  - Physical Memory Array
  - Memory Device
  - 32-bit Memory Error
  - Memory Array Mapped Address
  - Memory Device Mapped Address
  - Built-in Pointing Device
  - Portable Battery
  - System Reset
  - Hardware Security
  - System Power Controls
  - Voltage Probe
  - Cooling Device
  - Temperature Probe
  - Electrical Current Probe
  - Out-of-band Remote Access
  - Boot Integrity Services
  - System Boot
  - 64-bit Memory Error
  - Management Device
  - Management Device Component
  - Management Device Threshold Data
  - Memory Channel
  - IPMI Device
  - Power Supply
  - Additional Information
  - Onboard Device

## 实例

```
机器信息:
dmidecode | grep "Product Name"###查看机器型号
dmidecode -t bios ###查看bios信息 system、baseboard、chassis、processor、memory、cache、connector、slot
dmidecode |grep 'Serial Number'###查看所有序列号,第一个序列号为机器序列号
dmidecode -s system-serial-number ###查看机器序列号,和上条命令第一个序列号显示的一样
dmidecode -q###查看所有有用的信息,包括内存位置、BIOS、system信息、SN号等信息

CPU信息:
dmidecode | grep -i CPU###查看CPU个数、型号
dmidecode -t processor###查看cpu个数和位置

MEM信息:
dmidecode -t memory###查看内存信息,内存位置
dmidecode | grep -A 16 "Memory Device$" |grep Size:|grep -v "No Module Installed"|awk '{print "*" $2,$3}'|uniq -c ###查看内存条数
dmidecode|grep -P -A5 "Memory/s+Device"|grep Size|grep -v Range###查看单个内存大小,内存总个数
dmidecode | grep -A16 "Memory Device$"###查看内存个数大小、每个内存的位置、SN和PN号等详细信息

```









