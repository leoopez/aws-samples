An Amazon Machine Image (AMI) is a template that contains a software configuration (for example, an operating system, an application server, and applications) for your Amazon EC2 instances.

AMIs are used to create new instances with the same configuration. You can launch instances from as many different AMIs as you need.

AMIs include the following components:

- One or more Amazon Elastic Block Store (EBS) snapshots, or, for instance-store-backed AMIs, a template for the root file system.
- Launch permissions that control which AWS accounts can use the AMI to launch instances.
- A block device mapping that specifies the volumes to attach to the instance when it's launched.