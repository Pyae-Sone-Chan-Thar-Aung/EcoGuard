import 'package:flutter/material.dart';
import '../../screens/education/eco_museum_screen.dart';


class AsiaEWasteMap extends StatefulWidget {
  const AsiaEWasteMap({Key? key}) : super(key: key);

  @override
  State<AsiaEWasteMap> createState() => _AsiaEWasteMapState();
}

class _AsiaEWasteMapState extends State<AsiaEWasteMap> {
  final List<Map<String, dynamic>> countries = [
    {"name": "China", "waste": 10000, "category": "Critical", "offset": Offset(0.65, 0.15)},
    {"name": "India", "waste": 3200, "category": "Awareness", "offset": Offset(0.35, 0.35)},
    {"name": "Japan", "waste": 2500, "category": "Warning", "offset": Offset(0.85, 0.22)},
    {"name": "South Korea", "waste": 800, "category": "Warning", "offset": Offset(0.78, 0.18)},
    {"name": "Thailand", "waste": 900, "category": "Warning", "offset": Offset(0.52, 0.55)},
    {"name": "Vietnam", "waste": 800, "category": "Awareness", "offset": Offset(0.58, 0.48)},
    {"name": "Philippines", "waste": 500, "category": "Warning", "offset": Offset(0.72, 0.52)},
    {"name": "Indonesia", "waste": 1500, "category": "Warning", "offset": Offset(0.58, 0.7)},
    {"name": "Malaysia", "waste": 400, "category": "Warning", "offset": Offset(0.55, 0.62)},
    {"name": "Singapore", "waste": 70, "category": "Awareness", "offset": Offset(0.55, 0.65)},
    {"name": "Myanmar", "waste": 300, "category": "Warning", "offset": Offset(0.48, 0.42)},
    {"name": "Cambodia", "waste": 150, "category": "Warning", "offset": Offset(0.58, 0.52)},
    {"name": "Laos", "waste": 120, "category": "Awareness", "offset": Offset(0.55, 0.46)},
    {"name": "Brunei", "waste": 50, "category": "Awareness", "offset": Offset(0.62, 0.58)},
  ];

  String? selectedCountry;

  Color _getCategoryColor(String category) {
    switch (category) {
      case "Critical":
        return const Color(0xFFE53E3E);
      case "Danger":
        return const Color(0xFFDD6B20);
      case "Warning":
        return const Color(0xFFD69E2E);
      case "Awareness":
        return const Color(0xFF38A169);
      default:
        return const Color(0xFF718096);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        title: const Text(
          "Asia E-Waste Distribution",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF38A169),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Legend
          _buildLegend(),

          // Map
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Custom painted map background
                        Positioned.fill(
                          child: CustomPaint(
                            painter: AsiaMapPainter(),
                          ),
                        ),

                        // Country markers
                        ...countries.map((country) {
                          final position = Offset(
                            constraints.maxWidth * country["offset"].dx,
                            constraints.maxHeight * country["offset"].dy,
                          );

                          final isSelected = selectedCountry == country["name"];
                          final waste = country["waste"] as int;
                          final markerSize = _getMarkerSize(waste);

                          return Positioned(
                            left: position.dx - markerSize / 2,
                            top: position.dy - markerSize / 2,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCountry = country["name"];
                                });
                                _showCountrySheet(context, country);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: markerSize,
                                height: markerSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getCategoryColor(country["category"]),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: isSelected ? 3 : 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getCategoryColor(country["category"]).withOpacity(0.4),
                                      blurRadius: isSelected ? 12 : 8,
                                      spreadRadius: isSelected ? 2 : 1,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _getWasteLabel(waste),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: markerSize * 0.25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),

                        // Country labels
                        if (selectedCountry != null)
                          ...countries.where((c) => c["name"] == selectedCountry).map((country) {
                            final position = Offset(
                              constraints.maxWidth * country["offset"].dx,
                              constraints.maxHeight * country["offset"].dy,
                            );

                            return Positioned(
                              left: position.dx - 40,
                              top: position.dy - 50,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  country["name"],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Statistics
          _buildStatistics(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "E-Waste Categories",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem("Critical", const Color(0xFFE53E3E), "> 5000kt"),
              _buildLegendItem("Warning", const Color(0xFFD69E2E), "500-5000kt"),
              _buildLegendItem("Awareness", const Color(0xFF38A169), "< 500kt"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String range) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A5568),
          ),
        ),
        Text(
          range,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    final totalWaste = countries.fold<int>(
        0, (sum, country) => sum + (country["waste"] as int));
    final criticalCount =
        countries.where((c) => c["category"] == "Critical").length;
    final warningCount =
        countries.where((c) => c["category"] == "Warning").length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            "Total E-Waste",
            "${totalWaste}kt",
            Icons.delete_outline,
            Colors.green, // ✅ Suitable for total (eco-awareness)
          ),
          _buildStatItem(
            "Critical Zones",
            "$criticalCount",
            Icons.warning,
            Colors.redAccent, // ✅ Critical = red
          ),
          _buildStatItem(
            "Warning Zones",
            "$warningCount",
            Icons.error_outline,
            Colors.amber.shade700, // ✅ Warning = yellow
          ),
        ],
      ),
    );
  }

  /// Modified version of _buildStatItem with color
  Widget _buildStatItem(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  double _getMarkerSize(int waste) {
    if (waste > 5000) return 50.0;
    if (waste > 1000) return 40.0;
    if (waste > 500) return 35.0;
    return 30.0;
  }

  String _getWasteLabel(int waste) {
    if (waste >= 1000) return "${(waste / 1000).toStringAsFixed(0)}k";
    return waste.toString();
  }

  void _showCountrySheet(BuildContext context, Map<String, dynamic> country) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(country["category"]).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.public,
                        color: _getCategoryColor(country["category"]),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          country["name"],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        Text(
                          "E-Waste Generation",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Annual E-Waste",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4A5568),
                            ),
                          ),
                          Text(
                            "${country["waste"]} kilotons",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _getCategoryColor(country["category"]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: (country["waste"] / 10000).clamp(0.0, 1.0),
                        backgroundColor: Colors.grey.shade200,
                        color: _getCategoryColor(country["category"]),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: _getCategoryColor(country["category"]).withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: _getCategoryColor(country["category"]),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Status: ",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4A5568),
                        ),
                      ),
                      Text(
                        country["category"],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _getCategoryColor(country["category"]),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  "💡 E-waste contains valuable materials that can be recycled, but improper disposal leads to environmental pollution and health risks.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getCategoryColor(country["category"]),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // close the bottom sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EcoMuseumScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Learn More About E-Waste Management",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("About E-Waste Mapping"),
        content: const Text(
          "This map shows electronic waste generation across Asian countries. "
              "E-waste includes discarded electronic devices and is one of the fastest-growing waste streams globally. "
              "Proper management and recycling are crucial for environmental protection.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

class AsiaMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color(0xFFCBD5E0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw simplified Asia continent shape
    final path = Path();

    // Simplified Asia outline
    path.moveTo(size.width * 0.1, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.1, size.width * 0.3, size.height * 0.05);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.02, size.width * 0.85, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.95, size.height * 0.3, size.width * 0.9, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.85, size.height * 0.7, size.width * 0.7, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.9, size.width * 0.3, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.15, size.height * 0.7, size.width * 0.1, size.height * 0.5);
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);

    // Add some geographical features (simplified)
    final featurePaint = Paint()
      ..color = const Color(0xFFBBDBF5)
      ..style = PaintingStyle.fill;

    // Add water bodies representation
    final waterPath = Path();
    waterPath.addOval(Rect.fromLTWH(size.width * 0.3, size.height * 0.3, size.width * 0.1, size.height * 0.05));
    waterPath.addOval(Rect.fromLTWH(size.width * 0.6, size.height * 0.4, size.width * 0.15, size.height * 0.08));
    canvas.drawPath(waterPath, featurePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}