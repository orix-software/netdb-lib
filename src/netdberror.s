
.include "telestrat.inc"

.include "SDK_conio.mac"
.include "SDK_print.mac"

.include "socket.inc"
.include "ch395.inc"

; Get error Code, and displays right error code
.proc netdberror
    cpx     #INVALID_SOCKET
    beq     @invalid_socket_error

    cpx     #EISCONN
    beq     @already_open_socket_error

    print   unknown_error

    rts

@invalid_socket_error:
    print invalid_socket_error_str
    rts

@already_open_socket_error:
    print already_open_socket_error_str
    rts

unknown_error:
    .byte "[GethostByName] Unknown error",$0A,$0D,00

invalid_socket_error_str:
    .byte "[GethostByName] Invalid socket error",$0A,$0D,00

already_open_socket_error_str:
    .asciiz "[GethostByName] Socket already open error"
.endproc
