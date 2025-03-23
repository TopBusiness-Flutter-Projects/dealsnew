
class GetUserDataModel {
    int? id;
    dynamic email;
    dynamic phone;
    dynamic name;
    dynamic partnerId;
    dynamic image1920;
    dynamic login;

    GetUserDataModel({
        this.id,
        this.email,
        this.phone,
        this.name,
        this.partnerId,
        this.image1920,
        this.login,
    });

    factory GetUserDataModel.fromJson(Map<String, dynamic> json) => GetUserDataModel(
        id: json["id"],
        email: json["email"],
        phone: json["phone"],
        name: json["name"],
        partnerId: json["partner_id"],
        image1920: json["image_1920"],
        login: json["login"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "phone": phone,
        "name": name,
        "partner_id": partnerId,
        "image_1920": image1920,
        "login": login,
    };
}
