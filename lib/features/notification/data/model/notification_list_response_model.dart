class NotificationListResponseModel {
  final int unreadCount;
  final List<NotificationItemModel> unread;
  final List<NotificationItemModel> read;

  NotificationListResponseModel({
    required this.unreadCount,
    required this.unread,
    required this.read,
  });

  factory NotificationListResponseModel.fromJson(Map<String, dynamic> json) {
    final unreadList = (json['unread'] as List<dynamic>? ?? [])
        .map((item) => NotificationItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
    
    final readList = (json['read'] as List<dynamic>? ?? [])
        .map((item) => NotificationItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return NotificationListResponseModel(
      unreadCount: json['unreadCount'] as int? ?? 0,
      unread: unreadList,
      read: readList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unreadCount': unreadCount,
      'unread': unread.map((item) => item.toJson()).toList(),
      'read': read.map((item) => item.toJson()).toList(),
    };
  }
}

class NotificationItemModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationItemModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: (json['_id'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      type: (json['type'] ?? 'general').toString(),
      isRead: (json['read'] ?? false) as bool,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'type': type,
      'read': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
