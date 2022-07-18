// Get the avaliability zones in the provider's region that have the state as 'avaliable'
data "aws_availability_zones" "azs" {
  state = "available"
}