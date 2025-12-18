import 'package:equatable/equatable.dart';

class PdfDocument extends Equatable {
  final int id;
  final String name;
  final String path;

  const PdfDocument({
    required this.id,
    required this.name,
    required this.path,
  });

  @override
  List<Object?> get props => [id, name, path];
}
