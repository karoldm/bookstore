class CreateEmployeeModel {
  String name;
  String username;
  String password;

  CreateEmployeeModel({
    required this.name,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'username': username, 'password': password};
  }

  factory CreateEmployeeModel.empty() {
    return CreateEmployeeModel(name: '', username: '', password: '');
  }
}
