// ignore_for_file: prefer_const_constructors
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/manager/manager_functions.dart';
import 'package:kmsmerino/views/screens/auth/loggedin_user.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';

class ManagerKPI extends StatefulWidget {
  const ManagerKPI({super.key});

  @override
  State<ManagerKPI> createState() => _ManagerKPIState();
}

class _ManagerKPIState extends State<ManagerKPI> with TickerProviderStateMixin {
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
        child: dashboardWidget(),
    );
  }

  Widget dashboardWidget() {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Color(0xFFEFF3F9),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Manager KPI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: FutureBuilder<dynamic>(
          future: () async {
            final managerId = await LoggedInUser.getUserId();
            return getKaizenKPIData(managerId);
          }(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return errorWidgetDesign(context, snapshot.error.toString());
              } else if (snapshot.hasData) {
                dynamic response = snapshot.data;
                return response['success'] == true
                    ? (response['data'] != null &&
                              response['data']['counts'] != null &&
                              response['data']['counts']['total'] > 0)
                          ? RefreshIndicator(
                              onRefresh: () async {
                                setState(() {});
                              },
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Summary Cards Section
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        top: 10,
                                      ),
                                      child: Text(
                                        "Performance Overview",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    _buildSummaryCards(
                                      response['data']['counts'],
                                    ),
                                    SizedBox(height: 20),

                                    SizedBox(height: 10),
                                    _buildStatusCards(
                                      response['data']['counts'],
                                    ),
                                    SizedBox(height: 20),

                                    // Visual Analytics Heading
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 4,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            "Visual Analytics",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              letterSpacing: -0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Bar Chart Card
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.03),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              20,
                                              24,
                                              20,
                                              0,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.bar_chart_rounded,
                                                  color: Colors.blueGrey[400],
                                                  size: 20,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  "Implementation Progress",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 320,
                                            padding: EdgeInsets.fromLTRB(
                                              10,
                                              30,
                                              20,
                                              10,
                                            ),
                                            child: barChart(
                                              response['data']['counts']['pending'],
                                              response['data']['counts']['notstart'],
                                              response['data']['counts']['inprogress'],
                                              response['data']['counts']['rejected'],
                                              response['data']['counts']['verified'],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          _buildChartLegend(),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 20),

                                    // Pie Chart Card
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.03),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              20,
                                              24,
                                              20,
                                              0,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.pie_chart_rounded,
                                                  color: Colors.blueGrey[400],
                                                  size: 20,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  "Status Breakdown",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 280,
                                            padding: EdgeInsets.all(24),
                                            child: pieChart(
                                              response['data']['counts']['pending'],
                                              response['data']['counts']['notstart'],
                                              response['data']['counts']['inprogress'],
                                              response['data']['counts']['rejected'],
                                              response['data']['counts']['verified'],
                                            ),
                                          ),
                                          _buildChartLegend(),
                                          SizedBox(height: 24),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                  ],
                                ),
                              ),
                            )
                          : NoDataWidget(
                              title: 'No KPI Data Available',
                              subtitle:
                                  'Performance metrics will appear here once data is available.',
                              icon: Icons.analytics_outlined,
                            )
                    : NoDataWidget(
                        title: 'No KPI Data Available',
                        subtitle:
                            'Performance metrics will appear here once data is available.',
                        icon: Icons.analytics_outlined,
                      );
              }
            }
            return Center(
              child: AnimatedDotsLoader(
                text: "Loading",
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> counts) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildSummaryCard(
            icon: Icons.lightbulb_outline,
            title: "Total Ideas",
            count: counts['total'].toString(),
            color: Color(0xFF4CAF50),
          ),
          _buildSummaryCard(
            icon: Icons.check_circle_outline,
            title: "Implemented",
            count: counts['verified'].toString(),
            color: Color(0xFF2196F3),
          ),
          _buildSummaryCard(
            icon: Icons.people_outline,
            title: "Per Employee",
            count: counts['totalPerUser'].toStringAsFixed(2),
            color: Color(0xFFFF9800),
          ),
          _buildSummaryCard(
            icon: Icons.timer,
            title: "MTTI (Days)",
            count: counts['mtti'].toString(),
            color: Color(0xFF9C27B0),
          ),
        ],
      ),
    );
  }

  bool _isNumericString(String str) {
    // Check if the string is a valid number (int or double)
    return (int.tryParse(str) != null) || (double.tryParse(str) != null);
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(icon, color: color, size: 28)),
            ),
            SizedBox(height: 10),
            Text(
              _isNumericString(count)
                  ? (int.tryParse(count) != null
                        ? count
                        : double.parse(count).toStringAsFixed(2))
                  : count, // Display as-is if it's not a number
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCards(Map<String, dynamic> counts) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Kaizens Numbers",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 2,
            endIndent: 2,
            color: Colors.grey.withValues(alpha: 0.3),
          ),
          _buildStatusItem(
            title: "Pending",
            count: counts['pending'].toString(),
            color: GFColors.WARNING,
          ),
          _buildStatusItem(
            title: "Rejected",
            count: counts['rejected'].toString(),
            color: GFColors.DANGER,
          ),
          _buildStatusItem(
            title: "Not Started",
            count: counts['notstart'].toString(),
            color: GFColors.INFO,
          ),
          _buildStatusItem(
            title: "In Progress",
            count: counts['inprogress'].toString(),
            color: GFColors.PRIMARY,
          ),
          _buildStatusItem(
            title: "Verified",
            count: counts['verified'].toString(),
            color: GFColors.SUCCESS,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required String title,
    required String count,
    required Color color,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: isFirst || isLast
            ? Border(
                top: isFirst
                    ? BorderSide(color: Colors.grey.withValues(alpha: 0.1))
                    : BorderSide.none,
                bottom: isLast
                    ? BorderSide(color: Colors.grey.withValues(alpha: 0.1))
                    : BorderSide.none,
              )
            : Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            count,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendItem("Pending", GFColors.WARNING),
              _legendItem("Not Start", GFColors.INFO),
              _legendItem("In Progress", GFColors.PRIMARY),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendItem("Rejected", GFColors.DANGER),
              _legendItem("Verified", GFColors.SUCCESS),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget headingText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget pieChart(
    int pending,
    int notstart,
    int inprogress,
    int rejected,
    int verified,
  ) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 60,
        sectionsSpace: 4,
        borderData: FlBorderData(show: false),
        sections: [
          _pieSection(pending, GFColors.WARNING, 'Pending'),
          _pieSection(notstart, GFColors.INFO, 'Not Started'),
          _pieSection(inprogress, GFColors.PRIMARY, 'In Progress'),
          _pieSection(rejected, GFColors.DANGER, 'Rejected'),
          _pieSection(verified, GFColors.SUCCESS, 'Verified'),
        ],
      ),
    );
  }

  PieChartSectionData _pieSection(int value, Color color, String title) {
    return PieChartSectionData(
      value: value.toDouble(),
      color: color,
      title: value > 0 ? value.toString() : '',
      radius: 25,
      titleStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
    );
  }

  Widget barChart(
    int pending,
    int notstart,
    int inprogress,
    int rejected,
    int verified,
  ) {
    List<int> data = [pending, notstart, inprogress, rejected, verified];
    int maxVal = data.fold(0, (max, e) => e > max ? e : max);

    double interval = 1;
    if (maxVal > 5) {
      interval = (maxVal / 5).ceilToDouble();
    }

    double maxY = maxVal == 0 ? 5 : (maxVal + interval).toDouble();

    return BarChart(
      BarChartData(
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.withValues(alpha: 0.08), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                String text = '';
                switch (value.toInt()) {
                  case 0:
                    text = 'Pnd';
                    break;
                  case 1:
                    text = 'N.S';
                    break;
                  case 2:
                    text = 'InP';
                    break;
                  case 3:
                    text = 'Rej';
                    break;
                  case 4:
                    text = 'Ver';
                    break;
                }
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: interval,
              reservedSize: 35,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return Container();
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => Colors.blueGrey.withValues(alpha: 0.9),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String status = '';
              switch (group.x.toInt()) {
                case 0:
                  status = 'Pending';
                  break;
                case 1:
                  status = 'Not Started';
                  break;
                case 2:
                  status = 'In Progress';
                  break;
                case 3:
                  status = 'Rejected';
                  break;
                case 4:
                  status = 'Verified';
                  break;
              }
              return BarTooltipItem(
                '$status\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY.toInt()).toString(),
                    style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        borderData: FlBorderData(show: false),
        alignment: BarChartAlignment.spaceAround,
        barGroups: [
          _buildBarGroup(0, pending.toDouble(), GFColors.WARNING),
          _buildBarGroup(1, notstart.toDouble(), GFColors.INFO),
          _buildBarGroup(2, inprogress.toDouble(), GFColors.PRIMARY),
          _buildBarGroup(3, rejected.toDouble(), GFColors.DANGER),
          _buildBarGroup(4, verified.toDouble(), GFColors.SUCCESS),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.7)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 18,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}
