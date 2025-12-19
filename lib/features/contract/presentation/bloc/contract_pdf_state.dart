import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;

enum ContractPdfStatus { initial, loading, success, failure }

class ContractPdfState extends Equatable {
  final ContractPdfStatus status;
  final String? errorMessage;
  final Uint8List? signatureBytes1;
  final Uint8List? signatureBytes2;
  final ui.Image? signatureImage1;
  final ui.Image? signatureImage2;
  final List<dynamic>? processedDocument;

  const ContractPdfState({
    this.status = ContractPdfStatus.initial,
    this.errorMessage,
    this.signatureBytes1,
    this.signatureBytes2,
    this.signatureImage1,
    this.signatureImage2,
    this.processedDocument,
  });

  bool get hasSignature1 => signatureBytes1 != null;
  bool get hasSignature2 => signatureBytes2 != null;

  ContractPdfState copyWith({
    ContractPdfStatus? status,
    String? errorMessage,
    Uint8List? signatureBytes1,
    Uint8List? signatureBytes2,
    ui.Image? signatureImage1,
    ui.Image? signatureImage2,
    List<dynamic>? processedDocument,
  }) {
    return ContractPdfState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      signatureBytes1: signatureBytes1 ?? this.signatureBytes1,
      signatureBytes2: signatureBytes2 ?? this.signatureBytes2,
      signatureImage1: signatureImage1 ?? this.signatureImage1,
      signatureImage2: signatureImage2 ?? this.signatureImage2,
      processedDocument: processedDocument ?? this.processedDocument,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        signatureBytes1,
        signatureBytes2,
        signatureImage1,
        signatureImage2,
        processedDocument,
      ];
}
