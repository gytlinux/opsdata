# vsftpd配置

* **anonymous_enable=NO**  //设置是否允许匿名用户登录FTP服务器。默认为YES  

* **local_enable=YES**  //是否允许本地用户登录FTP服务器。默认为NO

* **write_enable=YES**  //是否对登录用户开启写权限。属全局性设置。默认NO

* **ftp_username=ftp**  //定义匿名用户的账户名称，默认值为ftp。

* **local_umask=077**  //设置本地用户新增文档的umask，默认为022，对应的权限为755。umask为022，对应的二进制数为000 010 010，将其取反为111 101 101，转换成十进制数，即为权限值755，代表文档的所有者（属主）有读写执行权，所属组有读和执行权，其他用户有读和执行权。022适合于大多数情 况，一般不需要更改。若设置为077，则对应的权限为700。

* **anon_umask=022**   //设置匿名用户新增文档的umask。默认077

* **file_open_mode=0755** //设置上传文档的权限。权限采用数字格式。 默认0666

* **anon_world_readable_only=YES**  //匿名用户是否允许下载可阅读的文档，默认为YES。

* **anon_upload_enable=YES**  //是否允许匿名用户上传文件。只有在write_enable设置为YES时，该配置项才有效。而且匿名用户对相应的目录必须有写权限。默认为NO。

* **anon_mkdir_write_enable=YES**  //是否允许匿名用户创建目录。只有在write_enable设置为YES时有效。且匿名用户对上层目录有写入的权限。默认为NO。

* **anon_other_write_enable=NO**   //若设置为YES，则匿名用户会被允许拥有多于上传和建立目录的权限，还会拥有删除和更名权限。默认值为NO。

* **dirmessage_enable=YES**  //设置是否显示目录消息。若设置为YES，则当用户进入特定目录（比如/var/ftp/linux）时，将显示该目录中的由message_file配置项指定的文件（.message）中的内容。

* **xferlog_enable=YES**  //是否启用上传/下载日志记录。默认为NO

* **connect_from_port_20=YES**  // 默认值为YES，指定FTP数据传输连接使用20端口。若设置为NO，则进行数据连接时，所使用的端口由ftp_data_port指定。

* **chown_uploads=YES**  //用于设置是否改变匿名用户上传的文档的属主。默认为NO。若设置为YES，则匿名用户上传的文档的属主将被设置为chown_username配置项所设置的用户名。

* **chown_username=whoever**  //设置匿名用户上传的文档的属主名。只有chown_uploads=YES时才有效。建议不要设置为root用户。 但系统默root

* **xferlog_file=/var/log/xferlog**  //设置日志文件名及路径。需启用xferlog_enable选项

* **xferlog_std_format=YES**   //日志文件是否使用标准的xferlog日志文件格式（与wu-ftpd使用的格式相同） 。默认为NO

* **idle_session_timeout=600**  //设置多长时间不对FTP服务器进行任何操作，则断开该FTP连接，单位为秒，默认为600秒。即设置发呆的逾时时间，在这个时间内，若没有数据传送或指令的输入，则会强行断开连接。

* **data_connection_timeout=120**  //设置建立FTP数据连接的超时时间，默认为300秒。

* **nopriv_user=ftpsecure**

* **async_abor_enable=YES**

* **ascii_upload_enable=YES** //设置是否启用ASCII模式下载数据。默认为NO。

* **ascii_download_enable=YES**  //设置是否启用ASCII模式上传数据。默认为NO。

* **ftpd_banner=Welcome to blah FTP service.**  //该配置项用于设置比较简短的欢迎信息。若欢迎信息较多，则可使用banner_file配置项。

* **deny_email_enable=YES**

* **banned_email_file=/etc/vsftpd/banned_emails**

* **chroot_local_user=YES**  // 用于指定用户列表文件中的用户，是否允许切换到上级目录。默认NO

* **allow_writeable_chroot=YES**  

* **local_root=/home/export/ftp**  //设置本地用户登录后所在的目录。默认配置文件中没有设置该项，此时用户登录FTP服务器后，所在的目录为该用户的主目录，对于root用户，则为/root目录。

* **anon_root=/var/ftp**  //设置匿名用户登录后所在的目录。若未指定，则默认为/var/ftp目录。

* **chroot_list_enable=YES**  // 设置是否启用chroot_list_file配置项指定的用户列表文件。设置为YES则除了列在j/etc/vsftpd/chroot_list文件中的的帐号外，所有登录的用户都可以进入ftp根目录之外的目录。默认NO

* **chroot_list_file=/etc/vsftpd/chroot_list**  // 用于指定用户列表文件，该文件用于控制哪些用户可以切换到FTP站点根目录的上级目录。

* **ls_recurse_enable=YES**  //若设置为YES，则允许执行“ls –R”这个命令，默认值为NO。在配置文件中该配置项被注释掉了，与此类似的还有一些配置，需要启用时，将注释符去掉并进行YES或NO的设置即可

* **listen=YES|NO** //设置vsftpd服务器是否以standalone模式运行。以standalone模式运行是一种较好的方式，此时listen必须设置为YES， 此为默认值，建议不要更改。很多与服务器运行相关的配置命令，需要此运行模式才有效。若设置为NO，则vsftpd不是以独立的服务运行，要受 xinetd服务的管理控制，功能上会受限制。

* **listen_ipv6=YES|NO**  //#

* **pam_service_name=vsftpd** //设置在PAM所使用的名称，默认值为vsftpd。

* **userlist_enable=YES**  // 决定/etc/vsftpd/user_list文件是否启用生效。YES则生效，NO不生效。

* **userlist_deny=YES**  // 决定/etc/vsftpd/user_list文件中的用户是允许访问还是不允许访问。若设置为YES，则/etc/vsftpd/user_list 文件中的用户将不允许访问FTP服务器；若设置为NO，则只有vsftpd.user_list文件中的用户，才能访问FTP服务器。

* **tcp_wrappers=YES**  //用来设置vsftpd服务器是否与tcp wrapper相结合，进行主机的访问控制。默认设置为YES，vsftpd服务器会检查/etc/hosts.allow和/etc /hosts.deny中的设置，以决定请求连接的主机是否允许访问该FTP服务器。这两个文件可以起到简易的防火墙功能。

* **port_enable=YES**  //开启 FTP 主动模式

* **pasv_enable=YES** //若设置为YES，则使用PASV工作模式；若设置为NO，使用PORT模式。默认为YES，即使用PASV模式。

* **pasv_max_port=40000** //设置在PASV工作方式下，数据连接可以使用的端口范围的上界。默认值为0，表示任意端口。

* **pasv_min_port=50000** //设置在PASV工作方式下，数据连接可以使用的端口范围的下界。默认值为0，表示任意端口。

* **pasv_address=123.206.81.163**  //被动模式下，服务器的公网 IP 地址，注意将此处的地址改为服务器实际的公网 IP。

* **accept_timeout=60**  //设置建立被动（PASV）数据连接的超时时间，单位为秒，默认值为60。

* **no_anon_password=YES** //匿名用户登录时是否询问口令。设置为YES，则不询问。默认NO

* **anon_max_rate=0**  //设置匿名用户所能使用的最大传输速度，单位为b/s。若设置为0，则不受速度限制，此为默认值。

* **local_max_rate=0**   // 设置本地用户所能使用的最大传输速度。默认为0，不受限制。

* **user_config_dir=/etc/vsftpd/userconf** //用于设置用户配置文件所在的目录。设置了该配置项后，当用户登录FTP服务器时，系统就会到/etc/vsftpd/userconf目录下读取与当前用户名相同的文件，并根据文件中的配 置命令，对当前用户进行更进一步的配置。比如，利用用户配置文件，可实现对不同用户进行访问的速度进行控制，在各用户配置文件中，定义 local_max_rate配置，以决定该用户允许的访问速度。


* **max_clients=0**  //设置vsftpd允许的最大连接数，默认为0，表示不受限制。若设置为150时，则同时允许有150个连接，超出的将拒绝建立连接。只有在以standalone模式运行时才有效。

* **max_per_ip=0**  // 设置每个IP地址允许与FTP服务器同时建立连接的数目。默认为0，不受限制。通常可对此配置进行设置，防止同一个用户建立太多的连接。只有在以standalone模式运行时才有效。

* **listen_address=IP地址**  //设置在指定的IP地址上侦听用户的FTP请求。若不设置，则对服务器所绑定的所有IP地址进行侦听。只有在以standalone模式运行时才有效。 对于只绑定了一个IP地址的服务器，不需要配置该项，默认情况下，配置文件中没有该配置项。若服务器同时绑定了多个IP地址，则应通过该配置项，指定在哪 个IP地址上提供FTP服务，即指定FTP服务器所使用的IP地址。注意：设置此值前后，可以通过netstat -tnl对比端口的监听情况


* **connect_timeout=60** // PORT方式下建立数据连接的超时时间，单位为秒。

* **setproctitle_enable=NO|YES**   //设置每个与FTP服务器的连接，是否以不同的进程表现出来，默认值为NO，此时只有一个名为vsftpd的进程。若设置为YES，则每个连接都会有一个vsftpd进程，使用“ps -ef|grep ftp”命令可查看到详细的FTP连接信息。安全起见，建议关闭。


* **ftp_data_port=20**  //设置PORT方式下FTP数据连接所使用的端口，默认值为20。

* **text_userdb_names=NO**  //设置在执行ls命令时，是显示UID、GID还是显示出具体的用户名或组名称。默认为NO，以UID和GID方式显示，若希望显示用户名和组名称，则设置为YES。


## **注**

* 如果设置chroot，必须设置allow_writeable_chroot = YES或用命令chmod a-w /home/user去除用户主目录的写权限，否则登录报错500 OOPS: vsftpd: refusing to run with writable root inside chroot ()  从2.3.5之后，vsftpd增强了安全检查，如果用户被限定在了其主目录下，则该用户的主目录不能再具有写权限了！如果检查发现还有写权限，就会报该错误。

* 主动模式port下的 FTP 服务器可以通过 Windows 操作系统 “命令提示符” 窗口的 ftp 命令，成功登录并使用 FTP 服务。但使用资源管理器或浏览器则无法访问，因为它们默认使用被动模式的 FTP。要想使用资源管理器或浏览器访问 FTP 服务器，还需要为 vsFTPd 设置被动模式pasv。

* vsftpd防火墙设置

firewalld防火墙系统

```
port模式
firewall-cmd --add-service ftp --permanent
firewall-cmd --reload

pasv模式
firewall-cmd --add-port=[pasv_min_port]-[pasv_max_port]/tcp --permanent
firewall-cmd --reload

```

iptables防火墙

```
port模式
iptables -I INPUT -p tcp --destination-port 20:21 -j ACCEPT

pasv模式
iptables -I INPUT -p tcp --destination-port [pasv_min_port]:[pasv_max_port] -j ACCEPT

```
