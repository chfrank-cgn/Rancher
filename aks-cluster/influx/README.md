# Deconstructing TICK

TICK is another monitoring stack, and the acronym stands for Telegraf, InfluxDB, Chronograf, and Kapacitor.
InfluxDB 2.0 is more of a TI stack since InfluxDB now bundles the UI.

> The steps below are aimed at rapid setup and teardown!  
> The deployments are neither highly available nor do they offer persistence.

## State Metrics

An essential tool for Kubernetes metrics is kube-state-metrics, which we will install first:

- `20-roles.yaml` has the service account and role bindings
- `22-deployment.yaml` has the actual deployment

kube-state-metrics depends on the Kubernetes version; check [here](https://github.com/kubernetes/kube-state-metrics#compatibility-matrix) for the correct version.

## InfluxDB

We first install a local instance of InfluxDB:

- `00-roles.yaml` has the service account and role bindings
- `02-deployment.yaml` has the actual deployment and the ingress definition

InfluxDB has example dashboards for Kubernetes metrics, and you can load them [here](https://raw.githubusercontent.com/influxdata/community-templates/master/k8s/k8s.yml).

## Telegraf DS

To load the metrics for the sample dashboards, we need two instances of Telegraf. The first instance is a DaemonSet that collects the Kubernetes metrics:

- `10-roles.yaml` has the service account and role bindings
- `11-config.yaml` has the configuration
- `12-deployment.yaml` has the actual deployment

## Telegraf 

The second instance is a simple Deployment that collects Kubernetes inventory data:

- `31-config.yaml` has the configuration
- `32-deployment.yaml` has the actual deployment

## Prometheus metrics

In addition to writing to a local instance, Telegraf can write to multiple remote instances. Also, Telegraf can scrape metrics in Prometheus format. We'll combine these two features to send our Kubernetes state metrics to Influxdata's cloud:

- `41-config.yaml` has the configuration
- `42-deployment.yaml` has the actual deployment

## Syslog forwarding 

The installation so far only covers metrics; we will need to configure Rancher's logging operator to send the log files to Syslog:

- `51-config.yaml` has the cluster flow and output

## Navigation Link

As a finishing touch, we will put navigation links to the InfluxDB instances into the Rancher UI:

- `99-navlink.yaml` has the navigation links

Happy Ranching!

