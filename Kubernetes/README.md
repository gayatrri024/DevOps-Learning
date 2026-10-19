# Kubernetes Learning Projects

This folder contains Kubernetes manifest practice.

## Topics

- Deployments and replica management
- Services and application access
- ConfigMaps and application configuration
- Multi-component application deployments

## Learning workflow

1. Review each YAML manifest.
2. Validate manifests with `kubectl`.
3. Apply resources to a local test cluster.
4. Inspect resources with `kubectl get` and `kubectl describe`.
5. Delete test resources when finished.

Example validation:

```bash
kubectl apply --dry-run=client -f nginx-deployment.yaml
kubectl get deployments,services
```

## Security

Do not commit real passwords, tokens, or credentials in Kubernetes
Secrets or other manifests. Use safe placeholders for learning.
