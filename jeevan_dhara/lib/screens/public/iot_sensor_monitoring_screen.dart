import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/enhanced_ui_widgets.dart' as enhanced;

class IoTSensorMonitoringScreen extends StatefulWidget {
  const IoTSensorMonitoringScreen({super.key});

  @override
  State<IoTSensorMonitoringScreen> createState() => _IoTSensorMonitoringScreenState();
}

class _IoTSensorMonitoringScreenState extends State<IoTSensorMonitoringScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  
  bool isConnecting = false;
  bool isConnected = false;
  String connectionStatus = 'Disconnected';
  
  final List<Map<String, dynamic>> iotSensors = [
    {
      'id': 'WQ001',
      'name': 'Village Well Sensor',
      'type': 'Water Quality',
      'location': 'Main Village Well',
      'status': 'online',
      'battery': 85,
      'lastUpdate': '2 minutes ago',
      'readings': {
        'ph': 7.2,
        'tds': 145,
        'turbidity': 2.1,
        'temperature': 24.5,
        'chlorine': 0.3,
        'bacteria': 'Safe',
      },
      'alerts': [],
    },
    {
      'id': 'WQ002',
      'name': 'River Water Sensor',
      'type': 'Water Quality',
      'location': 'River Stream',
      'status': 'warning',
      'battery': 42,
      'lastUpdate': '15 minutes ago',
      'readings': {
        'ph': 6.8,
        'tds': 285,
        'turbidity': 8.5,
        'temperature': 26.2,
        'chlorine': 0.1,
        'bacteria': 'High',
      },
      'alerts': [
        {'type': 'warning', 'message': 'High turbidity detected'},
        {'type': 'error', 'message': 'Bacteria levels elevated'},
      ],
    },
    {
      'id': 'AQ001',
      'name': 'Air Quality Sensor',
      'type': 'Air Quality',
      'location': 'Community Center',
      'status': 'online',
      'battery': 78,
      'lastUpdate': '1 minute ago',
      'readings': {
        'pm2_5': 35,
        'pm10': 58,
        'co2': 410,
        'humidity': 65,
        'temperature': 28.3,
        'aqi': 72,
      },
      'alerts': [],
    },
    {
      'id': 'WQ003',
      'name': 'Hand Pump Sensor',
      'type': 'Water Quality',
      'location': 'School Area',
      'status': 'offline',
      'battery': 12,
      'lastUpdate': '2 hours ago',
      'readings': {
        'ph': 7.0,
        'tds': 128,
        'turbidity': 1.8,
        'temperature': 23.8,
        'chlorine': 0.4,
        'bacteria': 'Safe',
      },
      'alerts': [
        {'type': 'error', 'message': 'Sensor offline - low battery'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _tabController = TabController(length: 3, vsync: this);
    _startAnimations();
    _simulateConnectionStatus();
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

  void _simulateConnectionStatus() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isConnected = true;
          connectionStatus = 'Connected to IoT Network';
        });
      }
    });
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
            _buildConnectionStatus(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSensorsOverview(),
                  _buildRealTimeData(),
                  _buildAlertsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _refreshSensors,
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.refresh, color: Colors.white),
        label: const Text('Refresh', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('IoT Sensor Monitoring'),
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _openSensorSettings,
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: _showHelpDialog,
        ),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: isConnected 
            ? AppTheme.successGreen.withValues(alpha: 0.1)
            : AppTheme.warningOrange.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.neutralGray.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          enhanced.AnimatedStatusIndicator(
            status: isConnected ? 'success' : 'warning',
            text: connectionStatus,
            icon: isConnected ? Icons.wifi : Icons.wifi_off,
          ),
          const Spacer(),
          if (!isConnected)
            enhanced.EnhancedButton(
              text: 'Connect',
              onPressed: _connectToNetwork,
              type: enhanced.ButtonType.primary,
              isLoading: isConnecting,
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryBlue,
        unselectedLabelColor: AppTheme.neutralGray,
        indicatorColor: AppTheme.primaryBlue,
        tabs: const [
          Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
          Tab(icon: Icon(Icons.show_chart), text: 'Real-time'),
          Tab(icon: Icon(Icons.warning), text: 'Alerts'),
        ],
      ),
    );
  }

  Widget _buildSensorsOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'Sensor Status',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...iotSensors.map((sensor) => _buildSensorCard(sensor)).toList(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final onlineSensors = iotSensors.where((s) => s['status'] == 'online').length;
    final warningSensors = iotSensors.where((s) => s['status'] == 'warning').length;
    final offlineSensors = iotSensors.where((s) => s['status'] == 'offline').length;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Online',
            onlineSensors.toString(),
            Icons.sensors,
            AppTheme.successGreen,
          ),
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: _buildSummaryCard(
            'Warning',
            warningSensors.toString(),
            Icons.warning,
            AppTheme.warningOrange,
          ),
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: _buildSummaryCard(
            'Offline',
            offlineSensors.toString(),
            Icons.sensors_off,
            AppTheme.errorRed,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return enhanced.EnhancedCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard(Map<String, dynamic> sensor) {
    final statusColor = _getSensorStatusColor(sensor['status']);
    final alerts = sensor['alerts'] as List<Map<String, dynamic>>;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: enhanced.EnhancedCard(
        isInteractive: true,
        onTap: () => _viewSensorDetails(sensor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getSensorIcon(sensor['type']),
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sensor['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'ID: ${sensor['id']} • ${sensor['location']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    enhanced.AnimatedStatusIndicator(
                      status: sensor['status'],
                      text: sensor['status'].toString().toUpperCase(),
                      icon: _getStatusIcon(sensor['status']),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.battery_full,
                          size: 16,
                          color: _getBatteryColor(sensor['battery']),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${sensor['battery']}%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            // Key readings preview
            if (sensor['type'] == 'Water Quality') ...[
              _buildReadingPreview(sensor['readings']),
            ] else if (sensor['type'] == 'Air Quality') ...[
              _buildAirQualityPreview(sensor['readings']),
            ],
            
            const SizedBox(height: AppTheme.spacingS),
            
            Row(
              children: [
                Icon(
                  Icons.update,
                  size: 14,
                  color: AppTheme.neutralGray,
                ),
                const SizedBox(width: 4),
                Text(
                  'Last update: ${sensor['lastUpdate']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
                const Spacer(),
                if (alerts.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.errorRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${alerts.length} alert${alerts.length > 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.errorRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingPreview(Map<String, dynamic> readings) {
    return Row(
      children: [
        Expanded(
          child: _buildMiniReading('pH', readings['ph'].toString()),
        ),
        Expanded(
          child: _buildMiniReading('TDS', '${readings['tds']} ppm'),
        ),
        Expanded(
          child: _buildMiniReading('Turbidity', '${readings['turbidity']} NTU'),
        ),
        Expanded(
          child: _buildMiniReading('Bacteria', readings['bacteria']),
        ),
      ],
    );
  }

  Widget _buildAirQualityPreview(Map<String, dynamic> readings) {
    return Row(
      children: [
        Expanded(
          child: _buildMiniReading('PM2.5', '${readings['pm2_5']} μg/m³'),
        ),
        Expanded(
          child: _buildMiniReading('AQI', readings['aqi'].toString()),
        ),
        Expanded(
          child: _buildMiniReading('CO₂', '${readings['co2']} ppm'),
        ),
        Expanded(
          child: _buildMiniReading('Humidity', '${readings['humidity']}%'),
        ),
      ],
    );
  }

  Widget _buildMiniReading(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.neutralGray,
          ),
        ),
      ],
    );
  }

  Widget _buildRealTimeData() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          _buildRealTimeChart(),
          const SizedBox(height: AppTheme.spacingL),
          _buildParametersList(),
        ],
      ),
    );
  }

  Widget _buildRealTimeChart() {
    return enhanced.EnhancedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real-time Trends',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 64, color: AppTheme.neutralGray),
                  SizedBox(height: 16),
                  Text('Real-time chart visualization\ncoming soon'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParametersList() {
    return enhanced.EnhancedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Readings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...iotSensors
              .where((s) => s['status'] == 'online')
              .map((sensor) => _buildParameterRow(sensor))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildParameterRow(Map<String, dynamic> sensor) {
    return ExpansionTile(
      title: Text(sensor['name']),
      leading: Icon(_getSensorIcon(sensor['type'])),
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: _buildDetailedReadings(sensor['readings'], sensor['type']),
        ),
      ],
    );
  }

  Widget _buildDetailedReadings(Map<String, dynamic> readings, String sensorType) {
    if (sensorType == 'Water Quality') {
      return Column(
        children: [
          _buildReadingRow('pH Level', readings['ph'].toString(), '6.5-8.5', _isPHNormal(readings['ph'])),
          _buildReadingRow('TDS', '${readings['tds']} ppm', '< 500 ppm', readings['tds'] < 500),
          _buildReadingRow('Turbidity', '${readings['turbidity']} NTU', '< 5 NTU', readings['turbidity'] < 5),
          _buildReadingRow('Temperature', '${readings['temperature']}°C', '15-25°C', true),
          _buildReadingRow('Chlorine', '${readings['chlorine']} mg/L', '0.2-1.0 mg/L', true),
          _buildReadingRow('Bacteria', readings['bacteria'], 'Safe', readings['bacteria'] == 'Safe'),
        ],
      );
    } else {
      return Column(
        children: [
          _buildReadingRow('PM2.5', '${readings['pm2_5']} μg/m³', '< 35 μg/m³', readings['pm2_5'] < 35),
          _buildReadingRow('PM10', '${readings['pm10']} μg/m³', '< 150 μg/m³', readings['pm10'] < 150),
          _buildReadingRow('CO₂', '${readings['co2']} ppm', '< 1000 ppm', readings['co2'] < 1000),
          _buildReadingRow('Humidity', '${readings['humidity']}%', '30-70%', true),
          _buildReadingRow('Temperature', '${readings['temperature']}°C', '20-35°C', true),
          _buildReadingRow('AQI', readings['aqi'].toString(), '< 100', readings['aqi'] < 100),
        ],
      );
    }
  }

  Widget _buildReadingRow(String parameter, String value, String normal, bool isNormal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              parameter,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isNormal ? AppTheme.successGreen : AppTheme.errorRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              normal,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.neutralGray,
              ),
            ),
          ),
          Icon(
            isNormal ? Icons.check_circle : Icons.warning,
            color: isNormal ? AppTheme.successGreen : AppTheme.errorRed,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertsTab() {
    final allAlerts = iotSensors
        .expand((sensor) => (sensor['alerts'] as List<Map<String, dynamic>>)
            .map((alert) => {...alert, 'sensorName': sensor['name'], 'sensorId': sensor['id']}))
        .toList();

    if (allAlerts.isEmpty) {
      return const EmptyState(
        title: 'No Active Alerts',
        subtitle: 'All sensors are operating normally',
        icon: Icons.check_circle,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: allAlerts.length,
      itemBuilder: (context, index) {
        final alert = allAlerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final alertColor = alert['type'] == 'error' ? AppTheme.errorRed : AppTheme.warningOrange;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: enhanced.EnhancedCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: alertColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                alert['type'] == 'error' ? Icons.error : Icons.warning,
                color: alertColor,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert['sensorName'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    alert['message'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Sensor ID: ${alert['sensorId']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _acknowledgeAlert(alert),
              icon: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSensorStatusColor(String status) {
    switch (status) {
      case 'online':
        return AppTheme.successGreen;
      case 'warning':
        return AppTheme.warningOrange;
      case 'offline':
        return AppTheme.errorRed;
      default:
        return AppTheme.neutralGray;
    }
  }

  IconData _getSensorIcon(String type) {
    switch (type) {
      case 'Water Quality':
        return Icons.water_drop;
      case 'Air Quality':
        return Icons.air;
      default:
        return Icons.sensors;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'online':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'offline':
        return Icons.error;
      default:
        return Icons.help;
    }
  }

  Color _getBatteryColor(int battery) {
    if (battery > 50) return AppTheme.successGreen;
    if (battery > 20) return AppTheme.warningOrange;
    return AppTheme.errorRed;
  }

  bool _isPHNormal(double ph) {
    return ph >= 6.5 && ph <= 8.5;
  }

  void _connectToNetwork() {
    setState(() {
      isConnecting = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          isConnecting = false;
          isConnected = true;
          connectionStatus = 'Connected to IoT Network';
        });
      }
    });
  }

  void _refreshSensors() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing sensor data...')),
    );
  }

  void _openSensorSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening sensor settings')),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('IoT Sensor Monitoring Help'),
        content: const Text(
          'This screen shows real-time data from IoT sensors monitoring water and air quality. '
          'Green status means normal operation, yellow indicates warnings, and red means alerts or offline status.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _viewSensorDetails(Map<String, dynamic> sensor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      sensor['name'],
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingL),
                _buildDetailedReadings(sensor['readings'], sensor['type']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _acknowledgeAlert(Map<String, dynamic> alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert acknowledged for ${alert['sensorName']}'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}