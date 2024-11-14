# C

## unsigned char ch395_check_exist();

***Description***

Checks if ch395 exists



## void ch395_clear_recv_buf_sn(unsigned char ID_SOCKET)

***Description***

Clear receive buffer



## oid ch395_close_socket_sn(unsigned char socketid)

***Description***

Close socket

***Input***








## unsigned char ch395_get_dhcp_status();

***Description***

Get dhcp status



## unsigned int ch395_get_glob_int_status();

***Description***

Get General interrupt Status



## unsigned char ch395_get_ic_ver();

***Description***

Get ch395 firmware version



## unsigned char ch395_get_int_status_sn(unsigned char ID_SOCKET);

***Description***

Check interrupt socket status

***Input***




## void ch395_get_ip_inf(unsigned char ip_infos[]);

***Description***

Get ip info



## void ch395_get_mac_adress(unsigned char macaddress[]);

***Description***

Get mac address



## unsigned char ch395_get_phy_status();

***Description***

Get physical status



## void ch395_get_recv_len_sn(unsigned char ID_SOCKET)

***Description***

Get the length received from socket

***Input***




## void ch395_get_remot_ipp_sn(unsigned char *ptr, unsigned char socket);

***Description***

Get remote ip connected to the socket

***Input***




## unsigned int ch395_get_socket_status_sn(unsigned char ID_SOCKET);

***Description***

Returns in A socket status (close/open ... )

***Input***




## void ch395_init();

***Description***

Initialize ch395



## void ch395_open_socket_sn(unsigned char ID_SOCKET)

***Input***




## void ch395_read_recv_buf_sn(unsigned char *buffer, unsigned int length,unsigned char ID_SOCKET);

***Input***




## void ch395_reset_all()

***Description***

Reset ch395



## void ch395_retran_period(unsigned int period);

***Description***

Retran period



## void ch395_set_des_port_sn(unsigned int port, unsigned char ID_SOCKET);

***Description***

Set dest port socket

***Input***




## void ch395_set_fun_para(unsigned char flag)

***Description***

Set fun para



***Description***

Set gateway ip addr



***Description***

Set ip addr



## void ch395_set_ip_addr_sn(unsigned char ip_addr[], unsigned char ID_SOCKET)



## void ch395_set_ipraw_pro_sn(unsigned char ID_SOCKET);

***Description***

Set ipraw protocol on socket

***Input***




## void ch395_set_mac_adress(unsigned char macaddress[]);



## void ch395_set_proto_type_sn(unsigned char proto,unsigned char ID_SOCKET)

***Input***




## void ch395_set_retran_count(unsigned int period);

***Description***

Set retran period



## void ch395_set_sour_port_sn(unsigned int port,unsigned char ID_SOCKET)

***Description***

Set source socket

***Input***




## void ch395_tcp_connect_sn(unsigned char ID_SOCKET)

***Input***




## void ch395_tcp_disconnect_sn(unsigned char ID_SOCKET)

***Input***




## void ch395_tcp_listen_sn(unsigned char ID_SOCKET)



## void ch395_write_send_buf_sn(unsigned char *buffer, unsigned int length,unsigned char ID_SOCKET);

***Description***

Send data to socketid

***Input***




