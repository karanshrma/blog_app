import 'package:supabase_flutter/supabase_flutter.dart' as su;
import 'package:offline_first/core/common/entities/user.dart' as entity;

entity.User mapSupabaseUserToEntity(su.User user) {
  print('🔹 Mapping Supabase user to entity');
  return entity.User(
    id: user.id,
    email: user.email ?? '',
    name: user.userMetadata?['name'] ?? '',
  );
}
