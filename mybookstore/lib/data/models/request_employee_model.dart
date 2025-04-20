class RequestEmployeeModel {
  String name;
  String username;
  String password;
  String? photo;

  RequestEmployeeModel({
    required this.name,
    required this.username,
    required this.password,
    this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'password': password,
      'photo': photo,
    };
  }

  factory RequestEmployeeModel.empty() {
    return RequestEmployeeModel(
      name: '',
      username: '',
      password: '',
      photo: null,
    );
  }
}
