class TokensModel {
  String accessToken;
  String refreshToken;

  TokensModel({required this.accessToken, required this.refreshToken});

  Map<String, dynamic> toMap() {
    return {'access_token': accessToken, 'refresh_token': refreshToken};
  }

  factory TokensModel.fromMap(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }
}
