import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class NearbyFacilitiesScreen extends StatefulWidget {
  const NearbyFacilitiesScreen({super.key});

  @override
  State<NearbyFacilitiesScreen> createState() => _NearbyFacilitiesScreenState();
}

class _NearbyFacilitiesScreenState extends State<NearbyFacilitiesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String selectedCategory = 'All';
  String searchQuery = '';
  bool isLocationEnabled = false;
  
  final List<String> categories = [
    'All',
    'Primary Health Centers',
    'Community Health Centers',
    'Hospitals',
    'Pharmacies',
    'ASHA Centers',
    'Emergency Services',
  ];
  
  final List<Map<String, dynamic>> facilities = [
    {
      'name': 'Kohima District Hospital',
      'type': 'Hospitals',
      'distance': '2.5 km',
      'address': 'Hospital Hill, Kohima, Nagaland',
      'phone': '+91-9876543210',
      'rating': 4.2,
      'isOpen': true,
      'services': ['Emergency', 'OPD', 'IPD', 'Laboratory', 'Radiology'],
      'specialties': ['General Medicine', 'Pediatrics', 'Gynecology'],
      'timings': '24/7',
      'beds': 150,
    },
    {
      'name': 'PHC Kohima Village',
      'type': 'Primary Health Centers',
      'distance': '1.2 km',
      'address': 'Main Road, Kohima Village',
      'phone': '+91-9876543211',
      'rating': 3.8,
      'isOpen': true,
      'services': ['OPD', 'Vaccination', 'Maternity', 'Basic Laboratory'],
      'specialties': ['General Medicine', 'Maternal Care'],
      'timings': '9:00 AM - 5:00 PM',
      'beds': 6,
    },
    {
      'name': 'Apollo Pharmacy',
      'type': 'Pharmacies',
      'distance': '0.8 km',
      'address': 'Jail Colony, Kohima',
      'phone': '+91-9876543213',
      'rating': 4.5,
      'isOpen': true,
      'services': ['Medicines', 'Health Products', 'Consultation'],
      'specialties': ['24/7 Service', 'Home Delivery'],
      'timings': '24/7',
      'beds': 0,
    },
    {
      'name': 'ASHA Center Tseminyu',
      'type': 'ASHA Centers',
      'distance': '12.5 km',
      'address': 'Village Council Hall, Tseminyu',
      'phone': '+91-9876543214',
      'rating': 4.1,
      'isOpen': true,
      'services': ['Health Education', 'Referral Services', 'Immunization'],
      'specialties': ['Community Health', 'Maternal Care'],
      'timings': '9:00 AM - 6:00 PM',
      'beds': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
    _checkLocationPermission();
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

  void _checkLocationPermission() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLocationEnabled = true;
      });
    });
  }

  List<Map<String, dynamic>> get filteredFacilities {
    return facilities.where((facility) {
      bool matchesCategory = selectedCategory == 'All' || 
                            facility['type'] == selectedCategory;
      bool matchesSearch = searchQuery.isEmpty ||
                          facility['name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                          facility['type'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                          facility['address'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList()..sort((a, b) {
      double distanceA = double.parse(a['distance'].split(' ')[0]);
      double distanceB = double.parse(b['distance'].split(' ')[0]);
      return distanceA.compareTo(distanceB);
    });
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
            _buildLocationHeader(),
            _buildSearchAndFilters(),
            _buildQuickActions(),
            Expanded(
              child: _buildFacilitiesList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMapView,
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.map, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Nearby Facilities'),
      backgroundColor: AppTheme.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.emergency),
          onPressed: _callEmergency,
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshLocation,
        ),
      ],
    );
  }

  Widget _buildLocationHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: isLocationEnabled ? AppTheme.successGreen.withOpacity(0.1) : AppTheme.warningOrange.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.neutralGray.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isLocationEnabled ? Icons.location_on : Icons.location_off,
            color: isLocationEnabled ? AppTheme.successGreen : AppTheme.warningOrange,
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isLocationEnabled ? 'Current Location' : 'Location Access Required',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  isLocationEnabled ? 'Kohima, Nagaland' : 'Enable location for better results',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
              ],
            ),
          ),
          if (!isLocationEnabled)
            ElevatedButton(
              onPressed: _enableLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Enable'),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Search facilities, services, or location...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.filter_list),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: AppTheme.spacingM),
          
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                
                return Container(
                  margin: const EdgeInsets.only(right: AppTheme.spacingS),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryGreen,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              'Emergency',
              Icons.emergency,
              AppTheme.errorRed,
              _callEmergency,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: _buildQuickActionCard(
              'Hospital',
              Icons.local_hospital,
              AppTheme.primaryBlue,
              _findNearestHospital,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: _buildQuickActionCard(
              'Pharmacy',
              Icons.local_pharmacy,
              AppTheme.successGreen,
              _findNearestPharmacy,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: _buildQuickActionCard(
              'ASHA',
              Icons.person_pin,
              AppTheme.warningOrange,
              _findNearestASHA,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Hospitals':
        return AppTheme.errorRed;
      case 'Primary Health Centers':
        return AppTheme.primaryGreen;
      case 'Community Health Centers':
        return AppTheme.primaryBlue;
      case 'Pharmacies':
        return AppTheme.warningOrange;
      case 'ASHA Centers':
        return AppTheme.infoBlue;
      case 'Emergency Services':
        return AppTheme.errorRed;
      default:
        return AppTheme.neutralGray;
    }
  }

  void _enableLocation() {
    setState(() {
      isLocationEnabled = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location enabled successfully'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _refreshLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing location...')),
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

  void _findNearestHospital() {
    setState(() {
      selectedCategory = 'Hospitals';
    });
  }

  void _findNearestPharmacy() {
    setState(() {
      selectedCategory = 'Pharmacies';
    });
  }

  void _findNearestASHA() {
    setState(() {
      selectedCategory = 'ASHA Centers';
    });
  }

  void _showMapView() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Map View'),
        content: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            color: AppTheme.lightGray,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: AppTheme.neutralGray),
                SizedBox(height: 16),
                Text('Interactive map view\ncoming soon'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _callFacility(Map<String, dynamic> facility) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling ${facility['name']}: ${facility['phone']}'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }

  void _getDirections(Map<String, dynamic> facility) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Getting directions to ${facility['name']}'),
        backgroundColor: AppTheme.primaryBlue,
      ),
    );
  }

  void _viewDetails(Map<String, dynamic> facility) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
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
                    Expanded(
                      child: Text(
                        facility['name'],
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingL),
                
                _buildDetailRow(Icons.location_on, 'Address', facility['address']),
                _buildDetailRow(Icons.phone, 'Phone', facility['phone']),
                _buildDetailRow(Icons.schedule, 'Timings', facility['timings']),
                if (facility['beds'] > 0)
                  _buildDetailRow(Icons.bed, 'Beds', '${facility['beds']} available'),
                
                const SizedBox(height: AppTheme.spacingL),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _callFacility(facility);
                        },
                        icon: const Icon(Icons.phone),
                        label: const Text('Call Now'),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _getDirections(facility);
                        },
                        icon: const Icon(Icons.directions),
                        label: const Text('Get Directions'),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppTheme.neutralGray),
          const SizedBox(width: AppTheme.spacingS),
          SizedBox(
            width: 80,
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

  Widget _buildFacilitiesList() {
    final filteredList = filteredFacilities;
    
    if (filteredList.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final facility = filteredList[index];
        return _buildFacilityCard(facility);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.neutralGray.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'No facilities found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Try adjusting your search or filters',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.neutralGray,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedCategory = 'All';
                searchQuery = '';
              });
            },
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(Map<String, dynamic> facility) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        facility['name'],
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getTypeColor(facility['type']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              facility['type'],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getTypeColor(facility['type']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Icon(
                            facility['isOpen'] ? Icons.access_time : Icons.access_time_filled,
                            size: 16,
                            color: facility['isOpen'] ? AppTheme.successGreen : AppTheme.errorRed,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            facility['isOpen'] ? 'Open' : 'Closed',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: facility['isOpen'] ? AppTheme.successGreen : AppTheme.errorRed,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        facility['distance'],
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppTheme.warningOrange, size: 16),
                        const SizedBox(width: 2),
                        Text(
                          facility['rating'].toString(),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppTheme.neutralGray),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    facility['address'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neutralGray,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 16, color: AppTheme.neutralGray),
                const SizedBox(width: 4),
                Text(
                  facility['phone'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                const Icon(Icons.schedule, size: 16, color: AppTheme.neutralGray),
                const SizedBox(width: 4),
                Text(
                  facility['timings'],
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            if (facility['services'].isNotEmpty) ...[
              Text(
                'Services',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingS),
              Wrap(
                spacing: AppTheme.spacingXS,
                runSpacing: AppTheme.spacingXS,
                children: (facility['services'] as List<String>).take(3).map((service) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      service,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppTheme.spacingM),
            ],
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _callFacility(facility),
                    icon: const Icon(Icons.phone, size: 16),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _getDirections(facility),
                    icon: const Icon(Icons.directions, size: 16),
                    label: const Text('Directions'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _viewDetails(facility),
                    icon: const Icon(Icons.info, size: 16),
                    label: const Text('Details'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}