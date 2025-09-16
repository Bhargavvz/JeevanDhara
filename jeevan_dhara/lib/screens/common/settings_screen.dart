import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';
import 'help_support_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  Map<String, dynamic> settings = {
    'notifications': true,
    'location_services': true,
    'offline_sync': true,
    'data_saver': false,
    'dark_mode': false,
    'language': 'English',
    'auto_backup': true,
    'push_notifications': true,
    'email_notifications': false,
    'sound_enabled': true,
    'vibration_enabled': true,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildNotificationSettings(),
              _buildAppearanceSettings(),
              _buildDataSettings(),
              _buildLocationSettings(),
              _buildAccountSettings(),
              _buildAboutSection(),
              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Settings'),
      backgroundColor: AppTheme.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _resetToDefaults,
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return _buildSettingsSection(
      'Notifications',
      Icons.notifications,
      [
        _buildSwitchSetting(
          'Push Notifications',
          'Receive important alerts and updates',
          'push_notifications',
        ),
        _buildSwitchSetting(
          'Email Notifications',
          'Get updates via email',
          'email_notifications',
        ),
        _buildSwitchSetting(
          'Sound',
          'Play sounds for notifications',
          'sound_enabled',
        ),
        _buildSwitchSetting(
          'Vibration',
          'Vibrate for notifications',
          'vibration_enabled',
        ),
        _buildNavigationSetting(
          'Notification Categories',
          'Customize which notifications you receive',
          Icons.category,
          _openNotificationCategories,
        ),
      ],
    );
  }

  Widget _buildAppearanceSettings() {
    return _buildSettingsSection(
      'Appearance',
      Icons.palette,
      [
        _buildSwitchSetting(
          'Dark Mode',
          'Use dark theme for the app',
          'dark_mode',
        ),
        _buildDropdownSetting(
          'Language',
          'Choose your preferred language',
          'language',
          ['English', 'हिंदी', 'অসমীয়া', 'नेपाली', 'Tribal Languages'],
          Icons.language,
        ),
        _buildNavigationSetting(
          'Font Size',
          'Adjust text size for better readability',
          Icons.font_download,
          _openFontSettings,
        ),
      ],
    );
  }

  Widget _buildDataSettings() {
    return _buildSettingsSection(
      'Data & Storage',
      Icons.storage,
      [
        _buildSwitchSetting(
          'Auto Backup',
          'Automatically backup your data',
          'auto_backup',
        ),
        _buildSwitchSetting(
          'Offline Sync',
          'Sync data when connection is restored',
          'offline_sync',
        ),
        _buildSwitchSetting(
          'Data Saver',
          'Reduce data usage',
          'data_saver',
        ),
        _buildNavigationSetting(
          'Clear Cache',
          'Free up storage space',
          Icons.delete_sweep,
          _clearCache,
        ),
        _buildNavigationSetting(
          'Export Data',
          'Download your data',
          Icons.download,
          _exportData,
        ),
      ],
    );
  }

  Widget _buildLocationSettings() {
    return _buildSettingsSection(
      'Location & Privacy',
      Icons.location_on,
      [
        _buildSwitchSetting(
          'Location Services',
          'Allow app to access your location',
          'location_services',
        ),
        _buildNavigationSetting(
          'Privacy Settings',
          'Manage your privacy preferences',
          Icons.privacy_tip,
          _openPrivacySettings,
        ),
        _buildNavigationSetting(
          'Data Sharing',
          'Control how your data is shared',
          Icons.share,
          _openDataSharing,
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return _buildSettingsSection(
      'Account',
      Icons.account_circle,
      [
        _buildNavigationSetting(
          'Profile Management',
          'Edit your profile information',
          Icons.person,
          _openProfileManagement,
        ),
        _buildNavigationSetting(
          'Security Settings',
          'Manage passwords and security',
          Icons.security,
          _openSecuritySettings,
        ),
        _buildNavigationSetting(
          'Subscription',
          'Manage your subscription',
          Icons.credit_card,
          _openSubscription,
        ),
        _buildNavigationSetting(
          'Sign Out',
          'Sign out of your account',
          Icons.logout,
          _signOut,
          color: AppTheme.errorRed,
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSettingsSection(
      'About',
      Icons.info,
      [
        _buildNavigationSetting(
          'Help & Support',
          'Get help and contact support',
          Icons.help,
          _openHelpSupport,
        ),
        _buildNavigationSetting(
          'Terms of Service',
          'Read our terms of service',
          Icons.description,
          _openTerms,
        ),
        _buildNavigationSetting(
          'Privacy Policy',
          'Read our privacy policy',
          Icons.privacy_tip,
          _openPrivacyPolicy,
        ),
        _buildInfoSetting(
          'Version',
          '1.0.0',
          Icons.info_outline,
        ),
      ],
    );
  }

  Widget _buildSettingsSection(
    String title,
    IconData icon,
    List<Widget> settings,
  ) {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryGreen),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            ...settings,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchSetting(String title, String description, String key) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        children: [
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
              ],
            ),
          ),
          Switch(
            value: settings[key] ?? false,
            onChanged: (value) {
              setState(() {
                settings[key] = value;
              });
              _saveSettings();
            },
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String description,
    String key,
    List<String> options,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.neutralGray, size: 20),
          const SizedBox(width: AppTheme.spacingS),
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
              ],
            ),
          ),
          DropdownButton<String>(
            value: settings[key],
            underline: const SizedBox(),
            items: options.map((option) {
              return DropdownMenuItem(value: option, child: Text(option));
            }).toList(),
            onChanged: (value) {
              setState(() {
                settings[key] = value;
              });
              _saveSettings();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationSetting(
    String title,
    String description,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingS),
          child: Row(
            children: [
              Icon(icon, color: color ?? AppTheme.neutralGray, size: 20),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutralGray,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: color ?? AppTheme.neutralGray,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSetting(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.neutralGray, size: 20),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    // Save settings to local storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                settings = {
                  'notifications': true,
                  'location_services': true,
                  'offline_sync': true,
                  'data_saver': false,
                  'dark_mode': false,
                  'language': 'English',
                  'auto_backup': true,
                  'push_notifications': true,
                  'email_notifications': false,
                  'sound_enabled': true,
                  'vibration_enabled': true,
                };
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings reset to defaults'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _openNotificationCategories() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotificationCategoriesScreen(),
      ),
    );
  }

  void _openFontSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Font settings coming soon')),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will free up storage space but may slow down the app temporarily.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparing data export...')),
    );
  }

  void _openPrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening privacy settings')),
    );
  }

  void _openDataSharing() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening data sharing settings')),
    );
  }

  void _openProfileManagement() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening profile management')),
    );
  }

  void _openSecuritySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening security settings')),
    );
  }

  void _openSubscription() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening subscription management')),
    );
  }

  void _signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out successfully'),
                  backgroundColor: AppTheme.successGreen,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _openHelpSupport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpSupportScreen(),
      ),
    );
  }

  void _openTerms() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening terms of service')),
    );
  }

  void _openPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening privacy policy')),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class NotificationCategoriesScreen extends StatefulWidget {
  const NotificationCategoriesScreen({super.key});

  @override
  State<NotificationCategoriesScreen> createState() => _NotificationCategoriesScreenState();
}

class _NotificationCategoriesScreenState extends State<NotificationCategoriesScreen> {
  Map<String, bool> notificationCategories = {
    'health_alerts': true,
    'water_quality': true,
    'disease_outbreaks': true,
    'weather_warnings': false,
    'community_updates': true,
    'system_updates': true,
    'tips_advice': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Categories'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          children: [
            _buildCategorySection(
              'Critical Alerts',
              [
                _buildCategory('health_alerts', 'Health Alerts', 'Emergency health notifications'),
                _buildCategory('water_quality', 'Water Quality', 'Water contamination alerts'),
                _buildCategory('disease_outbreaks', 'Disease Outbreaks', 'Disease outbreak warnings'),
              ],
            ),
            _buildCategorySection(
              'General Notifications',
              [
                _buildCategory('weather_warnings', 'Weather Warnings', 'Severe weather alerts'),
                _buildCategory('community_updates', 'Community Updates', 'Community news and updates'),
                _buildCategory('system_updates', 'System Updates', 'App updates and maintenance'),
                _buildCategory('tips_advice', 'Tips & Advice', 'Health tips and advice'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Widget> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        CustomCard(
          child: Column(children: categories),
        ),
        const SizedBox(height: AppTheme.spacingL),
      ],
    );
  }

  Widget _buildCategory(String key, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        children: [
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
              ],
            ),
          ),
          Switch(
            value: notificationCategories[key] ?? false,
            onChanged: (value) {
              setState(() {
                notificationCategories[key] = value;
              });
            },
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }
}