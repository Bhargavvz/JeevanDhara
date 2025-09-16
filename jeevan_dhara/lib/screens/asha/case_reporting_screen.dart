import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_widgets.dart';

class CaseReportingScreen extends StatefulWidget {
  const CaseReportingScreen({Key? key}) : super(key: key);

  @override
  State<CaseReportingScreen> createState() => _CaseReportingScreenState();
}

class _CaseReportingScreenState extends State<CaseReportingScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  final _speechToText = SpeechToText();
  
  // Form Controllers
  final _casesController = TextEditingController();
  final _notesController = TextEditingController();
  
  // Form Data
  String? selectedVillage;
  String? selectedDistrict;
  List<String> selectedSymptoms = [];
  List<String> selectedWaterConditions = [];
  Position? currentLocation;
  DateTime reportDateTime = DateTime.now();
  bool isListening = false;
  bool isSavingOffline = false;
  bool isSubmitting = false;
  
  int currentPage = 0;
  final int totalPages = 4;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _getCurrentLocation();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentLocation = position;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to get location: $e')),
      );
    }
  }

  void _nextPage() {
    if (currentPage < totalPages - 1) {
      _pageController.nextPage(
        duration: AppTheme.normalAnimation,
        curve: Curves.easeInOut,
      );
      setState(() {
        currentPage++;
      });
    }
  }

  void _previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: AppTheme.normalAnimation,
        curve: Curves.easeInOut,
      );
      setState(() {
        currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Report New Case'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: LoadingOverlay(
        isLoading: isSubmitting,
        message: 'Submitting report...',
        child: Column(
          children: [
            // Progress Indicator
            _buildProgressIndicator(),
            
            // Form Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                children: [
                  _buildLocationPage(),
                  _buildCaseDetailsPage(),
                  _buildSymptomsPage(),
                  _buildWaterConditionsPage(),
                ],
              ),
            ),
            
            // Navigation Buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: List.generate(totalPages, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(
                right: index < totalPages - 1 ? AppTheme.spacingS : 0,
              ),
              decoration: BoxDecoration(
                color: index <= currentPage 
                    ? AppTheme.primaryGreen 
                    : AppTheme.lightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLocationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location Details',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            // District Dropdown
            DropdownButtonFormField<String>(
              value: selectedDistrict,
              decoration: const InputDecoration(
                labelText: 'District',
                prefixIcon: Icon(Icons.location_city),
              ),
              items: AppConstants.districts.map((district) {
                return DropdownMenuItem(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  selectedVillage = null; // Reset village when district changes
                });
              },
              validator: (value) => value == null ? 'Please select a district' : null,
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Village Dropdown
            DropdownButtonFormField<String>(
              value: selectedVillage,
              decoration: const InputDecoration(
                labelText: 'Village/Community',
                prefixIcon: Icon(Icons.home),
              ),
              items: AppConstants.villages.map((village) {
                return DropdownMenuItem(
                  value: village,
                  child: Text(village),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedVillage = value;
                });
              },
              validator: (value) => value == null ? 'Please select a village' : null,
            ),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // GPS Location Card
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        currentLocation != null ? Icons.location_on : Icons.location_off,
                        color: currentLocation != null 
                            ? AppTheme.successGreen 
                            : AppTheme.warningOrange,
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(
                        'GPS Location',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  if (currentLocation != null) ...[
                    Text('Latitude: ${currentLocation!.latitude.toStringAsFixed(6)}'),
                    Text('Longitude: ${currentLocation!.longitude.toStringAsFixed(6)}'),
                    Text('Accuracy: ${currentLocation!.accuracy.toStringAsFixed(1)}m'),
                  ] else ...[
                    const Text('Location not available'),
                    const SizedBox(height: AppTheme.spacingS),
                    CustomButton(
                      text: 'Get Location',
                      onPressed: _getCurrentLocation,
                      type: ButtonType.secondary,
                      icon: Icons.my_location,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseDetailsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Case Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          // Number of Cases
          TextFormField(
            controller: _casesController,
            decoration: const InputDecoration(
              labelText: 'Number of Cases',
              hintText: 'Enter number of affected people',
              prefixIcon: Icon(Icons.people),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter number of cases';
              }
              final number = int.tryParse(value);
              if (number == null || number < 1) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Date and Time
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, color: AppTheme.primaryGreen),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      'Report Date & Time',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  '${reportDateTime.day}/${reportDateTime.month}/${reportDateTime.year} at ${reportDateTime.hour}:${reportDateTime.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppTheme.spacingS),
                CustomButton(
                  text: 'Change Date/Time',
                  onPressed: _selectDateTime,
                  type: ButtonType.secondary,
                  icon: Icons.calendar_today,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Additional Notes with Voice Input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Additional Notes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: isListening ? AppTheme.errorRed : AppTheme.primaryGreen,
                    ),
                    onPressed: _toggleSpeechToText,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingS),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Add any additional information (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                maxLength: AppConstants.maxReportDescriptionLength,
              ),
              if (isListening)
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingS),
                  decoration: BoxDecoration(
                    color: AppTheme.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.mic, color: AppTheme.errorRed),
                      SizedBox(width: AppTheme.spacingS),
                      Text('Listening... Speak now'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Symptoms',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Select all symptoms reported (multiple selection allowed)',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          // Symptoms Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: AppTheme.spacingS,
              mainAxisSpacing: AppTheme.spacingS,
            ),
            itemCount: AppConstants.symptoms.length,
            itemBuilder: (context, index) {
              final symptom = AppConstants.symptoms[index];
              final isSelected = selectedSymptoms.contains(symptom);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedSymptoms.remove(symptom);
                    } else {
                      selectedSymptoms.add(symptom);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppTheme.primaryGreen.withOpacity(0.1)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected 
                          ? AppTheme.primaryGreen 
                          : AppTheme.lightGray,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      symptom,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected 
                            ? AppTheme.primaryGreen 
                            : AppTheme.darkGray,
                        fontWeight: isSelected 
                            ? FontWeight.w600 
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWaterConditionsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Water Source Conditions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Select all observed water source conditions',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          // Water Conditions List
          ...AppConstants.waterSourceConditions.map((condition) {
            final isSelected = selectedWaterConditions.contains(condition);
            
            return CheckboxListTile(
              title: Text(condition),
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    selectedWaterConditions.add(condition);
                  } else {
                    selectedWaterConditions.remove(condition);
                  }
                });
              },
              activeColor: AppTheme.primaryGreen,
              controlAffinity: ListTileControlAffinity.leading,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentPage > 0) ...[
            Expanded(
              child: CustomButton(
                text: 'Previous',
                onPressed: _previousPage,
                type: ButtonType.secondary,
                icon: Icons.arrow_back,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
          ],
          
          Expanded(
            flex: currentPage == 0 ? 2 : 1,
            child: CustomButton(
              text: currentPage == totalPages - 1 ? 'Submit Report' : 'Next',
              onPressed: currentPage == totalPages - 1 ? _submitReport : _nextPage,
              type: ButtonType.primary,
              icon: currentPage == totalPages - 1 ? Icons.send : Icons.arrow_forward,
              isLoading: isSubmitting,
            ),
          ),
          
          if (currentPage == totalPages - 1) ...[
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: CustomButton(
                text: 'Save Offline',
                onPressed: _saveOffline,
                type: ButtonType.secondary,
                icon: Icons.save,
                isLoading: isSavingOffline,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: reportDateTime,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(reportDateTime),
      );
      
      if (time != null) {
        setState(() {
          reportDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _toggleSpeechToText() async {
    if (isListening) {
      await _speechToText.stop();
      setState(() {
        isListening = false;
      });
    } else {
      final available = await _speechToText.initialize();
      if (available) {
        setState(() {
          isListening = true;
        });
        await _speechToText.listen(
          onResult: (result) {
            setState(() {
              _notesController.text = result.recognizedWords;
            });
          },
        );
      }
    }
  }

  void _submitReport() async {
    if (!_validateForm()) return;
    
    setState(() {
      isSubmitting = true;
    });
    
    // Simulate API submission
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        isSubmitting = false;
      });
      
      _showSuccessDialog();
    }
  }

  void _saveOffline() async {
    if (!_validateForm()) return;
    
    setState(() {
      isSavingOffline = true;
    });
    
    // Simulate offline save
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        isSavingOffline = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report saved offline. Will sync when online.'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
      
      Navigator.of(context).pop();
    }
  }

  bool _validateForm() {
    if (selectedDistrict == null || selectedVillage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select district and village')),
      );
      return false;
    }
    
    if (_casesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter number of cases')),
      );
      return false;
    }
    
    if (selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one symptom')),
      );
      return false;
    }
    
    return true;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successGreen),
            SizedBox(width: 8),
            Text('Report Submitted'),
          ],
        ),
        content: const Text('Your report has been successfully submitted and will be reviewed by health officials.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to dashboard
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _casesController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}