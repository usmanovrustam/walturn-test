class UserModel {
  int? age;
  String? id;
  String? email;
  String? name;

  UserModel({
    this.id,
    this.age,
    this.email,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        age: json["age"],
      );
}
