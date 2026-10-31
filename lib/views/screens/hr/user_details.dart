import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  final Map userArray;
  final Widget filename;
  const UserDetail(this.userArray, this.filename, {super.key});
  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> with TickerProviderStateMixin {
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
        child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'User Details',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ListView(
            children: [
              // Profile header section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userArray['name'] ?? 'No Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.userArray['username'] ?? 'No Username',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: widget.userArray['status'] == 1
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: widget.userArray['status'] == 1
                                    ? Colors.green.withValues(alpha: 0.5)
                                    : Colors.red.withValues(alpha: 0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.userArray['status'] == 1
                                  ? "Active"
                                  : "Inactive",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // User details section
              Text(
                'User Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 16),

              _buildDetailCard(
                icon: Icons.person_outline,
                title: 'Employee Name',
                value: widget.userArray['name'] ?? '-',
              ),

              _buildDetailCard(
                icon: Icons.alternate_email_outlined,
                title: 'Username',
                value: widget.userArray['username'] ?? '-',
              ),

              _buildDetailCard(
                icon: Icons.phone_outlined,
                title: 'Mobile Number',
                value: widget.userArray['mobile'] ?? '-',
              ),

              _buildDetailCard(
                icon: Icons.email_outlined,
                title: 'Email Address',
                value: widget.userArray['email'] ?? '-',
              ),

              _buildDetailCard(
                icon: Icons.business_outlined,
                title: 'Department',
                value: widget.userArray['deptname'] ?? '-',
              ),

              if (widget.userArray['assigned_departments'] != null &&
                  widget.userArray['assigned_departments']
                      .toString()
                      .isNotEmpty)
                _buildDetailCard(
                  icon: Icons.account_tree_outlined,
                  title: 'Assigned Departments',
                  value: widget.userArray['assigned_departments'].toString(),
                ),

              _buildDetailCard(
                icon: Icons.confirmation_number_outlined,
                title: 'Position',
                value: widget.userArray['position'] ?? '-',
              ),

              _buildDetailCard(
                icon: Icons.bloodtype_outlined,
                title: 'Blood Group',
                value: widget.userArray['bloodgroup'] ?? '-',
              ),

              _buildDetailCard(
                icon: Icons.school_outlined,
                title: 'Qualification',
                value: widget.userArray['qualification'] ?? '-',
              ),

              _buildDetailCard(
                icon: Icons.work_outline,
                title: 'Experience',
                value: widget.userArray['experience'] ?? '-',
              ),

              _buildDetailCard(
                icon: Icons.calendar_today_outlined,
                title: 'Joining Date',
                value: widget.userArray['joining_date'] ?? '-',
              ),

              _buildDetailCard(
                icon: Icons.cake_outlined,
                title: 'Birth Date',
                value: widget.userArray['birthdate'] ?? '-',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build detail cards
  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
