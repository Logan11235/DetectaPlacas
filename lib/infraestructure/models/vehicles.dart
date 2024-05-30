class Vehicle {
  final String description;
  final String registrationYear;
  final String carMake;
  final String carModel;
  final String vin;
  final String use;
  final String imageUrl;

  Vehicle({
    required this.description,
    required this.registrationYear,
    required this.carMake,
    required this.carModel,
    required this.vin,
    required this.use,
    required this.imageUrl,
  });

  // Factory constructor para crear una instancia de Vehicle a partir de un JSON
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      description: json['Description'],
      registrationYear: json['RegistrationYear'],
      carMake: json['CarMake']['CurrentTextValue'],
      carModel: json['CarModel']['CurrentTextValue'],
      vin: json['VIN'],
      use: json['Use'],
      imageUrl: json['ImageUrl'],
    );
  }
}
