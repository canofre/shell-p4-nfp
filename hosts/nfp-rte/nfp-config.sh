#!/bin/bash
##
## Script para gerenciar o ambiente de desenvolvimento com RTE e SmartNics
## Agilio da Netronome
##

PATH_NFP=/opt/netronome/bin
PATH_RTE=/opt/netronome/p4/bin
PATH_NFP_SIM=/opt/nfp-sim/bin
PATH_MG=/opt/MoonGen

PORTAS=("20206" "20207")

function main() {
    case "$1" in
        ns|nic-status)
            nicStatus $*
            ;;
        nc|nic-clean)
            nicClean $*
            ;;
        nl|nic-load)
            nicLoadDriver $*
            ;;
        nr|nic-reload)
            nicReload $*
            ;;
        tl|table-list)
            nicTableList $*
            ;;
        tr|table-reload)
            nicTableReload $*
            ;;
        ri|rte-init)
            rteManager "start"
            ;;
        rr|rte-restart)
            rteManager "restart"
            ;;
        rs|rte-status)
            rteManager "status"
            ;;
        *)
            printHelp
            ;; 
    esac
}

function printHelp(){
    printf " USO nfp-config.sh [opcoes]\n\n"
    printf " Opcoes:\n"
    printf "  h                     : exibe opções e uso\n"
    printf "  ri|rte-init           : incia os servicos RTE (systemctl start nfp-sdk6-rte[x])\n"
    printf "  rs|rte-status         : retorna o status dos servicos RTE (system status nfp-sdk6-rte[x])\n"
    printf "  rr|rte-restart        : reinicia oos servicos RTE (system status nfp-sdk6-rte[x])\n"
    printf "  tl|table-list [PORTA] : lista as tabelas de regras existentes nas portas ou na porta passada\n"
    printf "  tr|table-reload [FILE]: carrega uma configuracao nas portas ou uma em cada\n"
    printf "      - tr conf.p4conf | conf20206.p4conf conf20207.p4conf ...\n"
    printf "  ns|nic-status [PORTA] : exibe o status da porta passada ou de todas ativas\n"
    printf "  nc|nic-clean [PORTA]  : remove os drivers nffw carregados nas interfaces\n"
    printf "  nl|nic-load [FILE]    : carrega as configuracoes  \n"
    printf "      - nl file.nffw conf.p4conf [conf2.p4conf]:\n"
    printf "      Carrega o mesmo driver e arquivo de configuracao para todas as portas ou um \n"
    printf "      arquivo de configuracao para cada que existir caso sejam passados.\n"
    printf "  nr|nic-reload [OPCOES]: limpa e carrega as configuracoes. Mesmos parametros da opcao nic-load \n\n"
}

# Inicializa um servico por porta ou retorna o status dos servicos
function rteManager(){
    systemctl $1 nfp-sdk6-rte --no-pager
    [ ${PORTAS[1]} ] && systemctl $1 nfp-sdk6-rte1 --no-pager
    [ ${PORTAS[2]} ] && systemctl $1 nfp-sdk6-rte2 --no-pager
    [ ${PORTAS[3]} ] && systemctl $1 nfp-sdk6-rte3 --no-pager
}

function nicStatus(){
    if [ $# -eq 2 ] && [ $2 -gt 20000 ];then
        echo "STATUS PORTA $1"
        $PATH_RTE/rtecli -p $1 status
    else
        for p in ${PORTAS[@]}; do
            echo 
            echo "STATUS PORTA $p"
            $PATH_RTE/rtecli -p $p status
        done
    fi
}

# Remove as configuracoes das interfaces. Se for passado um segundo parametro 
# como o numero da porta tenta remover.
function nicClean(){
    if [ $# -eq 2 ] && [ $2 -gt 20000 ];then
        echo "Removendo driver porta $2"
        $PATH_RTE/rtecli -p $2 status
    else
        for p in ${PORTAS[@]}; do
            echo "Removendo driver porta $p"
            $PATH_RTE/rtecli -p $p design-unload
        done
    fi

}


# Carrega o mesmo driver e arquivo de configuracao para todas as portas 
# ou um arquivo de configuracao para cada que existir caso sejam passados.
# Parametros: firmware conf [conf2..4]
function nicLoadDriver(){
    
    if [ $# -ge 3 ];then
        aFile=(`echo $* | cut -d" " -f3-`) 
        i=0        
        for p in ${PORTAS[@]}; do
            $PATH_RTE/rtecli -p $p design-load -f $2 -c ${aFile[$i]}
            i=$(($i+1))
            i=$( [[ ${aFile[$i]} ]] && echo $i || echo $(($i-1)) );
            nicStatus $p $p
        done
    else
        echo " USO: nl firmware.nffw conf.p4conf [conf2.p4conf]"
        exit
    fi
}

# Limpa as configuracoes das interfaces e recarrega. 
function nicReload(){
    if [ $# -lt 3 ];then
        echo " USO: nr firmware.nffw conf.p4conf [conf2.p4conf]"
        exit
    fi
#    rteManager "restart"
    nicClean
    nicLoadDriver $*
}

function nicTableList(){
    if [ $# -eq 2 ] && [ $2 -gt 20000 ];then
        echo -e "\nTabela de regras da porta $2:"
        $PATH_RTE/rtecli -p $2 tables list
    else
        for p in ${PORTAS[@]}; do
            echo -e "\nTabela de regras da porta $p:"
            $PATH_RTE/rtecli -p $p tables list
        done
    fi
    echo -e "\nPara exibir as regras de uma tabela:"
    echo "$PATH_RTE/rtecli -p [PORTA] tables -t [TABLE_NAME] list-rules"
}

function nicTableReload(){
    if [ $# -eq 3 ];then
        aFile=(`echo $* | cut -d" " -f2-`)
        i=0
        for p in ${PORTAS[@]}; do
            echo "Atualizando tabela de regras da porta $p"
            $PATH_RTE/rtecli -p $p config-reload -c ${aFile[$i]}
            i=$(($i+1))
            i=$( [[ ${aFile[$i]} ]] && echo $i || echo $(($i-1)) );
            nicTableList $p $p
        done
    elif [ $# -eq 2 ]; then
        for p in ${PORTAS[@]}; do
            echo "Atualizando regras da porta $p"
            $PATH_RTE/rtecli -p $p config-reload -c $2 
        done
    else
        echo " USO: tr conf.p4conf | conf_20206.p4conf conf_20207.p4conf"
        exit
    fi
}


main $*
