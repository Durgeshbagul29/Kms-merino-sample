/// Ethics Complaint Model
///
/// Represents a single ethics/complaint record as returned by the API.
/// API endpoints:
///   - List   : GET  /api/view_user_complaints/{user_id}
///   - Create : POST /api/add_user_complaint  (JSON body)
///
/// Fields observed across the project:
///   id, complaint_id, complaint, userid, date, status
///
/// Status values (from [user_ethics_screen.dart]):
///   0 = Pending
///   1 = Seen
class EthicsComplaintModel {
  /// Internal database primary key.
  final int id;

  /// Human-readable complaint identifier (e.g. "CPL-042").
  final String complaintId;

  /// Full text of the ethics complaint.
  final String complaint;

  /// ID of the user who submitted the complaint.
  final int userId;

  /// Submission date (formatted string from the server, e.g. "2025-03-11").
  final String date;

  /// Workflow status of the complaint.
  ///   0 = Pending   (not yet reviewed by HR / admin)
  ///   1 = Seen      (reviewed by HR / admin)
  final int status;

  const EthicsComplaintModel({
    required this.id,
    required this.complaintId,
    required this.complaint,
    required this.userId,
    required this.date,
    required this.status,
  });

  // ── Derived helpers ─────────────────────────────────────────────────────────

  /// Returns `true` when the complaint has not yet been reviewed.
  bool get isPending => status == 0;

  /// Returns a human-readable status label.
  String get statusLabel => isPending ? 'Pending' : 'Seen';

  // ── Factory constructors ─────────────────────────────────────────────────────

  /// Deserialise from a JSON [Map] (as returned by the REST API).
  ///
  /// Note: the API uses `userid` (no underscore) for this endpoint.
  factory EthicsComplaintModel.fromJson(Map<String, dynamic> json) {
    return EthicsComplaintModel(
      id: _parseInt(json['id']),
      complaintId: (json['complaint_id'] ?? '').toString(),
      complaint: (json['complaint'] ?? '').toString(),
      // The API field is 'userid' (no underscore) per AddComplaint payload.
      userId: _parseInt(json['userid'] ?? json['user_id']),
      date: (json['date'] ?? '').toString(),
      status: _parseInt(json['status']),
    );
  }

  /// Convenience factory that returns a blank / default instance.
  factory EthicsComplaintModel.empty() {
    return const EthicsComplaintModel(
      id: 0,
      complaintId: '',
      complaint: '',
      userId: 0,
      date: '',
      status: 0,
    );
  }

  // ── Serialisation ────────────────────────────────────────────────────────────

  /// Serialise to a JSON [Map].
  ///
  /// Uses `userid` (no underscore) to match the POST body expected by the API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'complaint_id': complaintId,
      'complaint': complaint,
      'userid': userId,
      'date': date,
      'status': status,
    };
  }

  // ── Immutable update ─────────────────────────────────────────────────────────

  /// Returns a new [EthicsComplaintModel] with the specified fields replaced.
  EthicsComplaintModel copyWith({
    int? id,
    String? complaintId,
    String? complaint,
    int? userId,
    String? date,
    int? status,
  }) {
    return EthicsComplaintModel(
      id: id ?? this.id,
      complaintId: complaintId ?? this.complaintId,
      complaint: complaint ?? this.complaint,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  // ── Equality & hashing ───────────────────────────────────────────────────────

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EthicsComplaintModel &&
        other.id == id &&
        other.complaintId == complaintId &&
        other.complaint == complaint &&
        other.userId == userId &&
        other.date == date &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(id, complaintId, complaint, userId, date, status);

  // ── Debug ────────────────────────────────────────────────────────────────────

  @override
  String toString() {
    return 'EthicsComplaintModel('
        'id: $id, '
        'complaintId: $complaintId, '
        'complaint: $complaint, '
        'userId: $userId, '
        'date: $date, '
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

/// Wraps the standard API envelope used for the complaints list endpoint.
///
/// ```json
/// {
///   "success": true,
///   "message": "...",
///   "data": [ { ...EthicsComplaintModel... } ]
/// }
/// ```
class EthicsComplaintListResponse {
  final bool success;
  final String message;
  final List<EthicsComplaintModel> data;

  const EthicsComplaintListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EthicsComplaintListResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    final List<EthicsComplaintModel> items = (rawList is List)
        ? rawList
            .map((e) => EthicsComplaintModel.fromJson(e as Map<String, dynamic>))
            .toList()
        : [];
    return EthicsComplaintListResponse(
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
      'EthicsComplaintListResponse(success: $success, message: $message, data.length: ${data.length})';
}

/// Wraps the API envelope for a create-complaint response.
///
/// ```json
/// { "success": true, "message": "Complaint Added Successfully" }
/// ```
class EthicsComplaintCreateResponse {
  final bool success;
  final String message;

  const EthicsComplaintCreateResponse({
    required this.success,
    required this.message,
  });

  factory EthicsComplaintCreateResponse.fromJson(Map<String, dynamic> json) {
    return EthicsComplaintCreateResponse(
      success: json['success'] as bool? ?? false,
      message: (json['message'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
