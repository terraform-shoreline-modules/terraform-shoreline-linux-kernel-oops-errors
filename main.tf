terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kernel_oops_errors" {
  source    = "./modules/kernel_oops_errors"

  providers = {
    shoreline = shoreline
  }
}