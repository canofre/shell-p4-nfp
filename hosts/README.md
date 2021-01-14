# Scripts em shell para uso com ambiente de SmartNICs Netronome

Diretório com scripts utilizados para gerenciamento dos hosts, utilizando 
aplicações já instaladas.

- [dpdk-mg](./dodk-mg): gerenciamento do MoonGen, atráves das opções existentes
  e inicialização com o sistema.
- [nfp-rte](./nfp-rte): basicamente realiza a inicialização do RTE e gerencia algumas
  funcionalidades do rtecli e do RTE. Possui dois arquivos, um shell script que
  realiza a tarefas e um arquivo .sercice que foi adicionado ao systectl para
  inicializar o RTE juntamente com o carregamento do sistema
