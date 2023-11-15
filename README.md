# Terraform

Este é um projeto terraform que provisiona uma maquina na google cloud, configura firewall na rede default e baixa o projeto lab-ERP-React do repositório: https://github.com/kwaark/lab-ERP-React e coloca pra rodar na porta 3000 (padrão).  

- Foi incluído todas as portas de entrada (allow) no firewall, tanto UDP como TCP, podendo ser configurado no proprio arquivo main do terraform.

- Este é apenas um exemplo para testes e estudos. Não é uma boa pratica usar essa configuração de firewall liberado para todos os IP's (0.0.0.0/0).
