class MarkAllAsReadResponseModel {
  final int modifiedCount;
  final String message;

  MarkAllAsReadResponseModel({
    required this.modifiedCount,
    required this.message,
  });

  factory MarkAllAsReadResponseModel.fromJson(Map<String, dynamic> json) {
    return MarkAllAsReadResponseModel(
      modifiedCount: json['modifiedCount'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modifiedCount': modifiedCount,
      'message': message,
    };
  }
}
