// To parse this JSON data, do
//
//     final carDetails = carDetailsFromJson(jsonString);

import 'dart:convert';

CarDetails carDetailsFromJson(String str) => CarDetails.fromJson(json.decode(str));

String carDetailsToJson(CarDetails data) => json.encode(data.toJson());

class CarDetails {
    int? id;
    dynamic name;
    dynamic licensePlate;
    dynamic image128;

    CarDetails({
        this.id,
        this.name,
        this.licensePlate,
        this.image128,
    });

    factory CarDetails.fromJson(Map<String, dynamic> json) => CarDetails(
        id: json["id"],
        name: json["name"],
        licensePlate: json["license_plate"],
        image128: json["image_128"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "license_plate": licensePlate,
        "image_128": image128,
    };
}
