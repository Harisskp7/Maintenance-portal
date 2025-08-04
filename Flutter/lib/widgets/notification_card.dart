import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationCard extends StatelessWidget {
  final MaintenanceNotification notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Priority Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: notification.priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: notification.priorityColor),
                    ),
                    child: Text(
                      notification.priorityText,
                      style: TextStyle(
                        color: notification.priorityColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(notification.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getStatusColor(notification.status)),
                    ),
                    child: Text(
                      notification.status,
                      style: TextStyle(
                        color: _getStatusColor(notification.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  
                  // Notification Icon
                  Icon(
                    Icons.notifications,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Notification ID
              Text(
                'Notification ${notification.qmnum}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Description
              if (notification.qmtxt.isNotEmpty)
                Text(
                  notification.qmtxt,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              
              const SizedBox(height: 12),
              
              // Details Row
              Row(
                children: [
                  // Equipment
                  if (notification.equnr.isNotEmpty) ...[
                    Icon(Icons.build, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'EQ: ${notification.equnr}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  
                  // Plant
                  Icon(Icons.factory, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Plant: ${notification.iwerk}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Work Center
              if (notification.arbplwerk.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.work, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Work Center: ${notification.arbplwerk}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
} 