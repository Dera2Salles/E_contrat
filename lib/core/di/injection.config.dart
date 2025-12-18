// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:get_it/get_it.dart' as i1;
import 'package:injectable/injectable.dart' as i2;

import 'injection.dart' as i3;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
i1.GetIt $initGetIt(
  i1.GetIt getIt, {
  String? environment,
  i2.EnvironmentFilter? environmentFilter,
}) {
  i2.GetItHelper(getIt, environment, environmentFilter);
  i3.RegisterModule();
  return getIt;
}
