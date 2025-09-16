import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_routes.dart';
import '../../widgets/common_widgets.dart';
import '../../services/notification_service.dart';

class OfficialDashboardScreen extends StatefulWidget {
  const OfficialDashboardScreen({Key? key}) : super(key: key);

  @override
  State<OfficialDashboardScreen> createState() => _OfficialDashboardScreenState();
}

class _OfficialDashboardScreenState extends State<OfficialDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _cardSlideAnimations;
  late List<Animation<double>> _cardFadeAnimations;
  
  int selectedTabIndex = 0;
  String selectedDistrict = 'All Districts';
  
  // Mock data
  final Map<String, dynamic> dashboardData = {
    'totalCases': 156,
    'activeCases': 89,
    'recoveredCases': 67,
    'newCasesToday': 12,
    'highRiskAreas': 8,
    'ashaReports': 45,
    'pendingAlerts': 6,
    'criticalAlerts': 2,
  };

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardSlideAnimations = List.generate(6, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.4 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    _cardFadeAnimations = List.generate(6, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1,
          0.4 + (index * 0.1),
          curve: Curves.easeOut,
        ),
      ));
    });
  }

  void _startAnimations() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppTheme.primaryBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Quick Stats Overview
              _buildQuickStats(),
              
              // Map and Alerts Section
              _buildMapSection(),
              
              // Quick Actions
              _buildQuickActions(),
              
              // Recent Activity
              _buildRecentActivity(),
              
              // Key Metrics
              _buildKeyMetrics(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.analytics,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          const Text('Health Dashboard'),
        ],
      ),
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        // District Selector
        PopupMenuButton<String>(
          icon: const Icon(Icons.location_on),
          onSelected: (district) {
            setState(() {
              selectedDistrict = district;
            });
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'All Districts',
              child: Text('All Districts'),
            ),
            ...AppConstants.districts.take(5).map((district) {
              return PopupMenuItem(
                value: district,
                child: Text(district),
              );
            }).toList(),
          ],
        ),
        // Notifications
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: _showNotifications,
            ),
            if (dashboardData['pendingAlerts'] > 0)
              Positioned(
                right: 8,
                top: 8,
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
                    '${dashboardData['pendingAlerts']}',
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
        // Profile
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () => AppRoutes.toProfileManagement(),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return SlideTransition(
      position: _cardSlideAnimations[0],
      child: FadeTransition(
        opacity: _cardFadeAnimations[0],
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Health Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    selectedDistrict,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Main Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Cases',
                      dashboardData['totalCases'].toString(),
                      Icons.medical_services,
                      AppTheme.primaryBlue,
                      '+${dashboardData['newCasesToday']} today',
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: _buildStatCard(
                      'Active Cases',
                      dashboardData['activeCases'].toString(),
                      Icons.local_hospital,
                      AppTheme.warningOrange,
                      'Monitoring',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingS),
              
              // Secondary Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Recovered',
                      dashboardData['recoveredCases'].toString(),
                      Icons.healing,
                      AppTheme.successGreen,
                      '${((dashboardData['recoveredCases'] / dashboardData['totalCases']) * 100).toInt()}% rate',
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: _buildStatCard(
                      'High Risk Areas',
                      dashboardData['highRiskAreas'].toString(),
                      Icons.warning,
                      AppTheme.errorRed,
                      'Need attention',
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return CustomCard(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              AnimatedCounter(
                value: int.parse(value),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.darkGray,
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return SlideTransition(
      position: _cardSlideAnimations[1],
      child: FadeTransition(
        opacity: _cardFadeAnimations[1],
        child: Container(
          margin: const EdgeInsets.all(AppTheme.spacingM),
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.map,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      'Disease Hotspot Map',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                      text: 'Full View',
                      onPressed: () => _openFullMap(),
                      type: ButtonType.text,
                      height: 32,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                // Map Placeholder with Hotspots
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.neutralGray.withOpacity(0.2)),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map,
                              size: 48,
                              color: AppTheme.neutralGray,
                            ),
                            SizedBox(height: AppTheme.spacingS),
                            Text('Northeast India Health Map'),
                          ],
                        ),
                      ),
                      // Mock hotspot indicators
                      Positioned(
                        top: 50,
                        left: 80,
                        child: _buildHotspotIndicator(AppTheme.errorRed, 'High'),
                      ),
                      Positioned(
                        top: 120,
                        right: 60,
                        child: _buildHotspotIndicator(AppTheme.warningOrange, 'Medium'),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 120,
                        child: _buildHotspotIndicator(AppTheme.primaryGreen, 'Low'),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppTheme.spacingM),
                
                // Legend
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLegendItem('High Risk', AppTheme.errorRed),
                    _buildLegendItem('Medium Risk', AppTheme.warningOrange),
                    _buildLegendItem('Low Risk', AppTheme.primaryGreen),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHotspotIndicator(Color color, String level) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return SlideTransition(
      position: _cardSlideAnimations[2],
      child: FadeTransition(
        opacity: _cardFadeAnimations[2],
        child: Container(
          margin: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'View Reports',
                      'ASHA worker submissions',
                      Icons.assignment,
                      AppTheme.primaryGreen,
                      () => _navigateToReports(),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: _buildActionCard(
                      'Manage Alerts',
                      'Review and respond',
                      Icons.notifications_active,
                      AppTheme.warningOrange,
                      () => _navigateToAlerts(),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingS),
              
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'Analytics',
                      'Data visualization',
                      Icons.analytics,
                      AppTheme.primaryBlue,
                      () => _navigateToAnalytics(),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: _buildActionCard(
                      'Predictions',
                      'Outbreak forecasting',
                      Icons.trending_up,
                      AppTheme.errorRed,
                      () => _navigateToPredictions(),
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

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutralGray,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return SlideTransition(
      position: _cardSlideAnimations[3],
      child: FadeTransition(
        opacity: _cardFadeAnimations[3],
        child: Container(
          margin: const EdgeInsets.all(AppTheme.spacingM),
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.history,
                      color: AppTheme.primaryGreen,
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      'Recent Activity',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    CustomButton(
                      text: 'View All',
                      onPressed: () {},
                      type: ButtonType.text,
                      height: 32,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                _buildActivityItem(
                  'New outbreak alert in Kohima district',
                  '2 hours ago',
                  Icons.warning,
                  AppTheme.errorRed,
                ),
                _buildActivityItem(
                  '15 new reports submitted by ASHA workers',
                  '4 hours ago',
                  Icons.assignment,
                  AppTheme.primaryGreen,
                ),
                _buildActivityItem(
                  'Water quality alert resolved in Dimapur',
                  '6 hours ago',
                  Icons.check_circle,
                  AppTheme.successGreen,
                ),
                _buildActivityItem(
                  'Weekly health summary generated',
                  '1 day ago',
                  Icons.summarize,
                  AppTheme.primaryBlue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetrics() {
    return SlideTransition(
      position: _cardSlideAnimations[4],
      child: FadeTransition(
        opacity: _cardFadeAnimations[4],
        child: Container(
          margin: const EdgeInsets.all(AppTheme.spacingM),
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Performance Indicators',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                _buildMetricRow('ASHA Reports Processed', '${dashboardData['ashaReports']}', '92%'),
                _buildMetricRow('Response Time (Avg)', '2.3 hours', '↓ 15%'),
                _buildMetricRow('Alert Resolution Rate', '89%', '↑ 8%'),
                _buildMetricRow('Data Accuracy', '96%', '↑ 3%'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, String change) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            change,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: change.startsWith('↑') ? AppTheme.successGreen : AppTheme.primaryBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: selectedTabIndex,
      onTap: (index) {
        setState(() {
          selectedTabIndex = index;
        });
        _navigateToTab(index);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryBlue,
      unselectedItemColor: AppTheme.neutralGray,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Alerts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'Predictions',
        ),
      ],
    );
  }

  void _navigateToTab(int index) {
    switch (index) {
      case 1:
        _navigateToAnalytics();
        break;
      case 2:
        _navigateToAlerts();
        break;
      case 3:
        _navigateToPredictions();
        break;
    }
  }

  void _openFullMap() {
    // Navigate to full map view
    NotificationService.to.showInfo('Opening Full Disease Hotspot Map');
  }

  void _navigateToReports() {
    NotificationService.to.showInfo('Opening ASHA Worker Reports');
    // Could navigate to a dedicated reports management screen
  }

  void _navigateToAlerts() {
    AppRoutes.toAlertsNotifications();
    NotificationService.to.showInfo('Opening Alerts Management');
  }

  void _navigateToAnalytics() {
    AppRoutes.toDataVisualization();
    NotificationService.to.showInfo('Opening Analytics Dashboard');
  }

  void _navigateToPredictions() {
    AppRoutes.toOutbreakPrediction();
    NotificationService.to.showInfo('Opening Outbreak Predictions');
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            const Text('No new notifications'),
          ],
        ),
      ),
    );
  }

  void _showProfile() {
    // Show profile modal
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    // Refresh dashboard data
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}