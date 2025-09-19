import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user/user_profile.dart';
import '../../models/tree/tree_model.dart';
import '../../models/e_waste/ewaste_item.dart';
import '../../models/carbon/carbon_footprint.dart';


class SupabaseDataService {
  final _client = Supabase.instance.client;

  // Get current logged-in user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) return null;

    return UserProfile.fromJson(response);
  }

  // Fetch user’s planted trees
  Future<List<TreeModel>> getUserTrees() async {
    final response = await _client
        .from('trees')
        .select()
        .eq('planted_by', _client.auth.currentUser?.id ?? '');

    return (response as List).map((e) => TreeModel.fromJson(e)).toList();
  }

  // Fetch ewaste items
  Future<List<EwasteItem>> getEwasteItems() async {
    final response = await _client.from('ewaste_items').select();
    return (response as List).map((e) => EwasteItem.fromJson(e)).toList();
  }

  // Fetch carbon footprint records
  Future<List<CarbonFootprint>> getCarbonFootprints() async {
    final response = await _client
        .from('carbon_footprints')
        .select()
        .eq('user_id', _client.auth.currentUser?.id ?? '');

    return (response as List)
        .map((e) => CarbonFootprint.fromJson(e))
        .toList();
  }
}
