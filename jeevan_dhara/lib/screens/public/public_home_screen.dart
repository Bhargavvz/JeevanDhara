import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../utils/app_routes.dart';
import '../../widgets/common_widgets.dart';
import '../../services/notification_service.dart';

class PublicHomeScreen extends StatefulWidget {
  const PublicHomeScreen({Key? key}) : super(key: key);

  @override
  State<PublicHomeScreen> createState() => _PublicHomeScreenState();
}

class _PublicHomeScreenState extends State<PublicHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  String selectedLanguage = 'en';
  int currentCarouselIndex = 0;
  int selectedBottomNavIndex = 0;
  PageController carouselController = PageController();
  
  final List<Map<String, dynamic>> carouselItems = [
    {
      'title': 'Clean Water, Healthy Life',
      'subtitle': 'Learn how to identify and prevent water-borne diseases',
      'icon': Icons.water_drop,
      'color': AppTheme.primaryBlue,
    },
    {
      'title': 'Hygiene Practices',
      'subtitle': 'Simple steps to protect yourself and your family',
      'icon': Icons.clean_hands,
      'color': AppTheme.primaryGreen,
    },
    {
      'title': 'Recognize Symptoms',
      'subtitle': 'Know when to seek medical help immediately',
      'icon': Icons.medical_services,
      'color': AppTheme.warningOrange,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    _startCarouselTimer();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    _animationController.forward();
  }

  void _startCarouselTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && carouselController.hasClients) {
        final nextIndex = (currentCarouselIndex + 1) % carouselItems.length;
        carouselController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startCarouselTimer();
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
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Hero Section with Carousel
                _buildHeroSection(),
                
                // Emergency Alert Banner
                _buildEmergencyBanner(),
                
                // Quick Access Cards
                _buildQuickAccessSection(),
                
                // Health Tips Section
                _buildHealthTipsSection(),
                
                // Community News
                _buildCommunityNewsSection(),
                
                // Contact Information
                _buildContactSection(),
              ],
            ),
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
              Icons.health_and_safety,
              color: AppTheme.secondaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Text(AppConstants.appName),
        ],
      ),
      backgroundColor: AppTheme.secondaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        LanguageSelector(
          selectedLanguage: selectedLanguage,
          onLanguageChanged: (language) {
            setState(() {
              selectedLanguage = language;
            });
          },
        ),
        // Profile button
        IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () => AppRoutes.toProfileManagement(),
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 280,
      child: PageView.builder(
        controller: carouselController,
        onPageChanged: (index) {
          setState(() {
            currentCarouselIndex = index;
          });
        },
        itemCount: carouselItems.length,
        itemBuilder: (context, index) {
          final item = carouselItems[index];
          return Container(
            margin: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  item['color'] as Color,
                  (item['color'] as Color).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (item['color'] as Color).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    size: 64,
                    color: Colors.white,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(
                    item['title'] as String,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    item['subtitle'] as String,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmergencyBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.errorRed.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning,
            color: AppTheme.errorRed,
            size: 24,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Health Emergency?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.errorRed,
                  ),
                ),
                Text(
                  'Call 108 for immediate medical assistance',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          CustomButton(
            text: 'Call 108',
            onPressed: () => _callEmergency(),
            type: ButtonType.primary,
            height: 36,
            icon: Icons.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learn & Stay Healthy',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  'Health Education',
                  'Learn about disease prevention',
                  Icons.school,
                  AppTheme.primaryGreen,
                  () => _navigateToEducation(),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: _buildQuickAccessCard(
                  'Health News',
                  'Latest updates & campaigns',
                  Icons.campaign,
                  AppTheme.primaryBlue,
                  () => _navigateToNews(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  'Symptom Checker',
                  'Identify potential issues',
                  Icons.medical_services,
                  AppTheme.warningOrange,
                  () => _openSymptomChecker(),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: _buildQuickAccessCard(
                  'Find Nearby',
                  'Hospitals & clinics',
                  Icons.location_on,
                  AppTheme.secondaryGreen,
                  () => _findNearbyFacilities(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  'Water Quality',
                  'Report water issues',
                  Icons.water_drop,
                  AppTheme.infoBlue,
                  () => _navigateToWaterQuality(),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: _buildQuickAccessCard(
                  'Health Assessment',
                  'Self-assessment tools',
                  Icons.assignment,
                  AppTheme.primaryGreen,
                  () => _navigateToHealthAssessment(),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  'Community Forums',
                  'Connect with others',
                  Icons.forum,
                  AppTheme.secondaryGreen,
                  () => _navigateToCommunityForums(),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: _buildQuickAccessCard(
                  'IoT Monitoring',
                  'Real-time sensor data',
                  Icons.sensors,
                  AppTheme.infoBlue,
                  () => _navigateToIoTMonitoring(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
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

  Widget _buildHealthTipsSection() {
    final tips = [
      {
        'title': 'Drink Safe Water',
        'description': 'Always boil water for 1 minute before drinking',
        'icon': Icons.water_drop,
      },
      {
        'title': 'Wash Your Hands',
        'description': 'Clean hands with soap for at least 20 seconds',
        'icon': Icons.clean_hands,
      },
      {
        'title': 'Cook Food Properly',
        'description': 'Ensure food is thoroughly cooked and served hot',
        'icon': Icons.restaurant,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Daily Health Tips',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'View All',
                onPressed: () => _navigateToEducation(),
                type: ButtonType.text,
                height: 32,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          ...tips.map((tip) => _buildHealthTipCard(tip)).toList(),
        ],
      ),
    );
  }

  Widget _buildHealthTipCard(Map<String, dynamic> tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: CustomCard(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                tip['icon'] as IconData,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip['title'] as String,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    tip['description'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityNewsSection() {
    final news = [
      {
        'title': 'Vaccination Drive in Rural Areas',
        'description': 'Free vaccination campaign starting next week',
        'time': '2 hours ago',
        'type': 'campaign',
      },
      {
        'title': 'Water Quality Alert Resolved',
        'description': 'Dimapur water supply restored to safe levels',
        'time': '5 hours ago',
        'type': 'alert',
      },
      {
        'title': 'New Health Center Opening',
        'description': 'Primary health center inaugurated in Kohima',
        'time': '1 day ago',
        'type': 'news',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Community Updates',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'View All',
                onPressed: () => _navigateToNews(),
                type: ButtonType.text,
                height: 32,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          ...news.map((item) => _buildNewsCard(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> newsItem) {
    IconData getIcon(String type) {
      switch (type) {
        case 'campaign':
          return Icons.campaign;
        case 'alert':
          return Icons.warning;
        case 'news':
          return Icons.article;
        default:
          return Icons.info;
      }
    }

    Color getColor(String type) {
      switch (type) {
        case 'campaign':
          return AppTheme.primaryBlue;
        case 'alert':
          return AppTheme.warningOrange;
        case 'news':
          return AppTheme.primaryGreen;
        default:
          return AppTheme.neutralGray;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: CustomCard(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: getColor(newsItem['type']).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                getIcon(newsItem['type']),
                color: getColor(newsItem['type']),
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem['title'] as String,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    newsItem['description'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralGray,
                    ),
                  ),
                  Text(
                    newsItem['time'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralGray,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: CustomCard(
        color: AppTheme.lightGray,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need Help?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            Row(
              children: [
                Expanded(
                  child: _buildContactItem(
                    'Emergency',
                    '108',
                    Icons.local_hospital,
                    AppTheme.errorRed,
                    () => _callEmergency(),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: _buildContactItem(
                    'Health Helpline',
                    '104',
                    Icons.phone,
                    AppTheme.primaryGreen,
                    () => _callHealthHelpline(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    String label,
    String number,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              number,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEducation() {
    AppRoutes.toEducationalModules();
    NotificationService.to.showInfo('Opening Educational Modules');
  }

  void _navigateToNews() {
    AppRoutes.toAwarenessCampaigns();
    NotificationService.to.showInfo('Opening Awareness Campaigns');
  }

  void _openSymptomChecker() {
    AppRoutes.toSymptomChecker();
    NotificationService.to.showInfo('Opening Symptom Checker');
  }

  void _findNearbyFacilities() {
    AppRoutes.toNearbyFacilities();
    NotificationService.to.showInfo('Finding Nearby Facilities');
  }

  void _callEmergency() {
    AppRoutes.toEmergencyContacts();
    NotificationService.to.showEmergencyAlert(
      'Emergency Contact', 
      'Redirecting to emergency services...'
    );
  }

  void _callHealthHelpline() {
    AppRoutes.toEmergencyContacts();
    NotificationService.to.showInfo('Connecting to health helpline...');
  }

  void _navigateToWaterQuality() {
    AppRoutes.toWaterQualityReporting();
    NotificationService.to.showInfo('Opening Water Quality Reporting');
  }

  void _navigateToHealthAssessment() {
    AppRoutes.toHealthSelfAssessment();
    NotificationService.to.showInfo('Opening Health Self-Assessment');
  }

  void _navigateToCommunityForums() {
    AppRoutes.toCommunityForums();
    NotificationService.to.showInfo('Opening Community Forums');
  }

  void _navigateToIoTMonitoring() {
    AppRoutes.toIoTSensorMonitoring();
    NotificationService.to.showInfo('Opening IoT Sensor Monitoring');
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
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.medical_services),
          label: 'Health Check',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          label: 'Nearby',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.forum),
          label: 'Community',
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
        // Already on home - do nothing or scroll to top
        break;
      case 1:
        AppRoutes.toSymptomChecker();
        break;
      case 2:
        AppRoutes.toNearbyFacilities();
        break;
      case 3:
        AppRoutes.toCommunityForums();
        break;
      case 4:
        AppRoutes.toProfileManagement();
        break;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    carouselController.dispose();
    super.dispose();
  }
}