import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_widgets.dart';

class AwarenessCampaignsScreen extends StatefulWidget {
  const AwarenessCampaignsScreen({Key? key}) : super(key: key);

  @override
  State<AwarenessCampaignsScreen> createState() => _AwarenessCampaignsScreenState();
}

class _AwarenessCampaignsScreenState extends State<AwarenessCampaignsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String selectedLanguage = 'en';
  String selectedFilter = 'All';
  
  final List<String> filters = ['All', 'Campaigns', 'News', 'Alerts', 'Infographics'];
  
  final List<Map<String, dynamic>> campaigns = [
    {
      'id': '1',
      'title': 'Clean Water for All',
      'description': 'Join our community-wide initiative to ensure safe drinking water for every household',
      'type': 'campaign',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'image': null,
      'priority': 'high',
      'tags': ['Water Safety', 'Community', 'Prevention'],
      'views': 1254,
      'likes': 89,
    },
    {
      'id': '2',
      'title': 'Vaccination Drive Success',
      'description': 'Over 5,000 children vaccinated in the recent immunization campaign across rural areas',
      'type': 'news',
      'date': DateTime.now().subtract(const Duration(hours: 6)),
      'image': null,
      'priority': 'medium',
      'tags': ['Vaccination', 'Children', 'Success'],
      'views': 892,
      'likes': 156,
    },
    {
      'id': '3',
      'title': 'Water Quality Alert - Resolved',
      'description': 'Water supply in Dimapur district has been restored to safe levels after quality testing',
      'type': 'alert',
      'date': DateTime.now().subtract(const Duration(hours: 8)),
      'image': null,
      'priority': 'high',
      'tags': ['Water Quality', 'Alert', 'Dimapur'],
      'views': 2156,
      'likes': 245,
    },
    {
      'id': '4',
      'title': 'Hand Hygiene Infographic',
      'description': 'Visual guide showing proper handwashing techniques to prevent disease transmission',
      'type': 'infographic',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'image': null,
      'priority': 'medium',
      'tags': ['Hygiene', 'Prevention', 'Education'],
      'views': 3421,
      'likes': 567,
    },
    {
      'id': '5',
      'title': 'Monsoon Health Preparedness',
      'description': 'Essential tips and guidelines for staying healthy during the monsoon season',
      'type': 'campaign',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'image': null,
      'priority': 'high',
      'tags': ['Monsoon', 'Prevention', 'Seasonal'],
      'views': 1876,
      'likes': 298,
    },
    {
      'id': '6',
      'title': 'New Health Center Inauguration',
      'description': 'Primary Health Center opened in Kohima to serve rural communities',
      'type': 'news',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'image': null,
      'priority': 'medium',
      'tags': ['Infrastructure', 'Healthcare', 'Kohima'],
      'views': 1234,
      'likes': 189,
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

  List<Map<String, dynamic>> get filteredCampaigns {
    if (selectedFilter == 'All') return campaigns;
    return campaigns.where((campaign) => 
      campaign['type'].toString().toLowerCase() == selectedFilter.toLowerCase()).toList();
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
            // Featured Banner
            _buildFeaturedBanner(),
            
            // Filter Tabs
            _buildFilterTabs(),
            
            // Content List
            Expanded(
              child: _buildContentList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSubmissionDialog,
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Health Awareness'),
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        LanguageSelector(
          selectedLanguage: selectedLanguage,
          onLanguageChanged: (language) {
            setState(() {
              selectedLanguage = language;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _showSearchDialog,
        ),
        IconButton(
          icon: const Icon(Icons.bookmark),
          onPressed: _showBookmarks,
        ),
      ],
    );
  }

  Widget _buildFeaturedBanner() {
    final featured = campaigns.first;
    
    return Container(
      margin: const EdgeInsets.all(AppTheme.spacingM),
      child: CustomCard(
        onTap: () => _openCampaign(featured),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Featured',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Content
            Text(
              featured['title'] as String,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              featured['description'] as String,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.neutralGray,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Engagement Stats
            Row(
              children: [
                _buildStatItem(Icons.visibility, featured['views'].toString()),
                const SizedBox(width: AppTheme.spacingM),
                _buildStatItem(Icons.favorite, featured['likes'].toString()),
                const Spacer(),
                Text(
                  _formatDate(featured['date'] as DateTime),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.neutralGray),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.neutralGray,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
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
              selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryBlue,
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentList() {
    final filtered = filteredCampaigns;
    
    if (filtered.isEmpty) {
      return EmptyState(
        title: 'No Content Found',
        subtitle: 'Try selecting a different filter or check back later',
        icon: Icons.campaign,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final item = filtered[index];
        return _buildContentCard(item);
      },
    );
  }

  Widget _buildContentCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        onTap: () => _openCampaign(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getTypeColor(item['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getTypeIcon(item['type']),
                    color: _getTypeColor(item['type']),
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        (item['type'] as String).toUpperCase(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getTypeColor(item['type']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item['priority'] == 'high')
                  const Icon(
                    Icons.priority_high,
                    color: AppTheme.errorRed,
                    size: 20,
                  ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Description
            Text(
              item['description'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Tags
            if ((item['tags'] as List).isNotEmpty)
              Wrap(
                spacing: AppTheme.spacingXS,
                children: (item['tags'] as List<String>).take(3).map((tag) {
                  return Chip(
                    label: Text(
                      tag,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    backgroundColor: AppTheme.lightGray,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            
            const SizedBox(height: AppTheme.spacingM),
            
            // Footer
            Row(
              children: [
                _buildStatItem(Icons.visibility, item['views'].toString()),
                const SizedBox(width: AppTheme.spacingM),
                _buildStatItem(Icons.favorite, item['likes'].toString()),
                const Spacer(),
                Text(
                  _formatDate(item['date'] as DateTime),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.neutralGray,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                CustomButton(
                  text: 'Read More',
                  onPressed: () => _openCampaign(item),
                  type: ButtonType.text,
                  height: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'campaign':
        return Icons.campaign;
      case 'news':
        return Icons.article;
      case 'alert':
        return Icons.warning;
      case 'infographic':
        return Icons.image;
      default:
        return Icons.info;
    }
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'campaign':
        return AppTheme.primaryBlue;
      case 'news':
        return AppTheme.primaryGreen;
      case 'alert':
        return AppTheme.warningOrange;
      case 'infographic':
        return AppTheme.secondaryGreen;
      default:
        return AppTheme.neutralGray;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  void _openCampaign(Map<String, dynamic> campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCampaignDetailsSheet(campaign),
    );
  }

  Widget _buildCampaignDetailsSheet(Map<String, dynamic> campaign) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.neutralGray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getTypeColor(campaign['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(campaign['type']),
                    color: _getTypeColor(campaign['type']),
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign['title'] as String,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (campaign['type'] as String).toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _getTypeColor(campaign['type']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _shareCampaign(campaign),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    campaign['description'] as String,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Engagement Stats
                  Row(
                    children: [
                      _buildDetailStat(Icons.visibility, 'Views', campaign['views'].toString()),
                      const SizedBox(width: AppTheme.spacingL),
                      _buildDetailStat(Icons.favorite, 'Likes', campaign['likes'].toString()),
                      const SizedBox(width: AppTheme.spacingL),
                      _buildDetailStat(Icons.access_time, 'Posted', _formatDate(campaign['date'] as DateTime)),
                    ],
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Tags
                  if ((campaign['tags'] as List).isNotEmpty) ...[
                    Text(
                      'Topics',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Wrap(
                      spacing: AppTheme.spacingS,
                      children: (campaign['tags'] as List<String>).map((tag) {
                        return Chip(
                          label: Text(tag),
                          backgroundColor: _getTypeColor(campaign['type']).withOpacity(0.1),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Like',
                    onPressed: () => _likeCampaign(campaign),
                    type: ButtonType.secondary,
                    icon: Icons.favorite_border,
                    height: 48,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: CustomButton(
                    text: 'Share',
                    onPressed: () => _shareCampaign(campaign),
                    type: ButtonType.primary,
                    icon: Icons.share,
                    height: 48,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppTheme.neutralGray),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.neutralGray,
          ),
        ),
      ],
    );
  }

  void _likeCampaign(Map<String, dynamic> campaign) {
    setState(() {
      campaign['likes'] = (campaign['likes'] as int) + 1;
    });
    
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Liked! Thank you for your support'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _shareCampaign(Map<String, dynamic> campaign) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing: ${campaign['title']}')),
    );
  }

  void _showSubmissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Content'),
        content: const Text(
          'Would you like to submit health awareness content or report a community health issue?',
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
                const SnackBar(content: Text('Content submission feature coming soon')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Content'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter keywords...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showBookmarks() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bookmarks feature coming soon')),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}