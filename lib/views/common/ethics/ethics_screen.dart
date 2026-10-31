// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/screens/manager/manager_functions.dart';
import 'package:kmsmerino/views/screens/director/director_functions.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kmsmerino/views/common/ethics/ethics_complaint_details.dart';

class EthicsScreen extends StatefulWidget {
  const EthicsScreen({super.key});

  @override
  State<EthicsScreen> createState() => _EthicsScreenState();
}

class _EthicsScreenState extends State<EthicsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  int? _roleId;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
    _loadUserRole();
    super.initState();
  }

  Future<void> _loadUserRole() async {
    final roleId = await LoggedInUser.getUserRoleId();
    setState(() {
      _roleId = roleId;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<dynamic> _fetchComplaints() async {
    _roleId ??= await LoggedInUser.getUserRoleId();

    switch (_roleId) {
      case 1: // Admin
        return getAdminComplaints();
      case 4: // Director
        return getDirectorComplaints();
      case 5: // Manager
        return getManagerComplaints();
      default:
        return {'success': false, 'message': 'Unauthorized role'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top : false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Ethics Complaints',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: FutureBuilder<dynamic>(
            future: _fetchComplaints(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return NoDataWidget(
                    title: 'Loading Failed',
                    subtitle: snapshot.error.toString(),
                    icon: Icons.error_outline,
                  );
                } else if (snapshot.hasData) {
                  dynamic response = snapshot.data;
                  if (response['success'] == true) {
                    if (response['data'] != null &&
                        (response['data'] as List).isNotEmpty) {
                      return ListView.builder(
                        padding: EdgeInsets.all(16),
                        physics: BouncingScrollPhysics(),
                        itemCount: response['data'].length,
                        itemBuilder: (context, index) {
                          final complaint = response['data'][index];
                          return _buildComplaintCard(complaint);
                        },
                      );
                    } else {
                      return NoDataWidget(
                        title: 'No complaints found',
                        subtitle: 'There are currently no complaints to review.',
                        icon: Iconsax.judge,
                      );
                    }
                  } else {
                    return NoDataWidget(
                      title: 'Loading Failed',
                      subtitle:
                          response['message'] ?? 'Failed to load complaints',
                      icon: Icons.error_outline,
                    );
                  }
                }
              }
              return Center(child: GFLoader());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintCard(Map complaint) {
    final isPending = complaint['status'] == 0;
    final statusColor = isPending ? Colors.orange : Colors.green;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EthicsComplaintDetails(complaint: complaint),
              ),
            );
            // Refresh logic if needed after returning
            setState(() {});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complaint['username'] ?? complaint['name'] ?? 'Unknown User',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${complaint['complaint_id'] ?? ''} â€¢ ${complaint['date'] ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        isPending ? 'Pending' : 'Reviewed',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 0.5, color: Colors.grey[100]),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  complaint['complaint'] ?? 'No details provided',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'View Details & Actions',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
