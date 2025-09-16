import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';

// Offline status controller
class OfflineStatusController extends GetxController {
  var isOnline = true.obs;
  var lastSyncTime = DateTime.now().obs;
  var pendingSyncItems = 0.obs;
  var syncStatus = 'synced'.obs;
  var dataSize = '0 MB'.obs;

  void updateConnectionStatus(bool status) {
    isOnline.value = status;
    if (status) {
      syncStatus.value = 'syncing';
      _simulateSync();
    } else {
      syncStatus.value = 'offline';
    }
  }

  void _simulateSync() {
    Future.delayed(const Duration(seconds: 3), () {
      lastSyncTime.value = DateTime.now();
      pendingSyncItems.value = 0;
      syncStatus.value = 'synced';
    });
  }

  void addPendingItem() {
    if (!isOnline.value) {
      pendingSyncItems.value++;
    }
  }

  String get connectionStatusText {
    if (isOnline.value) {
      return syncStatus.value == 'syncing' ? 'Syncing...' : 'Online';
    } else {
      return 'Offline';
    }
  }

  Color get statusColor {
    if (isOnline.value) {
      return syncStatus.value == 'syncing' ? AppTheme.warningOrange : AppTheme.successGreen;
    } else {
      return AppTheme.errorRed;
    }
  }

  IconData get statusIcon {
    if (isOnline.value) {
      return syncStatus.value == 'syncing' ? Icons.sync : Icons.cloud_done;
    } else {
      return Icons.cloud_off;
    }
  }
}

// Offline indicator widget
class OfflineIndicator extends StatelessWidget {
  final OfflineStatusController controller = Get.find<OfflineStatusController>();

  OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: controller.isOnline.value ? 0 : 40,
      decoration: BoxDecoration(
        color: AppTheme.errorRed,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: controller.isOnline.value
          ? const SizedBox.shrink()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'You\'re offline. Data will sync when connection is restored.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
    ));
  }
}

// Sync status indicator
class SyncStatusIndicator extends StatelessWidget {
  final bool compact;
  final OfflineStatusController controller = Get.find<OfflineStatusController>();

  SyncStatusIndicator({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () => _showSyncDetails(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 8,
        ),
        decoration: BoxDecoration(
          color: controller.statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(compact ? 12 : 16),
          border: Border.all(
            color: controller.statusColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.syncStatus.value == 'syncing')
              SizedBox(
                width: compact ? 12 : 16,
                height: compact ? 12 : 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(controller.statusColor),
                ),
              )
            else
              Icon(
                controller.statusIcon,
                color: controller.statusColor,
                size: compact ? 12 : 16,
              ),
            const SizedBox(width: 4),
            Text(
              controller.connectionStatusText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: controller.statusColor,
                fontWeight: FontWeight.w600,
                fontSize: compact ? 10 : 12,
              ),
            ),
            if (controller.pendingSyncItems.value > 0) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: controller.statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  controller.pendingSyncItems.value.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ));
  }

  void _showSyncDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SyncDetailsSheet(),
    );
  }
}

// Sync details bottom sheet
class SyncDetailsSheet extends StatelessWidget {
  final OfflineStatusController controller = Get.find<OfflineStatusController>();

  SyncDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                controller.statusIcon,
                color: controller.statusColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Sync Status',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          _buildStatusRow(
            'Connection',
            controller.connectionStatusText,
            controller.statusColor,
          ),
          _buildStatusRow(
            'Last Sync',
            _formatLastSync(controller.lastSyncTime.value),
            AppTheme.neutralGray,
          ),
          _buildStatusRow(
            'Pending Items',
            controller.pendingSyncItems.value.toString(),
            controller.pendingSyncItems.value > 0 ? AppTheme.warningOrange : AppTheme.successGreen,
          ),
          _buildStatusRow(
            'Offline Data',
            controller.dataSize.value,
            AppTheme.neutralGray,
          ),
          
          const SizedBox(height: 24),
          
          if (!controller.isOnline.value) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.warningOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.warningOrange.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.warningOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Offline Mode',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.warningOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your data is being saved locally and will sync automatically when connection is restored.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _forceSyncAttempt(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Sync'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openOfflineDataManager(context),
                  icon: const Icon(Icons.storage),
                  label: const Text('Manage Data'),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLastSync(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _forceSyncAttempt(BuildContext context) {
    // Simulate checking connection and syncing
    Get.showSnackbar(GetSnackBar(
      title: 'Sync Attempt',
      message: 'Checking connection and syncing data...',
      duration: const Duration(seconds: 2),
      backgroundColor: AppTheme.primaryBlue,
    ));
    
    // Simulate sync attempt
    Future.delayed(const Duration(seconds: 2), () {
      if (controller.isOnline.value) {
        controller._simulateSync();
      }
    });
    
    Navigator.pop(context);
  }

  void _openOfflineDataManager(BuildContext context) {
    Navigator.pop(context);
    Get.to(() => OfflineDataManagerScreen());
  }
}

// Offline data manager screen
class OfflineDataManagerScreen extends StatelessWidget {
  final OfflineStatusController controller = Get.find<OfflineStatusController>();

  OfflineDataManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Data'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStorageOverview(),
            const SizedBox(height: 24),
            _buildPendingItems(),
            const SizedBox(height: 24),
            _buildDataCategories(),
          ],
        ),
      )),
    );
  }

  Widget _buildStorageOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue.withValues(alpha: 0.1),
            AppTheme.primaryGreen.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storage,
                color: AppTheme.primaryBlue,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Storage Overview',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildStorageMetric(
                  'Offline Data',
                  controller.dataSize.value,
                  Icons.folder,
                ),
              ),
              Expanded(
                child: _buildStorageMetric(
                  'Pending Sync',
                  controller.pendingSyncItems.value.toString(),
                  Icons.sync_problem,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStorageMetric(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryBlue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.neutralGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPendingItems() {
    final pendingItems = [
      {'type': 'Health Report', 'count': 2, 'size': '0.5 MB'},
      {'type': 'Water Quality Report', 'count': 1, 'size': '0.2 MB'},
      {'type': 'Community Post', 'count': 3, 'size': '0.8 MB'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pending Sync Items',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        if (controller.pendingSyncItems.value == 0)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppTheme.successGreen,
                ),
                const SizedBox(width: 12),
                const Text('All data is synced'),
              ],
            ),
          )
        else
          ...pendingItems.map((item) => _buildPendingItemCard(item)).toList(),
      ],
    );
  }

  Widget _buildPendingItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.neutralGray.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getItemIcon(item['type']),
            color: AppTheme.warningOrange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['type'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${item['count']} items • ${item['size']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.neutralGray,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _viewPendingDetails(item['type']),
            child: const Text('View'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCategories() {
    final categories = [
      {'name': 'Health Records', 'size': '2.1 MB', 'items': 15},
      {'name': 'Water Reports', 'size': '0.8 MB', 'items': 8},
      {'name': 'Community Posts', 'size': '1.2 MB', 'items': 12},
      {'name': 'Cache Data', 'size': '0.5 MB', 'items': 25},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Categories',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        ...categories.map((category) => _buildCategoryCard(category)).toList(),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.neutralGray.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getCategoryIcon(category['name']),
            color: AppTheme.primaryBlue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${category['items']} items • ${category['size']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.neutralGray,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleCategoryAction(value, category['name']),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Export'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text('Clear'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getItemIcon(String type) {
    switch (type) {
      case 'Health Report':
        return Icons.health_and_safety;
      case 'Water Quality Report':
        return Icons.water_drop;
      case 'Community Post':
        return Icons.forum;
      default:
        return Icons.description;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Health Records':
        return Icons.medical_services;
      case 'Water Reports':
        return Icons.water;
      case 'Community Posts':
        return Icons.groups;
      case 'Cache Data':
        return Icons.cached;
      default:
        return Icons.folder;
    }
  }

  void _viewPendingDetails(String type) {
    Get.showSnackbar(GetSnackBar(
      title: 'Pending $type',
      message: 'Viewing pending $type items',
      duration: const Duration(seconds: 2),
    ));
  }

  void _handleCategoryAction(String action, String category) {
    switch (action) {
      case 'export':
        Get.showSnackbar(GetSnackBar(
          title: 'Export Started',
          message: 'Exporting $category data...',
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.primaryBlue,
        ));
        break;
      case 'clear':
        Get.showSnackbar(GetSnackBar(
          title: 'Data Cleared',
          message: '$category data has been cleared',
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.warningOrange,
        ));
        break;
    }
  }
}

// Offline functionality mixin for screens
mixin OfflineFunctionality {
  void saveOfflineData(String key, dynamic data) {
    // Implementation to save data locally
    final controller = Get.find<OfflineStatusController>();
    controller.addPendingItem();
  }

  Future<dynamic> loadOfflineData(String key) async {
    // Implementation to load data from local storage
    return null;
  }

  void scheduleSync(String dataType) {
    // Schedule data for sync when online
  }
}