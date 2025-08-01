import 'dart:convert';
import 'dart:io' as io show Directory, File;
import 'package:e_contrat/page/linear.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart' as path;
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Définir un document par défaut

// Mandeha ny POST

// final url = Uri.parse('http://192.168.229.144:1627/todo');
// Future<void>getData() async{
 
 

//  try{
//   final response = await http.get(url);
//   final data = jsonDecode(response.body);
//   debugPrint('Donnee : $data');


//   if (response.statusCode ==200 ){

//   }
//  }
//  catch(e){

//   debugPrint('Erreur $e');
//  }
// }






// Future<void>postData() async{

  

//   final data = {
//     'titre':'Fetch',
//     'description': 'Dera'
//   };


//   try {
//     final response = await http.post(
//       url,
//       headers:{'Content-Type':'application/json'},
//       body:jsonEncode(data),


//     );

//     if (response.statusCode==201 || response.statusCode == 200){
//       debugPrint('succes: ${response.body}');
//     }
//     else{
//       debugPrint('Erreur ${response.statusCode}');
//     }
//   }
//   catch(e){
//     debugPrint('Exception: $e');
//   }

// }


// class Edit extends StatelessWidget {
//   const Edit({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light(useMaterial3: true),
//       darkTheme: ThemeData.dark(useMaterial3: true),
//       themeMode: ThemeMode.system,
//       home: HomePage(),
//       localizationsDelegates: [
//         GlobalMaterialLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         FlutterQuillLocalizations.delegate,
//       ],
//     );
//   }
// }

class Editor extends StatefulWidget {
  
  const Editor({super.key, this.formData});


  final Map<String, String>? formData;



  @override
  State<Editor> createState() => _HomePageState();
}

class _HomePageState extends State<Editor> {
  final kQuillDefaultSample = [
  {'insert': '\n'}
];
  final QuillController _controller = () {
    return QuillController.basic(
        config: QuillControllerConfig(
      clipboardConfig: QuillClipboardConfig(
        enableExternalRichPaste: true,
        onImagePaste: (imageBytes) async {
          if (kIsWeb) {
            return null;
          }
          final newFileName =
              'image-file-${DateTime.now().toIso8601String()}.png';
          final newPath = path.join(
            io.Directory.systemTemp.path,
            newFileName,
          );
          final file = await io.File(newPath).writeAsBytes(imageBytes, flush: true);
          return file.path;
        },
      ),
    ));
  }();
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.document = Document.fromJson(kQuillDefaultSample);
  }
  @override
  Widget build(BuildContext context) {

    final formData = widget.formData ?? {};


    return Scaffold(
      resizeToAvoidBottomInset:false ,
       extendBodyBehindAppBar: true,
        appBar: AppBar(
           automaticallyImplyLeading: false,
            centerTitle: true,
           elevation: 0,
           backgroundColor: Colors.transparent,
         
          title: Text('Motif du contrat',
          
          style: TextStyle(
             fontWeight: FontWeight.bold
          ),
          ),
        ),





      body: 
      Stack(

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
          Align(
         alignment: Alignment(-1,-10),
           child: SvgPicture.asset(
            'assets/svg/Consent2.svg',
            width: 370.h,
            height:370.w,
           ),
             ),
           
            
          Scaffold(
            backgroundColor: Colors.transparent,
            
            body: Stack(
              children: [
                Align(
                  alignment: Alignment(0, 0.2),
                  child: SafeArea(
                    child: SizedBox(
                      width: 80.w,
                      child: Column(
                        children: [
                          QuillSimpleToolbar(
                            controller: _controller,
                            config: QuillSimpleToolbarConfig(
                              multiRowsDisplay: false,
                              embedButtons: FlutterQuillEmbeds.toolbarButtons(),
                              showClipboardPaste: true,
                              customButtons: [
                                QuillToolbarCustomButtonOptions(
                                  icon: const Icon(Icons.add_alarm_rounded),
                                  onPressed: () {
                                    _controller.document.insert(
                                      _controller.selection.extentOffset,
                                      TimeStampEmbed(
                                        DateTime.now().toString(),
                                      ),
                                    );
                                    _controller.updateSelection(
                                      TextSelection.collapsed(
                                        offset: _controller.selection.extentOffset + 1,
                                      ),
                                      ChangeSource.local,
                                    );
                                  },
                                ),
                              ],
                              buttonOptions: QuillSimpleToolbarButtonOptions(
                                base: QuillToolbarBaseButtonOptions(
                                  afterButtonPressed: () {
                                    final isDesktop = {
                                      TargetPlatform.linux,
                                      TargetPlatform.windows,
                                      TargetPlatform.macOS
                                    }.contains(defaultTargetPlatform);
                                    if (isDesktop) {
                                      _editorFocusNode.requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: QuillEditor(
                              focusNode: _editorFocusNode,
                              scrollController: _editorScrollController,
                              controller: _controller,
                              config: QuillEditorConfig(
                                placeholder: 'Ndao e-contrat...',
                                padding: const EdgeInsets.all(16),
                                embedBuilders: [
                                  ...FlutterQuillEmbeds.editorBuilders(
                                    imageEmbedConfig: QuillEditorImageEmbedConfig(
                                      imageProviderBuilder: (context, imageUrl) {
                                        if (imageUrl.startsWith('assets/')) {
                                          return AssetImage(imageUrl);
                                        }
                                        return null;
                                      },
                                    ),
                                    videoEmbedConfig: QuillEditorVideoEmbedConfig(
                                      customVideoBuilder: (videoUrl, readOnly) {
                                        return null;
                                      },
                                    ),
                                  ),
                                  TimeStampEmbedBuilder(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          
            floatingActionButton: SizedBox(
              width:15.w,
              height: 7.h,
              child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)
                              ) ,
                    onPressed: () {
              var quillContentList = _controller.document.toDelta().toJson();
     
              var quillContent = {'ops': quillContentList};
              // Si c'est une String, parse-la en Map
             debugPrint("quillContent après encapsulation : $quillContent");
              debugPrint("formData passé : $formData");
              Navigator.pushNamed(
                context,
                '/preview',
                arguments: {
                  'formData': formData,
                  'quillContent': quillContent,
                },
              );
            },
                    child: Icon(Icons.check,
                    size: 30,),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorScrollController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }
}

class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(
    String value,
  ) : super(timeStampType, value);

  static const String timeStampType = 'timeStamp';

  static TimeStampEmbed fromDocument(Document document) =>
      TimeStampEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class TimeStampEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'timeStamp';

  @override
  String toPlainText(Embed node) {
    return node.value.data;
  }

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded),
        Text(embedContext.node.value.data as String),
      ],
    );
  }
}