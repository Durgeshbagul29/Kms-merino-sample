// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/common/kaizen/kaizen_no_data_widget.dart';
import 'package:kmsmerino/views/screens/user/kaizens/update_approvedkaizen.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_kaizendetails.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';

class UserSubmittedKaizens extends StatefulWidget {
  const UserSubmittedKaizens({super.key});

  @override
  State<UserSubmittedKaizens> createState() => _AccidentState();
}

class _AccidentState extends State<UserSubmittedKaizens>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationController.repeat(reverse: true);
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
        child: dashboardWidget(),
    );
  }

  Widget dashboardWidget() {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Submitted Kaizens',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        body: PaddingWidget(
          FutureBuilder<dynamic>(
            future: getUserSubmittedKaizens(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return errorWidgetDesign(context, snapshot.error.toString());
                } else if (snapshot.hasData) {
                  dynamic response = snapshot.data;
                  return response['success'] == true
                      ? response['data'] != null && response['data']['kaizens'] != null && response['data']['kaizens'].length > 0
                            ? ListView.builder(
                                itemCount: response['data']['kaizens'].length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  dynamic kaizens = response['data']['kaizens'];

                                  return _buildKaizenCard(kaizens[index]);
                                },
                              )
                            : KaizenNoDataWidget(type: 'Submitted')
                      : KaizenNoDataWidget(type: 'Submitted');
                }
              }
              return Center(child: GFLoader());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildKaizenCard(dynamic kaizen) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Allow tapping anywhere on the card to view details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  UserKaizenDetails(kaizen['id'], UserSubmittedKaizens()),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with department, date and action menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.business,
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            kaizen['dept'] ?? 'Department',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).primaryColor,
                        size: 14,
                      ),
                      SizedBox(width: 4),
                      Text(
                        kaizen['choose_date'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  // More options button (popup menu) at top right
                  PopupMenuButton<int>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).primaryColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 1:
                          // View Details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserKaizenDetails(
                                kaizen['id'],
                                UserSubmittedKaizens(),
                              ),
                            ),
                          );
                          break;
                        case 2:
                          // Edit
                          if (kaizen['status'] == 0) {
                            getUserKaizenDetailsForPendingUpdate(
                              context,
                              kaizen['id'],
                              UserSubmittedKaizens(),
                            );
                          } else if (kaizen['status'] == 1 &&
                              (kaizen['end'] == 0 || kaizen['start'] == 1) &&
                              kaizen['k_status'] == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateApprovedKaizen(
                                  kaizen['id'],
                                  kaizen['subcategoryid'],
                                  UserSubmittedKaizens(),
                                ),
                              ),
                            );
                          }
                          break;
                        case 3:
                          // Delete
                          if (kaizen['status'] == 0) {
                            deletePendingKaizen(
                              context,
                              kaizen['id'],
                              UserSubmittedKaizens(),
                            );
                          }
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              color: Theme.of(context).primaryColor,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text("View Details"),
                          ],
                        ),
                      ),
                      if ((kaizen['status'] == 0) ||
                          (kaizen['status'] == 1 &&
                              (kaizen['end'] == 0 || kaizen['start'] == 1) &&
                              kaizen['k_status'] == 0))
                        PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text("Edit"),
                            ],
                          ),
                        ),
                      if (kaizen['status'] == 0)
                        PopupMenuItem(
                          value: 3,
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                color: Theme.of(context).primaryColor,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text("Delete"),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              Divider(height: 1, color: Colors.grey[300]),

              SizedBox(height: 12),

              // Problem description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Problem Description",
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          kaizen['problem'] ?? 'No problem description',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Status badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    kaizen['status'],
                    kaizen['end'],
                    kaizen['start'],
                    kaizen['k_status'],
                  ).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor(
                      kaizen['status'],
                      kaizen['end'],
                      kaizen['start'],
                      kaizen['k_status'],
                    ).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(
                        kaizen['status'],
                        kaizen['end'],
                        kaizen['start'],
                        kaizen['k_status'],
                      ),
                      size: 14,
                      color: _getStatusColor(
                        kaizen['status'],
                        kaizen['end'],
                        kaizen['start'],
                        kaizen['k_status'],
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      _getStatusText(
                        kaizen['status'],
                        kaizen['end'],
                        kaizen['start'],
                        kaizen['k_status'],
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(
                          kaizen['status'],
                          kaizen['end'],
                          kaizen['start'],
                          kaizen['k_status'],
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
    );
  }

  Color _getStatusColor(int status, int end, int start, int kStatus) {
    if (status == 0) {
      return Colors.orange; // Pending
    } else if (status == 2) {
      return Colors.red; // Rejected
    } else if (status == 3) {
      return Colors.green; // Verified
    } else if (status == 1 && (end == 0 || start == 1) && kStatus == 0) {
      return Colors.blue; // Approved (Not Start)
    } else if (status == 1 && (start == 1 || end == 0) && kStatus == 1) {
      return Theme.of(context).primaryColor; // Approved (In Progress)
    } else {
      return Colors.grey; // No Status
    }
  }

  String _getStatusText(int status, int end, int start, int kStatus) {
    if (status == 0) {
      return 'Pending';
    } else if (status == 2) {
      return 'Rejected';
    } else if (status == 3) {
      return 'Verified';
    } else if (status == 1 && (end == 0 || start == 1) && kStatus == 0) {
      return 'Approved (Not Start)';
    } else if (status == 1 && (start == 1 || end == 0) && kStatus == 1) {
      return 'Approved (In Progress)';
    } else {
      return 'No Status';
    }
  }

  IconData _getStatusIcon(int status, int end, int start, int kStatus) {
    if (status == 0) {
      return Icons.access_time; // Pending
    } else if (status == 2) {
      return Icons.cancel; // Rejected
    } else if (status == 3) {
      return Icons.check_circle; // Verified
    } else if (status == 1 && (end == 0 || start == 1) && kStatus == 0) {
      return Icons.check; // Approved (Not Start)
    } else if (status == 1 && (start == 1 || end == 0) && kStatus == 1) {
      return Icons.hourglass_bottom; // Approved (In Progress)
    } else {
      return Icons.help_outline; // No Status
    }
  }
}
