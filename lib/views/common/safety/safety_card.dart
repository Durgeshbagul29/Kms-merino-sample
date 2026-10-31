import 'package:flutter/material.dart';

class SafetyCard extends StatelessWidget {
  final String? accidentId;
  final String? sysDate;
  final bool isPending;
  final String? statusText;
  final String? userName;
  final String? incidentDescription;
  final Color? primaryColor;
  final Color? secondaryColor;
  final IconData? incidentIcon;
  final Color? incidentIconColor;
  final VoidCallback? onTap;

  const SafetyCard({
    super.key,
    this.accidentId,
    this.sysDate,
    required this.isPending,
    this.statusText,
    this.userName,
    this.incidentDescription,
    this.primaryColor,
    this.secondaryColor,
    this.incidentIcon,
    this.incidentIconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color themePrimaryColor = primaryColor ?? Theme.of(context).primaryColor;
    Color effectiveSecondaryColor = secondaryColor ?? Colors.grey;
    Color effectiveIncidentIconColor = incidentIconColor ?? Colors.red;
    IconData effectiveIncidentIcon =
        incidentIcon ?? Icons.local_fire_department;
    Color statusBgColor = isPending
        ? Colors.orange.withValues(alpha: 0.1)
        : Colors.green.withValues(alpha: 0.1);
    Color statusTextColor = isPending
        ? Colors.orange.shade700
        : Colors.green.shade700;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      accidentId ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: themePrimaryColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText ?? (isPending ? 'Pending' : 'Closed'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Submitted By ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          userName ?? 'Unknown User',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: themePrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Date ",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        sysDate ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: themePrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Divider
              Container(
                height: 1,
                color: effectiveSecondaryColor is MaterialColor
                    ? effectiveSecondaryColor.shade200
                    : effectiveSecondaryColor.withAlpha(0x33),
              ),
              SizedBox(height: 12),
              // Incident description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    effectiveIncidentIcon,
                    size: 18,
                    color: effectiveIncidentIconColor is MaterialColor
                        ? effectiveIncidentIconColor.shade600
                        : effectiveIncidentIconColor,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      incidentDescription ?? 'No description',
                      style: TextStyle(
                        fontSize: 14,
                        color: effectiveSecondaryColor is MaterialColor
                            ? effectiveSecondaryColor.shade700
                            : effectiveSecondaryColor,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
