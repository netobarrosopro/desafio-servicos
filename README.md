## **README.md - Projeto de CI/CD**

-----

# 🚀 Título do Projeto: [Projeto DevOps - DreamSquad]

## 📝 Descrição

Este projeto visa implementar algumas funcionalidades através de três serviços, como uma aplicação frontend rodando a partir do S3, uma aplicação backend com alguma funcionalidade básica e a implementação de lambda para um processo programado em determinado horário. Foi aplicado no projeto a integração com o GitHub de forma manual, para manter um repositório ativo e na sequência, implementação do CI/CD utilizando o GitHub Actions.

## 🛠️ Tecnologias e Ferramentas Utilizadas

A seguir, estão as principais tecnologias e ferramentas que compõem nossa pipeline:

### **Integração Contínua (CI)**

| Categoria | Ferramenta | Descrição |
| :--- | :--- | :--- |
| **Controle de Versão** | **[ Git / GitHub ]** | Hospedagem e controle do código-fonte. |
| **Orquestrador CI** | **[ GitHub Actions ]** | Gerencia e executa a esteira de build e testes. |
| **Linguagem/Runtime** | **[ HTML, CSS e javascript para a aplicação Frontend, Python para o Lambda e Node.js para a aplicação backend ]** | Linguagem de desenvolvimento da aplicação. |
| **Gerenciador de Pacotes** | **[ npm, pip]** | Gerencia as dependências do projeto. |
| **Testes** | **[ Ainda não foi implementado ferramentas de testes, mas utilizaremos Selenium]** | Frameworks para testes unitários e de integração. |

### **Entrega Contínua (CD)**

| Categoria | Ferramenta | Descrição |
| :--- | :--- | :--- |
| **Containerização** | **[ Docker ]** | Empacota a aplicação e suas dependências em imagens. |
| **Registro de Imagens** | **[ AWS ECR ]** | Armazena as imagens Docker prontas para deploy. |
| **Orquestração** | **[ AWS EKS ]** | Gerencia e escala os contêineres em produção. |
| **Nuvem/Infraestrutura** | **[ AWS ]** | Plataforma de hospedagem do ambiente. |
| **IaC (Infraestrutura como Código)** | **[ Terraform ]** | Automatiza o provisionamento da infraestrutura. |

## ⚙️ A Esteira de CI/CD (Após implementar o GitHub Actions)

Nossa pipeline de CI/CD é estruturada nas seguintes fases:

1.  **Commit (CI):**
      * Um desenvolvedor faz um `push` de código para o branch **`main`** (ou um *merge* de *feature branch*).
2.  **Build (CI):**
      * O Orquestrador **[Ferramenta CI]** é acionado.
      * As dependências são instaladas e o código é compilado.
      * Uma imagem **Docker** é construída.
3.  **Testes (CI):**
      * Testes **Unitários** e de **Integração** são executados automaticamente.
      * Verificação de **Qualidade de Código** (**[Ex: SonarQube]**) é realizada.
4.  **Artefato (CD):**
      * A imagem Docker é **taggeada** (ex: com o número do build) e enviada ao **[Registro de Imagens]**.
5.  **Deploy em Staging (CD):**
      * O ambiente de **Staging** (homologação) é atualizado com o novo artefato.
      * **Testes de Aceitação** automatizados (**[Ex: Selenium, Cypress]**) são executados neste ambiente.
6.  **Aprovação Manual:**
      * Após a validação em Staging, uma **aprovação manual** é necessária para prosseguir.
7.  **Deploy em Produção (CD):**
      * A implantação é feita no ambiente de **Produção** usando **[Ferramenta CD/IaC]**, seguindo uma estratégia de deploy segura (ex: *Rolling Update* ou *Canary Deployment*).

## 📄 Estrutura do Repositório

```
.
├── app/                          # Código-fonte da aplicação frontend
|   |__ index.html
|   |__ error.html
|   |__ script.js
|   |__ styles.css                        
├── backend/                      # Armazena os códigos do Dockerfile, package.json, server.js
|   |__ public
|   |__ Dockerfile
|   |__ package.json
|   |__ server.js
├── terraform/                    # Scripts terraform e do lambda
│   ├── kubernetes.tf             # Código do provisionamento do cluster EKS
│   ├── lambda_function.py        # Código do lambda
│   └── main.tf                   # Código para os buckets, permissões e outras coisas
|   |__ outputs.tf                # Código para apresentar o output de site, alb e ecr
|   |__ provider.tf               # Código com os providers da AWS e do Kubernetes
|   |__ variables.tf              # Código com definição de variaveis
|__ .gitignore                    # Código para que o github ignore partes do projeto que não devem
|                                 # ficar expostas no repositorio
└── README.md
```

## 🧑‍💻 Implementações futuras

Para futuro próximo, espera implementar muitas outras coisas como Ansible, Slack, Testes unitários, e praticas SRE com observalidade em Prometheus/Grafana:

## 📄 Como implementar o código passo a passo




-----

*Este projeto é mantido pela Equipe de DevOps.*