import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class WaterQualityReportingScreen extends StatefulWidget {
  const WaterQualityReportingScreen({super.key});

  @override
  State<WaterQualityReportingScreen> createState() => _WaterQualityReportingScreenState();
}

class _WaterQualityReportingScreenState extends State<WaterQualityReportingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  
  int currentStep = 0;
  Map<String, dynamic> reportData = {};
  List<Map<String, dynamic>> recentReports = [];
  
  final List<Map<String, dynamic>> waterSources = [
    {'name': 'Main Village Well', 'type': 'Well', 'location': 'Village Center'},
    {'name': 'River Stream', 'type': 'River', 'location': 'East Side'},
    {'name': 'Hand Pump #1', 'type': 'Hand Pump', 'location': 'School Area'},
    {'name': 'Hand Pump #2', 'type': 'Hand Pump', 'location': 'Market Area'},
    {'name': 'Spring Source', 'type': 'Natural Spring', 'location': 'Hill Side'},
  ];

  final List<Map<String, dynamic>> qualityParameters = [
    {
      'name': 'Color',
      'options': ['Clear', 'Slightly Cloudy', 'Cloudy', 'Colored'],
      'icon': Icons.palette,
    },
    {
      'name': 'Odor',
      'options': ['No Smell', 'Slight Smell', 'Strong Smell', 'Foul Smell'],
      'icon': Icons.air,
    },
    {
      'name': 'Taste',
      'options': ['Normal', 'Slightly Salty', 'Metallic', 'Bitter', 'Chemical'],
      'icon': Icons.emoji_food_beverage,
    },
    {
      'name': 'Debris/Particles',
      'options': ['None', 'Few Particles', 'Many Particles', 'Heavy Contamination'],
      'icon': Icons.scatter_plot,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _tabController = TabController(length: 3, vsync: this);
    _loadRecentReports();
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

  void _loadRecentReports() {
    // Mock data for demonstration
    recentReports = [
      {
        'id': '1',
        'source': 'Main Village Well',
        'date': '2024-01-15',
        'status': 'Good',
        'reporter': 'Community Member',
        'issues': [],
      },
      {
        'id': '2',
        'source': 'River Stream',
        'date': '2024-01-14',
        'status': 'Poor',
        'reporter': 'ASHA Worker',
        'issues': ['Cloudy Water', 'Bad Smell'],
      },
    ];
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
                  _buildReportTab(),
                  _buildMapTab(),
                  _buildHistoryTab(),
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
      title: const Text('Water Quality Reporting'),
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
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
        labelColor: AppTheme.primaryBlue,
        unselectedLabelColor: AppTheme.neutralGray,
        indicatorColor: AppTheme.primaryBlue,
        tabs: const [
          Tab(icon: Icon(Icons.report), text: 'Report'),
          Tab(icon: Icon(Icons.map), text: 'Map'),
          Tab(icon: Icon(Icons.history), text: 'History'),
        ],
      ),
    );
  }

  Widget _buildReportTab() {
    return Column(
      children: [
        _buildProgressIndicator(),
        Expanded(child: _buildCurrentStep()),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildMapTab() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          CustomCard(
            child: Column(
              children: [
                const Icon(Icons.map, size: 64, color: AppTheme.primaryBlue),
                const SizedBox(height: AppTheme.spacingM),
                Text(
                  'Water Sources Map',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  'Interactive map showing water sources and their quality status',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingL),
                ElevatedButton(
                  onPressed: _openFullMap,
                  child: const Text('Open Full Map'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Expanded(
            child: ListView.builder(
              itemCount: waterSources.length,
              itemBuilder: (context, index) {
                final source = waterSources[index];
                return _buildSourceCard(source);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (recentReports.isEmpty) {
      return const EmptyState(
        title: 'No Reports Yet',
        subtitle: 'Start reporting water quality issues to help your community',
        icon: Icons.report_off,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: recentReports.length,
      itemBuilder: (context, index) {
        final report = recentReports[index];
        return _buildReportHistoryCard(report);
      },
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
                'Step ${currentStep + 1} of 4',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _getStepTitle(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.neutralGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          LinearProgressIndicator(
            value: (currentStep + 1) / 4,
            backgroundColor: AppTheme.lightGray,
            valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0: return _buildLocationStep();
      case 1: return _buildVisualAssessmentStep();
      case 2: return _buildAdditionalInfoStep();
      case 3: return _buildReviewStep();
      default: return const SizedBox();
    }
  }

  Widget _buildLocationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Water Source',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Choose the water source you want to report about',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          ...waterSources.map((source) => Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
            child: CustomCard(
              onTap: () {
                setState(() {
                  reportData['source'] = source;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  border: reportData['source'] == source
                      ? Border.all(color: AppTheme.primaryBlue, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Row(
                    children: [
                      Icon(
                        _getSourceIcon(source['type']),
                        color: AppTheme.primaryBlue,
                        size: 32,
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              source['name'],
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${source['type']} • ${source['location']}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.neutralGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (reportData['source'] == source)
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.primaryBlue,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          )).toList(),
          
          const SizedBox(height: AppTheme.spacingL),
          CustomButton(
            text: 'Add Custom Location',
            onPressed: _addCustomLocation,
            type: ButtonType.secondary,
            icon: Icons.add_location,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildVisualAssessmentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visual Assessment',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Assess the water quality based on what you can see, smell, and taste',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          ...qualityParameters.map((parameter) => Container(
            margin: const EdgeInsets.only(bottom: AppTheme.spacingL),
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(parameter['icon'], color: AppTheme.primaryBlue),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(
                        parameter['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  Wrap(
                    spacing: AppTheme.spacingS,
                    runSpacing: AppTheme.spacingS,
                    children: (parameter['options'] as List<String>).map((option) {
                      final isSelected = reportData[parameter['name']] == option;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            reportData[parameter['name']] = option;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppTheme.primaryBlue 
                                : AppTheme.lightGray,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected 
                                  ? AppTheme.primaryBlue 
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            option,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isSelected ? Colors.white : AppTheme.darkGray,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Provide additional details about the water quality issue',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          CustomCard(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe any specific issues or concerns...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  onChanged: (value) => reportData['description'] = value,
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Your Name',
                          hintText: 'Enter your name',
                        ),
                        onChanged: (value) => reportData['reporterName'] = value,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Contact (Optional)',
                          hintText: 'Phone number',
                        ),
                        onChanged: (value) => reportData['contact'] = value,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                Row(
                  children: [
                    Icon(Icons.photo_camera, color: AppTheme.neutralGray),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      'Add Photos (Optional)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: _addPhoto,
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Add Photo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Report',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Please review your report before submitting',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReviewItem('Water Source', reportData['source']?['name'] ?? 'Not selected'),
                _buildReviewItem('Location', reportData['source']?['location'] ?? ''),
                const Divider(),
                
                ...qualityParameters.map((param) {
                  final value = reportData[param['name']] ?? 'Not assessed';
                  return _buildReviewItem(param['name'], value);
                }).toList(),
                
                if (reportData['description'] != null && reportData['description'].isNotEmpty) ...[
                  const Divider(),
                  _buildReviewItem('Description', reportData['description']),
                ],
                
                const Divider(),
                _buildReviewItem('Reporter', reportData['reporterName'] ?? 'Anonymous'),
              ],
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          CustomButton(
            text: 'Submit Report',
            onPressed: _submitReport,
            icon: Icons.send,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.neutralGray,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
              onPressed: currentStep < 3 ? _nextStep : null,
              child: Text(currentStep < 3 ? 'Next' : 'Complete'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceCard(Map<String, dynamic> source) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: CustomCard(
        child: Row(
          children: [
            Icon(
              _getSourceIcon(source['type']),
              color: AppTheme.primaryBlue,
              size: 24,
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    source['name'],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    source['location'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
            const StatusBadge(status: 'good'),
          ],
        ),
      ),
    );
  }

  Widget _buildReportHistoryCard(Map<String, dynamic> report) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    report['source'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                StatusBadge(status: report['status'].toLowerCase()),
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Reported on ${report['date']} by ${report['reporter']}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.neutralGray,
              ),
            ),
            if (report['issues'].isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacingS),
              Wrap(
                spacing: AppTheme.spacingXS,
                children: (report['issues'] as List<String>).map((issue) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.errorRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      issue,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.errorRed,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getSourceIcon(String type) {
    switch (type) {
      case 'Well': return Icons.water_drop;
      case 'River': return Icons.waves;
      case 'Hand Pump': return Icons.water_damage;
      case 'Natural Spring': return Icons.nature;
      default: return Icons.water;
    }
  }

  String _getStepTitle() {
    switch (currentStep) {
      case 0: return 'Location';
      case 1: return 'Assessment';
      case 2: return 'Details';
      case 3: return 'Review';
      default: return '';
    }
  }

  void _nextStep() {
    if (currentStep < 3) {
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

  void _submitReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Water quality report submitted successfully!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
    
    setState(() {
      currentStep = 0;
      reportData.clear();
    });
  }

  void _addCustomLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Custom location feature coming soon')),
    );
  }

  void _addPhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo capture feature coming soon')),
    );
  }

  void _openFullMap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening full map view')),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Water Quality Reporting Help'),
        content: const Text(
          'This tool helps you report water quality issues in your community. '
          'Follow the steps to assess and report the condition of local water sources. '
          'Your reports help health officials monitor and respond to water quality issues.',
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

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}