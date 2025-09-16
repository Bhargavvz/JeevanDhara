import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_widgets.dart';
import 'official_dashboard_screen.dart';

class OfficialLoginScreen extends StatefulWidget {
  const OfficialLoginScreen({Key? key}) : super(key: key);

  @override
  State<OfficialLoginScreen> createState() => _OfficialLoginScreenState();
}

class _OfficialLoginScreenState extends State<OfficialLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  void _startAnimations() {
    _animationController.forward();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Navigate to dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const OfficialDashboardScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Health Official Login'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.darkGray,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: 'Authenticating...',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Header Section
                    _buildHeader(),
                    
                    const SizedBox(height: AppTheme.spacingXXL),
                    
                    // Security Notice
                    _buildSecurityNotice(),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Login Form
                    _buildLoginForm(),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Login Button
                    _buildLoginButton(),
                    
                    const SizedBox(height: AppTheme.spacingM),
                    
                    // Footer Options
                    _buildFooterOptions(),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Access Information
                    _buildAccessInfo(),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Support Section
                    _buildSupportSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Official Icon with Gradient
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryBlue, AppTheme.primaryBlue.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.analytics,
            size: 50,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingM),
        
        Text(
          'Health Official Portal',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGray,
          ),
        ),
        
        const SizedBox(height: AppTheme.spacingS),
        
        Text(
          'Secure access to health monitoring dashboard',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.neutralGray,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSecurityNotice() {
    return CustomCard(
      color: AppTheme.primaryBlue.withOpacity(0.05),
      child: Row(
        children: [
          const Icon(
            Icons.security,
            color: AppTheme.primaryBlue,
            size: 24,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Login',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  'This is a secure portal for authorized health officials only.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Username/Employee ID Field
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Employee ID or Username',
              hintText: 'Enter your official ID',
              prefixIcon: Icon(Icons.badge),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your employee ID or username';
              }
              return null;
            },
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Password Field
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your secure password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _login(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < AppConstants.minPasswordLength) {
                return 'Password must be at least ${AppConstants.minPasswordLength} characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Secure Login',
        onPressed: _login,
        isLoading: _isLoading,
        type: ButtonType.primary,
        height: 56,
        icon: Icons.login,
      ),
    );
  }

  Widget _buildFooterOptions() {
    return Column(
      children: [
        // Remember Me
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: AppTheme.primaryBlue,
            ),
            Text(
              'Keep me signed in (secure device only)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        
        // Forgot Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _showForgotPasswordDialog();
              },
              child: const Text('Forgot Password?'),
            ),
            TextButton(
              onPressed: () {
                _showTwoFactorInfo();
              },
              child: const Text('2FA Setup'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAccessInfo() {
    return CustomCard(
      color: AppTheme.lightGreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.admin_panel_settings,
                color: AppTheme.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Health Official Access',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'As a health official, you have access to:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          _buildFeatureItem('Comprehensive health data dashboard'),
          _buildFeatureItem('Disease outbreak prediction analytics'),
          _buildFeatureItem('Real-time alert management'),
          _buildFeatureItem('ASHA worker report monitoring'),
          _buildFeatureItem('District-wise health statistics'),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppTheme.primaryGreen,
            size: 16,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return CustomCard(
      color: AppTheme.warningOrange.withOpacity(0.05),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.support_agent,
                color: AppTheme.warningOrange,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Technical Support',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.warningOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'For login issues or technical support, contact the IT helpdesk.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'IT Helpdesk',
                  onPressed: () {
                    // Implement call functionality
                  },
                  type: ButtonType.secondary,
                  icon: Icons.phone,
                  height: 40,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: CustomButton(
                  text: 'System Manual',
                  onPressed: () {
                    // Navigate to manual
                  },
                  type: ButtonType.secondary,
                  icon: Icons.book,
                  height: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password Reset'),
        content: const Text(
          'Please contact the system administrator or IT helpdesk to reset your password. For security reasons, password reset requires verification through official channels.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Call IT helpdesk
            },
            child: const Text('Contact IT'),
          ),
        ],
      ),
    );
  }

  void _showTwoFactorInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Two-Factor Authentication'),
        content: const Text(
          'For enhanced security, contact the IT administrator to enable two-factor authentication on your account.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}