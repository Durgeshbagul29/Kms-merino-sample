/// Centralized API Configuration for KMS Merino Mobile Application.
/// Contains all base URLs, endpoint routes, and URL builder helpers
/// for Authentication, User, Admin, Manager, Director, and HR modules.
class ApiConfig {
  // ===========================================================================
  // Base Configuration
  // ===========================================================================
  
  /// Base API URL for all KMS Merino backend services.
  static const String baseUrl = 'https://kmsmerino.abraca-dabra.com';

  /// Helper method to construct a full URL for any given endpoint path.
  static String url(String endpoint) => '$baseUrl$endpoint';

  // ===========================================================================
  // 1. Authentication & Profile Endpoints
  // ===========================================================================
  
  static const String loginEndpoint = '/api/login';
  static const String logoutEndpoint = '/api/logout';
  static const String registerDeviceTokenEndpoint = '/api/register_device_token';
  static const String getProfileEndpoint = '/api/get_profile';
  static const String changePasswordEndpoint = '/api/change_password';

  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String logoutUrl([String? deviceToken]) =>
      deviceToken != null && deviceToken.isNotEmpty
          ? '$baseUrl$logoutEndpoint?device_token=$deviceToken'
          : '$baseUrl$logoutEndpoint';
  static String get registerDeviceTokenUrl => '$baseUrl$registerDeviceTokenEndpoint';
  static String get getProfileUrl => '$baseUrl$getProfileEndpoint';
  static String get changePasswordUrl => '$baseUrl$changePasswordEndpoint';

  // ===========================================================================
  // 2. User Module Endpoints
  // ===========================================================================
  
  // Dashboard & Profile
  static const String userDashboardEndpoint = '/api/user_dashboard';
  static String get userDashboardUrl => '$baseUrl$userDashboardEndpoint';

  // Kaizens
  static const String addKaizenRecordEndpoint = '/api/add_kaizen_record';
  static const String viewUserApprovedKaizensEndpoint = '/api/view_user_approvedkaizens';
  static const String viewUserSubmittedKaizensEndpoint = '/api/view_user_submittedkaizens';
  static const String viewUserKaizensEndpoint = '/api/view_user_kaizens';
  static const String viewUserKaizenDetailsEndpoint = '/api/view_user_kaizens_details';
  static const String updateApprovedKaizenEndpoint = '/api/update_approved_kaizen';
  static const String updatePendingKaizenEndpoint = '/api/update_pending_kaizen';
  static const String deleteUserKaizenEndpoint = '/api/delete_user_kaizen';
  static const String downloadKaizenPdfEndpoint = '/api/download_kaizen_pdf';

  static String get addKaizenRecordUrl => '$baseUrl$addKaizenRecordEndpoint';
  static String get viewUserApprovedKaizensUrl => '$baseUrl$viewUserApprovedKaizensEndpoint';
  static String get viewUserSubmittedKaizensUrl => '$baseUrl$viewUserSubmittedKaizensEndpoint';
  static String viewUserKaizensUrl(dynamic type) => '$baseUrl$viewUserKaizensEndpoint/$type';
  static String viewUserKaizenDetailsUrl(dynamic id) => '$baseUrl$viewUserKaizenDetailsEndpoint/$id';
  static String get updateApprovedKaizenUrl => '$baseUrl$updateApprovedKaizenEndpoint';
  static String get updatePendingKaizenUrl => '$baseUrl$updatePendingKaizenEndpoint';
  static String get deleteUserKaizenUrl => '$baseUrl$deleteUserKaizenEndpoint';
  static String downloadKaizenPdfUrl(dynamic id) => '$baseUrl$downloadKaizenPdfEndpoint/$id';

  // Safety Incidents - Accidents
  static const String addAccidentRecordEndpoint = '/api/add_accident_record';
  static const String viewUserAccidentsEndpoint = '/api/view_user_accidents';
  static const String viewUserAccidentDetailsEndpoint = '/api/view_user_accident_details';
  static const String downloadAccidentFileEndpoint = '/api/download_accident_file';

  static String get addAccidentRecordUrl => '$baseUrl$addAccidentRecordEndpoint';
  static String viewUserAccidentsUrl([dynamic userId]) =>
      userId != null ? '$baseUrl$viewUserAccidentsEndpoint/$userId' : '$baseUrl$viewUserAccidentsEndpoint';
  static String viewUserAccidentDetailsUrl(dynamic id) => '$baseUrl$viewUserAccidentDetailsEndpoint/$id';
  static String downloadAccidentFileUrl([dynamic id]) =>
      id != null ? '$baseUrl$downloadAccidentFileEndpoint/$id' : '$baseUrl$downloadAccidentFileEndpoint';

  // Safety Incidents - Near Misses
  static const String addNearmissRecordEndpoint = '/api/add_nearmiss_record';
  static const String viewUserNearmissEndpoint = '/api/view_user_nearmiss';
  static const String viewUserNearmissDetailsEndpoint = '/api/view_user_nearmiss_details';
  static const String downloadNearmissFileEndpoint = '/api/download_nearmiss_file';

  static String get addNearmissRecordUrl => '$baseUrl$addNearmissRecordEndpoint';
  static String viewUserNearmissUrl([dynamic userId]) =>
      userId != null ? '$baseUrl$viewUserNearmissEndpoint/$userId' : '$baseUrl$viewUserNearmissEndpoint';
  static String viewUserNearmissDetailsUrl(dynamic id) => '$baseUrl$viewUserNearmissDetailsEndpoint/$id';
  static String downloadNearmissFileUrl([dynamic id]) =>
      id != null ? '$baseUrl$downloadNearmissFileEndpoint/$id' : '$baseUrl$downloadNearmissFileEndpoint';

  // Safety Incidents - Observations
  static const String addObservationRecordEndpoint = '/api/add_observation_record';
  static const String viewUserObservationEndpoint = '/api/view_user_observation';
  static const String viewUserObsDetailsEndpoint = '/api/view_user_obs_details';

  static String get addObservationRecordUrl => '$baseUrl$addObservationRecordEndpoint';
  static String viewUserObservationUrl([dynamic userId]) =>
      userId != null ? '$baseUrl$viewUserObservationEndpoint/$userId' : '$baseUrl$viewUserObservationEndpoint';
  static String viewUserObsDetailsUrl(dynamic id) => '$baseUrl$viewUserObsDetailsEndpoint/$id';

  // Ethics & Grievances
  static const String addUserComplaintEndpoint = '/api/add_user_complaint';
  static const String viewUserComplaintsEndpoint = '/api/view_user_complaints';

  static String get addUserComplaintUrl => '$baseUrl$addUserComplaintEndpoint';
  static String viewUserComplaintsUrl([dynamic userId]) =>
      userId != null ? '$baseUrl$viewUserComplaintsEndpoint/$userId' : '$baseUrl$viewUserComplaintsEndpoint';

  // Broadcast & Notifications
  static const String viewUserBroadcastEndpoint = '/api/view_user_broadcast';
  static const String viewUserNotificationsEndpoint = '/api/view_user_notifications';
  static const String deleteUserNotificationEndpoint = '/api/delete_user_notf';
  static const String seenUserBroadcastNotfEndpoint = '/api/seen_user_broadcast_notf';
  static const String reviewUserSectionNotfEndpoint = '/api/review_user_section_notf';
  static const String viewUserSectionNotfEndpoint = '/api/view_user_section_notf';

  static String get viewUserBroadcastUrl => '$baseUrl$viewUserBroadcastEndpoint';
  static String get viewUserNotificationsUrl => '$baseUrl$viewUserNotificationsEndpoint';
  static String get deleteUserNotificationUrl => '$baseUrl$deleteUserNotificationEndpoint';
  static String seenUserBroadcastNotfUrl(dynamic arg1, [dynamic arg2]) =>
      arg2 != null
          ? '$baseUrl$seenUserBroadcastNotfEndpoint/$arg2'
          : '$baseUrl$seenUserBroadcastNotfEndpoint/$arg1';
  static String reviewUserSectionNotfUrl(dynamic arg1, [dynamic arg2]) =>
      arg2 != null
          ? '$baseUrl$reviewUserSectionNotfEndpoint/$arg2'
          : '$baseUrl$reviewUserSectionNotfEndpoint/$arg1';
  static String viewUserSectionNotfUrl(dynamic arg1, [dynamic arg2]) =>
      arg2 != null
          ? '$baseUrl$viewUserSectionNotfEndpoint/$arg2'
          : '$baseUrl$viewUserSectionNotfEndpoint/$arg1';

  // ===========================================================================
  // 3. Admin Module Endpoints
  // ===========================================================================
  
  // Dashboard & Team
  static const String adminDashboardEndpoint = '/api/admin_dashboard';
  static const String adminMyTeamEndpoint = '/api/admin_my_team';

  static String adminDashboardUrl(dynamic adminId) => '$baseUrl$adminDashboardEndpoint?admin_id=$adminId';
  static String adminMyTeamUrl(dynamic adminId) => '$baseUrl$adminMyTeamEndpoint?admin_id=$adminId';

  // Admin Kaizens
  static const String viewAdminAllKaizensEndpoint = '/api/view_admin_allkaizens';
  static const String viewAdminKaizenTypeEndpoint = '/api/view_admin_kaizentype';
  static const String viewAdminKaizenDetailsEndpoint = '/api/view_admin_kaizen_details';
  static const String adminKaizenKpiEndpoint = '/api/admin_kaizen_kpi';
  static const String adminKaizenReportEndpoint = '/api/admin_kaizen_report';
  static const String adminKaizenExcelEndpoint = '/api/admin_kaizen_excel';
  static const String adminDownloadUrlKaizenExcelEndpoint = '/api/admin_downloadurl_kaizenexcel';
  static const String kaizenArchiveFilesEndpoint = '/api/kaizen_archive_files';
  static const String viewAdminKaizenNotfEndpoint = '/api/view_admin_kaizen_notf';
  static const String reviewAdminKaizenNotfEndpoint = '/api/review_admin_kaizen_notf';

  static String viewAdminAllKaizensUrl(dynamic adminId) =>
      '$baseUrl$viewAdminAllKaizensEndpoint?admin_id=$adminId';
  static String viewAdminKaizenTypeUrl(dynamic type, dynamic adminId) =>
      '$baseUrl$viewAdminKaizenTypeEndpoint/$type?admin_id=$adminId';
  static String viewAdminKaizenDetailsUrl(dynamic id, [dynamic adminId]) =>
      adminId != null
          ? '$baseUrl$viewAdminKaizenDetailsEndpoint/$id?admin_id=$adminId'
          : '$baseUrl$viewAdminKaizenDetailsEndpoint/$id';
  static String get adminKaizenKpiUrl => '$baseUrl$adminKaizenKpiEndpoint';
  static String get adminKaizenReportUrl => '$baseUrl$adminKaizenReportEndpoint';
  static String get adminKaizenExcelUrl => '$baseUrl$adminKaizenExcelEndpoint';
  static String get adminDownloadUrlKaizenExcelUrl => '$baseUrl$adminDownloadUrlKaizenExcelEndpoint';
  static String adminKaizenArchiveFilesUrl([dynamic adminId]) =>
      adminId != null
          ? '$baseUrl$kaizenArchiveFilesEndpoint?admin_id=$adminId'
          : '$baseUrl$kaizenArchiveFilesEndpoint';
  static String viewAdminKaizenNotfUrl([dynamic adminId]) =>
      adminId != null
          ? '$baseUrl$viewAdminKaizenNotfEndpoint?admin_id=$adminId'
          : '$baseUrl$viewAdminKaizenNotfEndpoint';
  static String reviewAdminKaizenNotfUrl(dynamic adminId, dynamic dataId) =>
      '$baseUrl$reviewAdminKaizenNotfEndpoint/$adminId/$dataId';

  // Admin Accidents
  static const String viewAdminAccidentEndpoint = '/api/view_admin_accident';
  static const String viewAdminAccidentDetailsEndpoint = '/api/view_admin_accident_details';
  static const String adminAccidentReportEndpoint = '/api/admin_accident_report';
  static const String adminAccidentExcelEndpoint = '/api/admin_accident_excel';
  static const String adminDownloadUrlAccidentExcelEndpoint = '/api/admin_downloadurl_accidentexcel';
  static const String accidentArchiveFilesEndpoint = '/api/accident_archive_files';

  static String viewAdminAccidentUrl(dynamic adminId) =>
      '$baseUrl$viewAdminAccidentEndpoint?admin_id=$adminId';
  static String viewAdminAccidentDetailsUrl(dynamic id, [dynamic adminId]) =>
      adminId != null
          ? '$baseUrl$viewAdminAccidentDetailsEndpoint/$id?admin_id=$adminId'
          : '$baseUrl$viewAdminAccidentDetailsEndpoint/$id';
  static String get adminAccidentReportUrl => '$baseUrl$adminAccidentReportEndpoint';
  static String get adminAccidentExcelUrl => '$baseUrl$adminAccidentExcelEndpoint';
  static String get adminDownloadUrlAccidentExcelUrl => '$baseUrl$adminDownloadUrlAccidentExcelEndpoint';
  static String adminAccidentArchiveFilesUrl([dynamic adminId]) =>
      adminId != null
          ? '$baseUrl$accidentArchiveFilesEndpoint?admin_id=$adminId'
          : '$baseUrl$accidentArchiveFilesEndpoint';

  // Admin Near Misses
  static const String viewAdminNearmissEndpoint = '/api/view_admin_nearmiss';
  static const String viewAdminNearmissDetailsEndpoint = '/api/view_admin_nearmiss_details';
  static const String adminNearmissReportEndpoint = '/api/admin_nearmiss_report';
  static const String adminNearmissExcelEndpoint = '/api/admin_nearmiss_excel';
  static const String adminDownloadUrlNearmissExcelEndpoint = '/api/admin_downloadurl_nearmissexcel';
  static const String nearmissArchiveFilesEndpoint = '/api/nearmiss_archive_files';

  static String viewAdminNearmissUrl(dynamic adminId) =>
      '$baseUrl$viewAdminNearmissEndpoint?admin_id=$adminId';
  static String viewAdminNearmissDetailsUrl(dynamic id, [dynamic adminId]) =>
      adminId != null
          ? '$baseUrl$viewAdminNearmissDetailsEndpoint/$id?admin_id=$adminId'
          : '$baseUrl$viewAdminNearmissDetailsEndpoint/$id';
  static String get adminNearmissReportUrl => '$baseUrl$adminNearmissReportEndpoint';
  static String get adminNearmissExcelUrl => '$baseUrl$adminNearmissExcelEndpoint';
  static String get adminDownloadUrlNearmissExcelUrl => '$baseUrl$adminDownloadUrlNearmissExcelEndpoint';
  static String adminNearmissArchiveFilesUrl([dynamic adminId]) =>
      adminId != null
          ? '$baseUrl$nearmissArchiveFilesEndpoint?admin_id=$adminId'
          : '$baseUrl$nearmissArchiveFilesEndpoint';

  // Admin Observations
  static const String viewAdminObservationEndpoint = '/api/view_admin_observation';
  static const String viewAdminObservationDetailsEndpoint = '/api/view_admin_observation_details';
  static const String adminObsReportEndpoint = '/api/admin_obs_report';
  static const String adminObservationExcelEndpoint = '/api/admin_observation_excel';
  static const String adminDownloadUrlObservationExcelEndpoint = '/api/admin_downloadurl_observationexcel';
  static const String observationArchiveFilesEndpoint = '/api/observation_archive_files';

  static String viewAdminObservationUrl(dynamic adminId) =>
      '$baseUrl$viewAdminObservationEndpoint?admin_id=$adminId';
  static String viewAdminObservationDetailsUrl(dynamic id, [dynamic adminId]) =>
      adminId != null
          ? '$baseUrl$viewAdminObservationDetailsEndpoint/$id?admin_id=$adminId'
          : '$baseUrl$viewAdminObservationDetailsEndpoint/$id';
  static String get adminObsReportUrl => '$baseUrl$adminObsReportEndpoint';
  static String get adminObservationExcelUrl => '$baseUrl$adminObservationExcelEndpoint';
  static String get adminDownloadUrlObservationExcelUrl => '$baseUrl$adminDownloadUrlObservationExcelEndpoint';
  static String adminObservationArchiveFilesUrl([dynamic adminId]) =>
      adminId != null
          ? '$baseUrl$observationArchiveFilesEndpoint?admin_id=$adminId'
          : '$baseUrl$observationArchiveFilesEndpoint';

  // Admin Ethics & Complaints
  static const String viewAdminEthicsEndpoint = '/api/view_admin_ethics';
  static const String reviewAdminComplaintEndpoint = '/api/review_admin_complaint';
  static const String adminEthicsTableEndpoint = '/api/admin_ethics_table';
  static const String adminEthicsExcelEndpoint = '/api/admin_ethics_excel';
  static const String adminDownloadUrlEthicsExcelEndpoint = '/api/admin_downloadurl_ethicsexcel';
  static const String ethicsArchiveFilesEndpoint = '/api/ethics_archive_files';

  static String viewAdminEthicsUrl(dynamic adminId) => '$baseUrl$viewAdminEthicsEndpoint?admin_id=$adminId';
  static String reviewAdminComplaintUrl(dynamic adminId, dynamic dataId) =>
      '$baseUrl$reviewAdminComplaintEndpoint/$adminId/$dataId';
  static String get adminEthicsTableUrl => '$baseUrl$adminEthicsTableEndpoint';
  static String get adminEthicsExcelUrl => '$baseUrl$adminEthicsExcelEndpoint';
  static String get adminDownloadUrlEthicsExcelUrl => '$baseUrl$adminDownloadUrlEthicsExcelEndpoint';
  static String adminEthicsArchiveFilesUrl([dynamic adminId]) =>
      adminId != null
          ? '$baseUrl$ethicsArchiveFilesEndpoint?admin_id=$adminId'
          : '$baseUrl$ethicsArchiveFilesEndpoint';

  // Admin Broadcasts
  static const String viewAdminBroadcastEndpoint = '/api/view_admin_broadcast';
  static const String viewAdminBroadcastDetailsEndpoint = '/api/view_admin_broadcast_details';
  static const String addBroadcastEndpoint = '/api/add_broadcast';
  static const String deleteAdminBroadcastEndpoint = '/api/delete_admin_broadcast';

  static String get viewAdminBroadcastUrl => '$baseUrl$viewAdminBroadcastEndpoint';
  static String viewAdminBroadcastDetailsUrl(dynamic id) => '$baseUrl$viewAdminBroadcastDetailsEndpoint/$id';
  static String get addBroadcastUrl => '$baseUrl$addBroadcastEndpoint';
  static String get deleteAdminBroadcastUrl => '$baseUrl$deleteAdminBroadcastEndpoint';

  // ===========================================================================
  // 4. Manager Module Endpoints
  // ===========================================================================
  
  // Dashboard & Team
  static const String managerDashboardEndpoint = '/api/manager_dashboard';
  static const String managerMyTeamEndpoint = '/api/manager_my_team';

  static String managerDashboardUrl(dynamic managerId) =>
      '$baseUrl$managerDashboardEndpoint?manager_id=$managerId';
  static String managerMyTeamUrl(dynamic managerId) =>
      '$baseUrl$managerMyTeamEndpoint?manager_id=$managerId';

  // Manager Kaizens
  static const String viewManagerAllKaizensEndpoint = '/api/view_manager_allkaizens';
  static const String viewManagerKaizenTypeEndpoint = '/api/view_manager_kaizentype';
  static const String viewManagerKaizenDetailsEndpoint = '/api/view_manager_kaizen_details';
  static const String managerKaizenKpiEndpoint = '/api/manager_kaizen_kpi';
  static const String managerKaizenReportEndpoint = '/api/manager_kaizen_report';
  static const String managerKaizenExcelEndpoint = '/api/manager_kaizen_excel';
  static const String managerDownloadUrlKaizenExcelEndpoint = '/api/manager_downloadurl_kaizenexcel';
  static const String managerKaizenArchiveFilesEndpoint = '/api/manager_kaizen_archive_files';
  static const String viewManagerKaizenNotfEndpoint = '/api/view_manager_kaizen_notf';
  static const String reviewManagerKaizenNotfEndpoint = '/api/review_manager_kaizen_notf';

  static String viewManagerAllKaizensUrl(dynamic managerId) =>
      '$baseUrl$viewManagerAllKaizensEndpoint?manager_id=$managerId';
  static String viewManagerKaizenTypeUrl(dynamic type, dynamic managerId) =>
      '$baseUrl$viewManagerKaizenTypeEndpoint/$type?manager_id=$managerId';
  static String viewManagerKaizenDetailsUrl(dynamic id, dynamic managerId) =>
      '$baseUrl$viewManagerKaizenDetailsEndpoint/$id?manager_id=$managerId';
  static String get managerKaizenKpiUrl => '$baseUrl$managerKaizenKpiEndpoint';
  static String get managerKaizenReportUrl => '$baseUrl$managerKaizenReportEndpoint';
  static String get managerKaizenExcelUrl => '$baseUrl$managerKaizenExcelEndpoint';
  static String get managerDownloadUrlKaizenExcelUrl => '$baseUrl$managerDownloadUrlKaizenExcelEndpoint';
  static String managerKaizenArchiveFilesUrl(dynamic managerId) =>
      '$baseUrl$managerKaizenArchiveFilesEndpoint?manager_id=$managerId';
  static String viewManagerKaizenNotfUrl(dynamic managerId) =>
      '$baseUrl$viewManagerKaizenNotfEndpoint?manager_id=$managerId';
  static String reviewManagerKaizenNotfUrl(dynamic managerId, dynamic dataId) =>
      '$baseUrl$reviewManagerKaizenNotfEndpoint/$managerId/$dataId';

  // Manager Accidents
  static const String viewManagerAccidentEndpoint = '/api/view_manager_accident';
  static const String viewManagerAccidentDetailsEndpoint = '/api/view_manager_accident_details';
  static const String managerAccidentReportEndpoint = '/api/manager_accident_report';
  static const String managerAccidentExcelEndpoint = '/api/manager_accident_excel';
  static const String managerDownloadUrlAccidentExcelEndpoint = '/api/manager_downloadurl_accidentexcel';
  static const String managerAccidentArchiveFilesEndpoint = '/api/manager_accident_archive_files';
  static const String downloadManagerAccidentFileEndpoint = '/api/download_manager_accident_file';

  static String viewManagerAccidentUrl(dynamic managerId) =>
      '$baseUrl$viewManagerAccidentEndpoint?manager_id=$managerId';
  static String viewManagerAccidentDetailsUrl(dynamic id, dynamic managerId) =>
      '$baseUrl$viewManagerAccidentDetailsEndpoint/$id?manager_id=$managerId';
  static String get managerAccidentReportUrl => '$baseUrl$managerAccidentReportEndpoint';
  static String get managerAccidentExcelUrl => '$baseUrl$managerAccidentExcelEndpoint';
  static String get managerDownloadUrlAccidentExcelUrl => '$baseUrl$managerDownloadUrlAccidentExcelEndpoint';
  static String managerAccidentArchiveFilesUrl(dynamic managerId) =>
      '$baseUrl$managerAccidentArchiveFilesEndpoint?manager_id=$managerId';
  static String downloadManagerAccidentFileUrl(dynamic id, dynamic managerId) =>
      '$baseUrl$downloadManagerAccidentFileEndpoint/$id?manager_id=$managerId';

  // Manager Near Misses
  static const String viewManagerNearmissEndpoint = '/api/view_manager_nearmiss';
  static const String viewManagerNearmissDetailsEndpoint = '/api/view_manager_nearmiss_details';
  static const String managerNearmissReportEndpoint = '/api/manager_nearmiss_report';
  static const String managerNearmissExcelEndpoint = '/api/manager_nearmiss_excel';
  static const String managerDownloadUrlNearmissExcelEndpoint = '/api/manager_downloadurl_nearmissexcel';
  static const String managerNearmissArchiveFilesEndpoint = '/api/manager_nearmiss_archive_files';

  static String viewManagerNearmissUrl(dynamic managerId) =>
      '$baseUrl$viewManagerNearmissEndpoint?manager_id=$managerId';
  static String viewManagerNearmissDetailsUrl(dynamic id, dynamic managerId) =>
      '$baseUrl$viewManagerNearmissDetailsEndpoint/$id?manager_id=$managerId';
  static String get managerNearmissReportUrl => '$baseUrl$managerNearmissReportEndpoint';
  static String get managerNearmissExcelUrl => '$baseUrl$managerNearmissExcelEndpoint';
  static String get managerDownloadUrlNearmissExcelUrl => '$baseUrl$managerDownloadUrlNearmissExcelEndpoint';
  static String managerNearmissArchiveFilesUrl(dynamic managerId) =>
      '$baseUrl$managerNearmissArchiveFilesEndpoint?manager_id=$managerId';

  // Manager Observations
  static const String viewManagerObservationEndpoint = '/api/view_manager_observation';
  static const String viewManagerObservationDetailsEndpoint = '/api/view_manager_observation_details';
  static const String managerObsReportEndpoint = '/api/manager_obs_report';
  static const String managerObservationExcelEndpoint = '/api/manager_observation_excel';
  static const String managerDownloadUrlObservationExcelEndpoint = '/api/manager_downloadurl_observationexcel';
  static const String managerObservationArchiveFilesEndpoint = '/api/manager_observation_archive_files';

  static String viewManagerObservationUrl(dynamic managerId) =>
      '$baseUrl$viewManagerObservationEndpoint?manager_id=$managerId';
  static String viewManagerObservationDetailsUrl(dynamic id, dynamic managerId) =>
      '$baseUrl$viewManagerObservationDetailsEndpoint/$id?manager_id=$managerId';
  static String get managerObsReportUrl => '$baseUrl$managerObsReportEndpoint';
  static String get managerObservationExcelUrl => '$baseUrl$managerObservationExcelEndpoint';
  static String get managerDownloadUrlObservationExcelUrl => '$baseUrl$managerDownloadUrlObservationExcelEndpoint';
  static String managerObservationArchiveFilesUrl(dynamic managerId) =>
      '$baseUrl$managerObservationArchiveFilesEndpoint?manager_id=$managerId';

  // Manager Ethics & Complaints
  static const String viewManagerEthicsEndpoint = '/api/view_manager_ethics';
  static const String reviewManagerComplaintEndpoint = '/api/review_manager_complaint';
  static const String managerEthicsTableEndpoint = '/api/manager_ethics_table';
  static const String managerEthicsExcelEndpoint = '/api/manager_ethics_excel';
  static const String managerDownloadUrlEthicsExcelEndpoint = '/api/manager_downloadurl_ethicsexcel';
  static const String managerEthicsArchiveFilesEndpoint = '/api/manager_ethics_archive_files';

  static String viewManagerEthicsUrl(dynamic managerId) =>
      '$baseUrl$viewManagerEthicsEndpoint?manager_id=$managerId';
  static String reviewManagerComplaintUrl(dynamic managerId, dynamic dataId) =>
      '$baseUrl$reviewManagerComplaintEndpoint/$managerId/$dataId';
  static String get managerEthicsTableUrl => '$baseUrl$managerEthicsTableEndpoint';
  static String get managerEthicsExcelUrl => '$baseUrl$managerEthicsExcelEndpoint';
  static String get managerDownloadUrlEthicsExcelUrl => '$baseUrl$managerDownloadUrlEthicsExcelEndpoint';
  static String managerEthicsArchiveFilesUrl(dynamic managerId) =>
      '$baseUrl$managerEthicsArchiveFilesEndpoint?manager_id=$managerId';

  // Manager Broadcasts
  static const String viewManagerBroadcastEndpoint = '/api/view_manager_broadcast';
  static const String viewManagerBroadcastDetailsEndpoint = '/api/view_manager_broadcast_details';
  static const String addManagerBroadcastEndpoint = '/api/add_manager_broadcast';
  static const String deleteManagerBroadcastEndpoint = '/api/delete_manager_broadcast';

  static String viewManagerBroadcastUrl(dynamic managerId) =>
      '$baseUrl$viewManagerBroadcastEndpoint?manager_id=$managerId';
  static String viewManagerBroadcastDetailsUrl(dynamic id, dynamic managerId) =>
      '$baseUrl$viewManagerBroadcastDetailsEndpoint/$id?manager_id=$managerId';
  static String get addManagerBroadcastUrl => '$baseUrl$addManagerBroadcastEndpoint';
  static String get deleteManagerBroadcastUrl => '$baseUrl$deleteManagerBroadcastEndpoint';

  // ===========================================================================
  // 5. Director Module Endpoints
  // ===========================================================================
  
  // Dashboard
  static const String directorDashboardEndpoint = '/api/director_dashboard';
  static String directorDashboardUrl(dynamic directorId) =>
      '$baseUrl$directorDashboardEndpoint?director_id=$directorId';

  // Director Kaizens
  static const String viewDirectorAllKaizensEndpoint = '/api/view_director_allkaizens';
  static const String viewDirectorKaizenTypeEndpoint = '/api/view_director_kaizentype';
  static const String viewDirectorKaizenDetailsEndpoint = '/api/view_director_kaizen_details';
  static const String directorKaizenKpiEndpoint = '/api/director_kaizen_kpi';
  static const String directorKaizenReportEndpoint = '/api/director_kaizen_report';
  static const String directorKaizenExcelEndpoint = '/api/director_kaizen_excel';
  static const String directorDownloadUrlKaizenExcelEndpoint = '/api/director_downloadurl_kaizenexcel';
  static const String directorKaizenArchiveFilesEndpoint = '/api/director_kaizen_archive_files';
  static const String viewDirectorKaizenNotfEndpoint = '/api/view_director_kaizen_notf';
  static const String reviewDirectorKaizenNotfEndpoint = '/api/review_director_kaizen_notf';

  static String viewDirectorAllKaizensUrl(dynamic directorId) =>
      '$baseUrl$viewDirectorAllKaizensEndpoint?director_id=$directorId';
  static String viewDirectorKaizenTypeUrl(dynamic type, dynamic directorId) =>
      '$baseUrl$viewDirectorKaizenTypeEndpoint/$type?director_id=$directorId';
  static String viewDirectorKaizenDetailsUrl(dynamic id, dynamic directorId) =>
      '$baseUrl$viewDirectorKaizenDetailsEndpoint/$id?director_id=$directorId';
  static String get directorKaizenKpiUrl => '$baseUrl$directorKaizenKpiEndpoint';
  static String get directorKaizenReportUrl => '$baseUrl$directorKaizenReportEndpoint';
  static String get directorKaizenExcelUrl => '$baseUrl$directorKaizenExcelEndpoint';
  static String get directorDownloadUrlKaizenExcelUrl => '$baseUrl$directorDownloadUrlKaizenExcelEndpoint';
  static String directorKaizenArchiveFilesUrl(dynamic directorId) =>
      '$baseUrl$directorKaizenArchiveFilesEndpoint?director_id=$directorId';
  static String viewDirectorKaizenNotfUrl(dynamic directorId) =>
      '$baseUrl$viewDirectorKaizenNotfEndpoint?director_id=$directorId';
  static String reviewDirectorKaizenNotfUrl(dynamic directorId, dynamic dataId) =>
      '$baseUrl$reviewDirectorKaizenNotfEndpoint/$directorId/$dataId';

  // Director Accidents
  static const String viewDirectorAccidentEndpoint = '/api/view_director_accident';
  static const String viewDirectorAccidentDetailsEndpoint = '/api/view_director_accident_details';
  static const String directorAccidentReportEndpoint = '/api/director_accident_report';
  static const String directorAccidentExcelEndpoint = '/api/director_accident_excel';
  static const String directorDownloadUrlAccidentExcelEndpoint = '/api/director_downloadurl_accidentexcel';
  static const String directorAccidentArchiveFilesEndpoint = '/api/director_accident_archive_files';
  static const String downloadDirectorAccidentFileEndpoint = '/api/download_director_accident_file';

  static String viewDirectorAccidentUrl(dynamic directorId) =>
      '$baseUrl$viewDirectorAccidentEndpoint?director_id=$directorId';
  static String viewDirectorAccidentDetailsUrl(dynamic id, dynamic directorId) =>
      '$baseUrl$viewDirectorAccidentDetailsEndpoint/$id?director_id=$directorId';
  static String get directorAccidentReportUrl => '$baseUrl$directorAccidentReportEndpoint';
  static String get directorAccidentExcelUrl => '$baseUrl$directorAccidentExcelEndpoint';
  static String get directorDownloadUrlAccidentExcelUrl => '$baseUrl$directorDownloadUrlAccidentExcelEndpoint';
  static String directorAccidentArchiveFilesUrl(dynamic directorId) =>
      '$baseUrl$directorAccidentArchiveFilesEndpoint?director_id=$directorId';
  static String downloadDirectorAccidentFileUrl(dynamic id, dynamic directorId) =>
      '$baseUrl$downloadDirectorAccidentFileEndpoint/$id?director_id=$directorId';

  // Director Near Misses
  static const String viewDirectorNearmissEndpoint = '/api/view_director_nearmiss';
  static const String viewDirectorNearmissDetailsEndpoint = '/api/view_director_nearmiss_details';
  static const String directorNearmissReportEndpoint = '/api/director_nearmiss_report';
  static const String directorNearmissExcelEndpoint = '/api/director_nearmiss_excel';
  static const String directorDownloadUrlNearmissExcelEndpoint = '/api/director_downloadurl_nearmissexcel';
  static const String directorNearmissArchiveFilesEndpoint = '/api/director_nearmiss_archive_files';

  static String viewDirectorNearmissUrl(dynamic directorId) =>
      '$baseUrl$viewDirectorNearmissEndpoint?director_id=$directorId';
  static String viewDirectorNearmissDetailsUrl(dynamic id, dynamic directorId) =>
      '$baseUrl$viewDirectorNearmissDetailsEndpoint/$id?director_id=$directorId';
  static String get directorNearmissReportUrl => '$baseUrl$directorNearmissReportEndpoint';
  static String get directorNearmissExcelUrl => '$baseUrl$directorNearmissExcelEndpoint';
  static String get directorDownloadUrlNearmissExcelUrl => '$baseUrl$directorDownloadUrlNearmissExcelEndpoint';
  static String directorNearmissArchiveFilesUrl(dynamic directorId) =>
      '$baseUrl$directorNearmissArchiveFilesEndpoint?director_id=$directorId';

  // Director Observations
  static const String viewDirectorObservationEndpoint = '/api/view_director_observation';
  static const String viewDirectorObservationDetailsEndpoint = '/api/view_director_observation_details';
  static const String directorObsReportEndpoint = '/api/director_obs_report';
  static const String directorObservationExcelEndpoint = '/api/director_observation_excel';
  static const String directorDownloadUrlObservationExcelEndpoint = '/api/director_downloadurl_observationexcel';
  static const String directorObservationArchiveFilesEndpoint = '/api/director_observation_archive_files';

  static String viewDirectorObservationUrl(dynamic directorId) =>
      '$baseUrl$viewDirectorObservationEndpoint?director_id=$directorId';
  static String viewDirectorObservationDetailsUrl(dynamic id, dynamic directorId) =>
      '$baseUrl$viewDirectorObservationDetailsEndpoint/$id?director_id=$directorId';
  static String get directorObsReportUrl => '$baseUrl$directorObsReportEndpoint';
  static String get directorObservationExcelUrl => '$baseUrl$directorObservationExcelEndpoint';
  static String get directorDownloadUrlObservationExcelUrl => '$baseUrl$directorDownloadUrlObservationExcelEndpoint';
  static String directorObservationArchiveFilesUrl(dynamic directorId) =>
      '$baseUrl$directorObservationArchiveFilesEndpoint?director_id=$directorId';

  // Director Ethics & Complaints
  static const String viewDirectorEthicsEndpoint = '/api/view_director_ethics';
  static const String reviewDirectorComplaintEndpoint = '/api/review_director_complaint';
  static const String directorEthicsTableEndpoint = '/api/director_ethics_table';
  static const String directorEthicsExcelEndpoint = '/api/director_ethics_excel';
  static const String directorDownloadUrlEthicsExcelEndpoint = '/api/director_downloadurl_ethicsexcel';
  static const String directorEthicsArchiveFilesEndpoint = '/api/director_ethics_archive_files';

  static String viewDirectorEthicsUrl(dynamic directorId) =>
      '$baseUrl$viewDirectorEthicsEndpoint?director_id=$directorId';
  static String reviewDirectorComplaintUrl(dynamic directorId, dynamic dataId) =>
      '$baseUrl$reviewDirectorComplaintEndpoint/$directorId/$dataId';
  static String get directorEthicsTableUrl => '$baseUrl$directorEthicsTableEndpoint';
  static String get directorEthicsExcelUrl => '$baseUrl$directorEthicsExcelEndpoint';
  static String get directorDownloadUrlEthicsExcelUrl => '$baseUrl$directorDownloadUrlEthicsExcelEndpoint';
  static String directorEthicsArchiveFilesUrl(dynamic directorId) =>
      '$baseUrl$directorEthicsArchiveFilesEndpoint?director_id=$directorId';

  // Director Broadcasts
  static const String viewDirectorBroadcastEndpoint = '/api/view_director_broadcast';
  static const String viewDirectorBroadcastDetailsEndpoint = '/api/view_director_broadcast_details';
  static const String deleteDirectorBroadcastEndpoint = '/api/delete_director_broadcast';

  static String viewDirectorBroadcastUrl(dynamic directorId) =>
      '$baseUrl$viewDirectorBroadcastEndpoint?director_id=$directorId';
  static String viewDirectorBroadcastDetailsUrl(dynamic id, dynamic directorId) =>
      '$baseUrl$viewDirectorBroadcastDetailsEndpoint/$id?director_id=$directorId';
  static String get deleteDirectorBroadcastUrl => '$baseUrl$deleteDirectorBroadcastEndpoint';

  // ===========================================================================
  // 6. HR & User Management Endpoints
  // ===========================================================================
  
  static const String hrDashboardEndpoint = '/api/hr_dashboard';
  static const String getAllAdminsEndpoint = '/api/get_all_admins';
  static const String getAllUsersEndpoint = '/api/get_all_users';
  static const String getAllManagersEndpoint = '/api/get_all_managers';
  static const String getAllDirectorsEndpoint = '/api/get_all_directors';
  static const String getDeptsEndpoint = '/api/get_depts';
  static const String getAllDepartmentsEndpoint = '/api/get_all_departments';
  static const String assignManagerDepartmentsEndpoint = '/api/assign_manager_departments';
  static const String getManagerDepartmentsEndpoint = '/api/get_manager_departments';
  static const String addNewUserOrAdminEndpoint = '/api/add_new_useroradmin';
  static const String updateUserOrAdminEndpoint = '/api/update_useroradmin';
  static const String addDirectorEndpoint = '/api/add_director';

  static String get hrDashboardUrl => '$baseUrl$hrDashboardEndpoint';
  static String get getAllAdminsUrl => '$baseUrl$getAllAdminsEndpoint';
  static String get getAllUsersUrl => '$baseUrl$getAllUsersEndpoint';
  static String get getAllManagersUrl => '$baseUrl$getAllManagersEndpoint';
  static String get getAllDirectorsUrl => '$baseUrl$getAllDirectorsEndpoint';
  static String get getDeptsUrl => '$baseUrl$getDeptsEndpoint';
  static String get getAllDepartmentsUrl => '$baseUrl$getAllDepartmentsEndpoint';
  static String get assignManagerDepartmentsUrl => '$baseUrl$assignManagerDepartmentsEndpoint';
  static String getManagerDepartmentsUrl([dynamic managerId]) =>
      managerId != null
          ? '$baseUrl$getManagerDepartmentsEndpoint/$managerId'
          : '$baseUrl$getManagerDepartmentsEndpoint';
  static String get addNewUserOrAdminUrl => '$baseUrl$addNewUserOrAdminEndpoint';
  static String get updateUserOrAdminUrl => '$baseUrl$updateUserOrAdminEndpoint';
  static String get addDirectorUrl => '$baseUrl$addDirectorEndpoint';

  // ===========================================================================
  // 7. Common & Shared Status Updates
  // ===========================================================================
  
  static const String updateAdminAccidentEndpoint = '/api/update_admin_accident';
  static const String updateAdminKaizenEndpoint = '/api/update_admin_kaizen';
  static const String updateAdminNearmissEndpoint = '/api/update_admin_nearmiss';
  static const String updateAdminObservationEndpoint = '/api/update_admin_observation';

  static String get updateAdminAccidentUrl => '$baseUrl$updateAdminAccidentEndpoint';
  static String get updateAdminKaizenUrl => '$baseUrl$updateAdminKaizenEndpoint';
  static String get updateAdminNearmissUrl => '$baseUrl$updateAdminNearmissEndpoint';
  static String get updateAdminObservationUrl => '$baseUrl$updateAdminObservationEndpoint';
}
