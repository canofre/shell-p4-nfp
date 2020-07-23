# Scripts em shell para uso com ambiente de SmartNICs Netronome

Diretório com scripts utilizados para gerenciamento dos hosts, utilizando 
aplicações já instaladas.

- dpdk-mg: basicamente realiza a inicialização do MoonGen e gerenciamentos de
  algumas funcionalidades de atribuição e remoção de interfaces ao DPDK. Possui
  um arquivo shell script responsável pela realização dos comandos e um arquivo
  do tipo service que foi adicionado ao systemctl para realizar a inicialização
  do MoonGem juntamente com a inicialização do sistema. 
- nfp-rte: basicamente realiza a inicialização do RTE e gerencia algumas
  funcionalidades do rtecli e do RTE. Possui dois arquivos, um shell script que
  realiza a tarefas e um arquivo .sercice que foi adicionado ao systectl para
  inicializar o RTE juntamente com o carregamento do sistema
