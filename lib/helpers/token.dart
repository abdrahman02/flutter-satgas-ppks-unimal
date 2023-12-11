class Token {
  static String userToken = "";

  void updateToken(String newToken) {
    userToken = newToken;
  }

  void clearToken() {
    userToken = "";
  }
}
