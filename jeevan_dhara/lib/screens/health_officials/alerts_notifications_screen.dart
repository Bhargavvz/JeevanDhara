import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_widgets.dart';

class AlertsNotificationsScreen extends StatefulWidget {
  const AlertsNotificationsScreen({Key? key}) : super(key: key);

  @override
  State<AlertsNotificationsScreen> createState() => _AlertsNotificationsScreenState();
}

class _AlertsNotificationsScreenState extends State<AlertsNotificationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String selectedFilter = 'All';
  String selectedSeverity = 'All';
  
  final List<String> filters = ['All', 'Active', 'Resolved', 'Acknowledged'];
  final List<String> severityLevels = ['All', 'Critical', 'High', 'Medium', 'Low'];
  
  final List<Map<String, dynamic>> alerts = [
    {
      'id': 'ALT001',
      'title': 'Water Contamination Detected',
      'description': 'High bacterial count detected in Kohima main water supply. Immediate action required.',
      'severity': 'Critical',
      'status': 'Active',
      'location': 'Kohima District',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'assignedTo': 'Dr. Sharma',
      'affectedPopulation': 15000,
      'suggestedActions': [
        'Issue boil water advisory',
        'Deploy water purification teams',
        'Set up temporary water distribution points',
        'Conduct health screening in affected areas'
      ],
      'reportedBy': 'ASHA Worker - Meena Devi',
      'relatedReports': 12,
    },
    {
      'id': 'ALT002',
      'title': 'Diarrhea Outbreak Alert',
      'description': 'Cluster of diarrhea cases reported in rural villages of Dimapur district.',
      'severity': 'High',
      'status': 'Active',
      'location': 'Dimapur District',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'assignedTo': 'Dr. Patel',
      'affectedPopulation': 500,
      'suggestedActions': [
        'Send medical team for investigation',
        'Distribute ORS packets',
        'Conduct water quality testing',
        'Educate community on hygiene practices'
      ],
      'reportedBy': 'ASHA Worker - Rita Sharma',
      'relatedReports': 8,
    },
    {
      'id': 'ALT003',
      'title': 'Unusual Water Color Reported',
      'description': 'Multiple reports of yellowish water from community wells in Mokokchung.',
      'severity': 'Medium',
      'status': 'Acknowledged',
      'location': 'Mokokchung District',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'assignedTo': 'Engineer Kumar',
      'affectedPopulation': 1200,
      'suggestedActions': [
        'Test water samples for chemical contamination',
        'Inspect upstream water sources',
        'Provide alternative water supply',
        'Monitor affected population'
      ],
      'reportedBy': 'ASHA Worker - Lily Ao',
      'relatedReports': 5,
    },
    {
      'id': 'ALT004',
      'title': 'Cholera Case Confirmed',
      'description': 'Laboratory confirmed cholera case in Nagaon district. Contact tracing initiated.',
      'severity': 'Critical',
      'status': 'Active',
      'location': 'Nagaon District',
      'timestamp': DateTime.now().subtract(const Duration(hours: 18)),
      'assignedTo': 'Dr. Das',
      'affectedPopulation': 2000,
      'suggestedActions': [
        'Isolate confirmed cases',
        'Conduct contact tracing',
        'Enhance surveillance in surrounding areas',
        'Implement strict sanitation measures'
      ],
      'reportedBy': 'District Hospital',
      'relatedReports': 3,
    },
    {
      'id': 'ALT005',
      'title': 'Water Supply System Failure',
      'description': 'Main water treatment plant breakdown affecting multiple villages.',
      'severity': 'High',
      'status': 'Resolved',
      'location': 'Jorhat District',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'assignedTo': 'PWD Team',
      'affectedPopulation': 8000,
      'suggestedActions': [
        'Repair treatment plant equipment',
        'Deploy mobile water tankers',
        'Monitor health impacts',
        'Update community on restoration progress'
      ],
      'reportedBy': 'PWD Engineer',
      'relatedReports': 15,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _animationController.forward();
  }

  List<Map<String, dynamic>> get filteredAlerts {
    return alerts.where((alert) {
      bool matchesFilter = selectedFilter == 'All' || alert['status'] == selectedFilter;
      bool matchesSeverity = selectedSeverity == 'All' || alert['severity'] == selectedSeverity;
      return matchesFilter && matchesSeverity;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Alert Summary
            _buildAlertSummary(),
            
            // Filters
            _buildFilters(),
            
            // Alerts List
            Expanded(
              child: _buildAlertsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewAlert,
        backgroundColor: AppTheme.errorRed,
        child: const Icon(Icons.add_alert),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Alerts & Notifications'),
      backgroundColor: AppTheme.warningOrange,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppTheme.errorRed,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${alerts.where((a) => a['status'] == 'Active').length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          onPressed: _showActiveAlertsOnly,
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _showNotificationSettings,
        ),
      ],
    );
  }

  Widget _buildAlertSummary() {
    final activeAlerts = alerts.where((a) => a['status'] == 'Active').length;
    final criticalAlerts = alerts.where((a) => a['severity'] == 'Critical' && a['status'] == 'Active').length;
    final resolvedToday = alerts.where((a) => a['status'] == 'Resolved').length;
    final totalAffected = alerts.where((a) => a['status'] == 'Active').fold<int>(0, (sum, alert) => sum + (alert['affectedPopulation'] as int));

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard('Active Alerts', activeAlerts.toString(), Icons.warning, AppTheme.warningOrange),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: _buildSummaryCard('Critical', criticalAlerts.toString(), Icons.priority_high, AppTheme.errorRed),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: _buildSummaryCard('Resolved Today', resolvedToday.toString(), Icons.check_circle, AppTheme.successGreen),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: _buildSummaryCard('People Affected', '${(totalAffected / 1000).toStringAsFixed(1)}K', Icons.people, AppTheme.infoBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return CustomCard(
      padding: const EdgeInsets.all(AppTheme.spacingS),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutralGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedFilter,
              decoration: const InputDecoration(
                labelText: 'Status',
                isDense: true,
              ),
              items: filters.map((filter) {
                return DropdownMenuItem(value: filter, child: Text(filter));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedSeverity,
              decoration: const InputDecoration(
                labelText: 'Severity',
                isDense: true,
              ),
              items: severityLevels.map((severity) {
                return DropdownMenuItem(value: severity, child: Text(severity));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSeverity = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsList() {
    final filtered = filteredAlerts;
    
    if (filtered.isEmpty) {
      return EmptyState(
        title: 'No Alerts Found',
        subtitle: 'No alerts match the selected filters',
        icon: Icons.notifications_off,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final alert = filtered[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final severity = alert['severity'] as String;
    final status = alert['status'] as String;
    final severityColor = StatusColors.getSeverityColor(severity);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        onTap: () => _showAlertDetails(alert),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: severityColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              alert['title'] as String,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SeverityBadge(severity: severity),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        'ID: ${alert['id']} • ${alert['location']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: status),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Description
            Padding(
              padding: const EdgeInsets.only(left: AppTheme.spacingM + 4),
              child: Text(
                alert['description'] as String,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Key Info
            Padding(
              padding: const EdgeInsets.only(left: AppTheme.spacingM + 4),
              child: Row(
                children: [
                  _buildInfoChip(
                    '${alert['affectedPopulation']} people',
                    Icons.people,
                    AppTheme.infoBlue,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  _buildInfoChip(
                    '${alert['relatedReports']} reports',
                    Icons.assignment,
                    AppTheme.primaryGreen,
                  ),
                  const Spacer(),
                  Text(
                    _formatTimestamp(alert['timestamp'] as DateTime),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Actions
            Padding(
              padding: const EdgeInsets.only(left: AppTheme.spacingM + 4),
              child: Row(
                children: [
                  if (status == 'Active') ...[
                    CustomButton(
                      text: 'Acknowledge',
                      onPressed: () => _acknowledgeAlert(alert),
                      type: ButtonType.secondary,
                      height: 32,
                      icon: Icons.check,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    CustomButton(
                      text: 'Resolve',
                      onPressed: () => _resolveAlert(alert),
                      type: ButtonType.primary,
                      height: 32,
                      icon: Icons.done_all,
                    ),
                  ] else if (status == 'Acknowledged') ...[
                    CustomButton(
                      text: 'Take Action',
                      onPressed: () => _takeAction(alert),
                      type: ButtonType.primary,
                      height: 32,
                      icon: Icons.play_arrow,
                    ),
                  ],
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.share, size: 18),
                    onPressed: () => _shareAlert(alert),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showAlertDetails(Map<String, dynamic> alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAlertDetailsSheet(alert),
    );
  }

  Widget _buildAlertDetailsSheet(Map<String, dynamic> alert) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.neutralGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Alert ID: ${alert['id']}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
                SeverityBadge(severity: alert['severity']),
              ],
            ),
          ),
          
          const Divider(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailSection('Description', alert['description']),
                  _buildDetailSection('Location', alert['location']),
                  _buildDetailSection('Assigned To', alert['assignedTo']),
                  _buildDetailSection('Reported By', alert['reportedBy']),
                  _buildDetailSection('Affected Population', '${alert['affectedPopulation']} people'),
                  _buildDetailSection('Related Reports', '${alert['relatedReports']} reports'),
                  _buildDetailSection('Timestamp', alert['timestamp'].toString()),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  Text(
                    'Suggested Actions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  
                  ...((alert['suggestedActions'] as List<String>).map((action) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingXS),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.arrow_right,
                            color: AppTheme.primaryGreen,
                            size: 20,
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Expanded(
                            child: Text(
                              action,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList()),
                ],
              ),
            ),
          ),
          
          // Action Buttons
          if (alert['status'] == 'Active')
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Acknowledge',
                      onPressed: () {
                        Navigator.of(context).pop();
                        _acknowledgeAlert(alert);
                      },
                      type: ButtonType.secondary,
                      height: 48,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: CustomButton(
                      text: 'Resolve Alert',
                      onPressed: () {
                        Navigator.of(context).pop();
                        _resolveAlert(alert);
                      },
                      type: ButtonType.primary,
                      height: 48,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _acknowledgeAlert(Map<String, dynamic> alert) {
    setState(() {
      alert['status'] = 'Acknowledged';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert ${alert['id']} acknowledged'),
        backgroundColor: AppTheme.infoBlue,
      ),
    );
  }

  void _resolveAlert(Map<String, dynamic> alert) {
    setState(() {
      alert['status'] = 'Resolved';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert ${alert['id']} resolved'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _takeAction(Map<String, dynamic> alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Taking action on ${alert['id']}')),
    );
  }

  void _shareAlert(Map<String, dynamic> alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing alert ${alert['id']}')),
    );
  }

  void _createNewAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create new alert feature coming soon')),
    );
  }

  void _showActiveAlertsOnly() {
    setState(() {
      selectedFilter = 'Active';
    });
  }

  void _showNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings coming soon')),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}