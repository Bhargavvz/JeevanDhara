import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_widgets.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({Key? key}) : super(key: key);

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  List<Map<String, dynamic>> reports = [
    {
      'id': 'RPT001',
      'date': '2024-01-15',
      'time': '10:30 AM',
      'village': 'Kohima',
      'cases': 3,
      'symptoms': ['Diarrhea', 'Fever'],
      'status': 'synced',
      'reviewed': true,
    },
    {
      'id': 'RPT002',
      'date': '2024-01-14',
      'time': '2:15 PM',
      'village': 'Dimapur',
      'cases': 1,
      'symptoms': ['Vomiting', 'Dehydration'],
      'status': 'pending',
      'reviewed': false,
    },
    {
      'id': 'RPT003',
      'date': '2024-01-13',
      'time': '11:45 AM',
      'village': 'Mokokchung',
      'cases': 2,
      'symptoms': ['Fever', 'Headache'],
      'status': 'reviewed',
      'reviewed': true,
    },
    {
      'id': 'RPT004',
      'date': '2024-01-12',
      'time': '4:00 PM',
      'village': 'Tuensang',
      'cases': 5,
      'symptoms': ['Diarrhea', 'Abdominal Pain'],
      'status': 'error',
      'reviewed': false,
    },
  ];
  
  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Pending', 'Synced', 'Reviewed', 'Error'];

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

  List<Map<String, dynamic>> get filteredReports {
    if (selectedFilter == 'All') return reports;
    return reports.where((report) {
      return report['status'].toString().toLowerCase() == selectedFilter.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Reports'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _syncReports,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Summary Cards
            _buildSummarySection(),
            
            // Filter Chips
            _buildFilterChips(),
            
            // Reports List
            Expanded(
              child: _buildReportsList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection() {
    final totalReports = reports.length;
    final pendingReports = reports.where((r) => r['status'] == 'pending').length;
    final syncedReports = reports.where((r) => r['status'] == 'synced').length;
    final errorReports = reports.where((r) => r['status'] == 'error').length;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total',
              totalReports.toString(),
              Icons.assignment,
              AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: _buildSummaryCard(
              'Pending',
              pendingReports.toString(),
              Icons.sync_problem,
              AppTheme.warningOrange,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: _buildSummaryCard(
              'Synced',
              syncedReports.toString(),
              Icons.cloud_done,
              AppTheme.successGreen,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: _buildSummaryCard(
              'Errors',
              errorReports.toString(),
              Icons.error,
              AppTheme.errorRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return CustomCard(
      padding: const EdgeInsets.all(AppTheme.spacingS),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppTheme.spacingXS),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterOptions.length,
        itemBuilder: (context, index) {
          final filter = filterOptions[index];
          final isSelected = selectedFilter == filter;
          
          return Padding(
            padding: const EdgeInsets.only(right: AppTheme.spacingS),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
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

  Widget _buildReportsList() {
    final filtered = filteredReports;
    
    if (filtered.isEmpty) {
      return EmptyState(
        title: 'No Reports Found',
        subtitle: selectedFilter == 'All' 
            ? 'You haven\'t submitted any reports yet.'
            : 'No reports found for selected filter.',
        icon: Icons.assignment,
        actionText: 'Create Report',
        onAction: () {
          Navigator.of(context).pop();
        },
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final report = filtered[index];
        return _buildReportCard(report, index);
      },
    );
  }

  Widget _buildReportCard(Map<String, dynamic> report, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        onTap: () => _showReportDetails(report),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report #${report['id']}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        '${report['date']} at ${report['time']}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: report['status']),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Content
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.location_on, 'Village', report['village']),
                      const SizedBox(height: AppTheme.spacingXS),
                      _buildInfoRow(Icons.people, 'Cases', '${report['cases']} people affected'),
                      const SizedBox(height: AppTheme.spacingXS),
                      _buildInfoRow(
                        Icons.medical_services, 
                        'Symptoms', 
                        (report['symptoms'] as List).join(', '),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Actions
            Row(
              children: [
                if (report['status'] == 'error') ...[
                  CustomButton(
                    text: 'Retry',
                    onPressed: () => _retryReport(report),
                    type: ButtonType.secondary,
                    icon: Icons.refresh,
                    height: 32,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                ],
                if (report['status'] == 'pending') ...[
                  CustomButton(
                    text: 'Edit',
                    onPressed: () => _editReport(report),
                    type: ButtonType.secondary,
                    icon: Icons.edit,
                    height: 32,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                ],
                Expanded(
                  child: CustomButton(
                    text: 'View Details',
                    onPressed: () => _showReportDetails(report),
                    type: ButtonType.text,
                    icon: Icons.visibility,
                    height: 32,
                  ),
                ),
                if (report['reviewed']) ...[
                  const Icon(
                    Icons.verified,
                    color: AppTheme.successGreen,
                    size: 20,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.neutralGray),
        const SizedBox(width: AppTheme.spacingXS),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppTheme.neutralGray,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _syncReports() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Syncing reports...'),
        duration: Duration(seconds: 2),
      ),
    );
    
    // Simulate sync
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        // Update pending reports to synced
        for (var report in reports) {
          if (report['status'] == 'pending') {
            report['status'] = 'synced';
          }
        }
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reports synced successfully!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Reports'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: filterOptions.map((filter) {
            return RadioListTile<String>(
              title: Text(filter),
              value: filter,
              groupValue: selectedFilter,
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showReportDetails(Map<String, dynamic> report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.neutralGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),
                
                // Title
                Text(
                  'Report #${report['id']}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                StatusBadge(status: report['status']),
                const SizedBox(height: AppTheme.spacingL),
                
                // Details
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      _buildDetailRow('Date', '${report['date']} at ${report['time']}'),
                      _buildDetailRow('Village', report['village']),
                      _buildDetailRow('Cases', '${report['cases']} people affected'),
                      _buildDetailRow('Symptoms', (report['symptoms'] as List).join(', ')),
                      _buildDetailRow('Status', report['status']),
                      _buildDetailRow('Reviewed', report['reviewed'] ? 'Yes' : 'No'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
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

  void _retryReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Retrying report submission...')),
    );
    
    // Simulate retry
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          report['status'] = 'synced';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    });
  }

  void _editReport(Map<String, dynamic> report) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality coming soon')),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}