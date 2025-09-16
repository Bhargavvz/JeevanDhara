import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class OutbreakPredictionScreen extends StatefulWidget {
  const OutbreakPredictionScreen({super.key});

  @override
  State<OutbreakPredictionScreen> createState() => _OutbreakPredictionScreenState();
}

class _OutbreakPredictionScreenState extends State<OutbreakPredictionScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String selectedTimeframe = 'Next 7 Days';
  String selectedDisease = 'All Diseases';
  bool showHistoricalData = false;
  
  final List<String> timeframes = [
    'Next 7 Days',
    'Next 14 Days',
    'Next 30 Days',
    'Next 3 Months'
  ];
  
  final List<String> diseases = [
    'All Diseases',
    'Diarrhea',
    'Cholera',
    'Typhoid',
    'Hepatitis A',
    'Dysentery'
  ];
  
  final List<Map<String, dynamic>> predictions = [
    {
      'location': 'Kohima District',
      'disease': 'Diarrhea',
      'riskLevel': 'High',
      'probability': 85,
      'predictedCases': 45,
      'currentCases': 12,
      'factors': ['Monsoon season', 'Water contamination', 'Population density'],
      'recommendedActions': [
        'Increase water quality monitoring',
        'Deploy additional ASHA workers',
        'Conduct awareness campaigns',
        'Prepare medical supplies'
      ],
      'confidenceLevel': 78,
      'timeToOutbreak': '3-5 days',
    },
    {
      'location': 'Dimapur District',
      'disease': 'Cholera',
      'riskLevel': 'Medium',
      'probability': 62,
      'predictedCases': 28,
      'currentCases': 3,
      'factors': ['Sanitation issues', 'Recent cases nearby', 'Seasonal patterns'],
      'recommendedActions': [
        'Enhance surveillance',
        'Improve sanitation facilities',
        'Educate on food safety',
        'Stockpile medical supplies'
      ],
      'confidenceLevel': 65,
      'timeToOutbreak': '7-10 days',
    },
    {
      'location': 'Mokokchung District',
      'disease': 'Typhoid',
      'riskLevel': 'Low',
      'probability': 35,
      'predictedCases': 15,
      'currentCases': 1,
      'factors': ['Historical patterns', 'Water quality reports'],
      'recommendedActions': [
        'Continue routine monitoring',
        'Maintain vaccination programs',
        'Monitor water sources',
        'Community education'
      ],
      'confidenceLevel': 58,
      'timeToOutbreak': '14+ days',
    },
    {
      'location': 'Nagaon District',
      'disease': 'Hepatitis A',
      'riskLevel': 'Medium',
      'probability': 55,
      'predictedCases': 22,
      'currentCases': 5,
      'factors': ['Poor sanitation', 'Contaminated water sources', 'High population density'],
      'recommendedActions': [
        'Test water sources',
        'Vaccination drive',
        'Sanitation improvement',
        'Health awareness campaigns'
      ],
      'confidenceLevel': 71,
      'timeToOutbreak': '5-8 days',
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
  }

  void _startAnimations() {
    _animationController.forward();
  }

  List<Map<String, dynamic>> get filteredPredictions {
    return predictions.where((prediction) {
      bool matchesDisease = selectedDisease == 'All Diseases' || 
                           prediction['disease'] == selectedDisease;
      return matchesDisease;
    }).toList()..sort((a, b) => (b['probability'] as int).compareTo(a['probability'] as int));
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
            // Prediction Overview
            _buildPredictionOverview(),
            
            // Filters and Settings
            _buildFiltersSection(),
            
            // Map and Predictions
            Expanded(
              child: _buildPredictionsContent(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Outbreak Predictions'),
      backgroundColor: AppTheme.errorRed,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: Icon(showHistoricalData ? Icons.timeline : Icons.trending_up),
          onPressed: () {
            setState(() {
              showHistoricalData = !showHistoricalData;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: _showPredictionSettings,
        ),
      ],
    );
  }

  Widget _buildPredictionOverview() {
    final highRiskAreas = predictions.where((p) => p['riskLevel'] == 'High').length;
    final totalPredictedCases = predictions.fold<int>(0, (sum, p) => sum + (p['predictedCases'] as int));
    final avgProbability = predictions.fold<int>(0, (sum, p) => sum + (p['probability'] as int)) / predictions.length;
    final criticalTimeframe = predictions.where((p) => p['riskLevel'] == 'High').isNotEmpty ? 
        predictions.where((p) => p['riskLevel'] == 'High').first['timeToOutbreak'] : 'No immediate risk';

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Outbreak Risk Assessment',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  'High Risk Areas',
                  highRiskAreas.toString(),
                  Icons.warning,
                  AppTheme.errorRed,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: _buildOverviewCard(
                  'Predicted Cases',
                  totalPredictedCases.toString(),
                  Icons.trending_up,
                  AppTheme.warningOrange,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: _buildOverviewCard(
                  'Avg Probability',
                  '${avgProbability.round()}%',
                  Icons.analytics,
                  AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: _buildOverviewCard(
                  'Next Risk',
                  criticalTimeframe.toString().split(' ').first,
                  Icons.schedule,
                  AppTheme.infoBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedTimeframe,
              decoration: const InputDecoration(
                labelText: 'Prediction Timeframe',
                isDense: true,
              ),
              items: timeframes.map((timeframe) {
                return DropdownMenuItem(value: timeframe, child: Text(timeframe));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTimeframe = value!;
                });
              },
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedDisease,
              decoration: const InputDecoration(
                labelText: 'Disease Type',
                isDense: true,
              ),
              items: diseases.map((disease) {
                return DropdownMenuItem(value: disease, child: Text(disease));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDisease = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Prediction Map
          _buildPredictionMap(),
          
          // Risk Analysis Chart
          _buildRiskAnalysisChart(),
          
          // Detailed Predictions
          _buildDetailedPredictions(),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return CustomCard(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  Widget _buildPredictionMap() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Outbreak Risk Map',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  const Center(child: Text('Northeast India Risk Map')),
                  Positioned(
                    top: 30,
                    left: 50,
                    child: _buildRiskIndicator('Kohima', AppTheme.errorRed),
                  ),
                  Positioned(
                    top: 60,
                    right: 40,
                    child: _buildRiskIndicator('Dimapur', AppTheme.warningOrange),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 80,
                    child: _buildRiskIndicator('Mokokchung', AppTheme.successGreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskIndicator(String location, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        location,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return AppTheme.errorRed;
      case 'medium':
        return AppTheme.warningOrange;
      case 'low':
        return AppTheme.successGreen;
      default:
        return AppTheme.neutralGray;
    }
  }

  Widget _buildRiskAnalysisChart() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Risk Analysis Trends',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                          if (value.toInt() >= 0 && value.toInt() < titles.length) {
                            return Text(titles[value.toInt()], style: const TextStyle(fontSize: 10));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 20),
                        FlSpot(1, 35),
                        FlSpot(2, 45),
                        FlSpot(3, 60),
                        FlSpot(4, 75),
                        FlSpot(5, 85),
                        FlSpot(6, 90),
                      ],
                      isCurved: true,
                      color: AppTheme.errorRed,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.errorRed.withOpacity(0.1),
                      ),
                    ),
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 15),
                        FlSpot(1, 25),
                        FlSpot(2, 40),
                        FlSpot(3, 50),
                        FlSpot(4, 55),
                        FlSpot(5, 62),
                        FlSpot(6, 68),
                      ],
                      isCurved: true,
                      color: AppTheme.warningOrange,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.warningOrange.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem('High Risk', AppTheme.errorRed),
                _buildLegendItem('Medium Risk', AppTheme.warningOrange),
                _buildLegendItem('Low Risk', AppTheme.successGreen),
              ],
            ),
          ],
        ),
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

  Widget _buildDetailedPredictions() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Predictions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...filteredPredictions.map((prediction) => _buildDetailedPredictionCard(prediction)),
        ],
      ),
    );
  }

  Widget _buildDetailedPredictionCard(Map<String, dynamic> prediction) {
    final riskColor = _getRiskColor(prediction['riskLevel']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        child: ExpansionTile(
          leading: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: riskColor,
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            '${prediction['disease']} - ${prediction['location']}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Row(
            children: [
              Text(
                'Risk: ${prediction['riskLevel']}',
                style: TextStyle(
                  color: riskColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Text('${prediction['probability']}% probability'),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Current Cases', prediction['currentCases'].toString()),
                      _buildStatItem('Predicted Cases', prediction['predictedCases'].toString()),
                      _buildStatItem('Confidence', '${prediction['confidenceLevel']}%'),
                      _buildStatItem('Time Frame', prediction['timeToOutbreak']),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Risk Factors
                  Text(
                    'Risk Factors:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Wrap(
                    spacing: AppTheme.spacingXS,
                    runSpacing: AppTheme.spacingXS,
                    children: (prediction['factors'] as List<String>).map((factor) {
                      return Chip(
                        label: Text(
                          factor,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        backgroundColor: riskColor.withOpacity(0.1),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Recommended Actions
                  Text(
                    'Recommended Actions:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  ...((prediction['recommendedActions'] as List<String>).map((action) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppTheme.spacingXS),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: AppTheme.successGreen,
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Expanded(
                            child: Text(
                              action,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
                  const SizedBox(height: AppTheme.spacingM),
                  
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _viewDetailedAnalysis(prediction),
                        icon: const Icon(Icons.analytics, size: 16),
                        label: const Text('Detailed Analysis'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _initiateResponse(prediction),
                        icon: const Icon(Icons.campaign, size: 16),
                        label: const Text('Initiate Response'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: riskColor,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.neutralGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showPredictionSettings() {
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
                Text(
                  'Prediction Settings',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                // Algorithm Selection
                Text(
                  'Prediction Algorithm',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Select Algorithm',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ML_ENSEMBLE', child: Text('ML Ensemble')),
                    DropdownMenuItem(value: 'STATISTICAL', child: Text('Statistical Model')),
                    DropdownMenuItem(value: 'HYBRID', child: Text('Hybrid Approach')),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                // Sensitivity Settings
                Text(
                  'Alert Sensitivity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                SwitchListTile(
                  title: const Text('High Sensitivity Mode'),
                  subtitle: const Text('Detect early risk indicators'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: const Text('Include Weather Data'),
                  subtitle: const Text('Factor in meteorological conditions'),
                  value: true,
                  onChanged: (value) {},
                ),
                SwitchListTile(
                  title: const Text('Historical Pattern Analysis'),
                  subtitle: const Text('Use 5-year historical data'),
                  value: false,
                  onChanged: (value) {},
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                // Notification Settings
                Text(
                  'Notification Preferences',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                CheckboxListTile(
                  title: const Text('Real-time Alerts'),
                  value: true,
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  title: const Text('Daily Summaries'),
                  value: true,
                  onChanged: (value) {},
                ),
                CheckboxListTile(
                  title: const Text('Weekly Reports'),
                  value: false,
                  onChanged: (value) {},
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Prediction settings updated'),
                            backgroundColor: AppTheme.successGreen,
                          ),
                        );
                      },
                      child: const Text('Save Settings'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _viewDetailedAnalysis(Map<String, dynamic> prediction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detailed Analysis - ${prediction['disease']}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Location: ${prediction['location']}'),
              const SizedBox(height: 8),
              Text('Prediction Confidence: ${prediction['confidenceLevel']}%'),
              const SizedBox(height: 8),
              Text('Expected Timeline: ${prediction['timeToOutbreak']}'),
              const SizedBox(height: 16),
              const Text(
                'Analysis Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Environmental factors indicate increased risk\n'
                '• Population density supports transmission\n'
                '• Seasonal patterns align with historical data\n'
                '• Water quality reports show contamination risks',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Detailed report generated'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            child: const Text('Generate Report'),
          ),
        ],
      ),
    );
  }

  void _initiateResponse(Map<String, dynamic> prediction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Initiate Emergency Response'),
        content: Text(
          'Are you sure you want to initiate emergency response protocols for ${prediction['disease']} outbreak in ${prediction['location']}?\n\n'
          'This will alert ASHA workers, medical teams, and relevant authorities.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Emergency response initiated'),
                  backgroundColor: AppTheme.errorRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Initiate Response'),
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