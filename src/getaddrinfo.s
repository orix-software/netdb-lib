.include "telestrat.inc"
.include "SDK_memory.mac"
.include "SDK_print.mac"
.include "SDK_conio.mac"

.include "socket.inc"
.include "socket.mac"

.include "ch395.inc"

.import str_oom

.import send
.import recv
.import socket_close
.import connect
.import socket

.proc getaddrinfo
    ;;@brief Get address information.
    ; Performs a malloc
    .out     .sprintf("|MODIFY:libnetdb:RES:dns_resolv_host")
    .out     .sprintf("|MODIFY:libnetdb:RESB:dns_resolv_host")
    .out     .sprintf("|MODIFY:libnetdb:HRS1:dns_resolv_host")
    .out     .sprintf("|MODIFY:libnetdb:HRS2:dns_resolv_host")
    .out     .sprintf("|MODIFY:libnetdb:DECFIN:dns_resolv_host")

    ; Input :
    ; - A and Y  : ptr of the name to resolve

    ; Output:
    ; Returns in A and Y the buffer (malloc)

    ; If A is equal to 0, then errno is sent into X

    libzp                           := $F0
    gethostbyname_length            := libzp   ; 2 bytes
    gethostbyname_tmp1              := libzp+2 ; 1 bytes
    gethostbyname_tmp2              := libzp+3 ; 1 bytes

    main_buffer_ptr                 := HRS1
    gethostby_name_packet_to_resolv := HRS3

    sta     RES
    sty     RES+1

    lda     #<query2
    sta     RESB

    lda     #>query2
    sta     RESB+1

    lda     #18
    sta     libzp    ; Save store packet

    lda     #$00
    sta     libzp+1

    lda     #$00
    sta     DECFIN

@restart_parse:
    ldy     #$00

@parse_host:
    lda     (RES),y
    beq     @out_first

    cmp     #'.'
    beq     @inc_res
    iny
    sta     (RESB),y
    inc     libzp   ; Inc for char

    jmp     @parse_host

@inc_res:
    tya         ; Store length
    ldy     #$00
    sta     (RESB),y

    tay

    iny
    tya

    pha

    clc
    adc     RES
    bcc     @do_not_inc
    inc     RES+1
@do_not_inc:
    sta     RES

    pla
    clc
    adc     RESB
    bcc     @do_not_inc_RESB
    inc     RESB+1

@do_not_inc_RESB:
    sta     RESB

    inc     libzp ; Inc for length value
    jmp     @restart_parse

@out_first:
    ; store last length
    tya         ; Store length
    ldy     #$00
    sta     (RESB),y
    tay

    iny
    lda     #$00
    sta     (RESB),y

    iny
    sta     (RESB),y

    iny
    lda     #$01
    sta     (RESB),y

    iny
    lda     #$00
    sta     (RESB),y

    iny
    lda     #$01
    sta     (RESB),y

    malloc 4096, main_buffer_ptr, str_oom
    sta     RES
    sty     RES+1



@start:
    ; init buffer
    ldy     #$00
    lda     #$00

@L300:
    sta     (RES),y
    iny
    cpy     #38+8
    bne     @L300


; SOCKET sock = socket(AF_INET, SOCK_STREAM, 0);
    ; A = 0
    ; Y SOCK_STREAM
    ; X : AF_INET (erased and not used)

    ; Set socket with UDP
    lda     #$00
    ldx     #AF_INET
    ldy     #SOCK_DGRAM
    jsr     socket

    sta     current_socket
    cmp     #INVALID_SOCKET
    bne     @continue

.ifdef debug_gethostbyname
    print   @str_invalid_socket
.endif
    ; Invalid socket
    jmp     @close_socket_and_return_error

.ifdef debug_gethostbyname

@str_invalid_socket:
    .byte "Invalid Socket",$0A,$0D,0

.endif

@continue:
    ; A contains the id of the socket
    ; Connect socket
    socket_connect 200, 53, dns1
    cmp     #$00
    beq     @opened
    cmp     #EISCONN
    bne     @is_busy

    jmp     @close_socket_and_return_error

.ifdef debug_gethostbyname
    print   @socket_already_connected_error
.endif


@is_busy:
    cmp     #ENOTCONN
    bne     @next_error
    jmp     @close_socket_and_return_error

@next_error:
    rts

@close_socket_and_return_error:
    pha     ; save error
    jsr     @close_socket
    pla

    tax     ; Return error code into X
    lda     #$00 ; return A=0 error
    rts

@close_socket:
    ldx     current_socket
    jsr     socket_close

    lda     #$00   ; Return null
    tay

    rts

@opened:
    ; x socket
    ; ay buffer
    ; RES len buffer

    lda     libzp
    sta     RES

    lda     libzp+1
    sta     RES+1

    ; Get socket
    ; Set ptr to send to RES parameter for socket_send
    ldx     current_socket
    lda     #<header2
    ldy     #>header2
    jsr     send

    cmp     #$00
    beq     @success_send

.ifdef debug_gethostbyname
    print   @error_send
.endif
    jmp     @close_socket

@success_send:
    ; Get socket
    ldx     current_socket
    ; Provide buffer for reveived
    lda     main_buffer_ptr
    ldy     main_buffer_ptr+1
    jsr     recv

    cpy     #ETIMEDOUT
    bne     @store

    ;print   str_timeout
    jmp     @close_socket

@store:
    sta     length_receveived
    stx     length_receveived+1

.ifdef debug_gethostbyname
    pha
    sta     @number_bytes_received
    print   @str_number_of_bytes_received
    pla


    ; Diplay how byte bytes received
    ldy     #$00
    ldx     #$03
    stx     DEFAFF

    BRK_KERNEL XDECIM
    crlf
.endif


@end:
    ldx     current_socket
    jsr     @close_socket

   ; jmp     @go
.ifdef debug_gethostbyname
    ldy     #$00

@L200:
    lda     main_buffer_ptr

    sta     RES
    lda     main_buffer_ptr+1
    sta     RES+1

    sty     save_x
    lda     (RES),y

    ; Diplay how many byte bytes received
    ldy     #$00
    ldx     #$03
    stx     DEFAFF

    BRK_KERNEL XDECIM
    print #' '


    ldy     save_x
    iny
    cpy     length_receveived
    bne     @L200
.endif
@go:

; **********************************************************************
; Read response from dns server
; **********************************************************************

; AA AA - Same ID as before
; 81 80 - Different flags, we'll look at this below
; 00 01 - 1 question
; 00 01 - 1 answer
; 00 00 - No authority records
; 00 00 - No additional records
    ; check if it's valid

    ; Response content
    ; 0x00 0120 ... ; Query id (Should be verifyed)
    ; 0x07 01       ; Number of the response

    print   str_debug_gethostbyname
    print   str_debug_gethostbyname_number_of_answer

    ldy     #$07
    lda     (main_buffer_ptr),y
    ldy     #$00
    print_int ,2,2
    crlf

    lda     main_buffer_ptr
    ldy     main_buffer_ptr+1
    rts

;     ; Read the query question (host) until we found 0
;     ldy     #11 ; First byte of the asked host, 11 in order to have a right loop with 12 (cf iny)
; @read_query_host_answer:
;     iny

;     lda     (main_buffer_ptr),y ; The length of the string ex : 03,www
;     beq     @exit_host_query
;     cpy     #12
;     beq     @do_not_display_dot
;     sty     gethostbyname_tmp1
;     sta     gethostbyname_tmp2
;     print   #'.'
;     ldy     gethostbyname_tmp1
;     lda     gethostbyname_tmp2

; @do_not_display_dot:
;     tax
;     ;dex
; @L400:

;     iny
;     lda     (main_buffer_ptr),y
;     BRK_KERNEL XWR0
;     dex
;     bne     @L400
;     beq     @read_query_host_answer



; @exit_host_query:


;     ldy     #$03
;     lda     (main_buffer_ptr),y

;     ldy     #$03
;     lda     (main_buffer_ptr),y
;     cmp     #$83
;     beq     @nx_domain_error

;     lda     #11 ; number of entries returns
;     clc
;     adc     libzp
;     tay

;     iny     ; At this step Y is at the first byte of the first entries
;     ;ldy     #44
; @L100:
;     lda     (main_buffer_ptr),y

;     sta     RESB
;     iny
;     lda     (main_buffer_ptr),y
;     sta     RESB+1
;     iny
;     lda     (main_buffer_ptr),y
;     sta     TR0
;     iny
;     lda     (main_buffer_ptr),y
;     sta     TR1

;     mfree (main_buffer_ptr)


;     lda     RESB

;     ldy     RESB+1
;     ldx     TR0
    ;


@exit_get:
    rts

@nx_domain_error:
    lda     #$00
    rts

str_timeout:
    .byte "[libnetdb/gethostbyname.s] socket timeout ... ",$0D,$0A,$00

str_debug_gethostbyname:
    .asciiz "[libnet/gethostbyname.s] "

str_debug_gethostbyname_number_of_answer:
    .asciiz "Number of answers :"

.ifdef debug_gethostbyname

@number_bytes_received:
    .res 2

@str_number_of_bytes_received:
    .byte "Number of bytes received",$0A,$0D,0

@error_send:
    .byte "Send error to socket",$0A,$0D,0

@str_error:
    .byte "Error",$0A,$0D,0

@socket_already_connected_error:
    .byte "Socket Already connected",$0A,$0D,0

@socket_busy_error:
    .byte "Socket Busy",$0A,$0D,0

@connection_refused_error:
    .byte "Connection refused",$0A,$0D,0

@socket_not_connected_error:
    .byte "Socket closed",$0A,$0D,0

@str_bytes_from_CH395:
    .byte $0D,$0A,"Number of bytes from ch395 in buffer : ",0

@str_reading_bytes:
    .byte $0D,$0A,"Reading bytes :",0

@str_get_int_status_sn_end_download:
    .byte $0D,$0A,"End download INT socket status :",0

str_int_status_sn_after_write:
    .byte $0D,$0A,"Int status sn after write:",0

str_int_status_sn_global:
    .byte $0D,$0A,"Int status sn Global :",0

str_int_status_sn_after_tcp_connect:
    .byte $0D,$0A,"Int status sn after tcp connect:",0

str_writing:
    .byte $0D,$0A,"Writing byte : ",0

str_waiting_for_tcp_disconnect:
    .byte "Waiting for TCP disconnection with code : ",0

str_cannot_connect_to_tcp_socket:
    .byte "Can not connect to tcp (socket)",0
.endif

current_socket:
    .res 1

header:
    ;.byte $AA,$AA ;- ID
    .byte $01,$20
    .byte $01,$00  ;- Query parameters
    .byte $00,$01  ;- Number of questions
    .byte $00,$00  ;- Number of answers
    .byte $00,$00  ;- Number of authority records
    .byte $00,$00  ;- Number of additional records

	;.byte $DE,$AD
    ;.byte $01, $00,
		;0x00, 0x01, 0x00, 0x00,
		;0x00, 0x00, 0x00, 0x00,

query:
   ; .byte 7,$65,$78,$61,$6d,$70,$6c,$65,$03,$63,$6f,$6d,$00,$00,$01,$00,$01
    .byte $03
    .byte "www"
    .byte $04 ;- 'example' has length 7, e
    .byte "oric"
    .byte $03
    .byte "org"
    .byte $00    ;- zero byte to end the QNAME
    .byte $00,$01 ;- QTYPE
    .byte $00,$01 ;- QCLASS

header2:
    ;.byte $AA,$AA ;- ID
    .byte $01,$20
    .byte $01,$00  ;- Query parameters
    .byte $00,$01  ;- Number of questions
    .byte $00,$00  ;- Number of answers
    .byte $00,$00  ;- Number of authority records
    .byte $00,$00  ;- Number of additional records

query2:
    .byte $03
    .byte "XXX"
    .byte $04 ;- 'example' has length 7, e
    .byte "oric"
    .byte $03
    .byte "org"
    .byte $00    ;- zero byte to end the QNAME
    .byte $00,$01 ;- QTYPE
    .byte $00,$01 ;- QCLASS
    .res 30
ip_to_reach:



;22:55:50.668860 IP 192.168.1.71.52865 > 192.168.1.77.domain: 36089+ [1au] A? www.oric.org. (53)
        ;0x0000:  4500 0051 2c31 0000 3f11 cb86 c0a8 0147
        ;0x0010:  c0a8 014d ce81 0035 003d 5315 8cf9 0120 ;$01 20
        ;0x0020:  0001 0000 0000 0001 0377 7777 046f 7269 ; 3,www
        ;0x0030:  6303 6f72 6700 0001 0001 0000 2910 0000
        ;0x0040:  0000 0000 0c00 0a00 08c3 ef03 411a 1477
        ;0x0050:  14
;22:55:50.671521 IP 192.168.1.77.domain > 192.168.1.71.52865: 36089 1/2/3 A 213.186.33.19 (168)
        ;0x0000:  4500 00c4 f52e 0000 4011 0116 c0a8 014d
        ;0x0010:  c0a8 0147 0035 ce81 00b0 5a85 8cf9 8180
        ;0x0020:  0001 0001 0002 0003 0377 7777 046f 7269
        ;0x0030:  6303 6f72 6700 0001 0001 c00c 0001 0001
        ;0x0040:  0001 4f35 0004 d5ba 2113 c010 0002 0001
        ;0x0050:  0000 0b92 0012 056e 7332 3030 0761 6e79
        ;0x0060:  6361 7374 026d 6500 c010 0002 0001 0000
        ;0x0070:  0b92 0009 0664 6e73 3230 30c0 40c0 3a00
        ;0x0080:  0100 0100 014f 0300 042e 69cf c8c0 5800
        ;0x0090:  0100 0100 014f 0300 042e 69ce c800 0029
        ;0x00a0:  1000 0000 0000 001c 000a 0018 c3ef 0341
        ;0x00b0:  1a14 7714 cb81 4263 629f c966 507b 24ad
        ;0x00c0:  9955 4835

; 07:45:55.605195 IP 192.168.1.77.domain > 192.168.1.168.200: 288 1/2/2 A 213.186.33.19 (129)
;         0x0000:  4500 009d 72be 0000 4011 834c c0a8 014d  E...r...@..L...M
;         0x0010:  c0a8 01a8 0035 00c8 0089 8995 0120 8180  .....5..........
;         0x0020:  0001 0001 0002 0002 0377 7777 046f 7269  .........www.ori
;         0x0030:  6303 6f72 6700 0001 0001 c00c 0001 0001  c.org...........
;         0x0040:  0001 4f3e 0004 d5ba 2113 c010 0002 0001  ..O>....!....... ; 0x0046 :  D5BA2113 ... IP
;         0x0050:  0000 0bcc 0013 0664 6e73 3230 3007 616e  .......dns200.an
;         0x0060:  7963 6173 7402 6d65 00c0 1000 0200 0100  ycast.me........
;         0x0070:  000b cc00 0805 6e73 3230 30c0 41c0 5900  ......ns200.A.Y.
;         0x0080:  0100 0100 014f 3d00 042e 69cf c8c0 3a00  .....O=...i...:.
;         0x0090:  0100 0100 014f 3d00 042e 69ce c8         .....O=...i..

; dig www.yahoo.fr
; 07:42:29.158928 IP 192.168.1.77.domain > 192.168.1.168.200: 288 3/4/0 CNAME rc.yahoo.com., CNAME src.g03.yahoodns.net., A 212.82.100.150 (189)
;         0x0000:  4500 00d9 31af 0000 4011 c41f c0a8 014d  E...1...@......M
;         0x0010:  c0a8 01a8 0035 00c8 00c5 8b22 0120 8180  .....5....."....
;         0x0020:  0001 0003 0004 0000 0377 7777 0579 6168  .........www.yah
;         0x0030:  6f6f 0266 7200 0001 0001 c00c 0005 0001  oo.fr...........
;         0x0040:  0000 00cf 000e 0272 6305 7961 686f 6f03  .......rc.yahoo.
;         0x0050:  636f 6d00 c02a 0005 0001 0000 00cf 0016  com..*..........
;         0x0060:  0373 7263 0367 3033 0879 6168 6f6f 646e  .src.g03.yahoodn
;         0x0070:  7303 6e65 7400 c044 0001 0001 0000 00d1  s.net..D........
;         0x0080:  0004 d452 6496 c048 0002 0001 0002 a2a4  ...Rd..H........
;         0x0090:  0011 0379 6632 0261 3101 6205 7961 686f  ...yf2.a1.b.yaho
;         0x00a0:  6fc0 55c0 4800 0200 0100 02a2 a400 0603  o.U.H...........
;         0x00b0:  7966 33c0 7ac0 4800 0200 0100 02a2 a400  yf3.z.H.........
;         0x00c0:  0603 7966 34c0 7ac0 4800 0200 0100 02a2  ..yf4.z.H.......
;         0x00d0:  a400 0603 7966 31c0 7a                   ....yf1.z


    ;.byte 80,10,246,2

debug_size:
    .res 2

length_receveived:
    .res 2

status_socket:
    .res 1
save_x:
    .res 1



    rts
.endproc
