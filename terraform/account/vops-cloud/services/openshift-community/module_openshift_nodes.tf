module "openshift-community_nodes_dev" {
  source  = "./envs/dev/nodes/src"
}

module "openshift-community_masters_dev" {
  source  = "./envs/dev/masters/src"
}