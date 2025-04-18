class AuthModel {
  String username;
  String password;

  AuthModel({
    required this.username,
    required this.password,
  });

  factory AuthModel.empty() {
    return AuthModel(
      username: '',
      password: '',
    );
  }
}
