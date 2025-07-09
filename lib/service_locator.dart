import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/interceptor.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );

  sl.registerSingleton<AppInterceptor>(AppInterceptor());
}
