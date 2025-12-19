import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:e_contrat/core/di/injection.config.dart';

export 'injection.config.dart';


final getIt = GetIt.instance;

@module
abstract class RegisterModule {
}

@injectableInit
void configureDependencies() => getIt.init();

// Manual registrations removed as they are now handled by @injectable
void registerFeatureDependencies() {}
