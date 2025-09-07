# 🌐 AWS Static Website + EC2 Backend
Este projeto demonstra uma arquitetura simples e segura na AWS, onde um site estático hospedado no S3 é entregue via CloudFront, e a interface (JS) se comunica com uma API Backend rodando em EC2 dentro de uma VPC.



## 🚀 Arquitetura

**Fluxo do Usuário:**

1. O usuário acessa o CloudFront.
2. O CloudFront entrega o site estático a partir do S3.
3. O navegador carrega a interface (HTML/CSS/JS).
4. O JavaScript no navegador faz chamadas de API para o EC2 Backend.
5. O tráfego passa pela Internet Gateway → VPC → Subnet Pública → Security Group.
6. O EC2 Backend processa e responde.
7. A resposta retorna para o usuário.

## 🛠️ Tecnologias Utilizadas

- Amazon S3 → Hospedagem de site estático
- Amazon CloudFront → CDN e distribuição de conteúdo
- Amazon VPC → Rede privada
- Subnet Pública → Conexão com a Internet
- Internet Gateway (IGW) → Entrada/saída da VPC
- Security Group (SG) → Controle de tráfego
- Amazon EC2 → Backend da aplicação (API)
- IAM → Controle de permissões
- Terraform → Infraestrutura como Código (IaC)

## ▶️ Como Usar

1. Clone este repositório:
```bash
git clone https://github.com/francisco-wellington/lab1-iac.git
cd lab1-iac
```
2. Configure as credenciais AWS (com ***aws configure*** ou variáveis de ambiente).
3. Inicialize e aplique o Terraform:
```bash
terraform init
terraform apply
```
4. Acesse a URL do CloudFront no output do Terraform.

