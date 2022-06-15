# Deconstructing Prometheus

Even though SUSE Rancher includes an operator-based Prometheus installation in the Apps Marketplace, it can be beneficial to manually install a complete Prometheus/Loki/Grafana stack.

> These steps are aimed at rapid setup and teardown!  
> The deployments are neither highly available nor do they offer persistence 

## State Metrics

An essential tool for Kubernetes metrics is kube-state-metrics, which we will install first:

- `10-roles.yaml` has the service account and role bindings
- `12-deployment.yaml` has the actual deployment

kube-state-metrics depends on the Kubernetes version; check [here](https://github.com/kubernetes/kube-state-metrics#compatibility-matrix) for the correct version.

## Prometheus

The next piece of software we'll install is Prometheus to collect Kubernetes metrics:

- `00-roles.yaml` has the service account and role bindings
- `01-config.yaml` has the config maps with the rules and alerts
- `02-deployment.yaml` has the actual deployment

The number of alerts and rules is at a bare minimum. If you want to install the [Kubernetes mixin](https://github.com/kubernetes-monitoring/kubernetes-mixin) dashboards, make sure to include the additional rules and alerts in the configuration.


## Node exporter

To get metrics from the underlying nodes, we'll install the node exporter:

- `32-deployment.yaml` has the actual deployment

As the node exporters come online, Prometheus will start scraping their endpoints.

## Loki

Next, we'll install Loki to store the Kubernetes logs:

- `40-roles.yaml` has the service account and role bindings
- `41-config.yaml` has the config maps with the ruler
- `42-deployment.yaml` has the actual deployment

The ruler is activated to keep the installation simple, but no rules are defined.

## Grafana

Now that we have the data sources, we'll install Grafana for analysis:

- `21-config.yaml` has the config maps for automatic provisioning
- `21-dashboard.yaml` has the SUSE Rancher Home dashboard
- `22-deployment.yaml` has the actual deployment

Grafana 8 does not yet allow for automatic provisioning of notifiers for Unified Alerting; this is planned for Grafana 9 and tracked in Issue [#39510](https://github.com/grafana/grafana/discussions/39510).

Unified alerting works fine, so we do not install Alertmanager anymore.

## Syslog forwarding 

Prometheus will start scraping metrics automatically, but for the logs, we will need to configure Rancher's logging operator:

- `51-config.yaml` has the cluster flow and output

## Navigation Link

As a finishing touch, we will put navigation links to Grafana into the Rancher UI:

- `99-navlink.yaml` has the navigation links

Happy Ranching!

