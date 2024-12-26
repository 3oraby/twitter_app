double calcEstimatedFare(double distance) {
  double baseFare = 5.0;
  double pricePerKm = 2.0; 
  return baseFare + (pricePerKm * distance);
}
