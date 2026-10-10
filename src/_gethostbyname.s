;struct hostent  *gethostbyname(const char *name);

.export _gethostbyname

.import gethostbyname

.importzp tmp0

.proc _gethostbyname
    stx     tmp0
    ldy     tmp0
    jsr     gethostbyname

    rts
.endproc
