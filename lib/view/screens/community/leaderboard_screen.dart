import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/route_names.dart';
import '../../widgets/common/bottom_nav.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});
  @override State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  final List<_User> _global = const [
    _User('Sarah Chen', 2847, 1),
    _User('Mike Rodriguez', 2651, 2),
    _User('Emma Wilson', 2433, 3),
    _User('Juan (You)', 1250, 127),
  ];

  final List<_User> _weekly = const [
    _User('Alex Turner', 425, 1),
    _User('Maria Garcia', 387, 2),
    _User('Juan (You)', 156, 3),
  ];

  @override
  Widget build(BuildContext context) {
    final myRank = _tabController.index == 0 ? _global.firstWhere((u)=>u.name.contains('(You)')).rank : _weekly.firstWhere((u)=>u.name.contains('(You)')).rank;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        bottom: TabBar(
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.white,
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Time'),
            Tab(text: 'This Week'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryGreen, AppColors.lightGreen],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: AppColors.primaryGreen),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Rank',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '#$myRank in ${_tabController.index == 0 ? 'Global' : 'Weekly'}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _List(users: _global),
                _List(users: _weekly),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: EcoBottomNav(
        currentIndex: 4, // Community/Leaderboard tab
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(RouteNames.dashboard);
              break;
            case 1:
              context.go(RouteNames.treePlanting);
              break;
            case 2:
              context.go(RouteNames.ewaste);
              break;
            case 3:
              context.go(RouteNames.carbonCalculator);
              break;
            case 4:
              // Already on leaderboard page
              break;
          }
        },
      ),
    );
  }
}

class _List extends StatelessWidget {
  final List<_User> users;
  const _List({required this.users});
  @override Widget build(BuildContext context){
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (_, i){
        final u = users[i];
        return Card(child: ListTile(title: Text('${u.rank}. ${u.name}'), trailing: Text('${u.points} pts')));
      },
    );
  }
}

class _User {
  final String name; final int points; final int rank;
  const _User(this.name, this.points, this.rank);
}
