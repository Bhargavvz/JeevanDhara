import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_routes.dart';
import '../../widgets/common_widgets.dart';
import '../../services/notification_service.dart';
import 'case_reporting_screen.dart';
import 'my_reports_screen.dart';

class ASHADashboardScreen extends StatefulWidget {
  const ASHADashboardScreen({Key? key}) : super(key: key);

  @override
  State<ASHADashboardScreen> createState() => _ASHADashboardScreenState();
}

class _ASHADashboardScreenState extends State<ASHADashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _cardSlideAnimations;
  late List<Animation<double>> _cardFadeAnimations;
  
  String selectedLanguage = 'en';
  bool isOnline = true;
  int pendingReports = 3;
  int todayReports = 2;
  int totalReports = 25;
  int selectedBottomNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _cardSlideAnimations = List.generate(4, (index) {
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

    _cardFadeAnimations = List.generate(4, (index) {
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
        color: AppTheme.primaryGreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Bar
              _buildStatusBar(),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Welcome Section
              _buildWelcomeSection(),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Quick Stats
              _buildQuickStats(),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Action Cards
              _buildActionCards(),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Today's Summary
              _buildTodaySummary(),
              
              const SizedBox(height: AppTheme.spacingL),
              
              // Quick Tips
              _buildQuickTips(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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
              Icons.water_drop,
              color: AppTheme.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Text(AppConstants.appName),
        ],
      ),
      backgroundColor: AppTheme.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        // Sync Status
        IconButton(
          icon: Icon(isOnline ? Icons.cloud_done : Icons.cloud_off),
          onPressed: _showSyncStatus,
        ),
        // Language Selector
        LanguageSelector(
          selectedLanguage: selectedLanguage,
          onLanguageChanged: (language) {
            setState(() {
              selectedLanguage = language;
            });
          },
        ),
        // Profile
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () => AppRoutes.toProfileManagement(),
        ),
      ],
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: isOnline ? AppTheme.successGreen : AppTheme.warningOrange,
        borderRadius: AppTheme.cardBorderRadius,
      ),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            isOnline ? 'Online - Data synced' : 'Offline - Data will sync later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (!isOnline && pendingReports > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$pendingReports pending',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return SlideTransition(
      position: _cardSlideAnimations[0],
      child: FadeTransition(
        opacity: _cardFadeAnimations[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Priya!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Ready to help your community stay healthy?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.neutralGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return SlideTransition(
      position: _cardSlideAnimations[1],
      child: FadeTransition(
        opacity: _cardFadeAnimations[1],
        child: Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Today',
                todayReports.toString(),
                'Reports',
                Icons.today,
                AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _buildStatCard(
                'Pending',
                pendingReports.toString(),
                'To Sync',
                Icons.sync_problem,
                AppTheme.warningOrange,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _buildStatCard(
                'Total',
                totalReports.toString(),
                'Reports',
                Icons.assignment,
                AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, IconData icon, Color color) {
    return CustomCard(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppTheme.spacingS),
          AnimatedCounter(
            value: int.parse(value),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
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

  Widget _buildActionCards() {
    return SlideTransition(
      position: _cardSlideAnimations[2],
      child: FadeTransition(
        opacity: _cardFadeAnimations[2],
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
            
            // Main Actions
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Report New Case',
                    'Add a new disease case report',
                    Icons.add_circle,
                    AppTheme.primaryGreen,
                    () => _navigateToReporting(),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: _buildActionCard(
                    'View My Reports',
                    'Check status of your reports',
                    Icons.list_alt,
                    AppTheme.primaryBlue,
                    () => _navigateToReports(),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Secondary Actions
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    'Emergency Alert',
                    'Report urgent health emergency',
                    Icons.warning,
                    AppTheme.errorRed,
                    () => _showEmergencyDialog(),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: _buildActionCard(
                    'Training Materials',
                    'Access learning resources',
                    Icons.school,
                    AppTheme.secondaryGreen,
                    () => _showTrainingMaterials(),
                  ),
                ),
              ],
            ),
          ],
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
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.darkGray,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXS),
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

  Widget _buildTodaySummary() {
    return SlideTransition(
      position: _cardSlideAnimations[3],
      child: FadeTransition(
        opacity: _cardFadeAnimations[3],
        child: CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.today,
                    color: AppTheme.primaryGreen,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    'Today\'s Activity',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              
              // Activity Items
              _buildActivityItem(
                'Reported 2 diarrhea cases in Kohima village',
                '10:30 AM',
                true,
              ),
              _buildActivityItem(
                'Water source inspection at Community Well #3',
                '2:15 PM',
                true,
              ),
              _buildActivityItem(
                'Follow-up on yesterday\'s typhoid case',
                'Pending',
                false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.schedule,
            color: isCompleted ? AppTheme.successGreen : AppTheme.warningOrange,
            size: 16,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTips() {
    return CustomCard(
      color: AppTheme.lightGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Quick Tip',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Remember to check water sources for any unusual smell, color, or visible contamination when visiting communities.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  void _navigateToReporting() {
    AppRoutes.toCaseReporting();
    NotificationService.to.showInfo('Opening Case Reporting');
  }

  void _navigateToReports() {
    AppRoutes.toMyReports();
    NotificationService.to.showInfo('Opening My Reports');
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppTheme.errorRed),
            SizedBox(width: 8),
            Text('Emergency Alert'),
          ],
        ),
        content: const Text(
          'Use this only for urgent health emergencies requiring immediate attention.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle emergency alert
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Report Emergency'),
          ),
        ],
      ),
    );
  }

  void _showTrainingMaterials() {
    AppRoutes.toASHATrainingMaterials();
    NotificationService.to.showInfo('Opening Training Materials');
  }

  void _showSyncStatus() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  isOnline ? Icons.cloud_done : Icons.cloud_off,
                  color: isOnline ? AppTheme.successGreen : AppTheme.warningOrange,
                ),
                const SizedBox(width: 8),
                Text(isOnline ? 'Connected' : 'Offline'),
              ],
            ),
            if (!isOnline) ...[
              const SizedBox(height: 8),
              Text('$pendingReports reports waiting to sync'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          if (!isOnline)
            ElevatedButton(
              onPressed: () {
                // Try to sync
                Navigator.of(context).pop();
              },
              child: const Text('Retry Sync'),
            ),
        ],
      ),
    );
  }

  void _showProfile() {
    // Show profile sheet
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    // Refresh data logic
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedBottomNavIndex,
      onTap: (index) {
        setState(() {
          selectedBottomNavIndex = index;
        });
        _navigateToBottomNavTab(index);
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryGreen,
      unselectedItemColor: AppTheme.neutralGray,
      backgroundColor: Colors.white,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Report Case',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'My Reports',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Training',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  void _navigateToBottomNavTab(int index) {
    switch (index) {
      case 0:
        // Already on dashboard - do nothing
        break;
      case 1:
        _navigateToReporting();
        break;
      case 2:
        _navigateToReports();
        break;
      case 3:
        _showTrainingMaterials();
        break;
      case 4:
        AppRoutes.toProfileManagement();
        break;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}