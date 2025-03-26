# Backstage on Kubernetes

A Kubernetes deployment configuration for [Backstage](https://backstage.io/), an open-source platform for building developer portals.

## Overview

This repository contains Kubernetes manifests and configuration files for deploying Backstage to a Kubernetes cluster. It provides a production-ready setup with reasonable defaults that can be customized to fit your organization's needs.

## Features

- Complete Kubernetes deployment configuration for Backstage
- Separation of frontend and backend services
- Configurable database integration
- Optional TLS/HTTPS support
- Horizontal scaling capabilities
- Configurable with Kubernetes secrets and config maps

## Prerequisites

- Kubernetes cluster (v1.19+)
- kubectl configured to communicate with your cluster
- Helm (optional, for chart-based deployment)
- PostgreSQL database (can be deployed separately or as part of this setup)

## Installation

### Using kubectl

```bash
# Clone the repository
git clone https://github.com/yourusername/backstage-k8s.git
cd backstage-k8s

# Create namespace
kubectl create namespace backstage

# Apply configurations
kubectl apply -f kubernetes/configmaps.yaml
kubectl apply -f kubernetes/secrets.yaml
kubectl apply -f kubernetes/database.yaml
kubectl apply -f kubernetes/backend.yaml
kubectl apply -f kubernetes/frontend.yaml
```

### Using Helm (if implemented)

```bash
helm repo add backstage-k8s https://yourusername.github.io/backstage-k8s
helm install backstage backstage-k8s/backstage -n backstage
```

## Configuration

The deployment can be configured through the following files:

- `kubernetes/configmaps.yaml` - General configuration
- `kubernetes/secrets.yaml` - Sensitive information (API keys, credentials)
- `app-config.yaml` - Backstage application configuration

### Customizing the Configuration

Update the `app-config.yaml` file with your specific configuration needs:

```yaml
app:
  title: Your Developer Portal
  baseUrl: https://your-backstage-instance.example.com

organization:
  name: Your Organization Name
```

## Usage

Once deployed, Backstage should be accessible via the configured ingress. By default, this will be at:

```
http://<ingress-address>/
```

For production deployments, configure a proper ingress with your domain and TLS certificates.

## Development

To set up a local development environment:

```bash
# Start minikube
minikube start

# Apply development configuration
kubectl apply -f kubernetes/dev/

# Forward ports for local access
kubectl port-forward -n backstage svc/backstage-frontend 3000:80
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [Backstage](https://backstage.io/) - For creating an amazing developer portal platform
- [Kubernetes](https://kubernetes.io/) - For the container orchestration platform