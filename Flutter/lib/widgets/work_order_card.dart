import 'package:flutter/material.dart';
import '../models/work_order.dart';

class WorkOrderCard extends StatelessWidget {
  final WorkOrder workOrder;
  final VoidCallback onTap;

  const WorkOrderCard({
    super.key,
    required this.workOrder,
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
                  // Work Order Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getWorkOrderTypeColor(workOrder.autyp).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getWorkOrderTypeColor(workOrder.autyp)),
                    ),
                    child: Text(
                      workOrder.workOrderType,
                      style: TextStyle(
                        color: _getWorkOrderTypeColor(workOrder.autyp),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  
                  // Work Order Icon
                  Icon(
                    Icons.work,
                    color: Colors.green.shade600,
                    size: 20,
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Work Order ID
              Text(
                'Work Order ${workOrder.aufnr}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Description
              if (workOrder.qmtxt.isNotEmpty)
                Text(
                  workOrder.qmtxt,
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
                  // Plant
                  Icon(Icons.factory, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Plant: ${workOrder.werks}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Company Code
                  Icon(Icons.business, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'CC: ${workOrder.bukrs}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Cost Center
              if (workOrder.kostl.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.account_balance, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Cost Center: ${workOrder.kostl}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              
              const SizedBox(height: 8),
              
              // Long Text
              if (workOrder.ltxa1.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.description, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        workOrder.ltxa1,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        maxLines: 1,
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

  Color _getWorkOrderTypeColor(String autyp) {
    switch (autyp) {
      case 'PM01':
        return Colors.blue; // Preventive Maintenance
      case 'PM02':
        return Colors.orange; // Corrective Maintenance
      case 'PM03':
        return Colors.red; // Emergency Maintenance
      default:
        return Colors.grey; // Other
    }
  }
} 