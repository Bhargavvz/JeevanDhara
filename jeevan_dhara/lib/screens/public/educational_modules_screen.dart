import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_widgets.dart';

class EducationalModulesScreen extends StatefulWidget {
  const EducationalModulesScreen({Key? key}) : super(key: key);

  @override
  State<EducationalModulesScreen> createState() => _EducationalModulesScreenState();
}

class _EducationalModulesScreenState extends State<EducationalModulesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String selectedLanguage = 'en';
  String selectedCategory = 'All';
  
  final List<String> categories = [
    'All',
    'Prevention',
    'Symptoms',
    'Hygiene',
    'Water Safety',
    'First Aid',
  ];
  
  final List<Map<String, dynamic>> modules = [
    {
      'id': '1',
      'title': 'Water Safety Basics',
      'description': 'Learn how to identify and treat contaminated water',
      'category': 'Water Safety',
      'duration': '5 min',
      'icon': Icons.water_drop,
      'color': AppTheme.primaryBlue,
      'difficulty': 'Beginner',
      'hasAudio': true,
      'hasVideo': false,
      'completed': false,
    },
    {
      'id': '2',
      'title': 'Hand Hygiene Practices',
      'description': 'Proper handwashing techniques to prevent disease',
      'category': 'Hygiene',
      'duration': '3 min',
      'icon': Icons.clean_hands,
      'color': AppTheme.primaryGreen,
      'difficulty': 'Beginner',
      'hasAudio': true,
      'hasVideo': true,
      'completed': true,
    },
    {
      'id': '3',
      'title': 'Recognizing Diarrhea Symptoms',
      'description': 'When to seek medical help for water-borne diseases',
      'category': 'Symptoms',
      'duration': '7 min',
      'icon': Icons.medical_services,
      'color': AppTheme.warningOrange,
      'difficulty': 'Intermediate',
      'hasAudio': true,
      'hasVideo': false,
      'completed': false,
    },
    {
      'id': '4',
      'title': 'Food Safety Guidelines',
      'description': 'Safe cooking and storage practices',
      'category': 'Prevention',
      'duration': '6 min',
      'icon': Icons.restaurant,
      'color': AppTheme.secondaryGreen,
      'difficulty': 'Beginner',
      'hasAudio': true,
      'hasVideo': true,
      'completed': false,
    },
    {
      'id': '5',
      'title': 'Emergency First Aid',
      'description': 'Basic first aid for dehydration and fever',
      'category': 'First Aid',
      'duration': '10 min',
      'icon': Icons.local_hospital,
      'color': AppTheme.errorRed,
      'difficulty': 'Advanced',
      'hasAudio': true,
      'hasVideo': true,
      'completed': false,
    },
    {
      'id': '6',
      'title': 'Community Health Awareness',
      'description': 'How to protect your family and neighbors',
      'category': 'Prevention',
      'duration': '8 min',
      'icon': Icons.people,
      'color': AppTheme.infoBlue,
      'difficulty': 'Intermediate',
      'hasAudio': true,
      'hasVideo': false,
      'completed': false,
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

  List<Map<String, dynamic>> get filteredModules {
    if (selectedCategory == 'All') return modules;
    return modules.where((module) => module['category'] == selectedCategory).toList();
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
            
            // Category Filter
            _buildCategoryFilter(),
            
            // Modules List
            Expanded(
              child: _buildModulesList(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Learn & Stay Healthy'),
      backgroundColor: AppTheme.primaryGreen,
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
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _showSearchDialog,
        ),
      ],
    );
  }

  Widget _buildProgressOverview() {
    final completedModules = modules.where((m) => m['completed'] == true).length;
    final progressPercentage = (completedModules / modules.length * 100).round();
    
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: CustomCard(
        color: AppTheme.lightGreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.school,
                  color: AppTheme.primaryGreen,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  'Your Learning Progress',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$completedModules of ${modules.length} modules completed',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      LinearProgressIndicator(
                        value: completedModules / modules.length,
                        backgroundColor: Colors.white,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryGreen,
                  child: Text(
                    '$progressPercentage%',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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

  Widget _buildCategoryFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          
          return Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingS),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                });
              },
              selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryGreen,
            ),
          );
        },
      ),
    );
  }

  Widget _buildModulesList() {
    final filtered = filteredModules;
    
    if (filtered.isEmpty) {
      return EmptyState(
        title: 'No Modules Found',
        subtitle: 'Try selecting a different category',
        icon: Icons.school,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final module = filtered[index];
        return _buildModuleCard(module);
      },
    );
  }

  Widget _buildModuleCard(Map<String, dynamic> module) {
    final isCompleted = module['completed'] as bool;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        onTap: () => _openModule(module),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (module['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    module['icon'] as IconData,
                    color: module['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module['title'] as String,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        module['description'] as String,
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
                  ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Module Details
            Row(
              children: [
                _buildDetailChip(
                  module['duration'] as String,
                  Icons.access_time,
                  AppTheme.primaryBlue,
                ),
                const SizedBox(width: AppTheme.spacingS),
                _buildDetailChip(
                  module['difficulty'] as String,
                  Icons.trending_up,
                  _getDifficultyColor(module['difficulty'] as String),
                ),
                const SizedBox(width: AppTheme.spacingS),
                _buildDetailChip(
                  module['category'] as String,
                  Icons.category,
                  AppTheme.neutralGray,
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Media Types and Action
            Row(
              children: [
                if (module['hasAudio'] as bool)
                  const Icon(Icons.volume_up, size: 16, color: AppTheme.primaryGreen),
                if (module['hasVideo'] as bool) ...[
                  if (module['hasAudio'] as bool) const SizedBox(width: 4),
                  const Icon(Icons.play_circle, size: 16, color: AppTheme.primaryBlue),
                ],
                const Spacer(),
                CustomButton(
                  text: isCompleted ? 'Review' : 'Start Learning',
                  onPressed: () => _openModule(module),
                  type: isCompleted ? ButtonType.secondary : ButtonType.primary,
                  height: 36,
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppTheme.successGreen;
      case 'intermediate':
        return AppTheme.warningOrange;
      case 'advanced':
        return AppTheme.errorRed;
      default:
        return AppTheme.neutralGray;
    }
  }

  void _openModule(Map<String, dynamic> module) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModuleDetailsSheet(module),
    );
  }

  Widget _buildModuleDetailsSheet(Map<String, dynamic> module) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (module['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    module['icon'] as IconData,
                    color: module['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        module['category'] as String,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
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
                  Text(
                    'About this module',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    module['description'] as String,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Module Features
                  Text(
                    'What you will learn',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  
                  _buildLearningPoint('Key concepts and best practices'),
                  _buildLearningPoint('Step-by-step instructions'),
                  _buildLearningPoint('Real-world examples'),
                  if (module['hasAudio'] as bool)
                    _buildLearningPoint('Audio narration in local language'),
                  if (module['hasVideo'] as bool)
                    _buildLearningPoint('Video demonstrations'),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Media Options
                  Text(
                    'Learning options',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  if (module['hasAudio'] as bool)
                    _buildMediaOption(
                      'Listen to Audio',
                      'Learn while you work or travel',
                      Icons.headphones,
                      AppTheme.primaryGreen,
                      () => _startAudioLearning(module),
                    ),
                  
                  if (module['hasVideo'] as bool)
                    _buildMediaOption(
                      'Watch Video',
                      'Visual learning with demonstrations',
                      Icons.play_circle,
                      AppTheme.primaryBlue,
                      () => _startVideoLearning(module),
                    ),
                  
                  _buildMediaOption(
                    'Read Content',
                    'Text-based learning at your pace',
                    Icons.article,
                    AppTheme.secondaryGreen,
                    () => _startTextLearning(module),
                  ),
                ],
              ),
            ),
          ),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Start Learning',
                onPressed: () {
                  Navigator.of(context).pop();
                  _startDefaultLearning(module);
                },
                type: ButtonType.primary,
                height: 56,
                icon: Icons.play_arrow,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXS),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.primaryGreen,
            size: 16,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: CustomCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
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
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.neutralGray,
            ),
          ],
        ),
      ),
    );
  }

  void _startAudioLearning(Map<String, dynamic> module) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting audio for ${module['title']}')),
    );
  }

  void _startVideoLearning(Map<String, dynamic> module) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Starting video for ${module['title']}')),
    );
  }

  void _startTextLearning(Map<String, dynamic> module) {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening text content for ${module['title']}')),
    );
  }

  void _startDefaultLearning(Map<String, dynamic> module) {
    // Mark as completed for demo
    setState(() {
      module['completed'] = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Started learning: ${module['title']}'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Modules'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter module name or topic...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}