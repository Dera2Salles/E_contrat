import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_quill_to_pdf/flutter_quill_to_pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:ui' as ui;

import '../../../pdf_management/domain/usecases/save_pdf_bytes.dart';
import '../quill/fonts_loader.dart';
import 'contract_pdf_event.dart';
import 'contract_pdf_state.dart';

@injectable
class ContractPdfBloc extends Bloc<ContractPdfEvent, ContractPdfState> {
  final SavePdfBytes savePdfBytes;
  final FontsLoader loader = FontsLoader();

  ContractPdfBloc(this.savePdfBytes) : super(const ContractPdfState()) {
    on<InitContractPdf>(_onInit);
    on<CaptureSignature>(_onCaptureSignature);
    on<GeneratePdfRequested>(_onGeneratePdf);
  }

  void _onInit(InitContractPdf event, Emitter<ContractPdfState> emit) {
    if (event.documentModel.isEmpty) return;
    
    final documentData = event.documentModel.map((op) {
      if (op['insert'] is String) {
        String text = op['insert'];
        event.formData.forEach((key, value) {
          text = text.replaceAll('[$key]', value);
        });
        return {
          'insert': text,
          'attributes': op['attributes'],
        };
      }
      return op;
    }).toList();

    emit(state.copyWith(processedDocument: documentData));
  }

  void _onCaptureSignature(CaptureSignature event, Emitter<ContractPdfState> emit) {
    if (event.index == 0) {
      emit(state.copyWith(
        signatureBytes1: event.bytes,
        signatureImage1: event.image,
      ));
    } else {
      emit(state.copyWith(
        signatureBytes2: event.bytes,
        signatureImage2: event.image,
      ));
    }
  }

  Future<void> _onGeneratePdf(GeneratePdfRequested event, Emitter<ContractPdfState> emit) async {
    emit(state.copyWith(status: ContractPdfStatus.loading));
    try {
      await loader.loadFonts();

      final dir = await getApplicationDocumentsDirectory();
      final String filePath = p.join(dir.path, 'temp_document_${DateTime.now().millisecondsSinceEpoch}.pdf');
      final File file = File(filePath);

      Delta safeDelta = Delta();
      try {
        for (final op in event.content.operations) {
          if (op.value is String) {
            safeDelta.insert(op.value);
          } else if (op.value is Map) {
            final Map valueMap = op.value as Map;
            if (valueMap.containsKey('insert')) {
              final Map<String, dynamic> attributes = {};
              if (op.attributes != null) {
                if (op.attributes!.containsKey('align')) {
                  attributes['align'] = op.attributes!['align'];
                }
                if (op.attributes!.containsKey('header')) {
                  attributes['header'] = op.attributes!['header'];
                }
              }
              safeDelta.insert(valueMap['insert'], attributes.isNotEmpty ? attributes : null);
            }
          }
        }
      } catch (e) {
        safeDelta = event.content;
      }

      final safeConverter = PDFConverter(
        backMatterDelta: null,
        frontMatterDelta: null,
        isWeb: kIsWeb,
        document: safeDelta,
        fallbacks: [...loader.allFonts()],
        onRequestFontFamily: (FontFamilyRequest familyRequest) {
          final normalFont = loader.getFontByName(fontFamily: familyRequest.family);
          return FontFamilyResponse(
            fontNormalV: normalFont,
            boldFontV: normalFont,
            italicFontV: normalFont,
            boldItalicFontV: normalFont,
            fallbacks: [normalFont],
          );
        },
        pageFormat: PDFPageFormat.a4,
      );

      final document = await safeConverter.createDocument();
      if (document == null) {
        emit(state.copyWith(status: ContractPdfStatus.failure, errorMessage: 'Impossible de créer le document PDF'));
        return;
      }

      Uint8List originalPdfBytes = await document.save();
      await file.writeAsBytes(originalPdfBytes);

      if (state.signatureBytes1 != null || state.signatureBytes2 != null) {
        final existingPdfBytes = await file.readAsBytes();
        final existingPdf = PdfDocument(inputBytes: existingPdfBytes);

        if (existingPdf.pages.count > 0) {
          PdfPage lastPage = existingPdf.pages[existingPdf.pages.count - 1];
          PdfGraphics graphics = lastPage.graphics;
          final pageHeight = lastPage.size.height;
          final pageWidth = lastPage.size.width;
          PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 10);

          if (state.signatureBytes2 != null) {
            PdfBitmap signature2 = PdfBitmap(state.signatureBytes2!);
            graphics.drawString('        ${event.parties[1]}', font,
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                bounds: ui.Rect.fromLTWH(pageWidth - 170, pageHeight - 150, 150, 20));
            graphics.drawImage(signature2, ui.Rect.fromLTWH(pageWidth - 170, pageHeight - 140, 150, 80));
          }

          if (state.signatureBytes1 != null) {
            PdfBitmap signature1 = PdfBitmap(state.signatureBytes1!);
            graphics.drawString('      ${event.parties[0]}', font,
                brush: PdfSolidBrush(PdfColor(0, 0, 0)),
                bounds: ui.Rect.fromLTWH(655 - pageWidth, pageHeight - 150, 150, 20));
            graphics.drawImage(signature1, ui.Rect.fromLTWH(30, pageHeight - 140, 150, 80));
          }
        }

        final List<int> modifiedPdfBytes = await existingPdf.save();
        
        String fileName = 'Document';
        if (event.formData.containsKey(event.placeholders[0]) && event.formData.containsKey(event.placeholders[2])) {
           fileName = '${event.formData[event.placeholders[0]]} et ${event.formData[event.placeholders[2]]}';
        }

        await savePdfBytes(modifiedPdfBytes, fileName);
        
        if (await file.exists()) {
          await file.delete();
        }
        existingPdf.dispose();
      } else {
         String fileName = 'Document';
         await savePdfBytes(originalPdfBytes, fileName);
         if (await file.exists()) {
          await file.delete();
        }
      }

      emit(state.copyWith(status: ContractPdfStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ContractPdfStatus.failure, errorMessage: e.toString()));
    }
  }
}
