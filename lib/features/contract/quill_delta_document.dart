import 'dart:collection';

import 'package:equatable/equatable.dart';

class QuillDeltaDocument extends Equatable {
  final UnmodifiableListView<Map<String, dynamic>> ops;

  QuillDeltaDocument._(List<Map<String, dynamic>> ops)
      : ops = UnmodifiableListView(ops);

  factory QuillDeltaDocument.fromJson(List<dynamic> json) {
    final ops = json.map<Map<String, dynamic>>((e) {
      if (e is Map<String, dynamic>) return e;
      if (e is Map) return Map<String, dynamic>.from(e);
      throw ArgumentError('Invalid delta op: $e');
    }).toList(growable: false);

    return QuillDeltaDocument._(ops);
  }

  List<Map<String, dynamic>> toJson() => List<Map<String, dynamic>>.from(ops);

  @override
  List<Object?> get props => [ops];
}
