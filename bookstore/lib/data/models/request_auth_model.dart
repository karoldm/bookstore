class RequestAuthModel {
  String user;
  String password;

  RequestAuthModel({required this.user, required this.password});

  factory RequestAuthModel.empty() {
    return RequestAuthModel(user: '', password: '');
  }

  Map<String, dynamic> toMap() {
    return {'user': user, 'password': password};
  }
}
