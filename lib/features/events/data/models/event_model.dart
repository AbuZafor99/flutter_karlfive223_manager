class CreatedByModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;

  CreatedByModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory CreatedByModel.fromJson(Map<String, dynamic> json) {
    return CreatedByModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}

class ApprovedByModel {
  final String id;
  final String name;
  final String email;

  ApprovedByModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory ApprovedByModel.fromJson(Map<String, dynamic> json) {
    return ApprovedByModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
    };
  }
}

class EventModel {
  final String id;
  final CreatedByModel createdBy;
  final String organizationName;
  final String eventName;
  final String startDate;
  final String endDate;
  final String status; // 'pending' or 'approved'
  final String? otp;
  final String? otpExpiry;
  final ApprovedByModel? approvedBy;
  final String? approvalDate;
  final String? declineReason;
  final int otpUsedCount;
  final String createdAt;
  final String updatedAt;

  EventModel({
    required this.id,
    required this.createdBy,
    required this.organizationName,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.otp,
    this.otpExpiry,
    this.approvedBy,
    this.approvalDate,
    this.declineReason,
    this.otpUsedCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] as String? ?? '',
      createdBy: json['createdBy'] != null
          ? CreatedByModel.fromJson(json['createdBy'] as Map<String, dynamic>)
          : CreatedByModel(id: '', name: '', email: '', phoneNumber: ''),
      organizationName: json['organizationName'] as String? ?? '',
      eventName: json['eventName'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      otp: json['otp'] as String?,
      otpExpiry: json['otpExpiry'] as String?,
      approvedBy: json['approvedBy'] != null
          ? ApprovedByModel.fromJson(json['approvedBy'] as Map<String, dynamic>)
          : null,
      approvalDate: json['approvalDate'] as String?,
      declineReason: json['declineReason'] as String?,
      otpUsedCount: json['otpUsedCount'] as int? ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'createdBy': createdBy.toJson(),
      'organizationName': organizationName,
      'eventName': eventName,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'otp': otp,
      'otpExpiry': otpExpiry,
      'approvedBy': approvedBy?.toJson(),
      'approvalDate': approvalDate,
      'declineReason': declineReason,
      'otpUsedCount': otpUsedCount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  EventModel copyWith({
    String? id,
    CreatedByModel? createdBy,
    String? organizationName,
    String? eventName,
    String? startDate,
    String? endDate,
    String? status,
    String? otp,
    String? otpExpiry,
    ApprovedByModel? approvedBy,
    String? approvalDate,
    String? declineReason,
    int? otpUsedCount,
    String? createdAt,
    String? updatedAt,
  }) {
    return EventModel(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      organizationName: organizationName ?? this.organizationName,
      eventName: eventName ?? this.eventName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      otp: otp ?? this.otp,
      otpExpiry: otpExpiry ?? this.otpExpiry,
      approvedBy: approvedBy ?? this.approvedBy,
      approvalDate: approvalDate ?? this.approvalDate,
      declineReason: declineReason ?? this.declineReason,
      otpUsedCount: otpUsedCount ?? this.otpUsedCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
