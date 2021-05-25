class UserModel {
  String? name;
  String? email;

  UserModel({
    this.name,
    this.email,
  });

  static const String _name = 'name';
  static const String _email = 'email';

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json[_name];
    email = json[_email];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data[_name] = name;
    data[_email] = email;

    return data;
  }
}
