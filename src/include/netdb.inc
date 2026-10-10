; struct hostent {
;     char  *h_name;        // Nom officiel de l'hôte
;     char **h_aliases;     // Liste des noms alternatifs (alias)
;     int    h_addrtype;    // Type d'adresse (généralement AF_INET pour IPv4)
;     int    h_length;      // Longueur des adresses en octets
;     char **h_addr_list;   // Liste des adresses de l'hôte (tableau de pointeurs)
; };



.struct hostent
    h_name     .res 100 ; Nom officiel de l'hôte
    h_addrtype .res 1;  ; Type d'adresse (généralement AF_INET pour IPv4)
    h_length   .res 1   ; Longueur des adresses en octets
.endstruct

