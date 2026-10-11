;struct hostent  *gethostbyname(const char *name);

.export _gethostbyname

.import gethostbyname

.importzp tmp0

.proc _gethostbyname
    ;;@brief Get host information by name.
    ;;@param name The host name (hostname or address string).
    stx     tmp0
    ldy     tmp0
    jsr     gethostbyname

    rts
.endproc
