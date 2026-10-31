/// Near Miss Report Model
///
/// Represents a single near-miss record as returned by the API.
/// API endpoints:
///   - List   : GET  /api/view_user_nearmiss/{user_id}
///   - Detail : GET  /api/view_user_nearmiss_details/{id}
///   - Create : POST /api/add_nearmiss_record  (multipart/form-data)
///
/// Fields observed across the project:
///   id, nearmiss_id, incident, action, image, user_id, sys_date, status
class NearmissModel {
  /// Internal database primary key.
  final int id;

  /// Human-readable near-miss identifier (e.g. "NM-007").
  final String nearmissId;

  /// Description of the near-miss incident.
  final String incident;

  /// Recommended corrective / preventive action.
  final String action;

  /// Optional URL or filename of the attached evidence image.
  final String? image;

  /// ID of the user who submitted the report.
  final int userId;

  /// Date the record was created (formatted string from server, e.g. "2025-03-11").
  final String sysDate;

  /// Workflow status of the report.
  ///   0 = Pending
  ///   1 = Closed
  final int status;

  const NearmissModel({
    required this.id,
    required this.nearmissId,
    required this.incident,
    required this.action,
    this.image,
    required this.userId,
    required this.sysDate,
    required this.status,
  });

  // ── Derived helpers ─────────────────────────────────────────────────────────

  /// Returns `true` when the report is still awaiting action.
  bool get isPending => status == 0;

  /// Returns a human-readable status label.
  String get statusLabel => isPending ? 'Pending' : 'Closed';

  // ── Factory constructors ─────────────────────────────────────────────────────

  /// Deserialise from a JSON [Map] (as returned by the REST API).
  factory NearmissModel.fromJson(Map<String, dynamic> json) {
    return NearmissModel(
      id: _parseInt(json['id']),
      nearmissId: (json['nearmiss_id'] ?? '').toString(),
      incident: (json['incident'] ?? '').toString(),
      action: (json['action'] ?? '').toString(),
      image: json['image'] as String?,
      userId: _parseInt(json['user_id']),
      sysDate: (json['sys_date'] ?? '').toString(),
      status: _parseInt(json['status']),
    );
  }

  /// Convenience factory that returns a blank / default instance.
  factory NearmissModel.empty() {
    return const NearmissModel(
      id: 0,
      nearmissId: '',
      incident: '',
      action: '',
      image: null,
      userId: 0,
      sysDate: '',
      status: 0,
    );
  }

  // ── Serialisation ────────────────────────────────────────────────────────────

  /// Serialise to a JSON [Map].
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nearmiss_id': nearmissId,
      'incident': incident,
      'action': action,
      if (image != null) 'image': image,
      'user_id': userId,
      'sys_date': sysDate,
      'status': status,
    };
  }

  // ── Immutable update ─────────────────────────────────────────────────────────

  /// Returns a new [NearmissModel] with the specified fields replaced.
  NearmissModel copyWith({
    int? id,
    String? nearmissId,
    String? incident,
    String? action,
    String? image,
    int? userId,
    String? sysDate,
    int? status,
  }) {
    return NearmissModel(
      id: id ?? this.id,
      nearmissId: nearmissId ?? this.nearmissId,
      incident: incident ?? this.incident,
      action: action ?? this.action,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      sysDate: sysDate ?? this.sysDate,
      status: status ?? this.status,
    );
  }

  // ── Equality & hashing ───────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NearmissModel &&
        other.id == id &&
        other.nearmissId == nearmissId &&
        other.incident == incident &&
        other.action == action &&
        other.image == image &&
        other.userId == userId &&
        other.sysDate == sysDate &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(
        id,
        nearmissId,
        incident,
        action,
        image,
        userId,
        sysDate,
        status,
      );

  // ── Debug ────────────────────────────────────────────────────────────────────

  @override
  String toString() {
    return 'NearmissModel('
        'id: $id, '
        'nearmissId: $nearmissId, '
        'incident: $incident, '
        'action: $action, '
        'image: $image, '
        'userId: $userId, '
        'sysDate: $sysDate, '
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

/// Wraps the standard API envelope used for near-miss list endpoint.
///
/// ```json
/// { "success": true, "message": "...", "data": [ { ...NearmissModel... } ] }
/// ```
class NearmissListResponse {
  final bool success;
  final String message;
  final List<NearmissModel> data;

  const NearmissListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NearmissListResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    final List<NearmissModel> items = (rawList is List)
        ? rawList.map((e) => NearmissModel.fromJson(e as Map<String, dynamic>)).toList()
        : [];
    return NearmissListResponse(
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
      'NearmissListResponse(success: $success, message: $message, data.length: ${data.length})';
}

/// Wraps the API envelope used for the near-miss detail endpoint.
///
/// ```json
/// { "success": true, "message": "...", "data": { ...NearmissModel... } }
/// ```
class NearmissDetailResponse {
  final bool success;
  final String message;
  final NearmissModel? data;

  const NearmissDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory NearmissDetailResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return NearmissDetailResponse(
      success: json['success'] as bool? ?? false,
      message: (json['message'] ?? '').toString(),
      data: rawData != null
          ? NearmissModel.fromJson(rawData as Map<String, dynamic>)
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
