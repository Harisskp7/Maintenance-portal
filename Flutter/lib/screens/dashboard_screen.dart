import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../models/work_order.dart';
import '../services/api_service.dart';
import '../widgets/notification_card.dart';
import '../widgets/work_order_card.dart';

class DashboardScreen extends StatefulWidget {
  final String employeeId;

  const DashboardScreen({super.key, required this.employeeId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedPlant = '';
  List<String> availablePlants = [];
  
  List<MaintenanceNotification> notifications = [];
  List<WorkOrder> workOrders = [];
  
  bool isLoadingNotifications = false;
  bool isLoadingWorkOrders = false;
  bool isLoadingPlants = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPlants();
  }

  Future<void> _loadPlants() async {
    setState(() {
      isLoadingPlants = true;
    });

    try {
      final plants = await ApiService.getPlants();
      setState(() {
        availablePlants = plants;
        if (plants.isNotEmpty) {
          selectedPlant = plants.first;
          _loadData(); // Load data after plants are loaded
        } else {
          errorMessage = 'No plants available';
        }
        isLoadingPlants = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load plants: $e';
        isLoadingPlants = false;
      });
    }
  }

  Future<void> _loadData() async {
    if (selectedPlant.isEmpty) {
      print('No plant selected, skipping data load');
      return;
    }
    
    await Future.wait([
      _loadNotifications(),
      _loadWorkOrders(),
    ]);
  }

  Future<void> _loadNotifications() async {
    setState(() {
      isLoadingNotifications = true;
      errorMessage = '';
    });

    try {
      final notificationsData = await ApiService.getNotifications(selectedPlant);
      setState(() {
        notifications = notificationsData;
        isLoadingNotifications = false;
      });
    } catch (e) {
      setState(() {
        isLoadingNotifications = false;
        notifications = []; // Set empty list instead of showing error
      });
    }
  }

  Future<void> _loadWorkOrders() async {
    setState(() {
      isLoadingWorkOrders = true;
    });

    try {
      final workOrdersData = await ApiService.getWorkOrders(selectedPlant);
      setState(() {
        workOrders = workOrdersData;
        isLoadingWorkOrders = false;
      });
    } catch (e) {
      setState(() {
        isLoadingWorkOrders = false;
        workOrders = []; // Set empty list instead of showing error
      });
    }
  }

  void _onPlantChanged(String? newPlant) {
    if (newPlant != null && newPlant != selectedPlant) {
      setState(() {
        selectedPlant = newPlant;
      });
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Maintenance Dashboard'),
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadPlants,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.notifications),
              text: 'Notifications',
            ),
            Tab(
              icon: Icon(Icons.work),
              text: 'Work Orders',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Enhanced Plant Selection
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.factory,
                    color: Color(0xFF2563EB),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Plant',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      isLoadingPlants
                          ? Row(
                              children: [
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Loading plants...',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : availablePlants.isEmpty
                              ? Text(
                                  'No plants available',
                                  style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : DropdownButton<String>(
                                  value: selectedPlant.isEmpty ? null : selectedPlant,
                                  isExpanded: true,
                                  hint: const Text(
                                    'Select a plant',
                                    style: TextStyle(color: Color(0xFF64748B)),
                                  ),
                                  items: availablePlants.map((plant) {
                                    return DropdownMenuItem<String>(
                                      value: plant,
                                      child: Text(
                                        'Plant $plant',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: _onPlantChanged,
                                  underline: Container(),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Enhanced Welcome Message
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF3B82F6),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Employee ${widget.employeeId}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedPlant.isEmpty 
                            ? 'Please select a plant to view data'
                            : 'Plant $selectedPlant Dashboard',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Enhanced Error Message
          if (errorMessage.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.warning_amber,
                      color: Colors.orange.shade700,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Notifications Tab
                _buildNotificationsTab(),
                
                // Work Orders Tab
                _buildWorkOrdersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsTab() {
    if (selectedPlant.isEmpty) {
      return _buildEmptyState(
        icon: Icons.factory_outlined,
        title: 'Please select a plant first',
        subtitle: 'Choose a plant from the dropdown above to view notifications',
      );
    }

    if (isLoadingNotifications) {
      return _buildLoadingState('Loading notifications...');
    }

    if (notifications.isEmpty) {
      return _buildEmptyState(
        icon: Icons.notifications_none,
        title: 'No notifications found',
        subtitle: 'No notifications available for Plant $selectedPlant',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationCard(
            notification: notifications[index],
            onTap: () {
              _showNotificationDetails(notifications[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildWorkOrdersTab() {
    if (selectedPlant.isEmpty) {
      return _buildEmptyState(
        icon: Icons.factory_outlined,
        title: 'Please select a plant first',
        subtitle: 'Choose a plant from the dropdown above to view work orders',
      );
    }

    if (isLoadingWorkOrders) {
      return _buildLoadingState('Loading work orders...');
    }

    if (workOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.work_outline,
        title: 'No work orders found',
        subtitle: 'No work orders available for Plant $selectedPlant',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadWorkOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: workOrders.length,
        itemBuilder: (context, index) {
          return WorkOrderCard(
            workOrder: workOrders[index],
            onTap: () {
              _showWorkOrderDetails(workOrders[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 64,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationDetails(MaintenanceNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.notifications,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Notification ${notification.qmnum}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Notification ID', notification.qmnum),
              _buildDetailRow('Plant (iwerk)', notification.iwerk),
              _buildDetailRow('Equipment', notification.equnr),
              _buildDetailRow('Priority', notification.priorityText),
              _buildDetailRow('Status', notification.status),
              _buildDetailRow('Description', notification.qmtxt),
              _buildDetailRow('Work Center', notification.arbplwerk),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showWorkOrderDetails(WorkOrder workOrder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.work,
                color: Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Work Order ${workOrder.aufnr}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Work Order ID', workOrder.aufnr),
              _buildDetailRow('Plant (werks)', workOrder.werks),
              _buildDetailRow('Type', workOrder.workOrderType),
              _buildDetailRow('Description', workOrder.qmtxt),
              _buildDetailRow('Cost Center', workOrder.kostl),
              _buildDetailRow('Company Code', workOrder.bukrs),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: const TextStyle(
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
