// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/common/kaizen/kaizen_no_data_widget.dart';
import 'package:kmsmerino/views/screens/user/kaizens/add_kaizen.dart';
import 'package:kmsmerino/views/screens/user/kaizens/update_approvedkaizen.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_kaizendetails.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_submittedkaizens.dart';
import 'package:kmsmerino/views/screens/user/kaizens/user_approvedkaizens.dart';

class UserViewKaizens extends StatefulWidget {
  final String type;
  const UserViewKaizens(this.type, {super.key});

  @override
  State<UserViewKaizens> createState() => _UserViewKaizensState();
}

class _UserViewKaizensState extends State<UserViewKaizens> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return dashboardWidget();
  }

  Widget dataLoadingWidget() {
    return Scaffold(
      backgroundColor: Color(0xFFEFF3F9),
      body: Center(
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1A73E8)),
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboardWidget() {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Color(0xFFEFF3F9),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false, // Disable default back button
          elevation: 0,
          title: Text(
            widget.type.isEmpty ? 'Kaizen Categories' : widget.type,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          leading: widget.type.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Navigate back to category selection
                    Navigator.pop(context);
                  },
                )
              : null,
          actions: <Widget>[
            if (widget.type.isNotEmpty)
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                tooltip: 'Add New Kaizen',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddKaizen(widget.type),
                    ),
                  );
                },
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: (widget.type.isEmpty)
              // Show category selection when no type is specified
              ? _buildCategoryMenu()
              // Show kaizen list for specific category
              : FutureBuilder<dynamic>(
                  future: getUserViewKaizens(widget.type),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        debugPrint(snapshot.error.toString());
                        return errorWidgetDesign(
                          context,
                          snapshot.error.toString(),
                        );
                      } else if (snapshot.hasData) {
                        dynamic response = snapshot.data;
                        if (response['success'] == true && response['data'] != null) {
                          var kaizensList = response['data']['kaizens'];
                          if (kaizensList != null && kaizensList.length > 0) {
                            return SizedBox(
                                height: MediaQuery.of(
                                  context,
                                ).size.height,
                                child: ListView.builder(
                                  itemCount: kaizensList.length,
                                  itemBuilder: (context, index) {
                                    dynamic kaizen = kaizensList[index];
                                    return _buildKaizenListItem(kaizen);
                                  },
                                ),
                              );
                          } else {
                            // Show custom no data widget when kaizens list is empty
                            return KaizenNoDataWidget(type: widget.type);
                          }
                        } else {
                          // Show custom no data widget when response is not successful
                          return KaizenNoDataWidget(type: widget.type);
                        }
                      }
                    }
                    // Show centered loading indicator while waiting for data
                    return dataLoadingWidget();
                  },
                ),
        ),
      ),
    );
  }



  // Build category menu similar to user profile
  Widget _buildCategoryMenu() {
    return ListView(
      padding: EdgeInsets.all(10),
      children: [
        SizedBox(height: 10),
        _menuCard(
          title: 'By Category',
          icon: Icons.category,
          color: Color(0xFF6A11CB),
          gradientColors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          items: [
            _menuItem('Productivity', Icons.speed, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserViewKaizens('Productivity'),
                ),
              );
            }),
            _menuItem('Quality', Icons.check_circle, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserViewKaizens('Quality'),
                ),
              );
            }),
            _menuItem('Cost', Icons.currency_rupee, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserViewKaizens('Cost'),
                ),
              );
            }),
            _menuItem('Delivery', Icons.local_shipping, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserViewKaizens('Delivery'),
                ),
              );
            }),
            _menuItem('Safety', Icons.security, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserViewKaizens('Safety'),
                ),
              );
            }),
            _menuItem('Others', Icons.more_horiz, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserViewKaizens('Others'),
                ),
              );
            }),
          ],
        ),

        SizedBox(height: 10),

        _menuCard(
          title: 'By Status',
          icon: Icons.view_list,
          color: Color(0xFF11998e),
          gradientColors: [Color(0xFF11998e), Color(0xFF38ef7d)],
          items: [
            _menuItem('Submitted Kaizens', Icons.send, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserSubmittedKaizens()),
              );
            }),
            _menuItem('Approved Kaizens', Icons.check, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserApprovedKaizens()),
              );
            }),
          ],
        ),
      ],
    );
  }

  // Menu card with enhanced styling and light border
  Widget _menuCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Color> gradientColors,
    required List<Widget> items,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[100]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  // Menu item with enhanced styling
  Widget _menuItem(String title, IconData icon, Function() onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          ),
          child: Center(
            child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).primaryColor,
        ),
        onTap: onTap,
      ),
    );
  }

  // Kaizen list item with modern card design matching submitted kaizens
  Widget _buildKaizenListItem(dynamic kaizen) {
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
                  UserKaizenDetails(kaizen['id'], UserViewKaizens(widget.type)),
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
                          _getIconForType(_getTypeFromKaizen(kaizen)),
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _getTypeFromKaizen(kaizen) ?? 'Type',
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
                    onSelected: (int value) {
                      if (value == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserKaizenDetails(
                              kaizen['id'],
                              UserViewKaizens(widget.type),
                            ),
                          ),
                        );
                      } else if (value == 2 &&
                          ((kaizen['status'] == 0) ||
                              (kaizen['status'] == 1 &&
                                  (kaizen['end'] == 0 || kaizen['start'] == 1) &&
                                  kaizen['k_status'] == 0))) {
                        if (kaizen['status'] == 0) {
                          getUserKaizenDetailsForPendingUpdate(
                            context,
                            kaizen['id'],
                            UserViewKaizens(widget.type),
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
                                UserViewKaizens(widget.type),
                              ),
                            ),
                          );
                        }
                      } else if (value == 3 && kaizen['status'] == 0) {
                        deletePendingKaizen(
                          context,
                          kaizen['id'],
                          UserViewKaizens(widget.type),
                        );
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

  // Status badge widget
  // Function to get the type from kaizen data
  // Try different possible field names that might contain the type
  String? _getTypeFromKaizen(dynamic kaizen) {
    // Check for various possible field names that might contain the type
    if (kaizen is Map) {
      // Try common field names that might contain the type
      if (kaizen.containsKey('type')) {
        return kaizen['type'];
      } else if (kaizen.containsKey('subcategory')) {
        return kaizen['subcategory'];
      } else if (kaizen.containsKey('category')) {
        return kaizen['category'];
      } else if (kaizen.containsKey('kaizen_type')) {
        return kaizen['kaizen_type'];
      }
    }
    // If no specific type field found, fall back to the widget's type
    return widget.type;
  }

  // Function to get icon based on kaizen type
  IconData _getIconForType(dynamic typeValue) {
    String? type;

    // Handle different possible types of input (could be string, int, or null)
    if (typeValue is String) {
      type = typeValue;
    } else if (typeValue != null) {
      type = typeValue.toString();
    }

    if (type == null) return Icons.lightbulb_outline;

    switch (type.toLowerCase()) {
      case 'productivity':
        return Icons.speed;
      case 'quality':
        return Icons.check_circle;
      case 'cost':
        return Icons.currency_rupee;
      case 'delivery':
        return Icons.local_shipping;
      case 'safety':
        return Icons.security;
      case 'others':
      case 'other':
        return Icons.more_horiz;
      default:
        return Icons.lightbulb_outline;
    }
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
