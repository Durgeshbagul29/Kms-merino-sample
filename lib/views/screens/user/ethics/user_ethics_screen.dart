// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kmsmerino/helper/route_helper.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/common/safety/empty_state_widget.dart';
import 'package:kmsmerino/views/screens/user/ethics/add_complaint.dart';
import 'package:kmsmerino/views/common/ethics/ethics_complaint_details.dart';
import 'package:kmsmerino/views/screens/user/user_bottom_navigation.dart';
import 'package:kmsmerino/views/screens/user/user_functions.dart';

class Complaints extends StatefulWidget {
  const Complaints({super.key});

  @override
  State<Complaints> createState() => ComplaintsState();
}

class ComplaintsState extends State<Complaints>
    with TickerProviderStateMixin, RouteAware, WidgetsBindingObserver {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Future<dynamic>? _complaintsFuture;
  DateTime? _lastFetchTime;
  bool _isRouteSubscribed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Initial fetch of complaints
    fetchComplaints(force: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isRouteSubscribed) {
      final modalRoute = ModalRoute.of(context);
      if (modalRoute != null) {
        routeObserver.subscribe(this, modalRoute);
        _isRouteSubscribed = true;
      }
    }
  }

  @override
  void dispose() {
    if (_isRouteSubscribed) {
      routeObserver.unsubscribe(this);
    }
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when a screen pushed on top is popped and this screen becomes visible again
    fetchComplaints();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isCurrentTab()) {
      fetchComplaints();
    }
  }

  bool _isCurrentTab() {
    final nav = UserBottomNavigation.of(context);
    if (nav != null) {
      return nav.currentIndex == 1;
    }
    return true;
  }

  /// Fetches complaints API data. Debounced to avoid duplicate rapid calls.
  void fetchComplaints({bool force = false}) {
    final now = DateTime.now();
    if (!force &&
        _lastFetchTime != null &&
        now.difference(_lastFetchTime!) < const Duration(milliseconds: 500)) {
      return;
    }
    _lastFetchTime = now;

    if (mounted) {
      setState(() {
        _complaintsFuture = getUserComplaints();
      });
      _animationController.forward(from: 0.0);
    }
  }

  /// Pull-to-refresh handler that awaits API completion
  Future<void> refresh() async {
    final future = getUserComplaints();
    if (mounted) {
      setState(() {
        _complaintsFuture = future;
      });
    }
    try {
      await future;
    } finally {
      if (mounted) {
        _animationController.forward(from: 0.0);
      }
    }
  }

  Future<void> _navigateToAddComplaint() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddComplaint()),
    );
    if (mounted) {
      fetchComplaints(force: true);
    }
  }

  Future<void> _navigateToDetails(Map data) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EthicsComplaintDetails(complaint: data),
      ),
    );
    if (mounted) {
      fetchComplaints();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: PopScope(
        canPop: true,
        child: dashboardWidget(),
      ),
    );
  }

  Widget dashboardWidget() {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'My Ethics Complaints',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _navigateToAddComplaint,
          label: Text(
            'New Complaint',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: FutureBuilder<dynamic>(
          future: _complaintsFuture,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return _buildErrorState(snapshot.error.toString());
              } else if (snapshot.hasData) {
                dynamic response = snapshot.data;
                if (response is Map &&
                    response['success'] == true &&
                    response['data'] != null) {
                  final List items = response['data'] is List ? response['data'] : [];
                  // Check if data array is empty
                  if (items.isEmpty) {
                    return _buildEmptyState();
                  }

                  // Data is not empty, show the list with RefreshIndicator
                  return RefreshIndicator(
                    onRefresh: refresh,
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        dynamic complaint = items[index];
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(1.0, 0),
                            end: Offset(0, 0),
                          ).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                (1.0 / items.length) * index,
                                1.0,
                                curve: Curves.easeOut,
                              ),
                            ),
                          ),
                          child: _buildComplaintCard(
                            context,
                            complaint["date"],
                            complaint["complaint"],
                            complaint['status'],
                            complaint is Map ? complaint : {},
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  final msg = (response is Map && response['message'] != null)
                      ? response['message'].toString()
                      : 'Failed to load complaints';
                  return _buildErrorState(msg);
                }
              }
            }
            return Center(
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
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF1A73E8),
                    ),
                    strokeWidth: 3,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: refresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: EmptyStateWidget(
              heading: 'No Complaints Found',
              subHeading:
                  'You haven\'t submitted any ethics complaints yet.\nTap the + button to add a new complaint.',
              icon: Icons.gavel_outlined,
              iconColor: Theme.of(context).primaryColor,
              backgroundColor: Theme.of(
                context,
              ).primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    errorWidgetDesign(context, message),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => fetchComplaints(force: true),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintCard(
    BuildContext context,
    dynamic date,
    dynamic complaint,
    dynamic status,
    Map data,
  ) {
    final dateStr = (date ?? '').toString();
    final complaintStr = (complaint ?? '').toString();
    final statusInt = int.tryParse(status?.toString() ?? '0') ?? 0;

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
          onTap: () => _navigateToDetails(data),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.description_outlined,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['complaint_id'] ?? 'Complaint',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  dateStr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(statusInt),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 0.5, color: Colors.grey[200]),
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  complaintStr,
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
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      'View Details',
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

  Widget _buildStatusBadge(int status) {
    bool isPending = status == 0;
    Color color = isPending ? Colors.orange : Colors.green;
    String text = isPending ? 'Pending' : 'Seen';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
