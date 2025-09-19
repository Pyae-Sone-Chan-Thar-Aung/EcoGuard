import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/route_names.dart';
import '../../widgets/common/bottom_nav.dart';

class EcoMuseumScreen extends StatelessWidget {
  const EcoMuseumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      {'title':'What is E-Waste?', 'desc':'E-waste includes discarded electronics like phones and laptops, often containing hazardous materials.'},
      {'title':'Green Computing', 'desc':'Designing, manufacturing, and using computers to reduce environmental impact.'},
      {'title':'Climate Change', 'desc':'Rising global temperatures caused by greenhouse gas emissions threaten ecosystems worldwide.'},
      {'title':'Sustainable Living', 'desc':'Everyday actions like recycling, reducing energy use, and planting trees make a difference.'},
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eco Museum'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final it = items[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.school,
                  color: AppColors.primaryGreen,
                ),
              ),
              title: Text(
                it['title']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                it['desc']!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryGreen,
                size: 16,
              ),
              onTap: () {
                _showArticleDetails(context, it);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: EcoBottomNav(
        currentIndex: 0, // Dashboard tab (education accessible from there)
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
  
  void _showArticleDetails(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item['title']!),
        content: SingleChildScrollView(
          child: Text(
            item['desc']! + '\n\n' + _getExtendedContent(item['title']!),
            style: const TextStyle(fontSize: 16, height: 1.5),
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
  
  String _getExtendedContent(String title) {
    switch (title) {
      case 'What is E-Waste?':
        return 'Electronic waste represents the fastest-growing waste stream globally. Proper disposal is crucial as these devices contain both valuable materials like gold and silver, and hazardous substances like lead and mercury. Many components can be recycled and reused in new products, reducing the need for mining raw materials.';
      case 'Green Computing':
        return 'Green computing involves creating energy-efficient hardware, using renewable energy sources, and developing software that requires less computational power. This includes designing devices that last longer, consume less power, and can be easily recycled at the end of their lifecycle.';
      case 'Climate Change':
        return 'Climate change affects every aspect of our planet, from rising sea levels to changing weather patterns. The technology sector can help by developing more efficient devices, supporting renewable energy, and creating solutions for monitoring and reducing carbon emissions.';
      case 'Sustainable Living':
        return 'Sustainable living means making conscious choices that reduce our environmental impact. This includes choosing durable electronics, participating in recycling programs, reducing energy consumption, and supporting companies with strong environmental policies.';
      default:
        return 'Learn more about environmental topics and how technology can help create a more sustainable future.';
    }
  }
  }

