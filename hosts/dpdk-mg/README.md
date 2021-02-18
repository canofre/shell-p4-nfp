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

- Utilização: nfp-dpdk-mg.sh [opcoes]
  - h                      : exibe opções e uso
  - mi|moongen-init        : incializa o moongen
  - ns|nic-status          : lista o status das NIC
  - nu|nic-unbind IDT      : desarrega o driver de uma NIC
  - nb|nic-bind DRIVER IDT : carrega um driver em uma NIC
    - DRIVER: igb_uio - DPDK | nfp - Netronome 
