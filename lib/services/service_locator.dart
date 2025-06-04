import 'package:get_it/get_it.dart';
import 'auth_service.dart';
import 'supabase_service.dart';


final getIt = GetIt.instance;

void setupServiceLocator() {
  // Register services 
  getIt.registerLazySingleton<SupabaseService>(() => SupabaseService());
  getIt.registerLazySingleton<AuthManager>(() => AuthManager());
}