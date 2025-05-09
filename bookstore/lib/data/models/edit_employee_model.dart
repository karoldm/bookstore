class EditEmployeeModel {
  String name;
  String? password;

  EditEmployeeModel({required this.name, this.password});

  Map<String, dynamic> toMap() {
    return {'name': name, 'password': password};
  }

  factory EditEmployeeModel.empty() {
    return EditEmployeeModel(name: '', password: null);
  }
}
