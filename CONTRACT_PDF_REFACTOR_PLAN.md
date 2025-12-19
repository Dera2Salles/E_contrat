# Refactoring Contract PDF Page Plan

We will refactor `contract_pdf_quill_page_impl.dart` to follow Clean Architecture and BLoC patterns.

## Proposed Changes

### [Presentation Layer]
#### [NEW] [contract_pdf_bloc.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/presentation/bloc/contract_pdf/contract_pdf_bloc.dart)
- Manage contract initialization (placeholder replacement).
- Manage signature states (captured/not captured, image data).
- Manage PDF generation state (Idle, Generating, Success, Error).

#### [NEW] [contract_pdf_event.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/presentation/bloc/contract_pdf/contract_pdf_event.dart)
- `InitContractPdf`
- `UpdateSignature`
- `GeneratePdf`

#### [NEW] [contract_pdf_state.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/presentation/bloc/contract_pdf/contract_pdf_state.dart)
- `ContractPdfState` with fields for signatures, generation status, and document data.

#### [MODIFY] [contract_pdf_quill_page_impl.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/presentation/pages/contract_pdf_quill_page_impl.dart)
- Convert `StatefulWidget` to `StatelessWidget` (or keep it as `Stateful` only for the `QuillController` lifecycle).
- Use `BlocBuilder` and `BlocListener` for UI updates and navigation.
- Move business logic (placeholder replacement, PDF generation coordination) to the BLoC.

### [Domain Layer]
- Leverage `SavePdfBytes` use case.
- Potentially create a `ProcessContractDocument` use case if placeholder logic becomes more complex.

## Verification Plan
- Run `flutter analyze`.
- Verify the full flow: Wizard -> Editor -> signatures -> PDF generation -> success navigation.
