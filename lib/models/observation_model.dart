/// Safety Observation Model
///
/// Represents a single safety observation record as returned by the API.
/// API endpoints:
///   - List   : GET  /api/view_user_observation/{user_id}
///   - Detail : GET  /api/view_user_obs_details/{id}
///   - Create : POST /api/add_observation_record  (multipart/form-data)
///
/// Fields observed across the project:
///   id, observation_id, observation, action, image, user_id, created_at, status
///
/// Status values (from [user_observations_list.dart]):
///   0 = Pending
///   1 = Approved
///   2 = Rejected
class ObservationModel {
  /// Internal database primary key.
  final int id;

  /// Human-readable observation identifier (e.g. "OBS-012").
  final String observationId;

  /// Detailed description of the safety observation.
  final String observation;

  /// Recommended corrective / preventive action.
  final String action;

  /// Optional URL or filename of the attached evidence image.
  final String? image;

  /// ID of the user who submitted the observation.
  final int userId;

  /// ISO-8601 datetime string when the record was created (e.g. "2025-03-11T10:30:00.000000Z").
  /// Use [createdAtDate] for the date-only string.
  final String createdAt;

  /// Workflow status of the observation.
  ///   0 = Pending   (awaiting manager review)
  ///   1 = Approved  (accepted)
  ///   2 = Rejected  (declined)
  final int status;

  const ObservationModel({
    required this.id,
    required this.observationId,
    required this.observation,
    required this.action,
    this.image,
    required this.userId,
    required this.createdAt,
    required this.status,
  });

  // ── Derived helpers ─────────────────────────────────────────────────────────

  /// Returns `true` while the observation is awaiting a decision.
  bool get isPending => status == 0;

  /// Returns `true` when the observation has been approved.
  bool get isApproved => status == 1;

  /// Returns `true` when the observation has been rejected.
  bool get isRejected => status == 2;

  /// Returns a human-readable status label.
  String get statusLabel {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  /// Extracts the date portion (YYYY-MM-DD) from [createdAt].
  /// Returns [createdAt] unmodified if it cannot be parsed.
  String get createdAtDate {
    try {
      return DateTime.parse(createdAt).toString().split(' ')[0];
    } catch (_) {
      return createdAt;
    }
  }

  // ── Factory constructors ─────────────────────────────────────────────────────

  /// Deserialise from a JSON [Map] (as returned by the REST API).
  factory ObservationModel.fromJson(Map<String, dynamic> json) {
    return ObservationModel(
      id: _parseInt(json['id']),
      observationId: (json['observation_id'] ?? '').toString(),
      observation: (json['observation'] ?? '').toString(),
      action: (json['action'] ?? '').toString(),
      image: json['image'] as String?,
      userId: _parseInt(json['user_id']),
      createdAt: (json['created_at'] ?? '').toString(),
      status: _parseInt(json['status']),
    );
  }

  /// Convenience factory that returns a blank / default instance.
  factory ObservationModel.empty() {
    return const ObservationModel(
      id: 0,
      observationId: '',
      observation: '',
      action: '',
      image: null,
      userId: 0,
      createdAt: '',
      status: 0,
    );
  }

  // ── Serialisation ────────────────────────────────────────────────────────────

  /// Serialise to a JSON [Map].
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'observation_id': observationId,
      'observation': observation,
      'action': action,
      if (image != null) 'image': image,
      'user_id': userId,
      'created_at': createdAt,
      'status': status,
    };
  }

  // ── Immutable update ─────────────────────────────────────────────────────────

  /// Returns a new [ObservationModel] with the specified fields replaced.
  ObservationModel copyWith({
    int? id,
    String? observationId,
    String? observation,
    String? action,
    String? image,
    int? userId,
    String? createdAt,
    int? status,
  }) {
    return ObservationModel(
      id: id ?? this.id,
      observationId: observationId ?? this.observationId,
      observation: observation ?? this.observation,
      action: action ?? this.action,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  // ── Equality & hashing ───────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ObservationModel &&
        other.id == id &&
        other.observationId == observationId &&
        other.observation == observation &&
        other.action == action &&
        other.image == image &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(
        id,
        observationId,
        observation,
        action,
        image,
        userId,
        createdAt,
        status,
      );

  // ── Debug ────────────────────────────────────────────────────────────────────

  @override
  String toString() {
    return 'ObservationModel('
        'id: $id, '
        'observationId: $observationId, '
        'observation: $observation, '
        'action: $action, '
        'image: $image, '
        'userId: $userId, '
        'createdAt: $createdAt, '
        'status: $status'
        ')';
  }

  // ── Private helpers ──────────────────────────────────────────────────────────

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}

// ── API Response wrappers ─────────────────────────────────────────────────────

/// Wraps the standard API envelope used for the observation list endpoint.
///
/// ```json
/// {
///   "success": true,
///   "message": "...",
///   "data": [ { ...ObservationModel... } ]
/// }
/// ```
class ObservationListResponse {
  final bool success;
  final String message;
  final List<ObservationModel> data;

  const ObservationListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ObservationListResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    final List<ObservationModel> items = (rawList is List)
        ? rawList
            .map((e) => ObservationModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : [];
    return ObservationListResponse(
      success: json['success'] as bool? ?? false,
      message: (json['message'] ?? '').toString(),
      data: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'ObservationListResponse(success: $success, message: $message, data.length: ${data.length})';
}

/// Wraps the API envelope used for the observation detail endpoint.
///
/// ```json
/// { "success": true, "message": "...", "data": { ...ObservationModel... } }
/// ```
class ObservationDetailResponse {
  final bool success;
  final String message;
  final ObservationModel? data;

  const ObservationDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ObservationDetailResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return ObservationDetailResponse(
      success: json['success'] as bool? ?? false,
      message: (json['message'] ?? '').toString(),
      data: rawData != null
          ? ObservationModel.fromJson(rawData as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
