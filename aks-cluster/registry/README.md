# Fleet Utilities - Registry

Here is a quick setup for the CNCF Registry.

> These steps are aimed at rapid setup and teardown!
> The deployments are neither highly available nor do they offer persistence 

## Registry

To support Fleet, we'll install a registry:

- `00-roles.yaml` has the namespace
- `02-deployment.yaml` has the actual deployment

> Make sure to configure `{ "insecure-registries" : ["docker.ingress.host"] }` or add a certificate to the ingress definition

Happy Ranching!

