# _odin

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
│   │   │   ├── user-api
│   │   │   └── health-api
│   │   ├── data-stores --> Contains data stores resources that are shared or not by applications
│   │   │   ├── rds
│   │   │   └── redis
│   │   ├── environments --> Contains environments for one or more accounts
│   │   │   ├── prod.hcl
│   │   │   └── staging.hcl
│   │   └── services --> Contains resources that are shared across applications
│   │       ├── msk
│   │       ├── eks
│   │       └── eks
....
└── terragrunt.hcl
```
