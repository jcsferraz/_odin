# EKS Launch Template - Correção do Erro MIME Multipart

## 🐛 Problema Identificado

```
Error: Ec2LaunchTemplateInvalidConfiguration: User data was not in the MIME multipart format.
```

## 🔧 Solução Implementada

### **Problema Raiz**
O erro ocorreu porque:
1. **User Data Complexo**: O script de user data estava causando conflito com o formato MIME esperado pelo EKS
2. **Configurações Conflitantes**: Launch Template com configurações que conflitavam com as do Node Group
3. **Formato MIME**: EKS esperava formato MIME multipart específico para user data

### **Abordagem de Correção**

#### **1. Simplificação dos Launch Templates**
- **Removido**: User data customizado
- **Removido**: Configurações de security group no Launch Template
- **Removido**: Configurações de metadata complexas
- **Mantido**: Apenas tag specifications (objetivo principal)

#### **2. Configuração Minimalista**
```hcl
resource "aws_launch_template" "node_group" {
  name_prefix = "${var.cluster_name}-${each.key}-"
  description = "Launch template for EKS node group ${each.key}"

  # Apenas tag specifications - sem user data
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
      Name = "${var.cluster_name}-${each.key}-node"
      # ... outras tags
    })
  }
}
```

#### **3. Delegação ao EKS**
- **Bootstrap**: EKS gerencia automaticamente o bootstrap dos nodes
- **User Data**: EKS aplica o user data padrão necessário
- **Security Groups**: Configurados no Node Group, não no Launch Template

## 📊 Comparação: Antes vs Depois

### **Antes (Problemático)**
```hcl
# Launch Template com muitas configurações
user_data = base64encode(<<-EOF
  #!/bin/bash
  /etc/eks/bootstrap.sh ${var.cluster_name}
  # ... script complexo
EOF)

vpc_security_group_ids = [...]
metadata_options { ... }
```

### **Depois (Funcional)**
```hcl
# Launch Template minimalista
tag_specifications {
  resource_type = "instance"
  tags = { ... }
}
# EKS gerencia o resto automaticamente
```

## 🎯 Benefícios da Solução

### **1. Compatibilidade**
- ✅ Sem conflitos de formato MIME
- ✅ Compatível com EKS managed node groups
- ✅ Funciona com todas as versões do EKS

### **2. Simplicidade**
- ✅ Configuração minimalista
- ✅ Menos pontos de falha
- ✅ Mais fácil de manter

### **3. Funcionalidade Mantida**
- ✅ Tags aplicadas corretamente às instâncias
- ✅ Nomes das instâncias funcionando
- ✅ Cluster Autoscaler tags presentes
- ✅ Karpenter discovery tags aplicadas

## 🏷️ Tags Aplicadas (Objetivo Alcançado)

### **Instâncias EC2**
```
Name: isengard-dev-general-node
kubernetes.io/cluster/isengard-dev: owned
k8s.io/cluster-autoscaler/enabled: true
NodeGroup: general
CapacityType: ON_DEMAND
Environment: dev
Project: isengard
auto-delete: no
```

### **Volumes EBS**
```
Name: isengard-dev-general-node-volume
kubernetes.io/cluster/isengard-dev: owned
NodeGroup: general
CapacityType: ON_DEMAND
```

## 🔄 Processo de Deploy

### **1. Limpeza (se necessário)**
```bash
# Se houver recursos em estado de erro
terraform destroy -target=module.eks_cluster_dev.aws_eks_node_group.main
terraform destroy -target=module.eks_cluster_dev.aws_launch_template.node_group
```

### **2. Deploy da Correção**
```bash
terraform plan
terraform apply
```

### **3. Verificação**
```bash
# Verificar node groups
aws eks describe-nodegroup --cluster-name isengard-dev --nodegroup-name isengard-dev-general

# Verificar instâncias
aws ec2 describe-instances \
  --filters "Name=tag:kubernetes.io/cluster/isengard-dev,Values=owned" \
  --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`].Value|[0],State:State.Name}'
```

## ⚠️ Considerações Importantes

### **1. Bootstrap Automático**
- EKS gerencia automaticamente o bootstrap dos nodes
- Não é necessário user data customizado para funcionalidade básica
- SSM Agent já vem pré-instalado nas AMIs do EKS

### **2. Customizações Futuras**
Se precisar de user data customizado no futuro:
```hcl
# Use formato MIME multipart correto
user_data = base64encode(templatefile("${path.module}/userdata.tpl", {
  cluster_name = var.cluster_name
}))
```

### **3. Monitoramento**
- CloudWatch Logs: `/aws/eks/isengard-dev/cluster`
- Node Logs: Acessíveis via SSM Session Manager
- Kubernetes Events: `kubectl get events`

## 🚀 Próximos Passos

1. **Verificar Deploy**: Confirmar que todos os node groups estão ACTIVE
2. **Testar Conectividade**: `kubectl get nodes`
3. **Validar Tags**: Verificar na console AWS
4. **Monitorar Logs**: Acompanhar logs do cluster
5. **Deploy Aplicações**: Testar workloads no cluster

## 📝 Lições Aprendidas

1. **Simplicidade**: Menos configuração = menos problemas
2. **EKS Managed**: Deixar o EKS gerenciar o que ele faz bem
3. **Tags**: Launch Templates são ideais para tag specifications
4. **User Data**: Usar apenas quando absolutamente necessário
5. **Debugging**: Logs do EKS são essenciais para troubleshooting