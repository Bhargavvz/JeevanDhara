import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../widgets/common_widgets.dart';

class DataVisualizationScreen extends StatefulWidget {
  const DataVisualizationScreen({Key? key}) : super(key: key);

  @override
  State<DataVisualizationScreen> createState() => _DataVisualizationScreenState();
}

class _DataVisualizationScreenState extends State<DataVisualizationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  String selectedTimeRange = 'Last 30 Days';
  String selectedDistrict = 'All Districts';
  int selectedTabIndex = 0;
  
  final List<String> timeRanges = [
    'Last 7 Days',
    'Last 30 Days',
    'Last 3 Months',
    'Last Year'
  ];

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
            // Filters Section
            _buildFiltersSection(),
            
            // Chart Tabs
            _buildChartTabs(),
            
            // Chart Content
            Expanded(
              child: _buildChartContent(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Health Analytics'),
      backgroundColor: AppTheme.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 4,
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: _exportData,
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _refreshData,
        ),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedTimeRange,
              decoration: const InputDecoration(
                labelText: 'Time Range',
                prefixIcon: Icon(Icons.date_range),
              ),
              items: timeRanges.map((range) {
                return DropdownMenuItem(
                  value: range,
                  child: Text(range),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTimeRange = value!;
                });
              },
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedDistrict,
              decoration: const InputDecoration(
                labelText: 'District',
                prefixIcon: Icon(Icons.location_on),
              ),
              items: ['All Districts', ...AppConstants.districts.take(5)]
                  .map((district) {
                return DropdownMenuItem(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      child: DefaultTabController(
        length: 4,
        child: TabBar(
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.neutralGray,
          indicatorColor: AppTheme.primaryBlue,
          onTap: (index) {
            setState(() {
              selectedTabIndex = index;
            });
          },
          tabs: const [
            Tab(text: 'Cases Trend'),
            Tab(text: 'By District'),
            Tab(text: 'Symptoms'),
            Tab(text: 'Water Sources'),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContent() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Main Chart
            _buildMainChart(),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Summary Stats
            _buildSummaryStats(),
            
            const SizedBox(height: AppTheme.spacingL),
            
            // Additional Insights
            _buildInsightsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainChart() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getChartTitle(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          SizedBox(
            height: 300,
            child: _buildChart(),
          ),
        ],
      ),
    );
  }

  String _getChartTitle() {
    switch (selectedTabIndex) {
      case 0:
        return 'Disease Cases Over Time';
      case 1:
        return 'Cases by District';
      case 2:
        return 'Symptom Distribution';
      case 3:
        return 'Water Source Issues';
      default:
        return 'Health Analytics';
    }
  }

  Widget _buildChart() {
    switch (selectedTabIndex) {
      case 0:
        return _buildLineChart();
      case 1:
        return _buildBarChart();
      case 2:
        return _buildPieChart();
      case 3:
        return _buildWaterSourceChart();
      default:
        return _buildLineChart();
    }
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 5,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.lightGray,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: AppTheme.lightGray,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(
                      color: AppTheme.neutralGray,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 5,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: AppTheme.neutralGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
              reservedSize: 32,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: AppTheme.lightGray),
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 30,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 12),
              FlSpot(1, 18),
              FlSpot(2, 15),
              FlSpot(3, 22),
              FlSpot(4, 19),
              FlSpot(5, 25),
              FlSpot(6, 21),
            ],
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryBlue.withOpacity(0.8),
                AppTheme.primaryBlue,
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.primaryBlue,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryBlue.withOpacity(0.3),
                  AppTheme.primaryBlue.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 50,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => AppTheme.darkGray,
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.round()} cases',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const districts = ['Kamrup', 'Cachar', 'Jorhat', 'Nagaon', 'Dibrugarh'];
                if (value.toInt() >= 0 && value.toInt() < districts.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      districts[value.toInt()],
                      style: const TextStyle(
                        color: AppTheme.neutralGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 10,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    color: AppTheme.neutralGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 45, color: AppTheme.primaryGreen)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 32, color: AppTheme.primaryBlue)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 28, color: AppTheme.warningOrange)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 38, color: AppTheme.secondaryGreen)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 25, color: AppTheme.infoBlue)]),
        ],
        gridData: FlGridData(show: false),
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Handle touch events
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: [
          PieChartSectionData(
            color: AppTheme.primaryGreen,
            value: 35,
            title: 'Diarrhea\n35%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: AppTheme.primaryBlue,
            value: 25,
            title: 'Fever\n25%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: AppTheme.warningOrange,
            value: 20,
            title: 'Vomiting\n20%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: AppTheme.secondaryGreen,
            value: 15,
            title: 'Nausea\n15%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            color: AppTheme.neutralGray,
            value: 5,
            title: 'Other\n5%',
            radius: 80,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterSourceChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const sources = ['Wells', 'Rivers', 'Ponds', 'Boreholes'];
                if (value.toInt() >= 0 && value.toInt() < sources.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      sources[value.toInt()],
                      style: const TextStyle(
                        color: AppTheme.neutralGray,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 20,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(
                    color: AppTheme.neutralGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(toY: 65, color: AppTheme.errorRed, width: 20),
              BarChartRodData(toY: 35, color: AppTheme.successGreen, width: 20),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(toY: 40, color: AppTheme.errorRed, width: 20),
              BarChartRodData(toY: 60, color: AppTheme.successGreen, width: 20),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(toY: 80, color: AppTheme.errorRed, width: 20),
              BarChartRodData(toY: 20, color: AppTheme.successGreen, width: 20),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(toY: 25, color: AppTheme.errorRed, width: 20),
              BarChartRodData(toY: 75, color: AppTheme.successGreen, width: 20),
            ],
          ),
        ],
        gridData: FlGridData(show: false),
      ),
    );
  }

  Widget _buildSummaryStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Total Cases', '1,247', Icons.medical_services, AppTheme.primaryBlue),
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: _buildStatCard('Active Cases', '189', Icons.local_hospital, AppTheme.warningOrange),
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: _buildStatCard('Recovery Rate', '94.2%', Icons.trending_up, AppTheme.successGreen),
        ),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(
          child: _buildStatCard('Alerts', '12', Icons.warning, AppTheme.errorRed),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return CustomCard(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.neutralGray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights, color: AppTheme.primaryGreen),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Key Insights',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildInsightItem(
            'Diarrhea cases increased by 15% this week',
            AppTheme.warningOrange,
            Icons.trending_up,
          ),
          _buildInsightItem(
            'Kohima district shows highest water contamination',
            AppTheme.errorRed,
            Icons.warning,
          ),
          _buildInsightItem(
            'Recovery rate improved by 5% compared to last month',
            AppTheme.successGreen,
            Icons.trending_up,
          ),
          _buildInsightItem(
            'ASHA worker reporting efficiency: 92%',
            AppTheme.primaryBlue,
            Icons.assessment,
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String text, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting data to CSV...')),
    );
  }

  void _refreshData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing analytics data...')),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}