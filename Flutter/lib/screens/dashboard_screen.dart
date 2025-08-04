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
      appBar: AppBar(
        title: const Text('Maintenance Dashboard'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPlants,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
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
          // Plant Selection
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Row(
              children: [
                const Icon(Icons.factory, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Plant:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: isLoadingPlants
                      ? const Row(
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 8),
                            Text('Loading plants...'),
                          ],
                        )
                      : availablePlants.isEmpty
                          ? const Text('No plants available', style: TextStyle(color: Colors.red))
                          : DropdownButton<String>(
                              value: selectedPlant.isEmpty ? null : selectedPlant,
                              isExpanded: true,
                              hint: const Text('Select a plant'),
                              items: availablePlants.map((plant) {
                                return DropdownMenuItem<String>(
                                  value: plant,
                                  child: Text('Plant $plant'),
                                );
                              }).toList(),
                              onChanged: _onPlantChanged,
                            ),
                ),
              ],
            ),
          ),

          // Welcome Message
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.person, color: Colors.blue.shade700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Employee ${widget.employeeId}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        selectedPlant.isEmpty 
                            ? 'Please select a plant'
                            : 'Plant $selectedPlant Dashboard',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Error Message
          if (errorMessage.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.orange.shade700),
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.factory_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Please select a plant first',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (isLoadingNotifications) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading notifications...'),
          ],
        ),
      );
    }

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No notifications found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'No notifications available for Plant $selectedPlant',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.factory_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Please select a plant first',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (isLoadingWorkOrders) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading work orders...'),
          ],
        ),
      );
    }

    if (workOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No work orders found',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'No work orders available for Plant $selectedPlant',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
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

  void _showNotificationDetails(MaintenanceNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Notification ${notification.qmnum}'),
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
        title: Text('Work Order ${workOrder.aufnr}'),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? 'N/A' : value),
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
