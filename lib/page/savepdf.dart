import 'dart:io';
import 'package:e_contrat/page/databasehelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

Future<void> savePdf(List<int>  bytes, String fileName) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, fileName));
  await file.writeAsBytes(bytes);

  // Sauvegarde dans la base de données
  await DatabaseHelper.insertPdf(fileName, file.path);
}

