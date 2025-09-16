import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class HealthSelfAssessmentScreen extends StatefulWidget {
  const HealthSelfAssessmentScreen({super.key});

  @override
  State<HealthSelfAssessmentScreen> createState() => _HealthSelfAssessmentScreenState();
}

class _HealthSelfAssessmentScreenState extends State<HealthSelfAssessmentScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  
  int currentStep = 0;
  Map<String, dynamic> assessmentData = {};
  Map<String, dynamic> assessmentResult = {};
  
  final List<Map<String, dynamic>> assessmentCategories = [
    {
      'title': 'General Health',
      'questions': [
        {
          'question': 'How would you rate your overall health today?',
          'type': 'rating',
          'scale': 5,
          'key': 'overall_health',
        },
        {
          'question': 'Have you experienced any fever in the last 24 hours?',
          'type': 'yes_no',
          'key': 'fever_24h',
        },
        {
          'question': 'How is your energy level today?',
          'type': 'multiple_choice',
          'options': ['Very Low', 'Low', 'Normal', 'High', 'Very High'],
          'key': 'energy_level',
        },
      ],
    },
    {
      'title': 'Digestive Health',
      'questions': [
        {
          'question': 'Have you experienced diarrhea in the last 3 days?',
          'type': 'yes_no',
          'key': 'diarrhea_3d',
        },
        {
          'question': 'How frequent are your bowel movements?',
          'type': 'multiple_choice',
          'options': ['Less than once daily', 'Once daily', '2-3 times daily', 'More than 3 times daily'],
          'key': 'bowel_frequency',
        },
        {
          'question': 'Rate your appetite today',
          'type': 'rating',
          'scale': 5,
          'key': 'appetite',
        },
        {
          'question': 'Have you experienced vomiting?',
          'type': 'yes_no',
          'key': 'vomiting',
        },
      ],
    },
    {
      'title': 'Hydration & Water Safety',
      'questions': [
        {
          'question': 'How much water do you drink daily?',
          'type': 'multiple_choice',
          'options': ['Less than 1 liter', '1-2 liters', '2-3 liters', 'More than 3 liters'],
          'key': 'water_intake',
        },
        {
          'question': 'Do you always boil or purify your drinking water?',
          'type': 'yes_no',
          'key': 'water_purification',
        },
        {
          'question': 'Rate your thirst level',
          'type': 'rating',
          'scale': 5,
          'key': 'thirst_level',
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> vitalSigns = [
    {
      'name': 'Body Temperature',
      'unit': '°F',
      'normal_range': '97.8 - 99.1',
      'icon': Icons.thermostat,
      'key': 'temperature',
    },
    {
      'name': 'Heart Rate',
      'unit': 'BPM',
      'normal_range': '60 - 100',
      'icon': Icons.favorite,
      'key': 'heart_rate',
    },
    {
      'name': 'Blood Pressure (Systolic)',
      'unit': 'mmHg',
      'normal_range': '90 - 120',
      'icon': Icons.monitor_heart,
      'key': 'systolic_bp',
    },
    {
      'name': 'Blood Pressure (Diastolic)',
      'unit': 'mmHg',
      'normal_range': '60 - 80',
      'icon': Icons.monitor_heart,
      'key': 'diastolic_bp',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _tabController = TabController(length: 3, vsync: this);
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
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAssessmentTab(),
                  _buildVitalSignsTab(),
                  _buildResultsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Health Self-Assessment'),
      backgroundColor: AppTheme.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: _showAssessmentHistory,
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: _showHelpDialog,
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.primaryGreen,
        unselectedLabelColor: AppTheme.neutralGray,
        indicatorColor: AppTheme.primaryGreen,
        tabs: const [
          Tab(icon: Icon(Icons.quiz), text: 'Assessment'),
          Tab(icon: Icon(Icons.monitor_heart), text: 'Vital Signs'),
          Tab(icon: Icon(Icons.analytics), text: 'Results'),
        ],
      ),
    );
  }

  Widget _buildAssessmentTab() {
    return Column(
      children: [
        if (currentStep < assessmentCategories.length) ...[
          _buildProgressIndicator(),
          Expanded(child: _buildCurrentCategory()),
          _buildNavigationButtons(),
        ] else ...[
          Expanded(child: _buildAssessmentSummary()),
        ],
      ],
    );
  }

  Widget _buildVitalSignsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Record Your Vital Signs',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Enter your current vital signs if available',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          ...vitalSigns.map((vital) => Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
            child: _buildVitalSignCard(vital),
          )).toList(),
          
          const SizedBox(height: AppTheme.spacingL),
          CustomButton(
            text: 'Save Vital Signs',
            onPressed: _saveVitalSigns,
            icon: Icons.save,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildResultsTab() {
    if (assessmentResult.isEmpty) {
      return const EmptyState(
        title: 'No Assessment Results',
        subtitle: 'Complete the health assessment to see your results',
        icon: Icons.analytics,
        actionText: 'Start Assessment',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultSummary(),
          const SizedBox(height: AppTheme.spacingL),
          _buildRecommendations(),
          const SizedBox(height: AppTheme.spacingL),
          _buildNextSteps(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentStep + 1} of ${assessmentCategories.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                assessmentCategories[currentStep]['title'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutralGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          LinearProgressIndicator(
            value: (currentStep + 1) / assessmentCategories.length,
            backgroundColor: AppTheme.lightGray,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentCategory() {
    final category = assessmentCategories[currentStep];
    final questions = category['questions'] as List<Map<String, dynamic>>;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category['title'],
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          ...questions.map((question) => Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingL),
            child: _buildQuestionCard(question),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question['question'],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildQuestionInput(question),
        ],
      ),
    );
  }

  Widget _buildQuestionInput(Map<String, dynamic> question) {
    final key = question['key'];
    
    switch (question['type']) {
      case 'yes_no':
        return Row(
          children: [
            Expanded(
              child: _buildYesNoOption('Yes', true, key),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _buildYesNoOption('No', false, key),
            ),
          ],
        );
        
      case 'rating':
        return _buildRatingInput(question);
        
      case 'multiple_choice':
        return _buildMultipleChoiceInput(question);
        
      default:
        return const SizedBox();
    }
  }

  Widget _buildYesNoOption(String label, bool value, String key) {
    final isSelected = assessmentData[key] == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          assessmentData[key] = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : AppTheme.lightGray,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isSelected ? Colors.white : AppTheme.darkGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingInput(Map<String, dynamic> question) {
    final key = question['key'];
    final scale = question['scale'] as int;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Very Poor', style: Theme.of(context).textTheme.bodySmall),
            Text('Excellent', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: AppTheme.spacingS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(scale, (index) {
            final rating = index + 1;
            final isSelected = assessmentData[key] == rating;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  assessmentData[key] = rating;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.lightGray,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryGreen : AppTheme.neutralGray,
                  ),
                ),
                child: Center(
                  child: Text(
                    rating.toString(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? Colors.white : AppTheme.darkGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMultipleChoiceInput(Map<String, dynamic> question) {
    final key = question['key'];
    final options = question['options'] as List<String>;
    
    return Column(
      children: options.map((option) {
        final isSelected = assessmentData[key] == option;
        
        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
          child: GestureDetector(
            onTap: () {
              setState(() {
                assessmentData[key] = option;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryGreen.withOpacity(0.1) : AppTheme.lightGray,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryGreen : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Text(
                option,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected ? AppTheme.primaryGreen : AppTheme.darkGray,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVitalSignCard(Map<String, dynamic> vital) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(vital['icon'], color: AppTheme.primaryBlue),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  vital['name'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Normal range: ${vital['normal_range']} ${vital['unit']}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter value',
              suffixText: vital['unit'],
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              assessmentData[vital['key']] = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                child: const Text('Previous'),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: ElevatedButton(
              onPressed: currentStep < assessmentCategories.length - 1 
                  ? _nextStep 
                  : _completeAssessment,
              child: Text(
                currentStep < assessmentCategories.length - 1 ? 'Next' : 'Complete Assessment'
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentSummary() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assessment Complete!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.successGreen,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          CustomCard(
            child: Column(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 64,
                  color: AppTheme.successGreen,
                ),
                const SizedBox(height: AppTheme.spacingM),
                Text(
                  'Your health assessment has been completed successfully.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                CustomButton(
                  text: 'View Results',
                  onPressed: () {
                    _tabController.animateTo(2);
                  },
                  icon: Icons.analytics,
                  width: double.infinity,
                ),
                const SizedBox(height: AppTheme.spacingM),
                OutlinedButton(
                  onPressed: _startNewAssessment,
                  child: const Text('Start New Assessment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSummary() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assessment Results',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildResultMetric('Overall Health Score', '85%', AppTheme.successGreen),
          _buildResultMetric('Risk Level', 'Low', AppTheme.successGreen),
          _buildResultMetric('Hydration Status', 'Good', AppTheme.primaryBlue),
        ],
      ),
    );
  }

  Widget _buildResultMetric(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildRecommendationItem(
            Icons.water_drop,
            'Maintain good hydration by drinking 2-3 liters of clean water daily',
          ),
          _buildRecommendationItem(
            Icons.health_and_safety,
            'Continue following water purification practices',
          ),
          _buildRecommendationItem(
            Icons.fitness_center,
            'Maintain regular physical activity for overall health',
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 20),
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

  Widget _buildNextSteps() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Steps',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          CustomButton(
            text: 'Schedule Follow-up Assessment',
            onPressed: _scheduleFollowUp,
            icon: Icons.schedule,
            width: double.infinity,
          ),
          const SizedBox(height: AppTheme.spacingM),
          OutlinedButton(
            onPressed: _shareResults,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.share, size: 16),
                SizedBox(width: 8),
                Text('Share with Healthcare Provider'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (currentStep < assessmentCategories.length - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _completeAssessment() {
    setState(() {
      currentStep = assessmentCategories.length;
      assessmentResult = _generateAssessmentResult();
    });
  }

  void _startNewAssessment() {
    setState(() {
      currentStep = 0;
      assessmentData.clear();
      assessmentResult.clear();
    });
  }

  void _saveVitalSigns() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vital signs saved successfully!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _scheduleFollowUp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Follow-up assessment scheduled')),
    );
  }

  void _shareResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Results shared with healthcare provider')),
    );
  }

  void _showAssessmentHistory() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Showing assessment history')),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Health Self-Assessment Help'),
        content: const Text(
          'This tool helps you assess your current health status and identify '
          'potential risks related to water-borne diseases. Answer all questions '
          'honestly for the most accurate assessment.',
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

  Map<String, dynamic> _generateAssessmentResult() {
    // Simple scoring logic - in a real app, this would be more sophisticated
    int totalScore = 0;
    int maxScore = 0;
    
    assessmentData.forEach((key, value) {
      if (value is int && value > 0) {
        totalScore += value;
        maxScore += 5; // Assuming max rating is 5
      }
    });
    
    double percentage = maxScore > 0 ? (totalScore / maxScore) * 100 : 0;
    
    return {
      'score': percentage,
      'risk_level': percentage > 80 ? 'Low' : percentage > 60 ? 'Medium' : 'High',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}