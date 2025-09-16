import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> profileData = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+91-9876543210',
    'location': 'Kohima, Nagaland',
    'age': '25',
    'gender': 'Male',
    'occupation': 'Farmer',
    'emergency_contact': '+91-9876543211',
    'health_conditions': ['None'],
    'preferred_language': 'English',
  };

  bool isEditing = false;

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
              _buildProfileHeader(),
              _buildProfileForm(),
              _buildQuickActions(),
              const SizedBox(height: AppTheme.spacingXL),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Profile Management'),
      backgroundColor: AppTheme.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: Icon(isEditing ? Icons.save : Icons.edit),
          onPressed: isEditing ? _saveProfile : _toggleEditing,
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryGreen,
                child: Text(
                  profileData['name']?.substring(0, 2).toUpperCase() ?? 'JD',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _changeProfilePicture,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            profileData['name'] ?? 'Unknown User',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            profileData['location'] ?? 'Location not set',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildPersonalInfoSection(),
            const SizedBox(height: AppTheme.spacingL),
            _buildContactInfoSection(),
            const SizedBox(height: AppTheme.spacingL),
            _buildHealthInfoSection(),
            const SizedBox(height: AppTheme.spacingL),
            _buildPreferencesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildFormField(
            'Full Name',
            'name',
            Icons.person,
            validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          Row(
            children: [
              Expanded(
                child: _buildFormField('Age', 'age', Icons.calendar_today),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: _buildDropdownField(
                  'Gender',
                  'gender',
                  Icons.person_outline,
                  ['Male', 'Female', 'Other', 'Prefer not to say'],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildFormField('Occupation', 'occupation', Icons.work),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildFormField(
            'Email',
            'email',
            Icons.email,
            validator: (value) {
              if (value?.isEmpty == true) return 'Email is required';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildFormField('Phone Number', 'phone', Icons.phone),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildFormField('Location', 'location', Icons.location_on),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildFormField(
            'Emergency Contact',
            'emergency_contact',
            Icons.emergency,
            validator: (value) => value?.isEmpty == true ? 'Emergency contact is required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthInfoSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          Text(
            'Health Conditions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          
          if (isEditing) ...[
            Wrap(
              spacing: AppTheme.spacingS,
              children: [
                'Diabetes',
                'Hypertension',
                'Heart Disease',
                'Kidney Disease',
                'Allergies',
                'None',
              ].map((condition) {
                final isSelected = (profileData['health_conditions'] as List).contains(condition);
                return FilterChip(
                  label: Text(condition),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      final conditions = profileData['health_conditions'] as List<String>;
                      if (selected) {
                        if (condition == 'None') {
                          conditions.clear();
                        } else {
                          conditions.remove('None');
                        }
                        conditions.add(condition);
                      } else {
                        conditions.remove(condition);
                        if (conditions.isEmpty) {
                          conditions.add('None');
                        }
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ] else ...[
            Text(
              (profileData['health_conditions'] as List).join(', '),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreferencesSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preferences',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          _buildDropdownField(
            'Preferred Language',
            'preferred_language',
            Icons.language,
            ['English', 'हिंदी', 'অসমীয়া', 'नेपाली', 'Tribal Languages'],
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    String key,
    IconData icon, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: profileData[key]?.toString(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      enabled: isEditing,
      validator: validator,
      onChanged: (value) {
        profileData[key] = value;
      },
    );
  }

  Widget _buildDropdownField(
    String label,
    String key,
    IconData icon,
    List<String> options,
  ) {
    return DropdownButtonFormField<String>(
      value: profileData[key],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      items: options.map((option) {
        return DropdownMenuItem(value: option, child: Text(option));
      }).toList(),
      onChanged: isEditing ? (value) {
        setState(() {
          profileData[key] = value;
        });
      } : null,
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          _buildActionCard(
            'Health Data Export',
            'Export your health data for healthcare providers',
            Icons.download,
            AppTheme.primaryBlue,
            _exportHealthData,
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildActionCard(
            'Privacy Settings',
            'Manage your data privacy and sharing preferences',
            Icons.privacy_tip,
            AppTheme.warningOrange,
            _openPrivacySettings,
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildActionCard(
            'Account Security',
            'Update password and security settings',
            Icons.security,
            AppTheme.primaryGreen,
            _openSecuritySettings,
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildActionCard(
            'Delete Account',
            'Permanently delete your account and data',
            Icons.delete_forever,
            AppTheme.errorRed,
            _confirmDeleteAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
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
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppTheme.neutralGray),
        ],
      ),
    );
  }

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  void _changeProfilePicture() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _chooseFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _takePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Camera feature coming soon')),
    );
  }

  void _chooseFromGallery() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gallery feature coming soon')),
    );
  }

  void _exportHealthData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting health data...')),
    );
  }

  void _openPrivacySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacySettingsScreen(),
      ),
    );
  }

  void _openSecuritySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SecuritySettingsScreen(),
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteAccount();
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account deletion initiated. Please contact support.'),
        backgroundColor: AppTheme.errorRed,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  Map<String, bool> privacySettings = {
    'data_sharing': true,
    'location_tracking': true,
    'health_data_sharing': false,
    'anonymous_reports': true,
    'marketing_emails': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          children: [
            _buildPrivacySetting(
              'Data Sharing',
              'Allow sharing anonymized data with health authorities',
              'data_sharing',
            ),
            _buildPrivacySetting(
              'Location Tracking',
              'Enable location services for nearby facilities',
              'location_tracking',
            ),
            _buildPrivacySetting(
              'Health Data Sharing',
              'Share health assessment data with healthcare providers',
              'health_data_sharing',
            ),
            _buildPrivacySetting(
              'Anonymous Reports',
              'Submit water quality reports anonymously',
              'anonymous_reports',
            ),
            _buildPrivacySetting(
              'Marketing Emails',
              'Receive health tips and updates via email',
              'marketing_emails',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySetting(String title, String description, String key) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
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
            value: privacySettings[key] ?? false,
            onChanged: (value) {
              setState(() {
                privacySettings[key] = value;
              });
            },
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }
}

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isBiometricEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildPasswordSection(),
              const SizedBox(height: AppTheme.spacingL),
              _buildBiometricSection(),
              const SizedBox(height: AppTheme.spacingL),
              _buildTwoFactorSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Change Password',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Current Password',
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) => value?.isEmpty == true ? 'Required' : null,
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'New Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) {
              if (value?.isEmpty == true) return 'Required';
              if (value!.length < 8) return 'Password must be at least 8 characters';
              return null;
            },
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Confirm New Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
            validator: (value) => value?.isEmpty == true ? 'Required' : null,
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          CustomButton(
            text: 'Update Password',
            onPressed: _updatePassword,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricSection() {
    return CustomCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biometric Authentication',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Use fingerprint or face ID to access the app',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isBiometricEnabled,
            onChanged: (value) {
              setState(() {
                isBiometricEnabled = value;
              });
            },
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildTwoFactorSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Two-Factor Authentication',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Add an extra layer of security to your account',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          
          CustomButton(
            text: 'Enable Two-Factor Authentication',
            onPressed: _enableTwoFactor,
            type: ButtonType.secondary,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  void _updatePassword() {
    if (_formKey.currentState?.validate() == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully!'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  void _enableTwoFactor() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Two-factor authentication setup coming soon')),
    );
  }
}