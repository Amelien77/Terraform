terraform {
  required_providers {
      aws = {
            source  = "hashicorp/aws"
              version = "~> 5.0"
              }
                }
            }
provider "aws" {
    region = "eu-west-3"
    access_key = "" # la clé d'acces crée pour l'utilisateur qu>
    secret_key = "" # la clé sécrète crée p>
            }

# région eu-west-3
# access_key /secret_key pour se connecter à la console AWS
