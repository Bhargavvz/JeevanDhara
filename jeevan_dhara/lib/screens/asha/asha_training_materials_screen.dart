import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';

import '../../widgets/common_widgets.dart';
import '../../services/notification_service.dart';

class ASHATrainingMaterialsScreen extends StatefulWidget {
  const ASHATrainingMaterialsScreen({Key? key}) : super(key: key);

  @override
  State<ASHATrainingMaterialsScreen> createState() => _ASHATrainingMaterialsScreenState();
}

class _ASHATrainingMaterialsScreenState extends State<ASHATrainingMaterialsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  int selectedCategoryIndex = 0;
  String selectedLanguage = 'en';
  
  final List<String> categories = [
    'Disease Prevention',
    'Water Quality',
    'Community Health',
    'Reporting Skills',
    'Emergency Response'
  ];
  
  final Map<String, List<Map<String, dynamic>>> trainingMaterials = {
    'Disease Prevention': [
      {
        'title': 'Water-Borne Disease Identification',
        'description': 'Learn to identify symptoms of common water-borne diseases',
        'type': 'video',
        'duration': '15 min',
        'difficulty': 'Beginner',
        'completed': true,
        'icon': Icons.play_circle,
        'color': AppTheme.primaryGreen,
      },
      {
        'title': 'Prevention Strategies Guide',
        'description': 'Comprehensive guide on disease prevention methods',
        'type': 'document',
        'duration': '20 min',
        'difficulty': 'Intermediate',
        'completed': false,
        'icon': Icons.description,
        'color': AppTheme.primaryBlue,
      },
      {
        'title': 'Community Education Techniques',
        'description': 'Effective methods to educate community members',
        'type': 'interactive',
        'duration': '30 min',
        'difficulty': 'Advanced',
        'completed': false,
        'icon': Icons.psychology,
        'color': AppTheme.warningOrange,
      },
    ],
    'Water Quality': [
      {
        'title': 'Water Testing Basics',
        'description': 'How to perform basic water quality tests',
        'type': 'video',
        'duration': '12 min',
        'difficulty': 'Beginner',
        'completed': true,
        'icon': Icons.play_circle,
        'color': AppTheme.infoBlue,
      },
      {
        'title': 'Contamination Source Identification',
        'description': 'Identifying potential sources of water contamination',
        'type': 'document',
        'duration': '18 min',
        'difficulty': 'Intermediate',
        'completed': false,
        'icon': Icons.description,
        'color': AppTheme.errorRed,
      },
    ],
    'Community Health': [
      {
        'title': 'Health Assessment Techniques',
        'description': 'Conducting community health assessments',
        'type': 'interactive',
        'duration': '25 min',
        'difficulty': 'Intermediate',
        'completed': false,
        'icon': Icons.psychology,
        'color': AppTheme.primaryGreen,
      },
      {
        'title': 'Vaccination Drive Management',
        'description': 'Organizing and managing vaccination campaigns',
        'type': 'video',
        'duration': '22 min',
        'difficulty': 'Advanced',
        'completed': false,
        'icon': Icons.play_circle,
        'color': AppTheme.secondaryGreen,
      },
    ],
    'Reporting Skills': [
      {
        'title': 'Digital Reporting Basics',
        'description': 'Using mobile apps for health reporting',
        'type': 'interactive',
        'duration': '15 min',
        'difficulty': 'Beginner',
        'completed': true,
        'icon': Icons.psychology,
        'color': AppTheme.primaryBlue,
      },
      {
        'title': 'Data Collection Standards',
        'description': 'Proper methods for collecting health data',
        'type': 'document',
        'duration': '20 min',
        'difficulty': 'Intermediate',
        'completed': false,
        'icon': Icons.description,
        'color': AppTheme.infoBlue,
      },
    ],
    'Emergency Response': [
      {
        'title': 'Outbreak Response Protocol',
        'description': 'Steps to take during disease outbreaks',
        'type': 'document',
        'duration': '25 min',
        'difficulty': 'Advanced',
        'completed': false,
        'icon': Icons.description,
        'color': AppTheme.errorRed,
      },
      {
        'title': 'Emergency Communication',
        'description': 'How to communicate during health emergencies',
        'type': 'video',
        'duration': '18 min',
        'difficulty': 'Intermediate',
        'completed': false,
        'icon': Icons.play_circle,
        'color': AppTheme.warningOrange,
      },
    ],
  };

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Progress Overview
            _buildProgressOverview(),
            
            // Categories Tabs
            _buildCategoriesTabs(),
            
            // Training Materials List
            Expanded(
              child: _buildTrainingMaterialsList(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Training Materials'),
      backgroundColor: AppTheme.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        // Language Selector
        LanguageSelector(
          selectedLanguage: selectedLanguage,
          onLanguageChanged: (language) {
            setState(() {
              selectedLanguage = language;
            });
          },
        ),
        // Download Offline
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: _downloadOfflineContent,
        ),
      ],
    );
  }

  Widget _buildProgressOverview() {
    final totalMaterials = trainingMaterials.values
        .expand((materials) => materials)
        .length;
    final completedMaterials = trainingMaterials.values
        .expand((materials) => materials)
        .where((material) => material['completed'] == true)
        .length;
    final progressPercentage = (completedMaterials / totalMaterials * 100).round();

    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: CustomCard(
        color: AppTheme.lightGreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.school, color: AppTheme.primaryGreen),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  'Training Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const Spacer(),
                Text(
                  '$progressPercentage%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            LinearProgressIndicator(
              value: progressPercentage / 100,
              backgroundColor: AppTheme.lightGray,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              '$completedMaterials of $totalMaterials materials completed',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedCategoryIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: AppTheme.spacingS),
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM,
                vertical: AppTheme.spacingS,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryGreen : AppTheme.lightGray,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.neutralGray.withOpacity(0.3),
                ),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected ? Colors.white : AppTheme.darkGray,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrainingMaterialsList() {
    final selectedCategory = categories[selectedCategoryIndex];
    final materials = trainingMaterials[selectedCategory] ?? [];

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final material = materials[index];
        return _buildTrainingMaterialCard(material);
      },
    );
  }

  Widget _buildTrainingMaterialCard(Map<String, dynamic> material) {
    final isCompleted = material['completed'] as bool;
    final materialColor = material['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        onTap: () => _openTrainingMaterial(material),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: materialColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    material['icon'] as IconData,
                    color: materialColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        material['title'] as String,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        material['description'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.neutralGray,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  const Icon(
                    Icons.check_circle,
                    color: AppTheme.successGreen,
                    size: 24,
                  ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Details Row
            Row(
              children: [
                _buildDetailChip(
                  material['type'] as String,
                  Icons.category,
                  AppTheme.infoBlue,
                ),
                const SizedBox(width: AppTheme.spacingS),
                _buildDetailChip(
                  material['duration'] as String,
                  Icons.schedule,
                  AppTheme.warningOrange,
                ),
                const SizedBox(width: AppTheme.spacingS),
                _buildDetailChip(
                  material['difficulty'] as String,
                  Icons.trending_up,
                  materialColor,
                ),
                const Spacer(),
                CustomButton(
                  text: isCompleted ? 'Review' : 'Start',
                  onPressed: () => _openTrainingMaterial(material),
                  type: ButtonType.primary,
                  height: 32,
                  icon: isCompleted ? Icons.refresh : Icons.play_arrow,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(String text, IconData icon, Color color) {
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

  void _openTrainingMaterial(Map<String, dynamic> material) {
    final materialType = material['type'] as String;
    final title = material['title'] as String;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildTrainingContentSheet(material),
    );
    
    NotificationService.to.showInfo('Opening: $title');
  }

  Widget _buildTrainingContentSheet(Map<String, dynamic> material) {
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
                        material['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${material['type']} • ${material['duration']} • ${material['difficulty']}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Content Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                children: [
                  // Mock Content
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            material['icon'] as IconData,
                            size: 48,
                            color: material['color'] as Color,
                          ),
                          const SizedBox(height: AppTheme.spacingM),
                          Text(
                            '${material['type']} Content',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Text(
                            material['description'] as String,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.neutralGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Mark as Complete',
                          onPressed: () => _markAsComplete(material),
                          type: ButtonType.primary,
                          height: 48,
                          icon: Icons.check,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: CustomButton(
                          text: 'Download',
                          onPressed: () => _downloadMaterial(material),
                          type: ButtonType.secondary,
                          height: 48,
                          icon: Icons.download,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _markAsComplete(Map<String, dynamic> material) {
    setState(() {
      material['completed'] = true;
    });
    Navigator.pop(context);
    NotificationService.to.showSuccess('Training material completed!');
  }

  void _downloadMaterial(Map<String, dynamic> material) {
    Navigator.pop(context);
    NotificationService.to.showInfo('Downloading ${material['title']} for offline access');
  }

  void _downloadOfflineContent() {
    NotificationService.to.showInfo('Downloading all training materials for offline access...');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}