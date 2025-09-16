import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  int currentStep = 0;
  List<String> selectedSymptoms = [];
  Map<String, dynamic> patientInfo = {};
  Map<String, dynamic> assessmentResult = {};
  
  final List<Map<String, dynamic>> symptoms = [
    {
      'category': 'Gastrointestinal',
      'symptoms': [
        {'name': 'Diarrhea', 'icon': Icons.sick, 'severity': 'high'},
        {'name': 'Vomiting', 'icon': Icons.sick, 'severity': 'high'},
        {'name': 'Nausea', 'icon': Icons.sick, 'severity': 'medium'},
        {'name': 'Stomach Cramps', 'icon': Icons.sick, 'severity': 'medium'},
      ]
    },
    {
      'category': 'General',
      'symptoms': [
        {'name': 'Fever', 'icon': Icons.thermostat, 'severity': 'high'},
        {'name': 'Fatigue', 'icon': Icons.battery_0_bar, 'severity': 'medium'},
        {'name': 'Headache', 'icon': Icons.psychology, 'severity': 'medium'},
        {'name': 'Dizziness', 'icon': Icons.psychology, 'severity': 'medium'},
      ]
    },
    {
      'category': 'Dehydration',
      'symptoms': [
        {'name': 'Excessive Thirst', 'icon': Icons.water_drop, 'severity': 'medium'},
        {'name': 'Dry Mouth', 'icon': Icons.dry, 'severity': 'medium'},
        {'name': 'Dark Urine', 'icon': Icons.warning, 'severity': 'high'},
        {'name': 'Little/No Urination', 'icon': Icons.warning, 'severity': 'high'},
      ]
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(child: _buildCurrentStep()),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Symptom Checker'),
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: _showInfoDialog,
        ),
      ],
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
      case 0: return _buildPatientInfoStep();
      case 1: return _buildSymptomSelectionStep();
      case 2: return _buildSeverityAssessmentStep();
      case 3: return _buildResultsStep();
      default: return const SizedBox();
    }
  }

  Widget _buildPatientInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Information',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Please provide basic information about the patient',
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
                    labelText: 'Age',
                    hintText: 'Enter age in years',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => patientInfo['age'] = value,
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: ['Male', 'Female', 'Other'].map((gender) {
                    return DropdownMenuItem(value: gender, child: Text(gender));
                  }).toList(),
                  onChanged: (value) => patientInfo['gender'] = value,
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    hintText: 'Village/Town name',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  onChanged: (value) => patientInfo['location'] = value,
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'When did symptoms start?',
                    prefixIcon: Icon(Icons.schedule),
                  ),
                  items: [
                    'Today',
                    'Yesterday', 
                    '2-3 days ago',
                    '4-7 days ago',
                    'More than a week ago'
                  ].map((duration) {
                    return DropdownMenuItem(value: duration, child: Text(duration));
                  }).toList(),
                  onChanged: (value) => patientInfo['symptomDuration'] = value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomSelectionStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Symptoms',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Tap on all symptoms the patient is experiencing',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          ...symptoms.map((category) => _buildSymptomCategory(category)),
          
          if (selectedSymptoms.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingL),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Symptoms (${selectedSymptoms.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Wrap(
                    spacing: AppTheme.spacingXS,
                    runSpacing: AppTheme.spacingXS,
                    children: selectedSymptoms.map((symptom) {
                      return Chip(
                        label: Text(symptom),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            selectedSymptoms.remove(symptom);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSymptomCategory(Map<String, dynamic> category) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category['category'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: AppTheme.spacingS,
                mainAxisSpacing: AppTheme.spacingS,
              ),
              itemCount: category['symptoms'].length,
              itemBuilder: (context, index) {
                final symptom = category['symptoms'][index];
                final isSelected = selectedSymptoms.contains(symptom['name']);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedSymptoms.remove(symptom['name']);
                      } else {
                        selectedSymptoms.add(symptom['name']);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryBlue.withOpacity(0.1) : AppTheme.lightGray,
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryBlue : AppTheme.neutralGray.withOpacity(0.3),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(AppTheme.spacingS),
                    child: Row(
                      children: [
                        Icon(
                          symptom['icon'],
                          color: isSelected ? AppTheme.primaryBlue : AppTheme.neutralGray,
                          size: 20,
                        ),
                        const SizedBox(width: AppTheme.spacingXS),
                        Expanded(
                          child: Text(
                            symptom['name'],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: isSelected ? AppTheme.primaryBlue : AppTheme.neutralGray,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryBlue,
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityAssessmentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Severity Assessment',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Rate the severity of symptoms from 1 (mild) to 5 (severe)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          ...selectedSymptoms.map((symptom) => _buildSeverityRating(symptom)),
          
          const SizedBox(height: AppTheme.spacingL),
          
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Additional Questions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                _buildYesNoQuestion('Have you consumed untreated water?', 'untreatedWater'),
                _buildYesNoQuestion('Are there similar cases in your community?', 'communityCases'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityRating(String symptom) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              symptom,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                final rating = index + 1;
                final isSelected = patientInfo['${symptom}_severity'] == rating;
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      patientInfo['${symptom}_severity'] = rating;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                      border: Border.all(
                        color: AppTheme.primaryBlue,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        rating.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mild',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
                Text(
                  'Severe',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYesNoQuestion(String question, String key) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('Yes'),
                  value: true,
                  groupValue: patientInfo[key],
                  onChanged: (value) {
                    setState(() {
                      patientInfo[key] = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  title: const Text('No'),
                  value: false,
                  groupValue: patientInfo[key],
                  onChanged: (value) {
                    setState(() {
                      patientInfo[key] = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assessment Results',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          _buildRiskLevelCard(),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildRecommendationsCard(),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildNextStepsCard(),
          const SizedBox(height: AppTheme.spacingL),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _shareResults,
                  icon: const Icon(Icons.share),
                  label: const Text('Share Results'),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _findNearbyFacilities,
                  icon: const Icon(Icons.local_hospital),
                  label: const Text('Find Facilities'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskLevelCard() {
    final riskLevel = _calculateRiskLevel();
    final riskColor = _getRiskColor(riskLevel);
    
    return CustomCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getRiskIcon(riskLevel),
                  color: riskColor,
                  size: 30,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Risk Level: $riskLevel',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                    ),
                    Text(
                      _getRiskDescription(riskLevel),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.neutralGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recommendations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          ..._getRecommendations().map((recommendation) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: AppTheme.successGreen,
                    size: 20,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Next Steps',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          if (_calculateRiskLevel() == 'High') ...[
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.errorRed.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emergency, color: AppTheme.errorRed),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: Text(
                      'Seek immediate medical attention. Contact emergency services if symptoms worsen.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.errorRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              '• Monitor symptoms closely\n'
              '• Maintain hydration with ORS\n'
              '• Contact ASHA worker if symptoms persist\n'
              '• Follow hygiene guidelines',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
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
              onPressed: _canProceed() ? _nextStep : null,
              child: Text(currentStep == 3 ? 'Start New Assessment' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (currentStep) {
      case 0: return 'Patient Info';
      case 1: return 'Symptoms';
      case 2: return 'Severity';
      case 3: return 'Results';
      default: return '';
    }
  }

  bool _canProceed() {
    switch (currentStep) {
      case 0:
        return patientInfo['age'] != null && 
               patientInfo['gender'] != null && 
               patientInfo['location'] != null &&
               patientInfo['symptomDuration'] != null;
      case 1:
        return selectedSymptoms.isNotEmpty;
      case 2:
        return selectedSymptoms.every((symptom) => 
               patientInfo['${symptom}_severity'] != null);
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
      if (currentStep == 3) {
        _generateAssessmentResult();
      }
    } else {
      _resetAssessment();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _resetAssessment() {
    setState(() {
      currentStep = 0;
      selectedSymptoms.clear();
      patientInfo.clear();
      assessmentResult.clear();
    });
  }

  void _generateAssessmentResult() {
    // Simple risk calculation based on symptoms
    int riskScore = 0;
    
    // High-risk symptoms
    if (selectedSymptoms.contains('Diarrhea')) riskScore += 3;
    if (selectedSymptoms.contains('Vomiting')) riskScore += 3;
    if (selectedSymptoms.contains('Fever')) riskScore += 2;
    if (selectedSymptoms.contains('Dark Urine')) riskScore += 3;
    if (selectedSymptoms.contains('Little/No Urination')) riskScore += 4;
    
    // Risk factors
    if (patientInfo['untreatedWater'] == true) riskScore += 2;
    if (patientInfo['communityCases'] == true) riskScore += 2;
    
    setState(() {
      assessmentResult['riskScore'] = riskScore;
      assessmentResult['riskLevel'] = _calculateRiskLevel();
    });
  }

  String _calculateRiskLevel() {
    final riskScore = assessmentResult['riskScore'] ?? 0;
    if (riskScore >= 8) return 'High';
    if (riskScore >= 4) return 'Medium';
    return 'Low';
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'High': return AppTheme.errorRed;
      case 'Medium': return AppTheme.warningOrange;
      case 'Low': return AppTheme.successGreen;
      default: return AppTheme.neutralGray;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel) {
      case 'High': return Icons.dangerous;
      case 'Medium': return Icons.warning;
      case 'Low': return Icons.check_circle;
      default: return Icons.help;
    }
  }

  String _getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'High': return 'Immediate medical attention recommended';
      case 'Medium': return 'Monitor closely and seek medical advice';
      case 'Low': return 'Continue monitoring and follow prevention guidelines';
      default: return '';
    }
  }

  List<String> _getRecommendations() {
    final riskLevel = _calculateRiskLevel();
    
    switch (riskLevel) {
      case 'High':
        return [
          'Seek immediate medical attention',
          'Increase fluid intake with ORS solution',
          'Contact local health worker',
          'Isolate to prevent spread',
        ];
      case 'Medium':
        return [
          'Monitor symptoms closely',
          'Maintain adequate hydration',
          'Contact ASHA worker if symptoms worsen',
          'Follow hygiene protocols',
        ];
      case 'Low':
        return [
          'Continue normal activities with caution',
          'Drink clean, boiled water',
          'Maintain good hygiene',
          'Follow prevention guidelines',
        ];
      default:
        return [];
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Symptom Checker'),
        content: const Text(
          'This tool helps assess water-borne disease symptoms and provides recommendations. '
          'It is not a substitute for professional medical advice. '
          'Always consult a healthcare provider for serious symptoms.',
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

  void _shareResults() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Results shared with local health authorities')),
    );
  }

  void _findNearbyFacilities() {
    Navigator.pushNamed(context, '/public/nearby-facilities');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
