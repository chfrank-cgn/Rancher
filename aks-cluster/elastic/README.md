# Elasticsearch

Here is a quick setup for Elasticsearch and Kibana.

> These steps are aimed at rapid setup and teardown!  
> The deployments are neither highly available nor do they offer persistence 

## Kube State Metrics

To support metricbeat we will install kube-state-metrics:

- `20-roles.yaml` has the service account and role bindings
- `22-deployment.yaml` has the actual deployment

## Elasticsearch

The first piece of software we'll install is Elasticsearch:

- `01-config.yaml` has the configuration
- `02-deployment.yaml` has the actual deployment

## Kibana

Now that we have the data source, we'll install Kibana for analysis:

- `12-deployment.yaml` has the actual deployment

## Filebeat

To collect logfiles, we'll either install Filebeat, or enable Rancher logging, or both:

- `30-roles.yaml` has the service account and role bindings
- `31-config.yaml` has the configuration
- `32-deployment.yaml` has the actual deployment

## Metricbeat

To collect metrics, we'll install Metricbeat:

- `40-roles.yaml` has the service account and role bindings
- `41-config.yaml` has the configuration
- `42-deployment.yaml` has the actual deployment

## Syslog forwarding 

As an option, we will configure Rancher's logging operator:

- `51-config.yaml` has the cluster flow and output

## Navigation Link

As a finishing touch, we will put navigation links to Kibana into the Rancher UI:

- `99-navlink.yaml` has the navigation links

Happy Ranching!
