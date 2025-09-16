import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'hi_IN': hiIN,
    'as_IN': asIN,
    'ne_IN': neIN,
  };
}

// English translations
final Map<String, String> enUS = {
  // App name and common
  'app_name': 'Jeevan Dhara',
  'loading': 'Loading...',
  'error': 'Error',
  'success': 'Success',
  'cancel': 'Cancel',
  'save': 'Save',
  'submit': 'Submit',
  'next': 'Next',
  'previous': 'Previous',
  'done': 'Done',
  'yes': 'Yes',
  'no': 'No',
  'ok': 'OK',
  'search': 'Search',
  'filter': 'Filter',
  'refresh': 'Refresh',
  'share': 'Share',
  'settings': 'Settings',
  'help': 'Help',
  'about': 'About',
  'logout': 'Logout',
  'login': 'Login',
  
  // Role selection
  'role_selection_title': 'Select Your Role',
  'role_selection_subtitle': 'Choose how you want to use Jeevan Dhara',
  'general_public': 'General Public',
  'general_public_desc': 'Access health resources and community features',
  'asha_worker': 'ASHA Worker',
  'asha_worker_desc': 'Report cases and manage community health',
  'health_official': 'Health Official',
  'health_official_desc': 'Monitor health data and manage responses',
  
  // Public home
  'public_home_title': 'Jeevan Dhara',
  'public_home_subtitle': 'Your Community Health Companion',
  'quick_actions': 'Quick Actions',
  'health_services': 'Health Services',
  'community': 'Community',
  'emergency': 'Emergency',
  'symptom_checker': 'Symptom Checker',
  'nearby_facilities': 'Nearby Facilities',
  'emergency_contacts': 'Emergency Contacts',
  'water_quality': 'Water Quality',
  'health_assessment': 'Health Assessment',
  'community_forums': 'Community Forums',
  'awareness_campaigns': 'Awareness Campaigns',
  'educational_modules': 'Educational Modules',
  
  // Symptom checker
  'symptom_checker_title': 'Symptom Checker',
  'symptom_checker_subtitle': 'Assess your health symptoms',
  'select_symptoms': 'Select Your Symptoms',
  'no_symptoms_selected': 'No symptoms selected',
  'health_assessment_result': 'Health Assessment Result',
  'consult_doctor': 'Consult a Doctor',
  'seek_immediate_attention': 'Seek Immediate Medical Attention',
  
  // Water quality
  'water_quality_title': 'Water Quality Reporting',
  'water_quality_subtitle': 'Report water quality issues in your area',
  'select_water_source': 'Select Water Source',
  'visual_assessment': 'Visual Assessment',
  'water_color': 'Water Color',
  'water_odor': 'Water Odor',
  'water_taste': 'Water Taste',
  'submit_report': 'Submit Report',
  
  // Emergency
  'emergency_title': 'Emergency Contacts',
  'emergency_subtitle': 'Quick access to emergency services',
  'call_now': 'Call Now',
  'ambulance': 'Ambulance',
  'police': 'Police',
  'fire_service': 'Fire Service',
  'poison_control': 'Poison Control',
  
  // Community
  'community_title': 'Community Forums',
  'community_subtitle': 'Connect with your community',
  'create_post': 'Create Post',
  'my_posts': 'My Posts',
  'health_alerts': 'Health Alerts',
  'post_title': 'Post Title',
  'post_content': 'Post Content',
  'post_category': 'Category',
  
  // Health facilities
  'facilities_title': 'Nearby Health Facilities',
  'facilities_subtitle': 'Find healthcare services near you',
  'hospitals': 'Hospitals',
  'clinics': 'Clinics',
  'pharmacies': 'Pharmacies',
  'distance': 'Distance',
  'rating': 'Rating',
  'open_now': 'Open Now',
  'closed': 'Closed',
  'get_directions': 'Get Directions',
  'call_facility': 'Call Facility',
  
  // Profile and settings
  'profile_title': 'Profile Management',
  'profile_subtitle': 'Manage your personal information',
  'personal_info': 'Personal Information',
  'contact_info': 'Contact Information',
  'health_info': 'Health Information',
  'preferences': 'Preferences',
  'full_name': 'Full Name',
  'email': 'Email',
  'phone': 'Phone Number',
  'age': 'Age',
  'gender': 'Gender',
  'location': 'Location',
  'emergency_contact': 'Emergency Contact',
  'health_conditions': 'Health Conditions',
  'preferred_language': 'Preferred Language',
  
  // Settings
  'settings_title': 'Settings',
  'notifications': 'Notifications',
  'push_notifications': 'Push Notifications',
  'email_notifications': 'Email Notifications',
  'location_services': 'Location Services',
  'dark_mode': 'Dark Mode',
  'language': 'Language',
  'privacy': 'Privacy',
  'security': 'Security',
  'about_app': 'About App',
  'version': 'Version',
  
  // Help and support
  'help_title': 'Help & Support',
  'faq': 'FAQ',
  'contact_support': 'Contact Support',
  'tutorials': 'Tutorials',
  'report_bug': 'Report Bug',
  'live_chat': 'Live Chat',
  
  // Health assessment
  'assessment_title': 'Health Self-Assessment',
  'assessment_subtitle': 'Evaluate your current health status',
  'general_health': 'General Health',
  'digestive_health': 'Digestive Health',
  'hydration_status': 'Hydration Status',
  'vital_signs': 'Vital Signs',
  'assessment_results': 'Assessment Results',
  'recommendations': 'Recommendations',
  
  // Common health terms
  'fever': 'Fever',
  'headache': 'Headache',
  'nausea': 'Nausea',
  'vomiting': 'Vomiting',
  'diarrhea': 'Diarrhea',
  'stomach_pain': 'Stomach Pain',
  'fatigue': 'Fatigue',
  'dizziness': 'Dizziness',
  'dehydration': 'Dehydration',
  'blood_pressure': 'Blood Pressure',
  'heart_rate': 'Heart Rate',
  'temperature': 'Temperature',
  
  // Water quality terms
  'clear_water': 'Clear',
  'cloudy_water': 'Cloudy',
  'colored_water': 'Colored',
  'no_smell': 'No Smell',
  'bad_smell': 'Bad Smell',
  'metallic_taste': 'Metallic Taste',
  'bitter_taste': 'Bitter Taste',
  'normal_taste': 'Normal Taste',
  
  // Validation messages
  'field_required': 'This field is required',
  'invalid_email': 'Please enter a valid email address',
  'invalid_phone': 'Please enter a valid phone number',
  'password_too_short': 'Password must be at least 8 characters',
  'passwords_dont_match': 'Passwords do not match',
  
  // Success messages
  'profile_updated': 'Profile updated successfully',
  'report_submitted': 'Report submitted successfully',
  'settings_saved': 'Settings saved',
  'message_sent': 'Message sent successfully',
  
  // Error messages
  'network_error': 'Network connection error',
  'server_error': 'Server error occurred',
  'data_load_error': 'Failed to load data',
  'location_permission_denied': 'Location permission denied',
  'camera_permission_denied': 'Camera permission denied',
};

// Hindi translations
final Map<String, String> hiIN = {
  // App name and common
  'app_name': 'जीवन धारा',
  'loading': 'लोड हो रहा है...',
  'error': 'त्रुटि',
  'success': 'सफलता',
  'cancel': 'रद्द करें',
  'save': 'सेव करें',
  'submit': 'जमा करें',
  'next': 'अगला',
  'previous': 'पिछला',
  'done': 'हो गया',
  'yes': 'हाँ',
  'no': 'नहीं',
  'ok': 'ठीक है',
  'search': 'खोजें',
  'filter': 'फिल्टर',
  'refresh': 'ताज़ा करें',
  'share': 'साझा करें',
  'settings': 'सेटिंग्स',
  'help': 'सहायता',
  'about': 'के बारे में',
  'logout': 'लॉगआउट',
  'login': 'लॉगिन',
  
  // Role selection
  'role_selection_title': 'अपनी भूमिका चुनें',
  'role_selection_subtitle': 'चुनें कि आप जीवन धारा का उपयोग कैसे करना चाहते हैं',
  'general_public': 'आम जनता',
  'general_public_desc': 'स्वास्थ्य संसाधनों और सामुदायिक सुविधाओं तक पहुंच',
  'asha_worker': 'आशा कार्यकर्ता',
  'asha_worker_desc': 'मामलों की रिपोर्ट करें और सामुदायिक स्वास्थ्य प्रबंधन',
  'health_official': 'स्वास्थ्य अधिकारी',
  'health_official_desc': 'स्वास्थ्य डेटा की निगरानी और प्रतिक्रिया प्रबंधन',
  
  // Public home
  'public_home_title': 'जीवन धारा',
  'public_home_subtitle': 'आपका सामुदायिक स्वास्थ्य साथी',
  'quick_actions': 'त्वरित कार्य',
  'health_services': 'स्वास्थ्य सेवाएं',
  'community': 'समुदाय',
  'emergency': 'आपातकाल',
  'symptom_checker': 'लक्षण जांचकर्ता',
  'nearby_facilities': 'नजदीकी सुविधाएं',
  'emergency_contacts': 'आपातकालीन संपर्क',
  'water_quality': 'पानी की गुणवत्ता',
  'health_assessment': 'स्वास्थ्य मूल्यांकन',
  'community_forums': 'सामुदायिक मंच',
  'awareness_campaigns': 'जागरूकता अभियान',
  'educational_modules': 'शैक्षिक मॉड्यूल',
  
  // Symptom checker
  'symptom_checker_title': 'लक्षण जांचकर्ता',
  'symptom_checker_subtitle': 'अपने स्वास्थ्य लक्षणों का आकलन करें',
  'select_symptoms': 'अपने लक्षण चुनें',
  'no_symptoms_selected': 'कोई लक्षण नहीं चुना गया',
  'health_assessment_result': 'स्वास्थ्य मूल्यांकन परिणाम',
  'consult_doctor': 'डॉक्टर से सलाह लें',
  'seek_immediate_attention': 'तत्काल चिकित्सा सहायता लें',
  
  // Water quality
  'water_quality_title': 'पानी की गुणवत्ता रिपोर्टिंग',
  'water_quality_subtitle': 'अपने क्षेत्र में पानी की गुणवत्ता की समस्याओं की रिपोर्ट करें',
  'select_water_source': 'पानी का स्रोत चुनें',
  'visual_assessment': 'दृश्य मूल्यांकन',
  'water_color': 'पानी का रंग',
  'water_odor': 'पानी की गंध',
  'water_taste': 'पानी का स्वाद',
  'submit_report': 'रिपोर्ट जमा करें',
  
  // Emergency
  'emergency_title': 'आपातकालीन संपर्क',
  'emergency_subtitle': 'आपातकालीन सेवाओं तक त्वरित पहुंच',
  'call_now': 'अभी कॉल करें',
  'ambulance': 'एम्बुलेंस',
  'police': 'पुलिस',
  'fire_service': 'अग्निशमन सेवा',
  'poison_control': 'विष नियंत्रण',
  
  // Community
  'community_title': 'सामुदायिक मंच',
  'community_subtitle': 'अपने समुदाय से जुड़ें',
  'create_post': 'पोस्ट बनाएं',
  'my_posts': 'मेरी पोस्ट',
  'health_alerts': 'स्वास्थ्य अलर्ट',
  'post_title': 'पोस्ट शीर्षक',
  'post_content': 'पोस्ट सामग्री',
  'post_category': 'श्रेणी',
  
  // Health facilities
  'facilities_title': 'नजदीकी स्वास्थ्य सुविधाएं',
  'facilities_subtitle': 'अपने पास स्वास्थ्य सेवाएं खोजें',
  'hospitals': 'अस्पताल',
  'clinics': 'क्लिनिक',
  'pharmacies': 'फार्मेसी',
  'distance': 'दूरी',
  'rating': 'रेटिंग',
  'open_now': 'अभी खुला',
  'closed': 'बंद',
  'get_directions': 'दिशा पाएं',
  'call_facility': 'सुविधा को कॉल करें',
  
  // Profile and settings
  'profile_title': 'प्रोफाइल प्रबंधन',
  'profile_subtitle': 'अपनी व्यक्तिगत जानकारी प्रबंधित करें',
  'personal_info': 'व्यक्तिगत जानकारी',
  'contact_info': 'संपर्क जानकारी',
  'health_info': 'स्वास्थ्य जानकारी',
  'preferences': 'वरीयताएं',
  'full_name': 'पूरा नाम',
  'email': 'ईमेल',
  'phone': 'फोन नंबर',
  'age': 'आयु',
  'gender': 'लिंग',
  'location': 'स्थान',
  'emergency_contact': 'आपातकालीन संपर्क',
  'health_conditions': 'स्वास्थ्य स्थितियां',
  'preferred_language': 'पसंदीदा भाषा',
  
  // Common health terms
  'fever': 'बुखार',
  'headache': 'सिरदर्द',
  'nausea': 'मतली',
  'vomiting': 'उल्टी',
  'diarrhea': 'दस्त',
  'stomach_pain': 'पेट दर्द',
  'fatigue': 'थकान',
  'dizziness': 'चक्कर आना',
  'dehydration': 'निर्जलीकरण',
  'blood_pressure': 'रक्तचाप',
  'heart_rate': 'हृदय गति',
  'temperature': 'तापमान',
};

// Assamese translations
final Map<String, String> asIN = {
  // App name and common
  'app_name': 'জীৱন ধাৰা',
  'loading': 'লোড হৈছে...',
  'error': 'ভুল',
  'success': 'সফলতা',
  'cancel': 'বাতিল কৰক',
  'save': 'সংৰক্ষণ কৰক',
  'submit': 'দাখিল কৰক',
  'next': 'পৰৱৰ্তী',
  'previous': 'আগৰ',
  'done': 'সম্পূৰ্ণ',
  'yes': 'হয়',
  'no': 'নহয়',
  'ok': 'ঠিক আছে',
  'search': 'সন্ধান কৰক',
  'filter': 'ফিল্টাৰ',
  'refresh': 'সতেজ কৰক',
  'share': 'ভাগ কৰক',
  'settings': 'সংহতিসমূহ',
  'help': 'সহায়',
  'about': 'বিষয়ে',
  'logout': 'লগআউট',
  'login': 'লগিন',
  
  // Role selection
  'role_selection_title': 'আপোনাৰ ভূমিকা বাছনি কৰক',
  'general_public': 'সাধাৰণ জনসাধাৰণ',
  'asha_worker': 'আশা কৰ্মী',
  'health_official': 'স্বাস্থ্য বিষয়া',
  
  // Common health terms
  'fever': 'জ্বৰ',
  'headache': 'মূৰৰ বিষ',
  'nausea': 'বমিৰ ভাব',
  'vomiting': 'বমি',
  'diarrhea': 'ডায়েৰিয়া',
  'stomach_pain': 'পেটৰ বিষ',
  'fatigue': 'ক্লান্তি',
  'emergency': 'জৰুৰীকালীন',
  'health_assessment': 'স্বাস্থ্য মূল্যায়ন',
  'water_quality': 'পানীৰ গুণগত মান',
};

// Nepali translations
final Map<String, String> neIN = {
  // App name and common
  'app_name': 'जीवन धारा',
  'loading': 'लोड हुँदैछ...',
  'error': 'त्रुटि',
  'success': 'सफलता',
  'cancel': 'रद्द गर्नुहोस्',
  'save': 'सेभ गर्नुहोस्',
  'submit': 'पेश गर्नुहोस्',
  'next': 'अर्को',
  'previous': 'अघिल्लो',
  'done': 'भयो',
  'yes': 'हो',
  'no': 'होइन',
  'ok': 'ठिक छ',
  'search': 'खोज्नुहोस्',
  'filter': 'फिल्टर',
  'refresh': 'ताजा गर्नुहोस्',
  'share': 'साझेदारी गर्नुहोस्',
  'settings': 'सेटिङहरू',
  'help': 'सहायता',
  'about': 'बारेमा',
  'logout': 'लगआउट',
  'login': 'लगिन',
  
  // Role selection
  'role_selection_title': 'आफ्नो भूमिका छान्नुहोस्',
  'general_public': 'सामान्य जनता',
  'asha_worker': 'आशा कार्यकर्ता',
  'health_official': 'स्वास्थ्य अधिकारी',
  
  // Common health terms
  'fever': 'ज्वरो',
  'headache': 'टाउको दुख्ने',
  'nausea': 'वान्ता लाग्ने',
  'vomiting': 'बान्ता',
  'diarrhea': 'डायरिया',
  'stomach_pain': 'पेट दुख्ने',
  'fatigue': 'थकान',
  'emergency': 'आपतकालीन',
  'health_assessment': 'स्वास्थ्य मूल्याङ्कन',
  'water_quality': 'पानीको गुणस्तर',
};

// Language controller
class LanguageController extends GetxController {
  var currentLanguage = 'English'.obs;
  var currentLocale = const Locale('en', 'US').obs;

  final Map<String, Locale> languages = {
    'English': const Locale('en', 'US'),
    'हिंदी': const Locale('hi', 'IN'),
    'অসমীয়া': const Locale('as', 'IN'),
    'नेपाली': const Locale('ne', 'IN'),
  };

  void changeLanguage(String language) {
    if (languages.containsKey(language)) {
      currentLanguage.value = language;
      currentLocale.value = languages[language]!;
      Get.updateLocale(languages[language]!);
      
      // Save to local storage
      _saveLanguagePreference(language);
    }
  }

  void _saveLanguagePreference(String language) {
    // Implementation to save language preference to local storage
    // This would typically use SharedPreferences or similar
  }

  String getCurrentLanguageCode() {
    return currentLocale.value.languageCode;
  }

  bool isRTL() {
    // Add RTL language support if needed
    return false;
  }
}

// Text direction helper
class TextDirectionHelper {
  static TextDirection getTextDirection(String languageCode) {
    switch (languageCode) {
      case 'ar':
      case 'fa':
      case 'he':
      case 'ur':
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }
}

// Localization helper methods
class LocalizationHelper {
  static String getLocalizedText(String key) {
    return key.tr;
  }

  static String getLocalizedHealthTerm(String term) {
    return term.tr;
  }

  static String getLocalizedEmergencyMessage(String message) {
    return message.tr;
  }

  static String formatLocalizedDate(DateTime date, String languageCode) {
    // Add date formatting based on locale
    switch (languageCode) {
      case 'hi':
      case 'as':
      case 'ne':
        return '${date.day}/${date.month}/${date.year}';
      default:
        return '${date.month}/${date.day}/${date.year}';
    }
  }

  static String formatLocalizedNumber(double number, String languageCode) {
    // Add number formatting based on locale
    return number.toStringAsFixed(1);
  }
}

// Voice synthesis helper for tribal languages
class VoiceSynthesisHelper {
  static Future<void> speakText(String text, String languageCode) async {
    // Implementation for text-to-speech in different languages
    // This would integrate with Flutter TTS plugin
    print('Speaking: $text in $languageCode');
  }

  static Future<void> speakEmergencyInstructions(String instructions, String languageCode) async {
    // Special handling for emergency instructions
    await speakText(instructions, languageCode);
  }
}

// Cultural adaptation helper
class CulturalAdaptationHelper {
  static String getGreeting(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return 'नमस्ते';
      case 'as':
        return 'নমস্কাৰ';
      case 'ne':
        return 'नमस्ते';
      default:
        return 'Hello';
    }
  }

  static List<String> getCulturalHealthPractices(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return ['आयुर्वेद', 'योग', 'प्राणायाम'];
      case 'as':
        return ['আয়ুৰ্বেদ', 'যোগ', 'প্ৰাণায়াম'];
      case 'ne':
        return ['आयुर्वेद', 'योग', 'प्राणायाम'];
      default:
        return ['Traditional Medicine', 'Yoga', 'Meditation'];
    }
  }

  static Map<String, String> getLocalEmergencyNumbers(String region) {
    // Returns emergency numbers specific to the region
    return {
      'emergency': '108',
      'police': '100',
      'fire': '101',
      'ambulance': '102',
    };
  }
}