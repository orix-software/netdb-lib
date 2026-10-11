.export _getaddrinfo
.import getaddrinfo

.proc _getaddrinfo
    ;;@brief Get address information.
    ;;@param node The node name (hostname or address string).
    jmp     getaddrinfo
.endproc


