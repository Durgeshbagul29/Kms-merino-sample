import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/admin/admin_functions.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';
import 'package:kmsmerino/views/screens/admin/observation/admin_obsdetails.dart';
import 'package:kmsmerino/views/common/safety/safety_card.dart';

class AdminObservationScreen extends StatelessWidget {
  const AdminObservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: true,
        title: Text(
          'Observations',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: FutureBuilder<dynamic>(
          future: getAdminObservation(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return NoDataWidget(
                  title: 'Loading Failed',
                  subtitle: snapshot.error.toString(),
                  icon: Icons.error_outline,
                );
              } else if (snapshot.hasData) {
                dynamic response = snapshot.data;
                // Check if API call was successful
                if (response['success'] == true) {
                  // Check if data exists and is not empty
                  if (response['data'] != null &&
                      (response['data'] as List).isNotEmpty) {
                    return ListView.builder(
                      itemCount: response['data'].length,
                      itemBuilder: (context, index) {
                        final item = response['data'][index];
                        final isPending = item['status'] == 0;

                        return SafetyCard(
                          accidentId: item["observation_id"] ??
                              '', // Observation doesn't have accident ID
                          sysDate: item["sys_date"] ?? 'No date',
                          isPending: isPending,
                          userName: item['name'] ?? 'Unknown User',
                          incidentDescription:
                              item["observation"] ?? 'No description',
                          incidentIcon: Icons.visibility,
                          incidentIconColor: Colors.blue,
                          onTap: () {
                            // Navigate to observation details screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminObservationDetails(
                                  response['data'][index]['id'],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    // Data is null or empty - show empty state
                    return NoDataWidget(
                      title: 'No observations reported yet',
                      subtitle: 'Observations will appear here once reported',
                      icon: Icons.visibility,
                    );
                  }
                } else {
                  // API success is false - show error
                  return NoDataWidget(
                    title: 'Loading Failed',
                    subtitle:
                        response['message'] ?? 'Failed to load observations',
                    icon: Icons.error_outline,
                  );
                }
              }
            }
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
