# Assembly

---

## ch395_check_exist

***Description***

This command is used to test the communication interface and working state to check whether CH395 is working properly. This command needs to input 1 byte of data, which can be any data. If CH395 is working properly, the output data of CH395 will be the bitwise reverse of the input data. For example, if the input data is 57H, the output data will be A8H.


***Modify***

* Accumulator 

***Returns***

* Accumulator : Returns '#CH395_DETECTED' if it exists


***Example***

```ca65
 jsr ch395_check_exist
 cmp #CH395_DETECTED
 beq ch395_connected
 rts
ch395_connected:
```



---

## ch395_clear_recv_buf_sn

***Description***

This command is used to clear the Socket receive buffer. It is necessary to input 1 byte of Socket index value. Upon receiving this command, CH395 will reset the receiving length of this Socket, and the receiving pointer will point to the buffer head.

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



---

## ch395_close_socket_sn

***Description***

This command is used to close Socket. It is necessary to input a 1 byte of Socket index value. After Socket is closed, the receive buffer and transmit buffer of Socket are emptied, but the configuration information is still reserved, and you just need to open the Socket again when using the Socket the next time. In TCP mode, CH395 will automatically disconnect TCP before turning off Socket.

***Input***

* Accumulator : The id of the socket to close

***Modify***

* Y Register 

***Example***

```ca65
 lda #$01 ; Socket ID
 jsr ch395_close_socket_sn
```



---

## ch395_dhcp_enable

***Description***

This command is used to start or stop DHCP. It is necessary to input a 1-byte flag. If the flag is 1, it will indicate that DHCP is on; if the flag is 0, it will indicate that DHCP is off. CH395 must be initialized before DHCP is started. After DHCP is started, CH395 will broadcast DHCPDISCOVER message to the network to discover DHCP Server, request the address and other configuration parameters after finding DHCP Server, and then generate GINT_STAT_DHCP interrupt. MCU can send GET_DHCP_STATUS command to get DHCP status. If the status code is 0, it will indicate success, and MCU can send the command GET_IP_INF to get IP, MASK and other information. If the status code is 1, it will indicate error, which is generally caused by timeout, for example, no DHCP Server is found. DHCP is always in a working state after startup unless it receives a DHCP shutdown command from MCU. During this process, if DHCP Server reassigns a configuration to CH395 and the configuration is different from the original configuration, CH395 will still generate an interrupt. After timeout interrupt is generated, if DHCP Server is not found, CH395 will continue to send DHCPDISCOVER message at an interval of about 16 seconds. It takes about 20MS to execute this command. MCU can send GET_CMD_STATUS to query whether the execution has finished and the execution status

***Input***

* Accumulator : The mode to activate DHCP mode

***Modify***

* X Register 


---

## ch395_enter_sleep

***Description***

This command enables CH395 chip in a low-power sleep suspended state. When MCU writes a new command to CH395 (no data input command, such as CMD_GET_IC_VER), it will exit the low-power state. For the parallel port and SPI interface communication modes, active SCS chip selection will also cause CH395 to exit the low-power state, so MCU shall immediately disable the SCS chip selection after sending the command CMD_ENTER_SLEEP. In sleep state, MAC and PHY of CH395 will be in power off mode and disconnect Ethernet. Typically, it takes several milliseconds for CH395 to exit the low-power state.

!!! failure "Does not work"


---

## ch395_get_cmd_status

***Description***

This command is used to get the command execution status. CH395 will output 1 byte of data, which is the command execution state. The command execution status is as follows:


***Example***

```ca65
 jsr ch395_get_cmd_status
 ; Check A for STATUS
 rts
```


***Modify***

* Accumulator 


---

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


---

## ch395_get_glob_int_status_all

***Description***

This command is used to get the global interrupt status. CH395 will output 2 bytes of global interrupt status after receiving this command. Global interrupt status is defined as follows:

!!! failure "Does not work"


---

## ch395_get_glob_int_status

***Description***

This command is used to get the global interrupt status. CH395 will output 1 byte of global interrupt status after receiving this command. Global interrupt status is defined as follows:

Bit Name Description

7 GINT_STAT_SOCK3 Socket3 interrupt

6 GINT_STAT_SOCK2 Socket2 interrupt

5 GINT_STAT_SOCK1 Socket1 interrupt

4 GINT_STAT_SOCK0 Socket0 interrupt

3 GINT_STAT_DHCP DHCP interrupt

2 GINT_STAT_PHY_CHANGE PHY status change interrupt

1 GINT_STAT_IP_CONFLI IP conflict

0 GINT_STAT_UNREACH Inaccessible interrupt

① GINT_STAT_UNREACH: Inaccessible interrupt. When CH395 receives ICMP inaccessible interrupt

message, it saves the IP address, port and protocol type of the inaccessible IP packet in the inaccessible

information table, and then generates an interrupt. When the MCU receives the interrupt, it can send the

command GET_UNREACH_IPPORT to get the inaccessible information.

② GINT_STAT_IP_CONFLI: IP conflict interrupt. This interrupt is generated when CH395 detects that its

IP address is the same as that of other network devices in the same network segment.

③ GINT_STAT_PHY_CHANGE: PHY change interrupt. This interrupt is generated when PHY connection

of CH395 changes, for example, PHY state changes from the connected state to the disconnected state or

from the disconnected state to the connected state. MCU can send GET_PHY_STATUS command to get

the current PHY connection status.

④ GINT_STAT_DHCP: DHCP interrupt. If MCU enables DHCP function of CH395, CH395 will generate

this interrupt. MCU can send the command CMD_GET_DHCP_STATUS to get the DHCP status. If the

status is 0, it will indicate success; otherwise, it will indicate timeout failure.

⑤ GINT_STAT_SOCK0 - GINT_STAT_SOCK3: Socket interrupt. When there is an interrupt event in

Socket, CH395 will generate this interrupt. MCU needs to send GET_INT_STATUS_SN to get the

interrupt status of Socket. Please refer to GET_INT_STATUS_SN.

When this command is completed, CH395 will set INT# pin to high level and clear the global interrupt

status


***Modify***

* Accumulator 

***Returns***

* Accumulator : Status 


***Example***

```ca65
 jsr ch395_get_glob_int_status
 ; check accumulator to get interrupts states
```



---

## ch395_get_ic_ver

***Description***

This command is used to get the chip and firmware versions. 1 byte of data returned is the version number, the bit 7 is 0, the bit 6 is 1, and the bits 5-0 are the version number. If the returned value is 41H, remove bits 7 and 6, and the version number will be 01H. It is called chip version in this text


***Modify***

* Accumulator 

***Returns***

* Accumulator : Version 


***Example***

```ca65
 jsr ch395_get_ic_ver
 ; Check A for version
 rts
```



---

## ch395_get_int_status_sn

***Description***

This command is used to get the interrupt status of Socket. It is necessary to input 1 byte of Socket index value. After receiving this command, CH395 will output 1 byte of Socket interrupt code. The interrupt code bits are defined as follows:

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
 and #CH395_SINT_STAT_SEND_OK
 cmp #CH395_SINT_STAT_SEND_OK
 beq @send_ok
 rts
```



---

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
* RESTmp value


---

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
* RESTmp value

***Returns***

* Accumulator : the content of ptr modified

* X Register : the content of ptr modified



---

## ch395_get_phy_status

***Description***

This command is used to get PHY connection status. After receiving this command, CH395 will query the current PHY connection status and output 1-byte PHY connection status code: PHY is disconnected when the connection status code is 01H; PHY connection is 10M full duplex when the connection status code is 02H; PHY connection is 10M half duplex when the connection status code is 04H. PHY connection is 100M full duplex when the connection status code is 08H; PHY connection is 100M half duplex when the connection status code is 10H


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



---

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



---

## ch395_get_remot_ipp_sn

***Description***

This command is used to get the remote IP address and port number. It is necessary to input 1 byte of Socket index value. CH395 will output 4 bytes of IP address and 2 bytes of port number (low bytes in front). After Socket works in TCP Server mode and the connection is established, MCU can get the remote IP address and port number through this command

***Input***

* Accumulator : The Socket for the ip to get
* X Register : The ptr (high) to store the ip
* Y Register : The ptr (low) to store the ip

***Modify***

* Accumulator 
* X Register 
* Y Register 
* RES

***Example***

```ca65
 lda #$01 ; Socket 1
 ldx #<ip_dest
 ldy #>ip_dest
 jsr ch395_get_remot_ipp_sn
 rts
ipdest:
 .byte 192,168,0,1
```



---

## ch395_get_socket_status_sn

***Description***

This command is used to get Socket status. It is necessary to input a 1 byte of Socket index value. CH395 will output a 2-byte status code when receiving this command. The first status code is the status code of Socket. The status code of Socket is defined as follows:

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
 cmp #CH395_SOCKET_CLOSED
 beq @soclet is closed
```



---

## ch395_get_unreach_ipport

***Description***

This command is used to get an inaccessible IP, ports and protocol type. CH395 will generate an inaccessible interrupt when an inaccessible message is received. MCU can use this command to get inaccessible information. After receiving this command, CH395 will output 1 byte of inaccessible code, 1 byte of protocol type, 2 bytes of port number (low bytes in front), and 4 bytes of IP in turn. MCU can judge whether the protocol, port or IP is inaccessible according to the inaccessible codes. For inaccessible codes, refer to RFC792 (CH395INC.H defines four common inaccessible codes).

!!! failure "Does not work"


---

## ch395_init

***Description***

This command is used to initialize CH395, including initializing MAC, PHY and TCP/IP stack of CH395. Generally, it takes 350mS to execute the command. MCU can send GET_CMD_STATUS to query whether the execution has finished and the execution status.


***Modify***

* Accumulator 
***Description***

Reset ch395


***Example***

```ca65
 jsr ch395_init
 ; Wait a bit
```



---

## ch395_open_socket_sn

***Description***

This command is used to open Socket and use the necessary steps of Socket. It is necessary to input 1 byte of Socket index value. After sending this command, MCU shall send GET_CMD_STATUS to query the command execution status. After opening Socket in UDP, IPRAW or MACRAW mode and returning successfully, data transmission can be performed. Before this command is sent, necessary settings must be made for destination IP, protocol type, source port, destination port, etc. Please refer to 8.3 Application Reference Steps for detailed steps.

***Input***

* Accumulator : Socket id

***Modify***

* Y Register 


---

## ch395_read_recv_buf_sn

***Description***

Get buffer from socket

***Input***

* Accumulator : Socket id
* Y Register : Low ptr to fill
* X Register : X ptr to fill

***Modify***

* REStmp value
* RESBtmp value


---

## ch395_reset_all

***Description***

This command enables CH395 to perform a hardware reset. Typically, hardware reset is completed within 50mS.


***Example***

```ca65
 jsr ch395_reset_all
 ; Wait a bit
```



---

## ch395_set_baudrate

***Description***

This command is used to set the baud rate of CH395 for serial communication. When CH395 works in serial communication mode, the default communication baud rate is set by the level combination of SDO, SDI and SCK pins (refer to Section 6.4 of this datasheet) after reset. When these pins are suspended, the baud rate is 9600bps by default. If MCU supports high communication speed, the serial communication baud rate can be dynamically regulated through this command. This command requires the input of three data, namely, baudrate coefficient 0, baud rate coefficient 1 and baud rate coefficient 2. The following table shows the corresponding relationship with baud rates.



---

## ch395_set_des_port_sn

***Description***

This command is used to set the Socket destination port. It is necessary to input 1 byte of Socket index value and 2 bytes of destination port (the low bytes are in front). When Socket works in UDP or TCP Client mode, this value must be set.

***Input***

* Accumulator : Socketid 
* Y Register : Low int
* X Register : high int

***Modify***

* REStmp

***Example***

```ca65
 lda #$01
 ldx #80
 ldx #$00
 jsr ch395_set_des_port_sn
 rts
```



---

## ch395_set_fun_para

***Description***

Set fun para

***Input***

* Accumulator : Value 

***Modify***

* Y Register 
* Accumulator 


---

## ch395_set_gwip_addr

***Description***

This command is used to set the gateway address for CH395. It is necessary to input 4 bytes of IP address

!!! failure "Does not work"


---

## ch395_set_ip_addr

***Description***

This command is used to set IP address for CH395. It is necessary to input 4 bytes of IP address, with low bytes of IP in front. For all commands including IP input or output in this datasheet, IP low bytes are in front. This will not be explained below

!!! failure "Does not work"


---

## ch395_set_ip_addr_sn

***Description***

This command is used to set the destination IP address of Socket. It is necessary to input 1 byte of Socket index value and 4 bytes of destination IP address. When Socket works in IPRAW, UDP, or TCP Client mode, 0the destination IP must be set before the command CMD_OPEN_SOCKET_SN is sent

***Input***

* Accumulator : Socket id
* Y Register : low ptr ip
* X Register : high ptr ip

***Modify***




---

## ch395_set_ipraw_pro_sn

***Description***

Set ipraw protocol on socket

***Input***

* Accumulator : Socket id
* X Register : the mode proto

***Modify***

* Y Register 


---

## ch395_set_mac_adress

***Description***

This command is used to set MAC address for CH395. It is necessary to input 6 bytes of MAC, with low bytes of MAC address in front. CH395 chip will store MAC address in the internal EEPROM. It will take 100mS to execute this command.MAC address assigned by IEEE has been burned when CH395 chip is delivered. If it is not necessary, please do not set MAC address

***Input***

* Accumulator : Low ptr mac adress
* X Register : High ptr mac adress

***Modify***

* Accumulator 
* Y Register 
* RESTmp


---

## ch395_set_mac_filt

!!! failure "Does not work"


---

## ch395_set_mask_addr

***Description***

This command is used to set the subnet mask for CH395. It is necessary to input 4 bytes of mask for this command. It is 255.255.255.0 by default and may not be set

!!! failure "Does not work"


---

## ch395_set_phy

***Description***

This command is used to set Ethernet PHY connection mode of CH395. The connection mode is automated negotiation mode by default. This command needs to input 1 byte of data, which is the connection mode code: Disconnect PHY when the connection mode code is 01H; PHY is 10M full duplex when the connection mode code is 02H; PHY is 10M half duplex when the connection mode code is 04H; PHY is 100M full duplex when the connection mode code is 08H; PHY is 100M half duplex when the connection mode code is 10H; PHY is automated negotiation when the connection mode code is 20H. When CH395 receives this command, it will reset MAC and PHY and reconnect according to the newly set connection mode. If Ethernet is already connected, it will be disconnected and reconnected.

!!! failure "Does not work"


---

## ch395_set_proto_type_sn

***Description***

This command is used to set the working mode of Socket. It is necessary to input 1 byte of Socket index value and 1 byte of working mode. The working mode is defined as follows:

Code Name Description

03H PROTO_TYPE_TCP TCP mode

02H PROTO_TYPE_UDP UDP mode

01H PROTO_TYPE_MAC_RAW MAC original message mode

00H PROTO_TYPE_IP_RAW IP original message mode

This command must be executed before CMD_OPEN_SOCKET_SN. Refer to 8.3 Application Reference

Steps for detailed steps.

***Input***

* Accumulator : Socket id


---

## ch395_set_retran_count

***Description***

This command is used to set the number of retries. It is necessary to input 1 byte of number of retries. The allowable maximum value is 20. If the input data is more than 20, it will be processed as 20. The default number of retries is 12, and retries are only valid in TCP mode.

***Input***

* Accumulator : Retran period

***Modify***

* X Register 


---

## ch395_set_retran_period

***Description***

This command is used to set the retry cycle. It is necessary to input 2 bytes of number of cycles of (with low bytes in front) in milliseconds. The allowable maximum value is 1000. The total retry time is N * M, N is the number of retries, and M is the retry cycle. The default retry cycle is 500MS and retries are only valid in TCP mode.

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



---

## ch395_set_sour_port_sn

***Description***

This command is used to set the source port of Socket. It is necessary to input 1 byte of Socket index value and 2 bytes of source port (low bytes in front). If two or more Sockets are in the same mode, the source port numbers must not be the same. For example, Socket 0 is in UDP mode, the source port number is 600, and Socket 1 is also in UDP mode. The source port number 600 cannot be used again, otherwise it may cause the0 opening failure.

***Input***

* Accumulator : Socket id
* Y Register : Low ptr address
* X Register : High ptr address

***Modify***

* RES


---

## ch395_set_ttl

***Description***

This command is used to set Socket TTL. It is necessary to input 1 byte of Socket index value and 1 byte of TTL value. It shall be set after the Socket is opened, and the maximum value is 128

***Input***

* Accumulator : Socket ID
* X Register : TTL value

***Modify***

* Y Register 


---

## ch395_tcp_connect_sn

***Input***

* Accumulator : Socket id


---

## ch395_tcp_disconnect_sn

***Input***

* Accumulator : Socket id


---

## ch395_tcp_listen_sn

***Description***

This command is only valid in TCP mode, enabling the Socket to be in the monitoring mode, namely, TCP Server mode. It is necessary to input a 1 byte of Socket index value. This command must be executed after OPEN_SOCKET_SN. After sending this command, MCU shall send GET_CMD_STATUS to query the 0command execution status. In TCP Server mode, the Socket will always detect connection events, and the interrupt SINT_STAT_CONNECT will be generated until the connection is successful. Only one connection can be 0established for each Socket. If an eligible connection event is received again, Socket will send TCP RESET to the remote end tried to be connected.



---

## ch395_write_send_buf_sn

***Description***

This command is used to write data to Socket transmit buffer. It is necessary to input 1 byte of Socket index value, 2 bytes of length (low bytes in front) and several bytes of data stream. The length of input data must not be larger than the size of transmit buffer. However, in MACRAW mode, the maximum length of input data can only be 1514, and any redundant data will be discarded. After the external MCU writes the data, CH395 will encapsulate the data packet according to the working mode of Socket, and then send it. Before MCU receives SINT_STAT_SENBUF_FREE, it is not allowed to write data into Socket transmit buffer again

***Input***

* Accumulator : Socket ID
* Y Register : Low length
* X Register : High length
* RESB : Adress ptr to read

***Modify***

* RESTmp

***Example***

```ca65
```



