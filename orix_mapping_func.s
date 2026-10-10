.proc orix_mapping_func
    ; ROM/RAM
    ; Checker quelle est la ROM en cours




    rts
.endproc

; 1 La rom network doit s'annonce au kernel avec XVARS
; ex 
network_start
   .define NETWORK_STACK #$01
   ldx #KERNEL_XVALUES_SET_ROM
   lda  #NETWORK_STACK
   sta  RES
   lda  $321
   ldy  $343
   BRK_KERNEL XVARS
   rts

.proc socket_rom
    ; Socket_rom doit vérifier si
    ; C'est dans une ROM
    ; que la rom network est bien actuellement celle active si non on bascule
    ; Dans ce cas si l'appel est bien en rom, alors, on continue
    rts
.endproc

.proc socket

    rts
.endproc

clemence debrune