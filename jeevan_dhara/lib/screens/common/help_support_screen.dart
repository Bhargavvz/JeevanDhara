import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  
  final List<Map<String, dynamic>> faqItems = [
    {
      'question': 'How do I report water quality issues?',
      'answer': 'Go to the Water Quality Reporting section from the main menu. Follow the step-by-step process to assess and report water quality issues in your area.',
    },
    {
      'question': 'What should I do if I have symptoms of a water-borne disease?',
      'answer': 'Use the Symptom Checker to assess your symptoms. Seek immediate medical attention if symptoms are severe. Contact emergency services at 108 if needed.',
    },
    {
      'question': 'How accurate is the health self-assessment?',
      'answer': 'The self-assessment is a screening tool only. It cannot replace professional medical diagnosis. Always consult healthcare providers for medical concerns.',
    },
    {
      'question': 'Can I use the app offline?',
      'answer': 'Yes, many features work offline. Data will sync automatically when you regain internet connection. Critical features like emergency contacts are always available.',
    },
    {
      'question': 'How is my data protected?',
      'answer': 'We use industry-standard encryption and follow strict privacy guidelines. You can control data sharing preferences in Privacy Settings.',
    },
    {
      'question': 'How do I change the app language?',
      'answer': 'Go to Settings > Appearance > Language. Select your preferred language from the available options including regional and tribal languages.',
    },
  ];

  final List<Map<String, dynamic>> supportContacts = [
    {
      'title': 'Technical Support',
      'description': 'App issues and technical problems',
      'icon': Icons.build,
      'contact': 'tech-support@jeevandhara.in',
      'phone': '+91-8000-123-456',
      'hours': '9 AM - 6 PM (Mon-Fri)',
    },
    {
      'title': 'Health Support',
      'description': 'Health-related questions and guidance',
      'icon': Icons.medical_services,
      'contact': 'health-support@jeevandhara.in',
      'phone': '+91-8000-123-457',
      'hours': '24/7',
    },
    {
      'title': 'Community Support',
      'description': 'Community features and forums',
      'icon': Icons.groups,
      'contact': 'community@jeevandhara.in',
      'phone': '+91-8000-123-458',
      'hours': '8 AM - 8 PM (Mon-Sun)',
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
                  _buildFAQTab(),
                  _buildContactSupportTab(),
                  _buildTutorialsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startLiveChat,
        backgroundColor: AppTheme.primaryBlue,
        icon: const Icon(Icons.chat, color: Colors.white),
        label: const Text('Live Chat', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Help & Support'),
      backgroundColor: AppTheme.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _showSearchDialog,
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
          Tab(icon: Icon(Icons.help), text: 'FAQ'),
          Tab(icon: Icon(Icons.contact_support), text: 'Contact'),
          Tab(icon: Icon(Icons.play_circle), text: 'Tutorials'),
        ],
      ),
    );
  }

  Widget _buildFAQTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickActions(),
          const SizedBox(height: AppTheme.spacingL),
          Text(
            'Frequently Asked Questions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...faqItems.map((item) => _buildFAQItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildContactSupportTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Support',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Choose the type of support you need',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          ...supportContacts.map((contact) => _buildSupportContactCard(contact)).toList(),
          
          const SizedBox(height: AppTheme.spacingL),
          _buildContactForm(),
        ],
      ),
    );
  }

  Widget _buildTutorialsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Video Tutorials',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildTutorialCard(
            'Getting Started',
            'Learn the basics of using Jeevan Dhara',
            '5:30',
            Icons.play_circle_fill,
          ),
          _buildTutorialCard(
            'Water Quality Reporting',
            'How to report water quality issues',
            '3:45',
            Icons.water_drop,
          ),
          _buildTutorialCard(
            'Health Assessment',
            'Using the health self-assessment tool',
            '4:20',
            Icons.health_and_safety,
          ),
          _buildTutorialCard(
            'Emergency Features',
            'Accessing emergency contacts and alerts',
            '2:15',
            Icons.emergency,
          ),
          _buildTutorialCard(
            'Community Forums',
            'Participating in community discussions',
            '6:10',
            Icons.forum,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Emergency Help',
                  Icons.emergency,
                  AppTheme.errorRed,
                  _callEmergency,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: _buildQuickActionButton(
                  'Report Bug',
                  Icons.bug_report,
                  AppTheme.warningOrange,
                  _reportBug,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        child: ExpansionTile(
          title: Text(
            item['question'],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Text(
                item['answer'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportContactCard(Map<String, dynamic> contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(contact['icon'], color: AppTheme.primaryBlue),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['title'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        contact['description'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.neutralGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            _buildContactInfo(Icons.email, contact['contact']),
            _buildContactInfo(Icons.phone, contact['phone']),
            _buildContactInfo(Icons.schedule, contact['hours']),
            
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _callSupport(contact['phone']),
                    icon: const Icon(Icons.phone, size: 16),
                    label: const Text('Call'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _emailSupport(contact['contact']),
                    icon: const Icon(Icons.email, size: 16),
                    label: const Text('Email'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppTheme.neutralGray),
          const SizedBox(width: AppTheme.spacingS),
          Text(
            info,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Send us a message',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Subject',
              hintText: 'Brief description of your issue',
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Message',
              hintText: 'Describe your issue in detail...',
              alignLabelWithHint: true,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Priority',
            ),
            items: ['Low', 'Medium', 'High', 'Urgent'].map((priority) {
              return DropdownMenuItem(value: priority, child: Text(priority));
            }).toList(),
            onChanged: (value) {},
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          CustomButton(
            text: 'Send Message',
            onPressed: _sendMessage,
            icon: Icons.send,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(
    String title,
    String description,
    String duration,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        onTap: () => _playTutorial(title),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: 32),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralGray,
                    ),
                  ),
                  Text(
                    duration,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_arrow, color: AppTheme.primaryBlue),
          ],
        ),
      ),
    );
  }

  void _callEmergency() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calling emergency services: 108'),
        backgroundColor: AppTheme.errorRed,
      ),
    );
  }

  void _reportBug() {
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
        builder: (context, scrollController) => _buildBugReportForm(scrollController),
      ),
    );
  }

  Widget _buildBugReportForm(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Report a Bug',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Bug Title',
                hintText: 'Brief description of the bug',
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Steps to Reproduce',
                hintText: 'Describe how to reproduce this bug...',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Expected vs Actual Behavior',
                hintText: 'What should happen vs what actually happens...',
                alignLabelWithHint: true,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppTheme.spacingL),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitBugReport,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitBugReport() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bug report submitted. Thank you!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _callSupport(String phone) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phone')),
    );
  }

  void _emailSupport(String email) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening email to $email')),
    );
  }

  void _sendMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent successfully!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _playTutorial(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing tutorial: $title')),
    );
  }

  void _startLiveChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Starting live chat with support...')),
    );
  }

  void _showSearchDialog() {
    showSearch(
      context: context,
      delegate: HelpSearchDelegate(faqItems),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

class SingleScrollView extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const SingleScrollView({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding,
      child: child,
    );
  }
}

class HelpSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> faqItems;

  HelpSearchDelegate(this.faqItems);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = faqItems.where((item) {
      return item['question'].toLowerCase().contains(query.toLowerCase()) ||
             item['answer'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          title: Text(item['question']),
          subtitle: Text(
            item['answer'],
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }
}