provider "azurerm" {
 # version = "=2.1.0"
  features {}
}

module "tag-ressource" {
  source  = "app.terraform.io/PersoPierre/tag-ressource/azurerm"
  version = "0.0.1"

  namespace = {
    ent_code  =lookup(var.tags, "ent","")
    dept_code =lookup(var.tags, "dept","")
    env_code  =lookup(var.tags, "env","")
    type_code =lookup(var.tags, "type","")
  }
  free_name = var.app_name
}

data "azurerm_resource_group" "RG1" {
  name     = var.rg_name
}

resource "azurerm_app_service_plan" "app-plan" {
  name                = "${module.tag-ressource.generated_values.name}plan"
  location            = data.azurerm_resource_group.RG1.location
  resource_group_name = data.azurerm_resource_group.RG1.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "example" {
  name                = module.tag-ressource.generated_values.name
  location            = data.azurerm_resource_group.RG1.location
  resource_group_name = data.azurerm_resource_group.RG1.name
  app_service_plan_id = azurerm_app_service_plan.app-plan.id

}