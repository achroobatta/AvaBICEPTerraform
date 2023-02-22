locals {
#random number generator to generate unique names for sa and eh namespace
  rng = random_integer.rng.result
}