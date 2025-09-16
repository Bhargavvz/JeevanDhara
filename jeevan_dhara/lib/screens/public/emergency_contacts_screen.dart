import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final List<Map<String, dynamic>> emergencyContacts = [
    {
      'title': 'National Emergency',
      'number': '108',
      'description': 'National Emergency Response System',
      'icon': Icons.emergency,
      'color': AppTheme.errorRed,
      'available': '24/7',
      'services': ['Medical Emergency', 'Fire', 'Police', 'Disaster Response'],
    },
    {
      'title': 'Ambulance Service',
      'number': '102',
      'description': 'Medical Emergency Ambulance',
      'icon': Icons.local_hospital,
      'color': AppTheme.errorRed,
      'available': '24/7',
      'services': ['Emergency Transport', 'Medical Aid', 'ICU Support'],
    },
    {
      'title': 'Police Emergency',
      'number': '100',
      'description': 'Police Emergency Helpline',
      'icon': Icons.local_police,
      'color': AppTheme.primaryBlue,
      'available': '24/7',
      'services': ['Emergency Response', 'Crime Reporting', 'Security'],
    },
    {
      'title': 'Fire Service',
      'number': '101',
      'description': 'Fire & Rescue Services',
      'icon': Icons.fire_truck,
      'color': AppTheme.warningOrange,
      'available': '24/7',
      'services': ['Fire Emergency', 'Rescue Operations', 'Disaster Management'],
    },
    {
      'title': 'Women Helpline',
      'number': '1091',
      'description': 'Women Emergency Helpline',
      'icon': Icons.support_agent,
      'color': AppTheme.primaryBlue,
      'available': '24/7',
      'services': ['Women Safety', 'Domestic Violence', 'Emergency Support'],
    },
    {
      'title': 'Child Helpline',
      'number': '1098',
      'description': 'Child Emergency & Support',
      'icon': Icons.child_care,
      'color': AppTheme.successGreen,
      'available': '24/7',
      'services': ['Child Protection', 'Emergency Support', 'Counseling'],
    },
    {
      'title': 'Disaster Management',
      'number': '1070',
      'description': 'National Disaster Management',
      'icon': Icons.warning,
      'color': AppTheme.warningOrange,
      'available': '24/7',
      'services': ['Disaster Response', 'Relief Operations', 'Coordination'],
    },
  ];

  final List<Map<String, dynamic>> localContacts = [
    {
      'title': 'District Collector Office',
      'number': '+91-9876543210',
      'description': 'Kohima District Administration',
      'icon': Icons.account_balance,
      'color': AppTheme.primaryGreen,
      'available': '9 AM - 5 PM',
      'services': ['Administration', 'Public Services', 'Emergency Coordination'],
    },
    {
      'title': 'Chief Medical Officer',
      'number': '+91-9876543211',
      'description': 'District Health Office',
      'icon': Icons.medical_services,
      'color': AppTheme.primaryBlue,
      'available': '24/7',
      'services': ['Health Emergency', 'Medical Support', 'Health Policy'],
    },
    {
      'title': 'ASHA Coordinator',
      'number': '+91-9876543212',
      'description': 'Community Health Coordinator',
      'icon': Icons.people,
      'color': AppTheme.infoBlue,
      'available': '8 AM - 8 PM',
      'services': ['Community Health', 'Health Education', 'Referral Services'],
    },
    {
      'title': 'Water Quality Control',
      'number': '+91-9876543213',
      'description': 'Public Health Engineering',
      'icon': Icons.water_drop,
      'color': AppTheme.primaryBlue,
      'available': '9 AM - 6 PM',
      'services': ['Water Testing', 'Quality Control', 'Contamination Report'],
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildEmergencyHeader(),
              _buildEmergencyContactsList(),
              _buildLocalContactsList(),
              _buildEmergencyTips(),
              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Emergency Contacts'),
      backgroundColor: AppTheme.errorRed,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareContacts,
        ),
      ],
    );
  }

  Widget _buildEmergencyHeader() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: CustomCard(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.errorRed.withOpacity(0.1),
                AppTheme.warningOrange.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              children: [
                Icon(
                  Icons.emergency,
                  size: 48,
                  color: AppTheme.errorRed,
                ),
                const SizedBox(height: AppTheme.spacingM),
                Text(
                  'Emergency Services',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.errorRed,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  'In case of medical emergency, call the numbers below immediately. '
                  'For water-borne disease symptoms, contact health services.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingM),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _callNumber('108'),
                        icon: const Icon(Icons.call, color: Colors.white),
                        label: const Text('Call 108'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorRed,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _callNumber('102'),
                        icon: const Icon(Icons.local_hospital),
                        label: const Text('Ambulance'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.errorRed,
                          side: const BorderSide(color: AppTheme.errorRed),
                        ),
                      ),
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

  Widget _buildEmergencyContactsList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'National Emergency Numbers',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...emergencyContacts.map((contact) => _buildContactCard(contact, true)),
        ],
      ),
    );
  }

  Widget _buildLocalContactsList() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Local Health & Administrative Contacts',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...localContacts.map((contact) => _buildContactCard(contact, false)),
        ],
      ),
    );
  }

  Widget _buildContactCard(Map<String, dynamic> contact, bool isEmergency) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        child: InkWell(
          onTap: () => _showContactDetails(contact),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: contact['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    contact['icon'],
                    color: contact['color'],
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              contact['title'],
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isEmergency)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.errorRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '24/7',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppTheme.errorRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact['description'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.neutralGray,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingS),
                      Row(
                        children: [
                          Text(
                            contact['number'],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: contact['color'],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _callNumber(contact['number']),
                            icon: Icon(
                              Icons.call,
                              color: contact['color'],
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyTips() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: AppTheme.warningOrange,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  'Emergency Tips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            _buildTipItem('Stay calm and speak clearly when calling emergency services'),
            _buildTipItem('Provide your exact location and describe the emergency'),
            _buildTipItem('For water-borne diseases: Stay hydrated and seek immediate medical help'),
            _buildTipItem('Keep these numbers saved in your phone for quick access'),
            _buildTipItem('In case of outbreak symptoms, report to ASHA worker immediately'),
            
            const SizedBox(height: AppTheme.spacingM),
            
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.infoBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.infoBlue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info,
                    color: AppTheme.infoBlue,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: Text(
                      'Share these contacts with your family and community members.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.infoBlue,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: AppTheme.primaryGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _callNumber(String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Emergency Service'),
        content: Text(
          'Do you want to call $number?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling $number...'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
              foregroundColor: Colors.white,
            ),
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  void _showContactDetails(Map<String, dynamic> contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: contact['color'].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        contact['icon'],
                        color: contact['color'],
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact['title'],
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            contact['description'],
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.neutralGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                _buildDetailItem('Phone Number', contact['number']),
                _buildDetailItem('Available', contact['available']),
                
                const SizedBox(height: AppTheme.spacingM),
                
                Text(
                  'Services',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                ...contact['services'].map((service) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: contact['color']),
                      const SizedBox(width: AppTheme.spacingS),
                      Text(service),
                    ],
                  ),
                )),
                
                const SizedBox(height: AppTheme.spacingL),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _callNumber(contact['number']);
                    },
                    icon: const Icon(Icons.call, color: Colors.white),
                    label: const Text('Call Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: contact['color'],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
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

  void _shareContacts() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency contacts shared successfully'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}