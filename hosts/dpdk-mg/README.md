# Script DPDK-MG

Basicamente realiza a inicialização do MoonGen e gerenciamentos de algumas 
funcionalidades de atribuição e remoção de interfaces ao DPDK, utilizandos
os comandos do próprio DPDK.

Possui um arquivo shell script responsável pela execução dos comandos e um 
arquivo do tipo service que foi adicionado ao systemctl para realizar a 
inicialização do MoonGem juntamente com a inicialização do sistema.

## nfp-dpdk-mg.sh
Script para concatenar as opções do MoonGen, possibilitando gerencias as 
interfaces, geralmente salvo em /var/lib/sbin, para possibilitar execução
de qualquer diretório. Para o correto funcionamento é necessário que exita 
um link simbólico ou o diretorio do MoonGen /opt.

- Utilização:
printf " USO nfp-dpdk-mg.sh [opcoes]\n\n"
    printf " Opcoes:\n"
    printf "\t h                      : exibe opções e uso\n"
    printf "\t mi|moongen-init        : incializa o moongen \n"
    printf "\t ns|nic-status          : lista o status das NIC \n"
    printf "\t nu|nic-unbind IDT      : desarrega o driver de uma NIC \n"
    printf "\t nb|nic-bind DRIVER IDT : carrega um driver em uma NIC \n"
    printf "\t\t DRIVER: igb_uio - DPDK | nfp - Netronome \n
