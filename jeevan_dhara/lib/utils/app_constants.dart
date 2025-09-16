class AppConstants {
  // App Info
  static const String appName = 'Jeevan Dhara';
  static const String appTagline = 'Clean Water, Healthy Communities';
  static const String appVersion = '1.0.0';
  
  // User Roles
  static const String roleASHA = 'asha';
  static const String roleHealthOfficial = 'health_official';
  static const String rolePublic = 'public';
  
  // Route Names
  static const String splashRoute = '/';
  static const String roleSelectionRoute = '/role-selection';
  
  // ASHA Routes
  static const String ashaLoginRoute = '/asha/login';
  static const String ashaDashboardRoute = '/asha/dashboard';
  static const String caseReportingRoute = '/asha/case-reporting';
  static const String myReportsRoute = '/asha/my-reports';
  static const String reportDetailRoute = '/asha/report-detail';
  
  // Health Official Routes
  static const String officialLoginRoute = '/official/login';
  static const String officialDashboardRoute = '/official/dashboard';
  static const String dataVisualizationRoute = '/official/data-visualization';
  static const String alertsRoute = '/official/alerts';
  static const String outbreakPredictionRoute = '/official/outbreak-prediction';
  
  // Public Routes
  static const String publicHomeRoute = '/public/home';
  static const String educationalModulesRoute = '/public/education';
  static const String awarenessCampaignsRoute = '/public/awareness';
  static const String moduleDetailRoute = '/public/module-detail';
  
  // Symptoms
  static const List<String> symptoms = [
    'Diarrhea',
    'Fever',
    'Vomiting',
    'Nausea',
    'Abdominal Pain',
    'Dehydration',
    'Fatigue',
    'Headache',
    'Muscle Aches',
    'Loss of Appetite',
  ];
  
  // Water Source Conditions
  static const List<String> waterSourceConditions = [
    'Turbid/Cloudy',
    'Foul Smell',
    'Unusual Color',
    'Visible Contamination',
    'Algae Growth',
    'Dead Animals Nearby',
    'Industrial Waste',
    'Human/Animal Waste',
    'Chemicals/Oil',
    'No Issues',
  ];
  
  // Villages/Communities (Northeast India)
  static const List<String> villages = [
    'Dimapur',
    'Kohima',
    'Mokokchung',
    'Tuensang',
    'Mon',
    'Wokha',
    'Zunheboto',
    'Phek',
    'Kiphire',
    'Longleng',
    'Peren',
    'Guwahati',
    'Silchar',
    'Dibrugarh',
    'Jorhat',
    'Nagaon',
    'Tinsukia',
    'Tezpur',
    'Bongaigaon',
    'Dhubri',
    'Imphal East',
    'Imphal West',
    'Thoubal',
    'Bishnupur',
    'Churachandpur',
    'Chandel',
    'Ukhrul',
    'Senapati',
    'Tamenglong',
    'Aizawl',
    'Lunglei',
    'Champhai',
    'Kolasib',
    'Lawngtlai',
    'Mamit',
    'Saiha',
    'Serchhip',
    'Itanagar',
    'Naharlagun',
    'Pasighat',
    'Namsai',
    'Changlang',
    'Tirap',
    'Shillong',
    'Tura',
    'Jowai',
    'Nongpoh',
    'Baghmara',
    'Williamnagar',
    'Agartala',
    'Dharmanagar',
    'Udaipur',
    'Kailashahar',
    'Belonia',
    'Khowai',
    'Ambassa',
    'Teliamura',
  ];
  
  // Districts (Northeast India)
  static const List<String> districts = [
    // Assam
    'Kamrup',
    'Cachar',
    'Dibrugarh',
    'Jorhat',
    'Nagaon',
    'Sivasagar',
    'Tinsukia',
    'Sonitpur',
    'Bongaigaon',
    'Dhubri',
    'Goalpara',
    'Kokrajhar',
    'Nalbari',
    'Darrang',
    'Morigaon',
    
    // Nagaland
    'Dimapur',
    'Kohima',
    'Mokokchung',
    'Tuensang',
    'Mon',
    'Wokha',
    'Zunheboto',
    'Phek',
    'Kiphire',
    'Longleng',
    'Peren',
    
    // Manipur
    'Imphal East',
    'Imphal West',
    'Thoubal',
    'Bishnupur',
    'Churachandpur',
    'Chandel',
    'Ukhrul',
    'Senapati',
    'Tamenglong',
    
    // Mizoram
    'Aizawl',
    'Lunglei',
    'Champhai',
    'Kolasib',
    'Lawngtlai',
    'Mamit',
    'Saiha',
    'Serchhip',
    
    // Arunachal Pradesh
    'Itanagar',
    'East Siang',
    'West Siang',
    'Changlang',
    'Tirap',
    'Lower Subansiri',
    'Upper Subansiri',
    'West Kameng',
    'East Kameng',
    
    // Meghalaya
    'East Khasi Hills',
    'West Khasi Hills',
    'East Garo Hills',
    'West Garo Hills',
    'South Garo Hills',
    'Ri Bhoi',
    'Jaintia Hills',
    
    // Tripura
    'West Tripura',
    'North Tripura',
    'South Tripura',
    'Dhalai',
    'Unakoti',
    'Khowai',
    'Gomati',
    'Sepahijala',
  ];
  
  // Languages
  static const List<Map<String, String>> languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिंदी'},
    {'code': 'as', 'name': 'অসমীয়া'}, // Assamese
    {'code': 'bn', 'name': 'বাংলা'}, // Bengali
    {'code': 'mni', 'name': 'মেইতেই'}, // Manipuri
    {'code': 'lus', 'name': 'Mizo'}, // Mizo
    {'code': 'grt', 'name': 'Garo'}, // Garo
    {'code': 'kha', 'name': 'Khasi'}, // Khasi
  ];
  
  // Report Status
  static const String statusPending = 'pending';
  static const String statusSynced = 'synced';
  static const String statusReviewed = 'reviewed';
  static const String statusError = 'error';
  
  // Alert Severity
  static const String severityHigh = 'high';
  static const String severityMedium = 'medium';
  static const String severityLow = 'low';
  
  // API Endpoints (Mock for now)
  static const String baseUrl = 'https://api.jeevandhara.gov.in';
  static const String loginEndpoint = '/auth/login';
  static const String reportsEndpoint = '/reports';
  static const String alertsEndpoint = '/alerts';
  static const String dashboardEndpoint = '/dashboard';
  
  // Local Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';
  static const String offlineReportsKey = 'offline_reports';
  static const String selectedLanguageKey = 'selected_language';
  static const String lastSyncKey = 'last_sync';
  
  // Animation Assets
  static const String splashAnimation = 'assets/animations/splash.json';
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successAnimation = 'assets/animations/success.json';
  static const String errorAnimation = 'assets/animations/error.json';
  static const String waterDropAnimation = 'assets/animations/water_drop.json';
  
  // Image Assets
  static const String logoImage = 'assets/images/logo.png';
  static const String backgroundImage = 'assets/images/background.jpg';
  static const String mapPlaceholder = 'assets/images/map_placeholder.png';
  static const String avatarPlaceholder = 'assets/images/avatar_placeholder.png';
  
  // Icon Assets
  static const String ashaIcon = 'assets/icons/asha.png';
  static const String officialIcon = 'assets/icons/official.png';
  static const String publicIcon = 'assets/icons/public.png';
  static const String waterIcon = 'assets/icons/water.png';
  static const String healthIcon = 'assets/icons/health.png';
  
  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxReportDescriptionLength = 500;
  static const int maxCasesPerReport = 1000;
  
  // UI Constants
  static const double maxPhoneWidth = 600;
  static const double defaultPadding = 16.0;
  static const double cardElevation = 4.0;
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;
  
  // Chart Colors
  static const List<String> chartColors = [
    '#2E7D5A', // Primary Green
    '#4A90A4', // Primary Blue
    '#66A680', // Secondary Green
    '#FF9800', // Orange
    '#9C27B0', // Purple
    '#F44336', // Red
    '#3F51B5', // Indigo
    '#009688', // Teal
  ];
  
  // Map Configuration
  static const double defaultLatitude = 26.2006; // Guwahati
  static const double defaultLongitude = 91.6956;
  static const double defaultZoom = 7.0;
  
  // Offline Configuration
  static const int maxOfflineReports = 100;
  static const int syncRetryAttempts = 3;
  static const Duration syncTimeout = Duration(seconds: 30);
}

// Enums
enum UserRole { asha, healthOfficial, public }

enum ReportStatus { pending, synced, reviewed, error }

enum AlertSeverity { high, medium, low }

enum ConnectionStatus { online, offline, syncing }

enum WaterSourceType {
  well,
  borehole,
  spring,
  river,
  pond,
  rainwater,
  other,
}

enum DiseaseType {
  diarrhea,
  cholera,
  typhoid,
  hepatitisA,
  dysentery,
  gastroenteritis,
  other,
}