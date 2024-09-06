class RequestOtp {
  final String username;
  final String name;
  final String password;
  final bool privacy_policy;

  RequestOtp({
    required this.username,
    required this.name,
    required this.password,
    required this.privacy_policy,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'password': password,
      'privacy_policy': privacy_policy,
    };
  }
}
