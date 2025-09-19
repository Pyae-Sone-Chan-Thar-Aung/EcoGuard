import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/router/route_names.dart';
import '../../../services/data/fake_data_service.dart';
import '../../../services/points/points_service.dart';
import '../../../models/carbon/carbon_footprint.dart';
import '../../widgets/common/bottom_nav.dart';

class CarbonCalculatorScreen extends ConsumerStatefulWidget {
  const CarbonCalculatorScreen({super.key});
  @override
  ConsumerState<CarbonCalculatorScreen> createState() =>
      _CarbonCalculatorScreenState();
}

class _CarbonCalculatorScreenState
    extends ConsumerState<CarbonCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isCalculating = false;
  CarbonFootprint? _lastCalculation;
  final PointsService _pointsService = PointsService();

  final _electricityController = TextEditingController();
  final _gasController = TextEditingController();
  final _carMilesController = TextEditingController();
  final _flightsController = TextEditingController();
  String? _diet; // dropdown selection

  @override
  void dispose() {
    _electricityController.dispose();
    _gasController.dispose();
    _carMilesController.dispose();
    _flightsController.dispose();
    super.dispose();
  }

  String? _numberValidator(String? v) {
    if (v == null || v.isEmpty) return 'Required';
    final n = double.tryParse(v);
    if (n == null || n < 0) return 'Enter a valid number';
    return null;
  }

  Widget _buildSectionHeader(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(t,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Calculator'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    const Icon(Icons.calculate,
                        size: 48, color: AppColors.primaryGreen),
                    const SizedBox(height: 12),
                    const Text('Calculate Your Carbon Footprint',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(
                      'Enter your annual consumption data to get personalized reduction suggestions',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Home Energy'),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(children: [
                              TextFormField(
                                controller: _electricityController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Monthly Electricity (kWh)',
                                    hintText: 'e.g., 300',
                                    prefixIcon:
                                    Icon(Icons.electrical_services)),
                                validator: _numberValidator,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _gasController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Monthly Natural Gas (cubic feet)',
                                    hintText: 'e.g., 1000',
                                    prefixIcon: Icon(Icons.local_fire_department)),
                                validator: _numberValidator,
                              ),
                            ]),
                          )),
                      const SizedBox(height: 16),
                      _buildSectionHeader('Transportation'),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(children: [
                              TextFormField(
                                controller: _carMilesController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Annual Car Miles',
                                    hintText: 'e.g., 12000',
                                    prefixIcon: Icon(Icons.directions_car)),
                                validator: _numberValidator,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _flightsController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    labelText: 'Annual Flight Hours',
                                    hintText: 'e.g., 10',
                                    prefixIcon: Icon(Icons.flight)),
                                validator: _numberValidator,
                              ),
                            ]),
                          )),
                      const SizedBox(height: 16),
                      _buildSectionHeader('Diet'),
                      Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: DropdownButtonFormField<String>(
                              value: _diet,
                              decoration: const InputDecoration(
                                  labelText: 'Diet Type',
                                  prefixIcon: Icon(Icons.restaurant)),
                              items: const [
                                DropdownMenuItem(
                                    value: 'meat_heavy',
                                    child: Text('Meat Heavy')),
                                DropdownMenuItem(
                                    value: 'average', child: Text('Average')),
                                DropdownMenuItem(
                                    value: 'vegetarian',
                                    child: Text('Vegetarian')),
                                DropdownMenuItem(
                                    value: 'vegan', child: Text('Vegan')),
                              ],
                              onChanged: (v) => setState(() => _diet = v),
                              validator: (v) =>
                              (v == null || v.isEmpty)
                                  ? 'Please select your diet type'
                                  : null,
                            ),
                          )),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isCalculating ? null : _calculate,
                          child: _isCalculating
                              ? const CircularProgressIndicator()
                              : const Text('Calculate'),
                        ),
                      ),
                    ]),
              ),
              if (_lastCalculation != null) ...[
                const SizedBox(height: 24),
                _ResultCard(result: _lastCalculation!),
              ],
            ]),
      ),
      bottomNavigationBar: EcoBottomNav(
        currentIndex: 3, // Carbon tab
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
              // Already on carbon page
              break;
            case 4:
              context.go(RouteNames.leaderboard);
              break;
          }
        },
      ),
    );
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isCalculating = true);

    final electricityAnnual =
        (double.parse(_electricityController.text)) * 12 * 0.42;
    final gasAnnual = (double.parse(_gasController.text)) * 0.054;
    final car = (double.parse(_carMilesController.text)) * 0.251;
    final flights = (double.parse(_flightsController.text)) * 90.0;

    double diet;
    switch (_diet) {
      case 'meat_heavy':
        diet = 3200.0;
        break;
      case 'average':
        diet = 2200.0;
        break;
      case 'vegetarian':
        diet = 1700.0;
        break;
      case 'vegan':
        diet = 1500.0;
        break;
      default:
        diet = 2200.0;
    }

    final inputs = {
      'home_electricity': electricityAnnual,
      'natural_gas': gasAnnual,
      'car': car,
      'flights': flights,
      'diet': diet,
    };

    // Use provider
    final service = ref.read(fakeDataServiceProvider);
    final result = await service.calculateCarbonFootprint(inputs);

    if (!mounted) return;
    
    // Record the carbon calculation activity
    await _pointsService.addCarbonCalculationActivity(
      result.totalAnnualEmissions,
      10, // Base points for calculating carbon footprint
    );
    
    setState(() {
      _lastCalculation = result;
      _isCalculating = false;
    });
  }
}

// ✅ This class must be outside _CarbonCalculatorScreenState
class _ResultCard extends StatelessWidget {
  final CarbonFootprint result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final emissions = result.emissionsByCategory;
    final sections = emissions.entries
        .map((e) => PieChartSectionData(
      value: e.value,
      title: e.key,
      radius: 50,
    ))
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Your Annual Emissions',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${result.totalAnnualEmissions.toStringAsFixed(0)} kg CO₂e',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen)),
          const SizedBox(height: 12),
          SizedBox(
              height: 200,
              child: PieChart(PieChartData(sections: sections))),
          const SizedBox(height: 12),
          const Text('Recommendations:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          ...result.recommendedActions.map((a) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.check_circle_outline),
            title: Text(a),
          )),
          const Divider(),
          Text(
            'Trees to offset: ${result.treesNeededToOffset.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ]),
      ),
    );

  }
}
