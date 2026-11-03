import 'package:kmsmerino/views/screens/user/user_functions.dart';
import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:kmsmerino/services/api/api_config.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/base/custom_loader.dart';
import 'package:kmsmerino/views/base/dialog_box_design.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class CommonKaizenDetails extends StatefulWidget {
  final dynamic kaizenData;
  final String title;
  final int? roleId;
  final int? kaizenId;
  final Widget? filename;

  const CommonKaizenDetails({
    super.key,
    required this.kaizenData,
    this.title = 'Kaizen Details',
    this.roleId,
    this.kaizenId,
    this.filename,
  });

  @override
  State<CommonKaizenDetails> createState() => _CommonKaizenDetailsState();
}

class _CommonKaizenDetailsState extends State<CommonKaizenDetails>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.grey.shade50,
          body: widget.kaizenData['success'] == true
              ? widget.kaizenData['data'] != null
                    ? Container(
                        padding: EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header summary card
                              _buildHeaderCard(),

                              // Implementation Details
                              _buildImplementationDetailsCard(),

                              // Status Information Card
                              _buildStatusCard(),

                              // Images Section
                              _buildImagesCard(),

                              // Action Buttons (only for admin)
                              if (widget.roleId == 1 &&
                                  widget.kaizenId != null &&
                                  widget.filename !=
                                      null) // Hide buttons if rejected
                                _buildActionButtons(
                                  widget.kaizenData['data']['details'],
                                ),
                            ],
                          ),
                        ),
                      )
                    : dataNotAvailableWidgetDesign(context)
              : dataNotAvailableWidgetDesign(context),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.kaizenData['data']['details']['kaizen_id'] ?? 'N/A',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              if (widget.kaizenId != null)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                    tooltip: 'Download PDF',
                    onPressed: () {
                      generateKaizenPDF(context, widget.kaizenId!);
                    },
                  ),
                ),
            ],
          ),
          SizedBox(height: 12),
          if (widget.roleId != 2) ...[
            _buildInfoRow(
              'Submitted By ',
              widget.kaizenData['data']['details']['name'] ?? 'Unknown User',
            ),
            SizedBox(height: 4),
          ],
          if (widget.roleId != 2) ...[
            _buildInfoRow(
              'Department ',
              widget.kaizenData['data']['details']['department_name'] ??
                  'Department',
            ),
            SizedBox(height: 4),
          ],
          _buildInfoRow(
            'Submission Date ',
            widget.kaizenData['data']['details']['choose_date'] != null &&
                    widget.kaizenData['data']['details']['choose_date'] != ''
                ? _formatDate(
                    widget.kaizenData['data']['details']['choose_date'],
                  )
                : '-',
          ),
          // SizedBox(height: 8),
          // _buildInfoRow(
          //   'Department',
          //   widget.kaizenData['data']['details']['dept'] ?? 'N/A',
          // ),
        ],
      ),
    );
  }

  Widget _buildImplementationDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Implementation Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 15),
          _buildDetailItem(
            'Implemented By',
            widget.kaizenData['data']['details']['self_support'] == 0
                ? 'Self'
                : 'With Support',
            icon: Icons.build_circle_outlined,
          ),
          _buildDetailItem(
            'Problem Statement',
            widget.kaizenData['data']['details']['problem'],
            icon: Icons.report_problem_outlined,
          ),
          _buildDetailItem(
            'Detailed Description',
            widget.kaizenData['data']['details']['description'],
            icon: Icons.description_outlined,
          ),
          _buildDetailItem(
            'Proposed Solution',
            widget.kaizenData['data']['details']['solution'],
            icon: Icons.lightbulb_outline,
          ),
          _buildDetailItem(
            'Expected Improvement',
            widget.kaizenData['data']['details']['improvement'] ??
                'Not specified',
            icon: Icons.trending_up,
          ),
          _buildDetailItem(
            'Estimated Cost Savings',
            widget.kaizenData['data']['details']['cost_savings'] != null &&
                    widget.kaizenData['data']['details']['cost_savings']
                        .toString()
                        .isNotEmpty
                ? 'Rs. ${widget.kaizenData['data']['details']['cost_savings']}'
                : '-',
            icon: Icons.currency_rupee,
          ),
          if (widget.kaizenData['data']['details']['validated_cost_savings'] !=
                  null &&
              widget.kaizenData['data']['details']['validated_cost_savings']
                  .toString()
                  .isNotEmpty &&
              widget.kaizenData['data']['details']['validated_cost_savings']
                      .toString()
                      .toLowerCase() !=
                  "null")
            _buildDetailItem(
              'Validated Cost Savings',
              'â‚¹ ${widget.kaizenData['data']['details']['validated_cost_savings']}',
              icon: Icons.currency_rupee,
            ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              _buildStatusBadge(
                '',
                _getStatusText(
                  widget.kaizenData['data']['details']['status'],
                  widget.kaizenData['data']['details']['k_status'],
                  widget.kaizenData['data']['details']['end'],
                  widget.kaizenData['data']['details']['start'],
                ),
                _getStatusColor(
                  widget.kaizenData['data']['details']['status'],
                  widget.kaizenData['data']['details']['k_status'],
                  widget.kaizenData['data']['details']['end'],
                  widget.kaizenData['data']['details']['start'],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          _buildStatusInfo(),
        ],
      ),
    );
  }

  Widget _buildImagesCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Media Evidence',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 15),

          // Before Section
          _buildImageSection(
            'Before Implementation Image',
            widget.kaizenData['data']['before_url'],
          ),
          if ((widget.kaizenData['data']['before_video_url'] != null &&
                  widget.kaizenData['data']['before_video_url']
                          .toString()
                          .toLowerCase() !=
                      "null") ||
              (widget.kaizenData['data']['details']['before_video'] != null &&
                  widget.kaizenData['data']['details']['before_video']
                          .toString()
                          .toLowerCase() !=
                      "null")) ...[
            _buildVideoSection(
              'Before Implementation Video',
              widget.kaizenData['data']['before_video_url'] != null &&
                      widget.kaizenData['data']['before_video_url']
                              .toString()
                              .toLowerCase() !=
                          "null"
                  ? widget.kaizenData['data']['before_video_url']
                  : widget.kaizenData['data']['details']['before_video'],
            ),
          ],

          SizedBox(height: 15),
          Divider(color: Colors.grey[200]),
          SizedBox(height: 15),

          // After Section
          _buildImageSection(
            'After Implementation Image',
            widget.kaizenData['data']['after_url'],
          ),
          if ((widget.kaizenData['data']['after_video_url'] != null &&
                  widget.kaizenData['data']['after_video_url']
                          .toString()
                          .toLowerCase() !=
                      "null") ||
              (widget.kaizenData['data']['details']['after_video'] != null &&
                  widget.kaizenData['data']['details']['after_video']
                          .toString()
                          .toLowerCase() !=
                      "null")) ...[
            _buildVideoSection(
              'After Implementation Video',
              widget.kaizenData['data']['after_video_url'] != null &&
                      widget.kaizenData['data']['after_video_url']
                              .toString()
                              .toLowerCase() !=
                          "null"
                  ? widget.kaizenData['data']['after_video_url']
                  : widget.kaizenData['data']['details']['after_video'],
            ),
          ],
        ],
      ),
    );
  }

  // Helper method to build video sections
  Widget _buildVideoSection(String title, String? videoUrl) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8),
          videoUrl == null ||
                  videoUrl == "" ||
                  videoUrl == "-" ||
                  videoUrl.toString().toLowerCase() == "null"
              ? Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.video_camera_back_outlined,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 4),
                        Text(
                          "No Video",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    if (videoUrl.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenVideoView(videoUrl: videoUrl),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_fill_rounded,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Play Video",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  // Helper method to build status information
  Widget _buildStatusInfo() {
    var details = widget.kaizenData['data']['details'];

    // Check if kaizen is rejected (status == 2)
    bool isRejected = details['status'] == 2;

    // Check if there's a reject comment
    bool hasRejectComment =
        details['reject_comment'] != null &&
        details['reject_comment'] != '' &&
        details['reject_comment'] != 'null';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // If rejected â†’ show ONLY reject comment
        if (isRejected && hasRejectComment) ...[
          _buildStatusLabel(
            'Reject Comment',
            Icons.cancel,
            details['reject_comment'],
          ),

          SizedBox(height: 16),
        ]
        // If NOT rejected â†’ show all other info
        else if (!isRejected) ...[
          if (details['approve_date'] != null &&
              details['approve_date'] != '') ...[
            _buildStatusLabel(
              'Approval Date',
              Icons.check,
              details['approve_date'],
            ),

            SizedBox(height: 16),
          ],

          if (details['verify_date'] != null &&
              details['verify_date'] != '') ...[
            _buildStatusLabel(
              'Verification Date',
              Icons.verified,
              details['verify_date'],
            ),

            SizedBox(height: 16),
          ],

          if (details['comment'] != null &&
              details['comment'] != '' &&
              details['comment'] != 'null') ...[
            _buildStatusLabel(
              'Approve Comment by Admin',
              Icons.approval,
              details['comment'],
            ),

            SizedBox(height: 16),
          ],

          if (details['verify_comment'] != null &&
              details['verify_comment'] != '' &&
              details['verify_comment'] != 'null') ...[
            _buildStatusLabel(
              'Verification Comment by Admin',
              Icons.verified_outlined,
              details['verify_comment'],
            ),

            SizedBox(height: 16),
          ],
        ],
      ],
    );
  }

  // Helper method to build status label (heading)
  Widget _buildStatusLabel(String label, IconData icon, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Icon(icon, size: 18, color: Theme.of(context).primaryColor),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                data,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to format date
  String _formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }

  // Helper method to get status text
  String _getStatusText(
    dynamic status,
    dynamic kStatus,
    dynamic end,
    dynamic start,
  ) {
    String statusText = 'No Status';

    if (status == 0) {
      statusText = 'Pending';
    } else if (status == 2) {
      statusText = 'Rejected';
    } else if (status == 3) {
      statusText = 'Verified';
    } else if (status == 1 && (end == 0 || start == 1) && kStatus == 0) {
      statusText = 'Approved (Not Start)';
    } else if (status == 1 && (start == 1 || end == 0) && kStatus == 1) {
      statusText = 'Approved (In Progress)';
    }

    return statusText;
  }

  // Helper method to get status color
  Color _getStatusColor(
    dynamic status,
    dynamic kStatus,
    dynamic end,
    dynamic start,
  ) {
    Color statusColor = Colors.grey;

    if (status == 0) {
      statusColor = Colors.orange;
    } else if (status == 2) {
      statusColor = Colors.red;
    } else if (status == 3) {
      statusColor = Colors.green;
    } else if (status == 1 && (end == 0 || start == 1) && kStatus == 0) {
      statusColor = Colors.blue;
    } else if (status == 1 && (start == 1 || end == 0) && kStatus == 1) {
      statusColor = Theme.of(context).primaryColor;
    }

    return statusColor;
  }

  // Helper method to build info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  // Helper method to build status badge
  Widget _buildStatusBadge(String title, String statusText, Color statusColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: statusColor,
        ),
      ),
    );
  }

  // Helper method to build detail items with icons
  Widget _buildDetailItem(String title, String value, {IconData? icon}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build image sections
  Widget _buildImageSection(String title, String? imageUrl) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    imageUrl == null
                        ? Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "No Image",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : imageUrl == "-"
                        ? Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, color: Colors.grey),
                                SizedBox(width: 8),
                                Text(
                                  "Image Not Found",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              _showFullScreenImage(context, imageUrl);
                            },
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                ),
                                            value:
                                                (loadingProgress
                                                        .expectedTotalBytes !=
                                                    null)
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: Colors.red,
                                              ),
                                              const SizedBox(height: 4),
                                              const Text(
                                                "Error loading image",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Full-screen image viewer with animation
  void _showFullScreenImage(BuildContext context, String imageUrl) async {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullScreenImageView(imageUrl: imageUrl);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  // Helper method to build action buttons based on status
  Widget _buildActionButtons(dynamic details) {
    int status = 0;

    if ((details['status'] == 0) ||
        (details['status'] == 1 &&
            (details['end'] == 0 || details['start'] == 1) &&
            details['k_status'] == 0) ||
        (details['status'] == 2)) {
      if (details['status'] == 0) {
        status = 1;
      } else if (details['status'] == 1 &&
          (details['end'] == 0 || details['start'] == 1) &&
          details['k_status'] == 0) {
        status = 2;
      } else if (details['status'] == 2) {
        status = 3;
      }
    } else if (details['status'] == 1 &&
        (details['start'] == 1 || details['end'] == 0) &&
        details['k_status'] == 1) {
      status = 4;
    }

    switch (status) {
      case 1: // Pending
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _updateForm(context, 'approve', 'Kaizen Approved');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.check_circle, size: 20),
                      label: Text(
                        'Approve',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _updateForm(context, 'reject', 'Kaizen Rejected');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.cancel, size: 20),
                      label: Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 2: // Approved (Not Start) - Can only reject
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: null, // Disabled
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.check_circle, size: 20),
                      label: Text(
                        'Approve',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _updateForm(context, 'reject', 'Kaizen Rejected');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.cancel, size: 20),
                      label: Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 3: // Rejected - Can only approve
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _updateForm(context, 'approve', 'Kaizen Approved');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.check_circle, size: 20),
                      label: Text(
                        'Approve',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: null, // Disabled
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.cancel, size: 20),
                      label: Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      case 4: // Approved (In Progress) - Can verify or reject
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _updateForm(context, 'verify', 'Kaizen Verified');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.verified, size: 20),
                      label: Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _updateForm(context, 'reject', 'Kaizen Rejected');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(Icons.cancel, size: 20),
                      label: Text(
                        'Reject',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );

      default:
        return SizedBox.shrink();
    }
  }

  // Update form method
  void _updateForm(BuildContext context, String title, String formtitle) async {
    // Pass existing cost_savings only for approve action
    final existingCostSavings = title == 'approve'
        ? (widget.kaizenData['data']['details']['cost_savings']?.toString() ??
              '')
        : '';
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MyForm(
        title,
        formtitle,
        widget.kaizenId!,
        widget.filename!,
        existingCostSavings: existingCostSavings,
      ),
    );
  }
}

class FullScreenVideoView extends StatefulWidget {
  final String videoUrl;
  const FullScreenVideoView({super.key, required this.videoUrl});

  @override
  State<FullScreenVideoView> createState() => _FullScreenVideoViewState();
}

class _FullScreenVideoViewState extends State<FullScreenVideoView> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        allowFullScreen: true,
        fullScreenByDefault: false,
        placeholder: Container(color: Colors.black),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(errorMessage, style: TextStyle(color: Colors.white)),
          );
        },
      );
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error initializing video: $e");
      if (mounted) setState(() => _hasError = true);
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: _hasError
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  SizedBox(height: 16),
                  Text(
                    "Error loading video",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              )
            : _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    "Loading video...",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}

// Full-screen image viewer widget
class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                icon: Icon(Icons.close, color: Theme.of(context).primaryColor),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded /
                      (event.expectedTotalBytes ??
                          event.cumulativeBytesLoaded + 1),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
        errorBuilder: (context, error, stackTrace) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.broken_image, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Image could not be loaded',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        backgroundDecoration: BoxDecoration(color: Colors.black),
        heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
      ),
    );
  }
}

// Form dialog widget for admin actions
class _MyForm extends StatefulWidget {
  final String title, formtitle;
  final int id;
  final Widget filename;
  final String existingCostSavings;

  const _MyForm(
    this.title,
    this.formtitle,
    this.id,
    this.filename, {
    this.existingCostSavings = '',
  });

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<_MyForm> {
  final _formKey = GlobalKey<FormState>();
  String comment = '';
  String validatedCostSavings = '';
  final TextEditingController _comment = TextEditingController();
  late final TextEditingController _validatedCostSavingsController;

  @override
  void initState() {
    super.initState();
    _validatedCostSavingsController = TextEditingController(
      text: widget.existingCostSavings,
    );
    validatedCostSavings = widget.existingCostSavings;
  }

  @override
  void dispose() {
    _comment.dispose();
    _validatedCostSavingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show validated cost savings field only for approve action
    final bool isApprove = widget.title == 'approve';
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.blue.shade100, width: 1),
      ),
      elevation: 8,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.only(bottom: 20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Header with title
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blue.shade900],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.formtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Content padding
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Validated Cost Savings field â€” only for approve
                        if (isApprove) ...[
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _validatedCostSavingsController,
                            validator: (val) => val!.isEmpty
                                ? 'Please Enter Validated Cost'
                                : null,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onChanged: (value) {
                              validatedCostSavings = value;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 15,
                              ),
                              labelText: 'Validated Cost Savings (Rs.)*',
                              labelStyle: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                              hintText: 'Enter validated cost savings...',
                              hintStyle: TextStyle(color: Colors.grey.shade600),
                              prefixIcon: Icon(
                                Icons.currency_rupee,
                                color: Theme.of(context).primaryColor,
                                size: 20,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade200,
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.blue.shade600,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                        TextFormField(
                          controller: _comment,
                          validator: (val) =>
                              val!.isEmpty ? 'Please Enter Comment' : null,
                          enableInteractiveSelection: true,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          minLines: 1,
                          onChanged: (String value) {
                            comment = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 15,
                            ),
                            labelStyle: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                            ),
                            hintText: widget.title == 'reject'
                                ? 'Enter reason for rejection...'
                                : 'Enter your comment...',
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.blue.shade200,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.blue.shade600,
                                width: 2.0,
                              ),
                            ),
                            labelText: widget.title == 'reject'
                                ? 'Reason*'
                                : 'Comment*',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Action buttons
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade300,
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                CustomLoader.show(
                                  context,
                                  progressIndicator: CircularProgressIndicator(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).primaryColor,
                                  ),
                                  loaderText: Text(
                                    "\nProcessing your request...",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                      fontFamily: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.fontFamily,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                                if (_formKey.currentState!.validate()) {
                                  if (comment.isEmpty) {
                                    CustomLoader.hide();
                                  } else {
                                    final token = await LoggedInUser.getToken();
                                    final adminid =
                                        await LoggedInUser.getUserId();

                                    final response = await post(
                                      Uri.parse(
                                        ApiConfig.updateAdminKaizenUrl,
                                      ),
                                      headers: {
                                        "Accept": "application/json",
                                        'Content-Type': 'application/json',
                                        'Authorization': 'Bearer $token',
                                      },
                                      body: json.encode({
                                        'admin_id': adminid,
                                        'k_id': widget.id,
                                        'update_status': widget.title,
                                        'comment': comment,
                                        if (widget.title == 'approve' &&
                                            validatedCostSavings.isNotEmpty)
                                          'validated_cost_savings':
                                              validatedCostSavings,
                                      }),
                                    );
                                    debugPrint(response.body.toString());

                                    var responsebody = json.decode(
                                      response.body,
                                    );
                                    if (responsebody['success'] == true) {
                                      CustomLoader.hide();
                                      dialogBoxForSuccess(
                                        context,
                                        '${widget.formtitle} Successfully',
                                        // We'll need to pass a callback or rebuild the parent
                                        // For now, just close the dialog and show success
                                        widget.filename,
                                      );
                                    } else {
                                      CustomLoader.hide();
                                      dialogBoxForFailure(
                                        context,
                                        'Something Went Wrong',
                                        'Please Try Again',
                                      );
                                    }
                                  }
                                } else {
                                  CustomLoader.hide();
                                  dialogBoxForFailure(
                                    context,
                                    'Please fill valid details',
                                    '',
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
