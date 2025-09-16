import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class CommunityForumsScreen extends StatefulWidget {
  const CommunityForumsScreen({super.key});

  @override
  State<CommunityForumsScreen> createState() => _CommunityForumsScreenState();
}

class _CommunityForumsScreenState extends State<CommunityForumsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  
  String selectedCategory = 'All';
  String searchQuery = '';
  
  final List<String> categories = [
    'All',
    'Health Alerts',
    'Water Quality',
    'Community Health',
    'Preventive Care',
    'ASHA Updates',
    'General Discussion',
  ];
  
  final List<Map<String, dynamic>> forumPosts = [
    {
      'id': '1',
      'title': 'Water Quality Issues in Kohima Village',
      'author': 'Community Health Worker',
      'authorRole': 'ASHA',
      'content': 'Recent water quality tests have shown concerning levels of bacteria in the main water source. Please boil water before consumption.',
      'category': 'Water Quality',
      'timestamp': '2 hours ago',
      'likes': 15,
      'replies': 8,
      'isImportant': true,
      'tags': ['water-quality', 'health-alert', 'prevention'],
      'image': null,
    },
    {
      'id': '2',
      'title': 'Seasonal Disease Prevention Tips',
      'author': 'Dr. Sarah Ao',
      'authorRole': 'Health Official',
      'content': 'As we enter monsoon season, here are important tips to prevent water-borne diseases: 1. Boil drinking water for at least 10 minutes...',
      'category': 'Preventive Care',
      'timestamp': '4 hours ago',
      'likes': 32,
      'replies': 12,
      'isImportant': false,
      'tags': ['prevention', 'monsoon', 'health-tips'],
      'image': null,
    },
    {
      'id': '3',
      'title': 'Community Health Camp - This Weekend',
      'author': 'Village Health Committee',
      'authorRole': 'Community',
      'content': 'Free health checkup camp will be organized this Saturday at the Community Center. Services include: Blood pressure check, Diabetes screening...',
      'category': 'Community Health',
      'timestamp': '6 hours ago',
      'likes': 45,
      'replies': 22,
      'isImportant': true,
      'tags': ['health-camp', 'free-checkup', 'community'],
      'image': null,
    },
    {
      'id': '4',
      'title': 'New Water Purification Methods',
      'author': 'Ravi Kumar',
      'authorRole': 'Community Member',
      'content': 'Has anyone tried the new ceramic water filters? I heard they are effective against bacteria and viruses. Would like to know your experiences.',
      'category': 'Water Quality',
      'timestamp': '1 day ago',
      'likes': 18,
      'replies': 15,
      'isImportant': false,
      'tags': ['water-purification', 'filters', 'technology'],
      'image': null,
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

  List<Map<String, dynamic>> get filteredPosts {
    return forumPosts.where((post) {
      bool matchesCategory = selectedCategory == 'All' || 
                            post['category'] == selectedCategory;
      bool matchesSearch = searchQuery.isEmpty ||
                          post['title'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                          post['content'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                          post['author'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
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
                  _buildForumsTab(),
                  _buildMyPostsTab(),
                  _buildHealthAlertsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewPost,
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Community Forums'),
      backgroundColor: AppTheme.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: _showNotifications,
        ),
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
          Tab(icon: Icon(Icons.forum), text: 'Forums'),
          Tab(icon: Icon(Icons.person), text: 'My Posts'),
          Tab(icon: Icon(Icons.warning), text: 'Alerts'),
        ],
      ),
    );
  }

  Widget _buildForumsTab() {
    return Column(
      children: [
        _buildSearchAndFilters(),
        Expanded(
          child: _buildPostsList(),
        ),
      ],
    );
  }

  Widget _buildMyPostsTab() {
    return const Center(
      child: EmptyState(
        title: 'No Posts Yet',
        subtitle: 'Start sharing with your community by creating your first post',
        icon: Icons.post_add,
        actionText: 'Create Post',
      ),
    );
  }

  Widget _buildHealthAlertsTab() {
    final alertPosts = forumPosts.where((post) => post['isImportant']).toList();
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: alertPosts.length,
      itemBuilder: (context, index) {
        final post = alertPosts[index];
        return _buildAlertCard(post);
      },
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Search posts, topics, or authors...',
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

  Widget _buildPostsList() {
    final filteredList = filteredPosts;
    
    if (filteredList.isEmpty) {
      return const EmptyState(
        title: 'No Posts Found',
        subtitle: 'Try adjusting your search or filters',
        icon: Icons.search_off,
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final post = filteredList[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        onTap: () => _viewPost(post),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post['isImportant'])
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.priority_high, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Important',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (post['isImportant']) const SizedBox(height: AppTheme.spacingS),
            
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getAuthorColor(post['authorRole']),
                  child: Icon(
                    _getAuthorIcon(post['authorRole']),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['author'],
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getAuthorColor(post['authorRole']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              post['authorRole'],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getAuthorColor(post['authorRole']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            post['timestamp'],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.neutralGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(post['category']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    post['category'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getCategoryColor(post['category']),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            Text(
              post['title'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            
            Text(
              post['content'],
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            if (post['tags'] != null && post['tags'].isNotEmpty) ...[
              Wrap(
                spacing: AppTheme.spacingXS,
                runSpacing: AppTheme.spacingXS,
                children: (post['tags'] as List<String>).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$tag',
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
                InkWell(
                  onTap: () => _likePost(post),
                  child: Row(
                    children: [
                      const Icon(Icons.thumb_up, size: 16, color: AppTheme.primaryBlue),
                      const SizedBox(width: 4),
                      Text(
                        post['likes'].toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                InkWell(
                  onTap: () => _viewPost(post),
                  child: Row(
                    children: [
                      const Icon(Icons.comment, size: 16, color: AppTheme.neutralGray),
                      const SizedBox(width: 4),
                      Text(
                        '${post['replies']} replies',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _sharePost(post),
                  icon: const Icon(Icons.share, size: 16),
                ),
                IconButton(
                  onPressed: () => _bookmarkPost(post),
                  icon: const Icon(Icons.bookmark_border, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: CustomCard(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.errorRed, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.warning, color: AppTheme.errorRed),
                    const SizedBox(width: AppTheme.spacingS),
                    Text(
                      'Health Alert',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.errorRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      post['timestamp'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.neutralGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  post['title'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  post['content'],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppTheme.spacingM),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _viewPost(post),
                        icon: const Icon(Icons.info, size: 16),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.errorRed,
                          side: const BorderSide(color: AppTheme.errorRed),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _sharePost(post),
                        icon: const Icon(Icons.share, size: 16),
                        label: const Text('Share Alert'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorRed,
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

  Color _getAuthorColor(String role) {
    switch (role) {
      case 'ASHA':
        return AppTheme.primaryGreen;
      case 'Health Official':
        return AppTheme.primaryBlue;
      case 'Community':
        return AppTheme.warningOrange;
      case 'Community Member':
        return AppTheme.neutralGray;
      default:
        return AppTheme.neutralGray;
    }
  }

  IconData _getAuthorIcon(String role) {
    switch (role) {
      case 'ASHA':
        return Icons.medical_services;
      case 'Health Official':
        return Icons.verified_user;
      case 'Community':
        return Icons.groups;
      case 'Community Member':
        return Icons.person;
      default:
        return Icons.person;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Health Alerts':
        return AppTheme.errorRed;
      case 'Water Quality':
        return AppTheme.primaryBlue;
      case 'Community Health':
        return AppTheme.primaryGreen;
      case 'Preventive Care':
        return AppTheme.successGreen;
      case 'ASHA Updates':
        return AppTheme.warningOrange;
      default:
        return AppTheme.neutralGray;
    }
  }

  void _createNewPost() {
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
        builder: (context, scrollController) => _buildCreatePostForm(scrollController),
      ),
    );
  }

  Widget _buildCreatePostForm(ScrollController scrollController) {
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
                  'Create New Post',
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
            
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
              ),
              items: categories.skip(1).map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter post title',
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Share your thoughts, questions, or information...',
                alignLabelWithHint: true,
              ),
              maxLines: 6,
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tags (optional)',
                hintText: 'Enter tags separated by commas',
                prefixIcon: Icon(Icons.tag),
              ),
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
                    onPressed: _submitPost,
                    child: const Text('Post'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitPost() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Post created successfully!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _viewPost(Map<String, dynamic> post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post),
      ),
    );
  }

  void _likePost(Map<String, dynamic> post) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post liked!')),
    );
  }

  void _sharePost(Map<String, dynamic> post) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post shared!')),
    );
  }

  void _bookmarkPost(Map<String, dynamic> post) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post bookmarked!')),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Showing notifications')),
    );
  }

  void _showSearchDialog() {
    showSearch(
      context: context,
      delegate: PostSearchDelegate(forumPosts),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

class PostDetailScreen extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post['title'],
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              post['content'],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppTheme.spacingL),
            Text(
              'Comments coming soon...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.neutralGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> posts;

  PostSearchDelegate(this.posts);

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
    final results = posts.where((post) {
      return post['title'].toLowerCase().contains(query.toLowerCase()) ||
             post['content'].toLowerCase().contains(query.toLowerCase()) ||
             post['author'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final post = results[index];
        return ListTile(
          title: Text(post['title']),
          subtitle: Text(post['content'], maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () {
            close(context, post);
          },
        );
      },
    );
  }
}