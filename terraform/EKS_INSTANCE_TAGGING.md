# EKS Instance Tagging - Configuração Completa

## Problema Resolvido

As instâncias EC2 dos node groups EKS não estavam recebendo tags adequadas, aparecendo sem nome na console da AWS. Implementamos Launch Templates para garantir que todas as instâncias recebam tags apropriadas.

## 🏷️ Tags Aplicadas às Instâncias

### **Node Groups Padrão (general, spot, compute)**

Cada instância EC2 recebe as seguintes tags:

```hcl
Name = "${cluster_name}-${node_group_name}-node"
# Exemplo: "isengard-dev-general-node"

# Tags do Kubernetes
"kubernetes.io/cluster/${cluster_name}" = "owned"
"k8s.io/cluster-autoscaler/enabled" = "true"
"k8s.io/cluster-autoscaler/${cluster_name}" = "owned"

# Tags de identificação
NodeGroup = "${node_group_name}"        # "general", "spot", "compute"
CapacityType = "${capacity_type}"       # "ON_DEMAND" ou "SPOT"

# Tags padrão do projeto
Environment = "dev"
Project = "isengard"
ManagedBy = "terraform"
auto-delete = "no"
```

### **Karpenter Management Node Group**

```hcl
Name = "${cluster_name}-karpenter-mgmt-node"
# Exemplo: "isengard-dev-karpenter-mgmt-node"

# Tags específicas do Karpenter
"karpenter.sh/discovery" = "${cluster_name}"
"karpenter.sh/management" = "true"
NodeType = "KarpenterManagement"
NodeGroup = "karpenter-mgmt"
CapacityType = "ON_DEMAND"

# Tags do Kubernetes
"kubernetes.io/cluster/${cluster_name}" = "owned"
```

### **Karpenter Provisioned Nodes**

```hcl
Name = "${cluster_name}-karpenter-provisioned-node"
# Exemplo: "isengard-dev-karpenter-provisioned-node"

# Tags específicas do Karpenter
"karpenter.sh/discovery" = "${cluster_name}"
NodeType = "KarpenterProvisioned"
NodeGroup = "karpenter-provisioned"
ManagedBy = "karpenter"

# Tags do Kubernetes
"kubernetes.io/cluster/${cluster_name}" = "owned"
"k8s.io/cluster-autoscaler/enabled" = "true"
"k8s.io/cluster-autoscaler/${cluster_name}" = "owned"
```

## 🔧 Implementação Técnica

### **Launch Templates**

Criamos Launch Templates para cada node group que garantem:

1. **Tag Specifications**: Tags aplicadas automaticamente às instâncias, volumes e ENIs
2. **User Data**: Script de bootstrap personalizado
3. **Security Groups**: Configuração de segurança adequada
4. **Instance Metadata**: Habilitado para permitir acesso às tags via metadata

### **Recursos Taggeados**

Para cada Launch Template, aplicamos tags em:

- **Instances**: As instâncias EC2 propriamente ditas
- **Volumes**: Volumes EBS anexados às instâncias
- **Network Interfaces**: ENIs das instâncias

### **User Data Script**

O script `userdata.sh` inclui:

- Bootstrap do EKS node
- Instalação do SSM Agent
- Configuração do CloudWatch Agent
- Configuração de hostname baseado no node group
- Logs de bootstrap

## 📊 Visualização na Console AWS

### **EC2 Console**

Agora você verá:

```
Nome da Instância: isengard-dev-general-node
Tags:
├── Name: isengard-dev-general-node
├── NodeGroup: general
├── CapacityType: ON_DEMAND
├── Environment: dev
├── Project: isengard
├── auto-delete: no
└── kubernetes.io/cluster/isengard-dev: owned
```

### **Auto Scaling Groups**

Os ASGs criados pelo EKS terão nomes como:
- `eks-isengard-dev-general-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
- `eks-isengard-dev-spot-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
- `eks-isengard-dev-compute-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`

## 🔍 Verificação

### **Via AWS CLI**

```bash
# Listar instâncias do cluster
aws ec2 describe-instances \
  --filters "Name=tag:kubernetes.io/cluster/isengard-dev,Values=owned" \
  --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`].Value|[0],InstanceId:InstanceId,NodeGroup:Tags[?Key==`NodeGroup`].Value|[0]}'

# Verificar tags de uma instância específica
aws ec2 describe-tags --filters "Name=resource-id,Values=i-1234567890abcdef0"
```

### **Via kubectl**

```bash
# Listar nodes com labels
kubectl get nodes --show-labels

# Verificar node específico
kubectl describe node <node-name>
```

## 🚀 Benefícios

1. **Identificação Clara**: Instâncias com nomes descritivos na console
2. **Organização**: Tags consistentes para filtros e relatórios
3. **Automação**: Cluster Autoscaler funciona corretamente
4. **Monitoramento**: CloudWatch metrics organizados por node group
5. **Billing**: Cost allocation tags para controle de custos
6. **Compliance**: Tags obrigatórias aplicadas automaticamente

## ⚠️ Considerações

- **Launch Templates**: Versionados automaticamente quando há mudanças
- **Rolling Updates**: Mudanças no Launch Template requerem rolling update dos nodes
- **Karpenter**: Usa seu próprio Launch Template para nodes provisionados dinamicamente
- **Costs**: Tags adicionais não geram custos extras

## 🔄 Próximos Passos

1. **Monitoring**: Configurar dashboards baseados nas tags
2. **Cost Management**: Usar tags para cost allocation
3. **Automation**: Scripts de manutenção baseados em tags
4. **Compliance**: Validação automática de tags obrigatórias