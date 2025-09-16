import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_theme.dart';
import '../utils/app_constants.dart';
import '../utils/app_routes.dart';
import '../widgets/common_widgets.dart';
import '../services/notification_service.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;
  
  String selectedLanguage = 'en';

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

    _slideAnimations = List.generate(3, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.2 + (index * 0.1),
          0.8 + (index * 0.1),
          curve: Curves.easeOutBack,
        ),
      ));
    });

    _fadeAnimations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.2 + (index * 0.1),
          0.8 + (index * 0.1),
          curve: Curves.easeOut,
        ),
      ));
    });
  }

  void _startAnimations() {
    _animationController.forward();
  }

  void _navigateToRole(UserRole role) {
    String routeName;
    
    switch (role) {
      case UserRole.asha:
        routeName = AppRoutes.ashaLogin;
        NotificationService.to.showInfo('Opening ASHA Worker Portal');
        break;
      case UserRole.healthOfficial:
        routeName = AppRoutes.officialLogin;
        NotificationService.to.showInfo('Opening Health Officials Portal');
        break;
      case UserRole.public:
        routeName = AppRoutes.publicHome;
        NotificationService.to.showInfo('Opening Public Health Portal');
        break;
    }

    Get.toNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppConstants.appName),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.darkGray,
        actions: [
          LanguageSelector(
            selectedLanguage: selectedLanguage,
            onLanguageChanged: (language) {
              setState(() {
                selectedLanguage = language;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppTheme.spacingL),
              
              // Header Section
              Column(
                children: [
                  // App Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: const Icon(
                      Icons.water_drop,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Welcome Text
                  Text(
                    'Welcome to ${AppConstants.appName}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingS),
                  
                  // Subtitle
                  Text(
                    'Choose your role to continue',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.neutralGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingXXL),
              
              // Role Cards
              Expanded(
                child: Column(
                  children: [
                    // ASHA Worker Card
                    _buildRoleCard(
                      index: 0,
                      title: 'ASHA Worker/Volunteer',
                      subtitle: 'Report disease cases, conduct health surveys, and educate community members',
                      features: ['Report Cases', 'Health Surveys', 'Training Materials', 'Emergency Alerts'],
                      icon: Icons.medical_services,
                      color: AppTheme.primaryGreen,
                      onTap: () => _navigateToRole(UserRole.asha),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Health Official Card
                    _buildRoleCard(
                      index: 1,
                      title: 'Health Official',
                      subtitle: 'Monitor disease patterns, manage alerts, and predict outbreaks',
                      features: ['Analytics Dashboard', 'Alert Management', 'Outbreak Prediction', 'Data Reports'],
                      icon: Icons.analytics,
                      color: AppTheme.primaryBlue,
                      onTap: () => _navigateToRole(UserRole.healthOfficial),
                    ),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Public User Card
                    _buildRoleCard(
                      index: 2,
                      title: 'General Public',
                      subtitle: 'Access health information, check symptoms, and find nearby facilities',
                      features: ['Symptom Checker', 'Nearby Facilities', 'Health Education', 'Water Quality'],
                      icon: Icons.people,
                      color: AppTheme.secondaryGreen,
                      onTap: () => _navigateToRole(UserRole.public),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required int index,
    required String title,
    required String subtitle,
    required List<String> features,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SlideTransition(
      position: _slideAnimations[index],
      child: FadeTransition(
        opacity: _fadeAnimations[index],
        child: CustomCard(
          onTap: onTap,
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icon Container
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 30,
                    ),
                  ),
                  
                  const SizedBox(width: AppTheme.spacingM),
                  
                  // Text Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGray,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.neutralGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    color: color,
                    size: 20,
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Features List
              Wrap(
                spacing: AppTheme.spacingS,
                runSpacing: AppTheme.spacingXS,
                children: features.map((feature) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingS,
                      vertical: AppTheme.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}