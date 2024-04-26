abbr --add kns "kubens"
abbr --add kcx "kubectx"
abbr --add kgnocas "kubectl get nodes -o custom-columns=Name:.metadata.name,InstanceGroup:.metadata.labels.aws/instance-group,KubeletVersion:.status.nodeInfo.kubeletVersion,Unschedulable:.spec.unschedulable --sort-by .metadata.labels.aws/instance-group"
abbr --add kgnok "kubectl get nodes -o custom-columns=Name:.metadata.name,NodePool:.metadata.labels.karpenter\\.sh/nodepool,InstanceType:.metadata.labels.beta\\\\.kubernetes\\\\.io/instance-type,KubeletVersion:.status.nodeInfo.kubeletVersion,Unschedulable:.spec.unschedulable --sort-by .metadata.labels.karpenter\\\\.sh/nodepool"
