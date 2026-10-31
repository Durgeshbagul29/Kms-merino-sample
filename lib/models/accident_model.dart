/// Accident Report Model
///
/// Represents a single accident record as returned by the API.
/// API endpoints:
///   - List   : GET  /api/view_user_accidents/{user_id}
///   - Detail : GET  /api/view_user_accident_details/{id}
///   - Create : POST /api/add_accident_record  (multipart/form-data)
///
/// Fields observed across the project:
///   id, accident_id, incident, analysis, action, image, user_id, sys_date, status
class AccidentModel {
  /// Internal database primary key.
  final int id;

  /// Human-readable accident identifier (e.g. "ACC-001").
  final String accidentId;

  /// Detailed description of what happened.
  final String incident;

  /// Root-cause analysis of the accident.
  final String analysis;

  /// Corrective / remedial action taken or planned.
  final String action;

  /// Optional URL or filename of the attached evidence image.
  final String? image;

  /// ID of the user who submitted the report.
  final int userId;

  /// Date the record was created (formatted string from server, e.g. "2025-03-11").
  final String sysDate;

  /// Workflow status of the report.
  ///   0 = Pending
  ///   1 = Implemented & Closed
  final int status;

  const AccidentModel({
    required this.id,
    required this.accidentId,
    required this.incident,
    required this.analysis,
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
  String get statusLabel => isPending ? 'Pending' : 'Implemented & Closed';

  // ── Factory constructors ─────────────────────────────────────────────────────

  /// Deserialise from a JSON [Map] (as returned by the REST API).
  factory AccidentModel.fromJson(Map<String, dynamic> json) {
    return AccidentModel(
      id: _parseInt(json['id']),
      accidentId: (json['accident_id'] ?? '').toString(),
      incident: (json['incident'] ?? '').toString(),
      analysis: (json['analysis'] ?? '').toString(),
      action: (json['action'] ?? '').toString(),
      image: json['image'] as String?,
      userId: _parseInt(json['user_id']),
      sysDate: (json['sys_date'] ?? '').toString(),
      status: _parseInt(json['status']),
    );
  }

  /// Convenience factory that returns a blank / default instance.
  factory AccidentModel.empty() {
    return const AccidentModel(
      id: 0,
      accidentId: '',
      incident: '',
      analysis: '',
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
      'accident_id': accidentId,
      'incident': incident,
      'analysis': analysis,
      'action': action,
      if (image != null) 'image': image,
      'user_id': userId,
      'sys_date': sysDate,
      'status': status,
    };
  }

  // ── Immutable update ─────────────────────────────────────────────────────────

  /// Returns a new [AccidentModel] with the specified fields replaced.
  AccidentModel copyWith({
    int? id,
    String? accidentId,
    String? incident,
    String? analysis,
    String? action,
    String? image,
    int? userId,
    String? sysDate,
    int? status,
  }) {
    return AccidentModel(
      id: id ?? this.id,
      accidentId: accidentId ?? this.accidentId,
      incident: incident ?? this.incident,
      analysis: analysis ?? this.analysis,
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
    return other is AccidentModel &&
        other.id == id &&
        other.accidentId == accidentId &&
        other.incident == incident &&
        other.analysis == analysis &&
        other.action == action &&
        other.image == image &&
        other.userId == userId &&
        other.sysDate == sysDate &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(
        id,
        accidentId,
        incident,
        analysis,
        action,
        image,
        userId,
        sysDate,
        status,
      );

  // ── Debug ────────────────────────────────────────────────────────────────────

  @override
  String toString() {
    return 'AccidentModel('
        'id: $id, '
        'accidentId: $accidentId, '
        'incident: $incident, '
        'analysis: $analysis, '
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

// ── API Response wrapper ──────────────────────────────────────────────────────

/// Wraps the standard API envelope used for accident list and detail endpoints.
///
/// ```json
/// {
///   "success": true,
///   "message": "...",
///   "data": [ { ...AccidentModel fields... } ]
/// }
/// ```
class AccidentListResponse {
  final bool success;
  final String message;
  final List<AccidentModel> data;

  const AccidentListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AccidentListResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    final List<AccidentModel> items = (rawList is List)
        ? rawList.map((e) => AccidentModel.fromJson(e as Map<String, dynamic>)).toList()
        : [];
    return AccidentListResponse(
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
      'AccidentListResponse(success: $success, message: $message, data.length: ${data.length})';
}

/// Wraps the API envelope used for a single accident detail endpoint.
///
/// ```json
/// { "success": true, "message": "...", "data": { ...AccidentModel fields... } }
/// ```
class AccidentDetailResponse {
  final bool success;
  final String message;
  final AccidentModel? data;

  const AccidentDetailResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AccidentDetailResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return AccidentDetailResponse(
      success: json['success'] as bool? ?? false,
      message: (json['message'] ?? '').toString(),
      data: rawData != null
          ? AccidentModel.fromJson(rawData as Map<String, dynamic>)
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
