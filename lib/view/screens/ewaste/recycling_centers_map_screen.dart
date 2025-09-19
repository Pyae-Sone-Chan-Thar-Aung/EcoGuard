import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import '../../../core/theme/app_colors.dart';

class RecyclingCentersMapScreen extends StatefulWidget {
  const RecyclingCentersMapScreen({super.key});

  @override
  State<RecyclingCentersMapScreen> createState() => _RecyclingCentersMapScreenState();
}

class _RecyclingCentersMapScreenState extends State<RecyclingCentersMapScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Electronics', 'Batteries', 'Large Appliances', 'Mobile Devices'];

  // Mock recycling centers data (in a real app, this would come from an API)
  final List<Map<String, dynamic>> _recyclingCenters = [
    {
      'id': '1',
      'name': 'EcoTech Recycling Center',
      'address': '123 Green Street, Eco City',
      'phone': '+1 (555) 123-4567',
      'hours': 'Mon-Fri: 8AM-6PM, Sat: 9AM-4PM',
      'accepts': ['Electronics', 'Batteries', 'Cables', 'Small Appliances'],
      'rating': 4.5,
      'distance': '1.2 km',
    },
    {
      'id': '2',
      'name': 'Green Electronics Disposal',
      'address': '456 Recycling Avenue, Green Town',
      'phone': '+1 (555) 234-5678',
      'hours': 'Tue-Sat: 9AM-5PM',
      'accepts': ['Computers', 'Phones', 'TVs', 'Gaming Consoles'],
      'rating': 4.2,
      'distance': '2.8 km',
    },
    {
      'id': '3',
      'name': 'Sustainable Tech Hub',
      'address': '789 Environmental Way, Clean City',
      'phone': '+1 (555) 345-6789',
      'hours': 'Mon-Sat: 7AM-7PM',
      'accepts': ['All Electronics', 'Batteries', 'Accessories', 'Large Appliances'],
      'rating': 4.8,
      'distance': '4.1 km',
    },
    {
      'id': '4',
      'name': 'City Electronics Recycling',
      'address': '321 Waste Management Blvd, Metro City',
      'phone': '+1 (555) 456-7890',
      'hours': 'Mon-Fri: 8AM-5PM',
      'accepts': ['Mobile Devices', 'Laptops', 'Tablets', 'Chargers'],
      'rating': 4.0,
      'distance': '5.7 km',
    },
    {
      'id': '5',
      'name': 'Zero Waste Electronics',
      'address': '654 Circular Economy Drive, Future City',
      'phone': '+1 (555) 567-8901',
      'hours': 'Every Day: 9AM-6PM',
      'accepts': ['All E-Waste', 'Precious Metal Recovery', 'Data Destruction'],
      'rating': 4.7,
      'distance': '6.3 km',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadRecyclingCenters();
  }

  Future<void> _loadRecyclingCenters() async {
    // Simulate loading
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
  }

  void _showCenterDetails(Map<String, dynamic> center) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // Center name and rating
              Row(
                children: [
                  Expanded(
                    child: Text(
                      center['name'],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${center['rating']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Distance
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    '${center['distance']} away',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.map, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      center['address'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Phone
              Row(
                children: [
                  const Icon(Icons.phone, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    center['phone'],
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Hours
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.access_time, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      center['hours'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // What they accept
              const Text(
                'Accepts:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (center['accepts'] as List<String>)
                    .map((item) => Chip(
                          label: Text(item),
                          backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
                          side: const BorderSide(color: AppColors.primaryGreen),
                        ))
                    .toList(),
              ),
              
              const SizedBox(height: 32),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _launchPhone(center['phone']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                      icon: const Icon(Icons.phone),
                      label: const Text('Call'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _launchDirections(center['address']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                      ),
                      icon: const Icon(Icons.directions),
                      label: const Text('Directions'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchDirections(String address) async {
    final query = Uri.encodeComponent(address);
    final Uri uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  List<Map<String, dynamic>> get filteredCenters {
    if (_selectedFilter == 'All') {
      return _recyclingCenters;
    }
    return _recyclingCenters.where((center) {
      final accepts = center['accepts'] as List<String>;
      return accepts.any((item) => item.contains(_selectedFilter));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Recycling Centers'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primaryGreen),
                  SizedBox(height: 16),
                  Text('Loading recycling centers...'),
                ],
              ),
            )
          : Column(
              children: [
                // Filter and search section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: AppColors.primaryGreen),
                          const SizedBox(width: 8),
                          const Text(
                            'Near you',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${filteredCenters.length} centers found',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Filter chips
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filterOptions.length,
                          itemBuilder: (context, index) {
                            final filter = _filterOptions[index];
                            final isSelected = _selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(filter),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                                checkmarkColor: AppColors.primaryGreen,
                                backgroundColor: Colors.grey[100],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Centers list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredCenters.length,
                    itemBuilder: (context, index) {
                      final center = filteredCenters[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _showCenterDetails(center),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryGreen.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.recycling,
                                        color: AppColors.primaryGreen,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            center['name'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                center['distance'],
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              const Icon(
                                                Icons.star,
                                                size: 14,
                                                color: Colors.amber,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${center['rating']}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        center['hours'],
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: (center['accepts'] as List<String>)
                                      .take(3)
                                      .map((item) => Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryGreen.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.primaryGreen,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
