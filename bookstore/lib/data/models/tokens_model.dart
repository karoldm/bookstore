class TokensModel {
  String accessToken;
  String refreshToken;

  TokensModel({required this.accessToken, required this.refreshToken});

  Map<String, dynamic> toMap() {
    return {'token': accessToken, 'refreshToken': refreshToken};
  }

  factory TokensModel.fromMap(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json['token'],
      refreshToken: json['refreshToken'],
    );
  }
}
