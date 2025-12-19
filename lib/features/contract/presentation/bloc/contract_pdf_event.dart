import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;
import 'package:flutter_quill/quill_delta.dart';

abstract class ContractPdfEvent extends Equatable {
  const ContractPdfEvent();
  @override
  List<Object?> get props => [];
}

class InitContractPdf extends ContractPdfEvent {
  final List<dynamic> documentModel;
  final Map<String, String> formData;
  const InitContractPdf(this.documentModel, this.formData);
}

class CaptureSignature extends ContractPdfEvent {
  final int index; // 0 or 1
  final Uint8List bytes;
  final ui.Image image;
  const CaptureSignature(this.index, this.bytes, this.image);
}

class GeneratePdfRequested extends ContractPdfEvent {
  final Delta content;
  final List<String> parties;
  final List<String> placeholders;
  final Map<String, String> formData;
  const GeneratePdfRequested({
    required this.content,
    required this.parties,
    required this.placeholders,
    required this.formData,
  });
}
