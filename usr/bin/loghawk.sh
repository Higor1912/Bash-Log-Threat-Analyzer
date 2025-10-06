#!/usr/bin/env bash
# ===============================================
# LogHawk v1.1
# Descrição: Ferramenta CLI para análise de logs e detecção de tentativas 
suspeitas
# ===============================================

# ======== Cores ========
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # sem cor

# ======== Banner ========
echo -e "${YELLOW}"
echo "==============================================="
echo "              LogHawk v1.1 🦅"
echo "  Intelligent Log Threat & Access Analyzer"
echo "==============================================="
echo -e "${NC}"

# ======== Verificação de argumento ========
if [ -z "$1" ]; then
    read -rp "Digite o caminho do log a ser analisado: " LOG_FILE
else
    LOG_FILE="$1"
fi

# ======== Verificação de existência ========
if [ ! -f "$LOG_FILE" ]; then
    echo -e "${RED}[x] Arquivo não encontrado:${NC} $LOG_FILE"
    exit 1
fi

# ======== Relatório ========
REPORT_DIR="$HOME/.loghawk/reports"
mkdir -p "$REPORT_DIR"
REPORT="$REPORT_DIR/report_$(date +%Y%m%d_%H%M%S).txt"

# ======== Funções principais ========

analyze_bruteforce() {
    echo -e "${GREEN}[+] Analisando tentativas de autenticação 
falhas...${NC}"
    grep -E "Failed password|authentication failure" "$LOG_FILE" | \
        awk '{print $(NF-3)}' | sort | uniq -c | sort -nr > "$REPORT"

    if [ -s "$REPORT" ]; then
        echo -e "${GREEN}[✔] Análise concluída.${NC}"
        echo -e "${CYAN}Top IPs suspeitos:${NC}"
        head -n 10 "$REPORT"
    else
        echo -e "${YELLOW}[!] Nenhuma tentativa de login falha 
encontrada.${NC}"
    fi
}

analyze_success() {
    echo -e "${GREEN}[+] Analisando logins bem-sucedidos...${NC}"
    grep "Accepted password" "$LOG_FILE" | awk '{print $(NF-3)}' | sort | 
uniq -c | sort -nr
}

count_repeated_ips() {
    echo -e "${GREEN}[+] Contando IPs reincidentes...${NC}"
    awk '{if($1 > 5) print "ALERTA: IP " $2 " com " $1 " tentativas"}' 
"$REPORT"
}

export_csv() {
    CSV_FILE="${REPORT%.txt}.csv"
    echo "Tentativas,IP" > "$CSV_FILE"
    awk '{print $1","$2}' "$REPORT" >> "$CSV_FILE"
    echo -e "${GREEN}[✔] Exportado como CSV:${NC} $CSV_FILE"
}

export_json() {
    JSON_FILE="${REPORT%.txt}.json"
    echo "[" > "$JSON_FILE"
    awk '{printf "  {\"ip\": \"%s\", \"attempts\": %s},\n", $2, $1}' 
"$REPORT" | sed '$ s/,$//' >> "$JSON_FILE"
    echo "]" >> "$JSON_FILE"
    echo -e "${GREEN}[✔] Exportado como JSON:${NC} $JSON_FILE"
}

show_menu() {
    echo -e "${YELLOW}"
    echo "1) Analisar tentativas de força bruta"
    echo "2) Analisar logins bem-sucedidos"
    echo "3) Contar IPs reincidentes"
    echo "4) Exportar último relatório (CSV)"
    echo "5) Exportar último relatório (JSON)"
    echo "6) Exibir último relatório"
    echo "7) Sair"
    echo -e "${NC}"
}

# ======== Execução principal ========
while true; do
    show_menu
    read -rp "Escolha uma opção: " opt
    case $opt in
        1) analyze_bruteforce ;;
        2) analyze_success ;;
        3) count_repeated_ips ;;
        4) export_csv ;;
        5) export_json ;;
        6) ls -1t "$REPORT_DIR"/report_*.txt 2>/dev/null | head -n 1 | 
xargs cat ;;
        7) echo "Saindo..."; exit 0 ;;
        *) echo -e "${RED}[x] Opção inválida.${NC}" ;;
    esac
    echo ""
done
