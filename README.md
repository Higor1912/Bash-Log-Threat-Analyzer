# 🛡️ Bash-Log-Threat-Analyzer

Script de triagem de segurança desenvolvido em **Bash** para automatizar a identificação de ataques de **Força Bruta (Brute Force)** em logs de autenticação.

Este projeto transforma logs brutos em **Threat Intelligence (TI)** acionável através da geolocalização imediata dos Indicadores de Compromisso (IOCs) suspeitos.

---

## 💡 Destaques do Projeto e Habilidades Demonstradas

* **Fundamentos em Bash:** Proficiência no uso de comandos essenciais como `grep`, `awk`, `sort`, `uniq` e *pipelines* (`|`) para manipulação e análise de logs em massa.
* **Extração de IOCs:** Automação do filtro por endereços IP com maior contagem de tentativas de acesso falhas (`Failed password`).
* **Integração de Threat Intelligence:** Utiliza o `curl` para consultar APIs externas de geolocalização (*ex: ipinfo.io*) e adicionar contexto geográfico (País) aos IPs suspeitos.
* **Computação Forense (Triagem):** Reduz o tempo de triagem, focando o analista nos IOCs de alto risco para investigação mais aprofundada.

---

## 🚀 Como Utilizar

O script espera o caminho completo do log de autenticação como o primeiro argumento (`$1`).

**Pré-requisitos:**
1.  O sistema operacional deve ter as ferramentas **`curl`** e **`awk`** instaladas (padrão na maioria das distribuições Linux/macOS).
2.  Acesso root/sudo ou permissão de leitura no arquivo de log (`/var/log/auth.log`).

```bash
# 1. Torna o script executável
chmod +x Log_Analyzer.sh

# 2. Executa a análise (o caminho do log é o primeiro argumento)
./Log_Analyzer.sh /var/log/auth.log
