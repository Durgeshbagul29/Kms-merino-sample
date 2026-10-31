// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/base/padding_widget.dart';
import 'package:kmsmerino/views/common/kaizen/kaizen_no_data_widget.dart';
import 'package:kmsmerino/views/screens/user/kaizens/update_approvedkaizen.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_kaizendetails.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';

class UserApprovedKaizens extends StatefulWidget {
  const UserApprovedKaizens({super.key});

  @override
  State<UserApprovedKaizens> createState() => _AccidentState();
}

class _AccidentState extends State<UserApprovedKaizens>
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
            'Approved Kaizens',
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
            future: getUserApprovedKaizens(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return errorWidgetDesign(context, snapshot.error.toString());
                } else if (snapshot.hasData) {
                  dynamic response = snapshot.data;
                  return response['success'] == true
                      ? response['data'] != null && response['data'] is List && response['data'].length > 0
                            ? ListView.builder(
                                itemCount: response['data'].length,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  dynamic kaizens = response['data'];
                                  return _buildKaizenCard(kaizens[index]);
                                },
                              )
                            : KaizenNoDataWidget(type: 'Approved')
                      : KaizenNoDataWidget(type: 'Approved');
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
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Allow tapping anywhere on the card to view details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  UserKaizenDetails(kaizen['id'], UserApprovedKaizens()),
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
                          size: 18,
                          color: Theme.of(context).primaryColor,
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
                  Text(
                    kaizen['choose_date'] ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                                UserApprovedKaizens(),
                              ),
                            ),
                          );
                          break;
                        case 2:
                          // Edit
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateApprovedKaizen(
                                kaizen['id'],
                                kaizen['subcategoryid'],
                                UserApprovedKaizens(),
                              ),
                            ),
                          );
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
                    ],
                  ),
                ],
              ),
              Divider(height: 1, color: Colors.grey[300]),

              SizedBox(height: 12),

              // Problem description with icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.report_problem_outlined,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      kaizen['problem'] ?? 'No problem description',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Status badge with icon
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: Colors.blue),
                    SizedBox(width: 6),
                    Text(
                      'Approved (Not Start)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
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
}
