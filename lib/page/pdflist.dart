import 'dart:io';
import 'package:e_contrat/page/databasehelper.dart';
import 'package:e_contrat/page/deleteConfirm.dart';
import 'package:e_contrat/page/linear.dart';
import 'package:e_contrat/page/pdfviewscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class PdfListScreen extends StatefulWidget {
  const PdfListScreen({super.key});

  @override
  State<PdfListScreen> createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  List<Map<String, dynamic>> _pdfs = [];

  @override
  void initState() {
    super.initState();
    _loadPdfs();
  }

  Future<void> _loadPdfs() async {
    final pdfs = await DatabaseHelper.getAllPdfs();
    setState(() {
      _pdfs = pdfs;
    });
  }

  Future<void> _deletePdf(int id, String path) async {
    await DatabaseHelper.deletePdf(id); // suppression base
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
       debugPrint('PDF DB supprime'); // suppression fichier physique
    }
    await _loadPdfs(); // recharge la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _pdfs.isNotEmpty
          ?  Stack(
                  children: [
                        Linear(),
       Positioned(
        top: 35.h,
       right: 55.w,
         child: Transform.scale(
      scale: 3.0,
       child: SvgPicture.asset(
        'assets/svg/background.svg',
        width: 35.w,
        height:35.h,
       ),
         ),
       ) ,

                ListView.builder(
              itemCount: _pdfs.length,
              itemBuilder: (context, index) {
                final pdf = _pdfs[index];
                return  Dismissible(
                  key: Key(pdf['id'].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white,),

                  ),
                  confirmDismiss: (direction) async {
                    return await ConfirmationDelete.show(
                      context,
                      title: 'Supprimer ?',
                      message: 'Ce fichier sera supprime definitevement',

                    );
                  
                  },
                  onDismissed: (direction)async => {
                  await _deletePdf(pdf['id'], pdf['path'])
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: Color(0xFF3200d5),
                      size: 35,
                    ),
                    title: Text(pdf['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PdfViewScreen(path: pdf['path'], title:pdf['name']),
                        ),
                      );
                    },
                    
                  ),
                );
                
              },
            ),
               
               
               ]
               ) 
          :   Stack(
                  children: [
                          Linear(),
       Positioned(
        top: 35.h,
       right: 55.w,
         child: Transform.scale(
      scale: 3.0,
       child: SvgPicture.asset(
        'assets/svg/background.svg',
        width: 35.w,
        height:35.h,
       ),
         ),
       ) ,
 ]
  )         
    );
  }
}


           



