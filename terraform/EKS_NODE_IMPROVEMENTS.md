# EKS Node Groups - Melhorias Implementadas

## Resumo das Alterações

Este documento descreve as melhorias implementadas para aumentar a capacidade e otimizar os node groups do Amazon EKS.

## 🚀 Principais Melhorias

### 1. **Aumento da Capacidade dos Node Groups**

#### Configuração Anterior:
- **general**: 2 nodes desejados, máximo 4
- **spot**: 1 node desejado, máximo 3
- **Total**: 3 nodes desejados, máximo 7

#### Nova Configuração:
- **general**: 3 nodes desejados, máximo 6
- **spot**: 2 nodes desejados, máximo 5  
- **compute**: 2 nodes desejados, máximo 4 (NOVO)
- **Total**: 7 nodes desejados, máximo 15

### 2. **Diversificação de Instance Types**

```hcl
# Antes
general = ["t3.medium"]
spot = ["t3.medium", "t3.large"]

# Depois  
general = ["t3.medium", "t3.large"]
spot = ["t3.medium", "t3.large", "t3.xlarge"]
compute = ["t3.large", "t3.xlarge"]  # NOVO
```

### 3. **Correção de Subnets**

- **Problema**: Node groups usando `var.private_subnet_ids` (incluindo us-east-1e não suportada)
- **Solução**: Agora usando `local.eks_subnets` (exclui us-east-1e automaticamente)

### 4. **Addons EKS Essenciais**

Adicionados os seguintes addons:
- **aws-ebs-csi-driver**: Para volumes persistentes
- **vpc-cni**: Networking avançado
- **coredns**: Resolução DNS
- **kube-proxy**: Proxy de rede

### 5. **Cluster Autoscaler**

- IAM role e policies configuradas
- Permissões para auto-scaling automático
- Integração com tags dos node groups

### 6. **Configurações Avançadas**

#### Labels Automáticas:
```hcl
labels = {
  "node-group" = each.key
  "capacity-type" = each.value.capacity_type
}
```

#### Taints para Spot Instances:
```hcl
taint {
  key    = "spot-instance"
  value  = "true"
  effect = "NO_SCHEDULE"
}
```

#### Acesso SSH Opcional:
- Security group para acesso remoto
- Configuração condicional baseada em `ssh_key_name`

### 7. **Monitoramento Aprimorado**

Novos outputs para monitoramento:
- Status de cada node group
- Contagem total de nodes (desejados/máximos)
- ARNs dos node groups
- Tipos de instância por grupo

## 📊 Comparação de Capacidade

| Métrica | Antes | Depois | Aumento |
|---------|-------|--------|---------|
| Node Groups | 2 | 3 | +50% |
| Nodes Desejados | 3 | 7 | +133% |
| Capacidade Máxima | 7 | 15 | +114% |
| Instance Types | 2 | 5 | +150% |

## 🔧 Como Usar

### 1. **Deploy Padrão**
```bash
terraform plan
terraform apply
```

### 2. **Com SSH Access**
```hcl
# terraform.tfvars
ssh_key_name = "my-key-pair"
```

### 3. **Monitoramento**
```bash
# Ver status dos node groups
terraform output eks_node_group_status

# Ver total de nodes
terraform output total_desired_nodes
terraform output total_max_nodes
```

## 🏷️ Tags Aplicadas

Todos os recursos recebem automaticamente:
- `auto-delete = "no"`
- `Environment = "dev"`
- `Project = "isengard"`
- `ManagedBy = "terraform"`

## 🔍 Próximos Passos

1. **Karpenter**: Já configurado para auto-scaling avançado
2. **Monitoring**: Considerar integração com CloudWatch
3. **Cost Optimization**: Revisar mix de spot/on-demand baseado no uso
4. **Security**: Implementar Pod Security Standards

## ⚠️ Considerações

- **Custos**: Aumento significativo na capacidade pode impactar custos
- **AZ Limitation**: us-east-1e não suportada pelo EKS (já tratado)
- **Spot Instances**: Podem ser interrompidas, usar taints apropriadas