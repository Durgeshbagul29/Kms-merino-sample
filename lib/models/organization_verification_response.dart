class OrganizationVerificationResponse {
  final bool success;
  final OrganizationData? data;
  final String? message;

  OrganizationVerificationResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory OrganizationVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OrganizationVerificationResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? OrganizationData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class OrganizationData {
  final bool exists;
  final OrganizationDetails? organization;

  OrganizationData({
    required this.exists,
    this.organization,
  });

  factory OrganizationData.fromJson(Map<String, dynamic> json) {
    return OrganizationData(
      exists: json['exists'] ?? false,
      organization: json['organization'] != null 
          ? OrganizationDetails.fromJson(json['organization']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exists': exists,
      'organization': organization?.toJson(),
    };
  }
}

class OrganizationDetails {
  final String name;
  final String slug;
  final String baseUrl;

  OrganizationDetails({
    required this.name,
    required this.slug,
    required this.baseUrl,
  });

  factory OrganizationDetails.fromJson(Map<String, dynamic> json) {
    return OrganizationDetails(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      baseUrl: json['base_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'base_url': baseUrl,
    };
  }
}