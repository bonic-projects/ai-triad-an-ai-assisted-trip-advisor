class AdminData {
  final String apiKey;

  AdminData(
      {
        required this.apiKey,
});

  AdminData.fromData(Map<String, dynamic> data)
      : apiKey = data['apiKey'] ?? "";

  Map<String, dynamic> toJson(keyword) {
    return {
      'apiKey': apiKey,
    };
  }
}
