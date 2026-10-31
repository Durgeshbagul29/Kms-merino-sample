// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:kmsmerino/views/common/fullscreen_image_view.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/screens/admin/safety/admin_observation_screen.dart';

class ObservationDetailsContent extends StatefulWidget {
  final dynamic responseFrmUrl;
  final BuildContext context;

  const ObservationDetailsContent({
    super.key,
    required this.responseFrmUrl,
    required this.context,
  });

  @override
  State<ObservationDetailsContent> createState() =>
      _ObservationDetailsContentState();
}

class _ObservationDetailsContentState extends State<ObservationDetailsContent> {
  String comment = '';
  final _formKey = GlobalKey<FormState>();
  int? userRoleId;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    int? roleId = await LoggedInUser.getUserRoleId();
    setState(() {
      userRoleId = roleId;
      isAdmin = roleId == 1; // Assuming role ID 1 is admin
    });
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.responseFrmUrl['data']['details'];
    final dateTime = widget.responseFrmUrl['data']['datetime'];
    final imageUrl = widget.responseFrmUrl['data']['image_url'];

    return Container(
      color: Color(0xFFF8FAFC),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with Status
                _buildStatusCard(details['status']),
                SizedBox(height: 16),

                // Overview Card
                _buildSectionCard(
                  title: "Observation Overview",
                  icon: Icons.visibility_outlined,
                  child: Column(
                    children: [
                      _buildInfoRow(
                        Icons.confirmation_number_outlined,
                        "Observation ID",
                        details['observation_id'],
                      ),
                      Divider(height: 24, color: Colors.grey[200]),
                      _buildInfoRow(
                        Icons.calendar_today_outlined,
                        "Date & Time",
                        dateTime,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Detail Details
                _buildDescriptionSection(
                  "Observation Details",
                  details['observation'],
                  Icons.description_outlined,
                  Colors.blue,
                ),
                SizedBox(height: 16),

                _buildDescriptionSection(
                  "Recommended Action",
                  details['action'],
                  Icons.build_circle_outlined,
                  Colors.green,
                ),
                SizedBox(height: 16),

                // Image Section
                _buildImageCard(imageUrl),
                SizedBox(height: 16),

                // Comment Section
                _buildCommentSection(details['comment']),

                // Admin Action Section
                if (isAdmin && details['status'] == 0) ...[
                  SizedBox(height: 20),
                  _buildAdminActionCard(),
                  SizedBox(height: 32),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(int status) {
    bool isPending = status == 0;
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Record Status",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                isPending ? "Pending Review" : "Reviewed & Approved",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isPending ? Colors.orange[700] : Colors.green[700],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isPending ? Colors.orange[50] : Colors.green[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isPending ? Colors.orange[100]! : Colors.green[100]!,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPending ? Icons.pending_actions : Icons.check_circle,
                  size: 16,
                  color: isPending ? Colors.orange[700] : Colors.green[700],
                ),
                SizedBox(width: 6),
                Text(
                  isPending ? "In Progress" : "Completed",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isPending ? Colors.orange[700] : Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[400]),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.1)),
            ),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF475569),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String? url) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.image_outlined, size: 20, color: Colors.indigo),
              SizedBox(width: 10),
              Text(
                "Evidence Image",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (url == null || url == "-")
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: 32,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "No image uploaded",
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: () => _showFullScreenImage(context, url),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[100],
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    Image.network(
                      url,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        color: Colors.grey[50],
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey[300],
                          size: 40,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentSection(String? value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.rate_review_outlined, size: 20, color: Colors.purple),
              SizedBox(width: 10),
              Text(
                "Admin Remarks",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value ?? "Pending admin review and remarks.",
            style: TextStyle(
              fontSize: 14,
              color: value != null ? Color(0xFF475569) : Colors.grey[400],
              fontStyle: value != null ? FontStyle.normal : FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminActionCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Review & Action",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Add your review comments here...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.all(16),
            ),
            maxLines: 4,
            validator: (val) => val!.isEmpty
                ? 'Please enter a comment before submitting'
                : null,
            onChanged: (val) => setState(() => comment = val),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                "Submit Review",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      CustomLoader.show(
        context,
        progressIndicator: CircularProgressIndicator(),
        loaderText: Text(
          "\nUpdating record...",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      );

      try {
        final token = await LoggedInUser.getToken();
        final adminid = await LoggedInUser.getUserId();

        final response = await http.post(
          Uri.parse("${ApiConfig.baseUrl}/api/update_admin_observation"),
          headers: {
            "Accept": "application/json",
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'admin_id': adminid,
            'comment': comment,
            'id': widget.responseFrmUrl['data']['details']['id'],
          }),
        );

        var responsebody = json.decode(response.body);
        CustomLoader.hide();

        if (responsebody['success'] == true) {
          dialogBoxForSuccess(
            context,
            'Record Reviewed Successfully',
            AdminObservationScreen(),
          );
        } else {
          dialogBoxForFailure(
            context,
            'Update Failed',
            'Please try again later',
          );
        }
      } catch (e) {
        CustomLoader.hide();
        dialogBoxForFailure(context, 'Error', e.toString());
      }
    }
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, _) =>
            FullScreenImageView(imageUrl: imageUrl),
        transitionsBuilder: (context, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }
}
