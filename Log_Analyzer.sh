#!/bin/bash

LOG_FILE=$1

FAIL_STRING="Failed" # Ajuste conforme o padrão do seu log

TOP_COUNT=10

display_help(){
    echo "Uso: $0 <caminho_para_o_log>"
    echo "Exemplo: $0 /var/log/install.log"
    echo "Este script analisa o log de autenticacao para identificar tentativas de brute force (falhas de senha)."
    exit 0
}

if [ -z "$LOG_FILE" ] || [ "$LOG_FILE" == "-h" ]; then
    display_help
fi

if [ ! -f "$LOG_FILE" ]; then
    echo "Erro: arquivo de log nao encontrado em $LOG_FILE"
    exit 1
fi

get_country(){
    local ip="$1"
    local COUNTRY=$(curl -s "ipinfo.io/$ip/country" | tr -d '\n')
    if [ -z "$COUNTRY" ]; then
        echo "DESCONHECIDO"
    else
        echo "$COUNTRY"
    fi
}

analyze_bruteforce(){
    echo "------------------------------------------------------------------------"
    echo " Analise de Brute Force (Log: $LOG_FILE) | IOCs para Threat Intelligence"
    echo " TOP $TOP_COUNT de IPs suspeitos e contexto geográfico"
    echo "------------------------------------------------------------------------"
    echo "Contagem | IP Suspeito     | Pais (TI)"	
    echo "------------------------------------------------------------------------"
    grep "$FAIL_STRING" "$LOG_FILE" | awk '{print $11}' | \
    sort | uniq -c | sort -nr | head -n "$TOP_COUNT" | \
    while read COUNT IP; do
        COUNTRY=$(get_country "$IP")
        printf "%-8s | %-15s | %s\n" "$COUNT" "$IP" "$COUNTRY"
    done
    echo "------------------------------------------------------------------------"
}

analyze_bruteforce

echo ""
echo "Analise concluida. os IPs acima sao suspeitos de varedura/brute force."