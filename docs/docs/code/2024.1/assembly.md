# Assembly

## ch395_check_exist

***Description***

Checks if ch395 exists


***Example***

```ca65
 jsr ch395_get_glob_int_status
 cmp #CH395_DETECTED
 beq ch395_connected
 rts
ch395_connected:
```


***Modify***

* Accumulator 

***Returns***

* Accumulator : Returns #CH395_DETECTED if it exists



## ch395_clear_recv_buf_sn

***Description***

Clear receive buffer

***Input***

* Accumulator : Socket id

***Modify***

* Accumulator 
* Y Register 

***Example***

```ca65
 lda #CH395_SOCKET1 ; Socket ID
 jsr ch395_clear_recv_buf_sn
```



## ch395_close_socket_sn

***Description***

Close socket

***Input***

* Accumulator : The id of the socket to close

***Modify***

* Y Register 

***Example***

```ca65
 lda #$01 ; Socket ID
 jsr ch395_close_socket_sn
```



## ch395_dhcp_enable

***Description***

Enable or not dhcp

***Input***

* Accumulator : The mode to activate DHCP mode

***Modify***

* X Register 


## ch395_get_cmd_status

***Description***

Get cmd status


***Example***

```ca65
 jsr ch395_get_cmd_status
 ; Check A for STATUS
 rts
```


***Modify***

* Accumulator 


## ch395_get_dhcp_status

***Description***

Get dhcp status


***Example***

```ca65
 jsr ch395_get_dhcp_status
 ; Check A for dhcp status
 rts
```


***Modify***

* Accumulator 


## ch395_get_glob_int_status

***Description***

Get General interrupt Status


***Modify***

* Accumulator 

***Example***

```ca65
 jsr ch395_get_glob_int_status
 ; check accumulator to get interrupts states
```



## ch395_get_ic_ver

***Description***

Get ch395 firmware version


***Example***

```ca65
 jsr ch395_get_ic_ver
 ; Check A for version
 rts
```


***Modify***

* Accumulator 


## ch395_get_int_status_sn

***Description***

Check interrupt socket status

***Input***

* Accumulator : Socket id

***Modify***

* Accumulator 
* X Register 

***Returns***

* Accumulator : Status of selected socket


***Example***

```ca65
 lda #CH395_SOCKET1 ; Check socket 1
 jsr ch395_get_int_status_sn
 ; Check interrupt type
 rts
```



## ch395_get_ip_inf

***Description***

Get ip info

***Input***

* Accumulator : the ptr to modify
* X Register : the ptr to modify

***Modify***

* Accumulator 
* X Register 
* Y Register 


## ch395_get_mac_adress

***Description***

Get mac address

***Input***

* Accumulator : the ptr
* X Register : the ptr

***Modify***

* Accumulator 
* X Register 
* Y Register 

***Returns***

* Accumulator : the content of ptr modified

* X Register : the content of ptr modified



## ch395_get_phy_status

***Description***

Get physical status


***Modify***

* Accumulator 

***Returns***

* Accumulator : The physical status


***Example***

```ca65
 jsr ch395_get_phy_status
 ; Check A physical status
 rts
```



## ch395_get_recv_len_sn

***Description***

Get the length received from socket

***Input***

* Accumulator : Socket id

***Example***

```ca65
 lda #$01 ; Socket 1
 jsr ch395_get_recv_len_sn
 ; check A and X for length received
ch395_connected:
```


***Modify***

* Accumulator 
* X Register 

***Returns***

* Accumulator : The length

* X Register : The length



## ch395_get_remot_ipp_sn

***Description***

Get remote ip connected to the socket

***Input***

* Accumulator : The Socket for the ip to get
* X Register : The ptr (high) to store the ip
* Y Register : The ptr (low) to store the ip

***Modify***

* Accumulator 
* X Register 
* Y Register 


## ch395_get_socket_status_sn

***Description***

Returns in A socket status (close/open ...)

***Input***

* Accumulator : Socket id

***Modify***

* X Register 
* Accumulator 

***Returns***

* Accumulator : The status

* X Register : The state


***Example***

```ca65
 lda #$01 ; Socket 1
 jsr ch395_get_socket_status_sn
 ; check A and X for the state
```



## ch395_init

***Description***

Initialize ch395


***Modify***

* Accumulator 
***Description***

Reset ch395


***Example***

```ca65
 jsr ch395_init
 ; Wait a bit
```



## ch395_open_socket_sn

***Description***

Open socket from arg

***Input***

* Accumulator : Socket id

***Modify***

* Y Register 


## ch395_read_recv_buf_sn

***Input***

* Accumulator : Socket id


## ch395_reset_all

***Description***

Reset ch395


***Example***

```ca65
 jsr ch395_reset_all
 ; Wait a bit
```



## ch395_retran_period

***Description***

Retran period

***Input***

* Accumulator : Period 
* X Register : Period 

***Modify***

* Y Register 

***Example***

```ca65
 lda #$FF
 ldx #$FF
 jsr ch395_retran_period
 rts
```



## ch395_set_des_port_sn

***Description***

Set dest port socket

***Input***

* Accumulator : Socketid 
* Y Register : Low int
* X Register : high int

***Example***

```ca65
 lda #$01
 ldx #80
 ldx #$00
 jsr ch395_set_des_port_sn
 rts
```



## ch395_set_fun_para

***Description***

Set fun para

***Input***

* Accumulator : Value 

***Modify***

* Y Register 
* Accumulator 


## ch395_set_gwip_addr

***Description***

Set gateway ip addr



## ch395_set_ip_addr

***Description***

Set ip row



## ch395_set_ip_addr_sn

***Description***

Set Socket Ip address to connect with

***Input***

* Accumulator : Socket id


## ch395_set_ipraw_pro_sn

***Description***

Set ipraw protocol on socket

***Input***

* Accumulator : Socket id


## ch395_set_mac_adress

***Description***

Set mac address



## ch395_set_proto_type_sn

***Input***

* Accumulator : Socket id


## ch395_set_retran_count

***Description***

Set retran period

***Input***

* Accumulator : Retran period


## ch395_set_sour_port_sn

***Input***

* Accumulator : Socket id


## ch395_tcp_connect_sn

***Input***

* Accumulator : Socket id


## ch395_tcp_disconnect_sn

***Input***

* Accumulator : Socket id


## ch395_tcp_listen_sn

***Description***

TCP listen socket



## ch395_write_send_buf_sn

***Description***

Send data to socketid

***Input***

* Accumulator : Socket ID
* Y Register : Low length
* X Register : High length


