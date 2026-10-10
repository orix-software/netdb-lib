struct hostent  *gethostbyname(const char *name);

#define INET6_ADDRSTRLEN 46

struct hostent {
    char  *h_name;        // Nom officiel de l'hôte
    char **h_aliases;     // Liste des noms alternatifs (alias)
    int    h_addrtype;    // Type d'adresse (généralement AF_INET pour IPv4)
    int    h_length;      // Longueur des adresses en octets
    char **h_addr_list;   // Liste des adresses de l'hôte (tableau de pointeurs)
};


struct addrinfo {
    int              ai_flags;     // Options de la requête (AI_PASSIVE, AI_CANONNAME, etc.)
    int              ai_family;    // Famille d'adresses (AF_INET, AF_INET6, AF_UNSPEC, etc.)
    int              ai_socktype;  // Type de socket (SOCK_STREAM, SOCK_DGRAM, etc.)
    int              ai_protocol;  // Protocole (habituellement 0 pour utiliser le protocole par défaut)
    size_t           ai_addrlen;   // Longueur de la structure d'adresse
    //struct sockaddr *ai_addr;      // Pointeur vers une structure sockaddr contenant l'adresse
    char            *ai_canonname; // Nom canonique (si AI_CANONNAME est défini)
    //struct addrinfo *ai_next;      // Pointeur vers la prochaine structure dans la liste liée
};