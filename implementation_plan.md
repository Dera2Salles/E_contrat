# Plan: Fix Flutter Analysis Issues

Fix 36 issues identified by `flutter analyze` following the refactoring of the Assistant and BLoC migration.

## Proposed Changes

### [Assistant Feature]
#### [MODIFY] [assistant_local_datasource.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/assistant/data/datasources/assistant_local_datasource.dart)
- Fix `AppConfig` import path (needs 4 levels: `../../../../core/config/app_config.dart`).
- Resolve undefined identifiers.

#### [MODIFY] [assistant_usecases.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/assistant/domain/usecases/assistant_usecases.dart)
- Add missing `import '../entities/assistant_message_entity.dart';`.

#### [MODIFY] [assistant_screen.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/assistant/presentation/pages/assistant_screen.dart)
- Migrate `withOpacity` to `withValues`.

### [Contract Feature]
#### [MODIFY] [contract_templates_static_datasource.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/data/datasources/contract_templates_static_datasource.dart)
- Fix legacy data source: Instead of `import 'package:e_contrat/page/sample.dart' as legacy;` (which was deleted), I need to find where that data went or restore it if it's needed but missing. Wait, the data should have been migrated to the new feature structure.

#### [MODIFY] [contract_categories_page.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/presentation/pages/contract_categories_page.dart)
- Add missing `import '../entities/contract_category.dart';`.

#### [MODIFY] [contract_wizard_form.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/presentation/pages/contract_wizard_form.dart)
- Migrate `withOpacity` to `withValues`.

#### [MODIFY] [contract_item.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/presentation/widgets/contract_item.dart)
- Remove unused `scheme` variable.
- Migrate `withOpacity` to `withValues`.

### [PDF Management Feature]
#### [MODIFY] [pdf_list_bloc.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/pdf_management/presentation/bloc/pdf_list_bloc.dart)
- Fix imports: `import 'pdf_list_state.dart';` and `import 'pdf_list_event.dart';`.
- Fix `DeletePdf` use case call: ensure the argument matches the signature.

#### [MODIFY] [pdf_list_page.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/pdf_management/presentation/pages/pdf_list_page.dart)
- Resolve missing state class imports.

### [Misc]
#### [MODIFY] [home.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/page/home.dart)
- Migrate `withOpacity` to `withValues`.

## Verification Plan

### Automated Tests
- Run `flutter analyze` after all fixes to ensure 0 issues.

### Manual Verification
- Review critical screens in the app to ensure they render correctly.
