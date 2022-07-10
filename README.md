# _Odin

## Structure

This is how we are implementing IaC at _Odin.

* **One of our premises is that we want the same code as the production environment in our staging/development environment.**

### Below we have a example of how we organize the folder structure of each account


```sh
.
├── README.md
├── accounts
│   ├── example
│   │   ├── applications --> Contains all resources that are owned by an application
│   │   │   ├── web-app-api
│   │   │   └── web-app-v2-api
│   │   ├── data-stores --> Contains data stores resources that are shared or not by applications
│   │   │   ├── dynamodb
|   |   |   ├── rds
│   │   │   └── redis
│   │   ├── environments --> Contains environments for one or more accounts
│   │   │   ├── prod.hcl
│   │   │   └── staging.hcl
│   │   └── services --> Contains resources that are shared across applications
│   │       ├── ec2s
│   │       └── eks
....
└── terragrunt.hcl
```
