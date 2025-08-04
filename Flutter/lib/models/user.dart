class User {
  final String employeeId;
  final String message;

  User({
    required this.employeeId,
    required this.message,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      employeeId: json['employee_id'] ?? '',
      message: json['MESSAGE'] ?? '',
    );
  }
} 