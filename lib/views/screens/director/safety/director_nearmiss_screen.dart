import 'package:flutter/material.dart';
import 'package:kmsmerino/views/screens/director/director_functions.dart';
import 'package:kmsmerino/views/base/error_message.dart';
import 'package:kmsmerino/views/screens/director/nearmiss/director_nearmissdetails.dart';
import 'package:kmsmerino/views/common/safety/safety_card.dart';
import 'package:kmsmerino/views/common/no_data_widget.dart';

class DirectorNearmissScreen extends StatelessWidget {
  const DirectorNearmissScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: true,
        title: Text(
          'Near Miss',
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
          future: getDirectorNearmiss(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                debugPrint(snapshot.error.toString());
                return errorWidgetDesign(context, snapshot.error.toString());
              } else if (snapshot.hasData) {
                dynamic response = snapshot.data;
                return response['success'] == true
                    ? (response['data'] != null && response['data'].isNotEmpty)
                          ? ListView.builder(
                              itemCount: response['data'].length,
                              itemBuilder: (context, index) {
                                final item = response['data'][index];
                                final isPending = item['status'] == 0;

                                return SafetyCard(
                                  accidentId:
                                      item["nearmiss_id"] ??
                                      '', // Near miss doesn't have accident ID
                                  sysDate: item["sys_date"] ?? 'No date',
                                  isPending: isPending,
                                  userName: item['name'] ?? 'Unknown User',
                                  incidentDescription:
                                      item["incident"] ?? 'No description',
                                  incidentIcon: Icons.warning_amber,
                                  incidentIconColor: Colors.orange,
                                  onTap: () {
                                    // Navigate to near miss details screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DirectorNearmissDetails(
                                              response['data'][index]['id'],
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : NoDataWidget(
                              title: 'No Near Misses Found',
                              subtitle:
                                  'There are currently no near miss incidents reported.',
                              icon: Icons.warning_amber,
                            )
                    : NoDataWidget(
                        title: 'Loading Failed',
                        subtitle:
                            'We encountered an error while retrieving the reports.',
                        icon: Icons.error_outline,
                      );
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
