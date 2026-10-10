#include <stdio.h>
#include <stdlib.h>
//#include <arpa/inet.h>
#include "../../../src/include/netdb.h"

int main(int argc, char *argv[]) {


    struct addrinfo hints, *res, *p;
    int status;
    char ipstr[INET6_ADDRSTRLEN];
    if (argc != 2) {
        fprintf(stderr, "Usage: %s hostname\n", argv[0]);
        return 1;
    }
    // // Remplir la structure hints pour spécifier les critères de recherche
    memset(&hints, 0, sizeof hints);
    // hints.ai_family = AF_UNSPEC; // AF_INET ou AF_INET6 pour forcer IPv4 ou IPv6
    // hints.ai_socktype = SOCK_STREAM; // SOCK_STREAM ou SOCK_DGRAM

    // Résolution DNS
    // if ((status = getaddrinfo(argv[1], NULL, &hints, &res)) != 0) {
    //     fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(status));
    //     return 2;
    // }

    // printf("Résultats de la résolution DNS pour %s :\n\n", argv[1]);

    // for (p = res; p != NULL; p = p->ai_next) {
    //     void *addr;
    //     char *ipver;

    //     // Obtenir le pointeur vers l'adresse IPv4 ou IPv6
    //     if (p->ai_family == AF_INET) { // IPv4
    //         struct sockaddr_in *ipv4 = (struct sockaddr_in *)p->ai_addr;
    //         addr = &(ipv4->sin_addr);
    //         ipver = "IPv4";
    //     } else { // IPv6
    //         struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)p->ai_addr;
    //         addr = &(ipv6->sin6_addr);
    //         ipver = "IPv6";
    //     }

    //     // Convertir l'adresse IP en une chaîne lisible
    //     inet_ntop(p->ai_family, addr, ipstr, sizeof ipstr);
    //     printf(" %s: %s\n", ipver, ipstr);
    // }

    // freeaddrinfo(res); // Libérer la mémoire allouée pour les résultats de la résolution DNS

    // return 0;
}