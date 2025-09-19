import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../services/points/points_service.dart';
import '../../widgets/common/bottom_nav.dart';

class TreePlantingHub extends ConsumerStatefulWidget {
  const TreePlantingHub({super.key});

  @override
  ConsumerState<TreePlantingHub> createState() => _TreePlantingHubState();
}

class _TreePlantingHubState extends ConsumerState<TreePlantingHub> {
  List<Map<String, dynamic>> trees = [];
  bool isLoading = false;
  late Box<Map> treesBox;
  final PointsService _pointsService = PointsService();

  final List<String> treeSpecies = [
    'English Oak',
    'Silver Birch',
    'Norway Spruce',
    'Douglas Fir',
    'Scots Pine',
    'European Beech',
    'Sweet Chestnut',
    'Field Maple',
  ];

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    treesBox = await Hive.openBox<Map>('trees');
    _loadTrees();
  }

  Future<void> _loadTrees() async {
    setState(() => isLoading = true);
    
    final treesList = <Map<String, dynamic>>[];
    for (int i = 0; i < treesBox.length; i++) {
      final tree = Map<String, dynamic>.from(treesBox.getAt(i) ?? {});
      treesList.add(tree);
    }
    
    // Sort by planted date (most recent first)
    treesList.sort((a, b) => b['planted_at'].compareTo(a['planted_at']));
    
    setState(() {
      trees = treesList;
      isLoading = false;
    });
  }

  Future<void> _plantTree() async {
    final random = Random();
    final species = treeSpecies[random.nextInt(treeSpecies.length)];
    final carbonOffset = 20 + random.nextInt(30); // 20-49 CO₂ offset
    
    final newTree = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'species': species,
      'carbon_offset': carbonOffset,
      'planted_at': DateTime.now().toIso8601String(),
    };

    await treesBox.add(newTree);
    _loadTrees();
    
    // Record activity in points service
    await _pointsService.addTreePlantingActivity(species, carbonOffset);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🌳 Successfully planted $species! +$carbonOffset points'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Forest"),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _loadTrees,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // Summary header
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Forest', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text('${trees.length} trees', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Estimated CO₂ offset', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      Text('${_estimateCO2()} kg', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: trees.length,
                itemBuilder: (context, index) {
                  final tree = trees[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.park, color: AppColors.primaryGreen),
                      ),
                      title: Text(tree['species'] ?? 'Unknown Tree', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(_formatPlantedDate(tree['planted_at'])),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('+${tree['carbon_offset']} pts', style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          const Text('CO₂', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _plantTree,
        icon: const Icon(Icons.add),
        label: const Text("Plant Tree"),
        backgroundColor: AppColors.primaryGreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: EcoBottomNav(
        currentIndex: 1, // Trees tab
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
              context.go(RouteNames.leaderboard);
              break;
          }
        },
      ),
    );
  }

  String _formatPlantedDate(String? isoDate) {
    if (isoDate == null) return 'Unknown date';
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final difference = now.difference(date);
      
      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return 'Unknown date';
    }
  }

  int _estimateCO2() {
    int total = 0;
    for (final t in trees) {
      total += (t['carbon_offset'] as int? ?? 0);
    }
    return total;
  }
}
