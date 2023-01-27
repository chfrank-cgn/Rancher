# OPA Gatekeeper

This directory contains common policies needed to migrate Pod Security Policies to Constraints and Constraint Templates from the [OPA Gatekeeper Library](https://open-policy-agent.github.io/gatekeeper-library/website/)


| Control Aspect | Field Names in PSP  | Gatekeeper Constraint Template |
|-|-|-|
| Running of privileged containers | `privileged` | `privileged-containers` |
| Usage of host namespaces | `hostPID`, `hostIPC` | `host-namespaces` |
| Usage of host networking and ports | `hostNetwork`, `hostPorts` | `host-network-ports` |
| Usage of volume types | `volumes` | `volumes` |
| Usage of the host filesystem | `allowedHostPaths` | `host-filesystem` |
| Approved list of flex-volume drivers | `allowedFlexVolumes` | `flexvolume-drivers` |
| Requiring the use of a read only root file system | `readOnlyRootFilesystem` | `read-only-root-filesystem` |
| The user and group IDs of the container | `runAsUser`, `runAsGroup`, `supplementalGroups`, `fsgroup` | `users` |
| Restricting escalation to root privileges | `allowPrivilegeEscalation`, `defaultAllowPrivilegeEscalation` |  `allow-privilege-escalation` |
| Linux capabilities | `defaultAddCapabilities`, `requiredDropCapabilities`, `allowedCapabilities` | `capabilities` |
| The SELinux context of the container | `seLinux` | `selinux` |
| The allowed Proc mount types for the container | `allowedProcMountTypes` | `proc-mount` |
| The AppArmor profile used by containers | | `apparmor` |
| The seccomp profile used by containers | | `seccomp` |
| The sysctl profile used by containers | `forbiddenSysctls`,`allowedUnsafeSysctls` | `forbidden-sysctls` |


[Source](https://github.com/open-policy-agent/gatekeeper-library/blob/master/library/pod-security-policy/README.md)
