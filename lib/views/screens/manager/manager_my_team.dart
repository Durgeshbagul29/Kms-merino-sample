import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/manager/manager_functions.dart';
import 'package:kmsmerino/views/base/animated_dots_loader.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';
import 'package:iconsax/iconsax.dart';

class ManagerMyTeam extends StatefulWidget {
  const ManagerMyTeam({super.key});

  @override
  State<ManagerMyTeam> createState() => _ManagerMyTeamState();
}

class _ManagerMyTeamState extends State<ManagerMyTeam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "My Team",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: FutureBuilder<dynamic>(
        future: getManagerMyTeam(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: AnimatedDotsLoader(
                text: "Fetching Team",
                color: Theme.of(context).primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final response = snapshot.data;
            if (response['success'] == true && response['data'] != null) {
              final data = response['data'];
              List admins = [];
              List users = [];
              int kCount = 0;

              if (data is Map) {
                admins = data['admins'] as List? ?? [];
                users = data['users'] as List? ?? [];
                kCount = data['k_count'] ?? 0;
              } else if (data is List) {
                // If it's a flat list, we filter by user_role_id
                // Assuming user_role_id 1 is Admin, others are regular members
                for (var item in data) {
                  if (item['user_role_id'] == 1) {
                    admins.add(item);
                  } else {
                    users.add(item);
                  }
                }
                // k_count might not be available in flat list
                kCount = 0; 
              }

              if (admins.isEmpty && users.isEmpty) {
                return const NoDataWidget(
                  title: "No Team Members",
                  subtitle: "You don't have any team members assigned yet.",
                  icon: Iconsax.people,
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTeamSummary(kCount, admins.length + users.length),
                    if (admins.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: _buildSectionHeader("Administrators"),
                      ),
                      ...admins
                          .map(
                            (admin) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _buildUserCard(admin, isHeader: true),
                            ),
                          )
                          ,
                      const SizedBox(height: 16),
                    ],
                    if (users.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: _buildSectionHeader("Team Members"),
                      ),
                      ...users
                          .map(
                            (user) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: _buildUserCard(user),
                            ),
                          )
                          ,
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              );
            } else {
              return const NoDataWidget(
                title: "No Team Members",
                subtitle: "You don't have any team members assigned yet.",
                icon: Iconsax.people,
              );
            }
          }
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: Color(0xFF64748B),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTeamSummary(int kCount, int memberCount) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem("Members", memberCount.toString(), Iconsax.people),
          _buildSummaryItem("Kaizens", kCount.toString(), Iconsax.flash),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(dynamic person, {bool isHeader = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHeader
              ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
              : const Color(0xFFF1F5F9),
          width: isHeader ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: (isHeader ? Colors.amber : Theme.of(context).primaryColor)
                .withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              (person['empname'] ?? person['name'] ?? person['username'] ?? "U")[0]
                  .toUpperCase(),
              style: TextStyle(
                color: isHeader
                    ? Colors.amber[800]
                    : Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                person['empname'] ?? person['name'] ?? person['username'] ?? "Unknown",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
            if (isHeader)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "ADMIN",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "USER",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Iconsax.briefcase,
                  size: 14,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 4),
                Text(
                  (person['deptname'] ?? "No Department").toString(),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Iconsax.sms, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text(
                  (person['email'] ?? "No Email").toString(),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Iconsax.call, size: 14, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text(
                  (person['mobile'] ?? "No Mobile").toString(),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
