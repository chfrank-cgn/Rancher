# Fleet Utilities - ChartMuseum

Here is a quick setup for ChartMuseum.

> These steps are aimed at rapid setup and teardown!
> The deployments are neither highly available nor do they offer persistence 

## ChartMuseum

To support Fleet, we'll install ChartMuseum:

- `00-roles.yaml` has the namespace
- `01-config.yaml` hast the auth secret
- `02-deployment.yaml` has the actual deployment

> The auth secret has the user "admin" and the password "password"

Happy Ranching!

