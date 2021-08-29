part of swagger.api;

class OAuth implements Authentication {
  String accessToken;

  OAuth({required this.accessToken});

  @override
  void applyToParams(
      List<QueryParam> queryParams, Map<String, String> headerParams) {
    headerParams["Authorization"] = "Bearer " + accessToken;
  }

  void setAccessToken(String accessToken) {
    this.accessToken = accessToken;
  }
}
