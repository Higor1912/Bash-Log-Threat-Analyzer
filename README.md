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

