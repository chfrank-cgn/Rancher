# Hauler

Here is a quick setup for RGS Hauler.

> These steps are aimed at rapid setup and teardown!
> The deployment is neither highly available nor does it offer persistence 

## Hauler Serving Store

We'll serve the Hauler store as a fileserver and a registry:

- `00-roles.yaml` has the namespace
- `01-config.yaml` has the hauler manifest
- `02-job.yaml` has the initial hauler store sync
- `12-deployment.yaml` has the fileserver deployment
- `22-deployment.yaml` has the registry deployment

Happy Ranching!

