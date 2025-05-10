class RequestAuthModel {
  String username;
  String password;

  RequestAuthModel({required this.username, required this.password});

  factory RequestAuthModel.empty() {
    return RequestAuthModel(username: '', password: '');
  }

  Map<String, dynamic> toMap() {
    return {'username': username, 'password': password};
  }
}
