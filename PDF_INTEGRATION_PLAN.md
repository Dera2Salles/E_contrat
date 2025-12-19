# Integration of PDF Generation & Signature Logic

We will restore and properly integrate the core PDF generation and signature handling logic from the original `pdfquill.dart` into the refactored project structure.

## Proposed Changes

### presentation
#### [MODIFY] [contract_pdf_quill_page_impl.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/presentation/pages/contract_pdf_quill_page_impl.dart)
- Update the PDF generation flow to ensure it matches the original logic for:
  - Delta simplification.
  - Signature capture and PNG conversion.
  - PDF modification using Syncfusion to add signatures on the last page.
  - Use case integration for final saving.
- Restore the original navigation flow (e.g., navigating back to the home/grid after success).
- Integrate the animated loading widgets.

#### [MODIFY] [loading.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/core/widgets/loading.dart)
- Restore the `LoadingWithAnimtedWidget` and `AnimatedWavyText` functionality to provide the original premium loading experience.

#### [MODIFY] [custom_quill_editor.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/presentation/quill/custom_quill_editor.dart)
- Ensure this file is correctly implemented to support the special editor features used in `pdfquill.dart`.

#### [MODIFY] [fonts_loader.dart](file:///home/ayanokoji/Documents/Coding/E_contrat/lib/features/contract/presentation/quill/fonts_loader.dart)
- Ensure all required fonts are correctly loaded as per the original implementation.

## Verification Plan

### Automated Verification
- Run `flutter analyze` to ensure no new errors are introduced.
- Verify `build_runner` for DI consistency.

### Manual Verification
- Test the contract generation flow:
  1. Fill the wizard.
  2. Open the editor.
  3. Sign as both parties.
  4. Generate the PDF.
  5. Verify the PDF contains the signatures on the last page.
  6. Verify the PDF is saved and appears in the PDF list.
