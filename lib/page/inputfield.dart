import 'package:e_contrat/page/linear.dart';
import 'package:e_contrat/page/pdfquill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class FormScreen extends StatefulWidget {

  final List<dynamic> template;
  const FormScreen({super.key , required this.template});

  @override
  // ignore: library_private_types_in_public_api
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    "Nom": TextEditingController(),
    "Date": TextEditingController(),
    "Montant": TextEditingController(),
  };
  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      resizeToAvoidBottomInset:false ,
       extendBodyBehindAppBar: true,
        appBar: AppBar(
           automaticallyImplyLeading: false,
            centerTitle: true,
           elevation: 0,
           backgroundColor: Colors.transparent,
         
          title: Text('Veuillez remplir',
          
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
         alignment: Alignment(-1,3),
           child: SvgPicture.asset(
            'assets/svg/Consent2.svg',
            width: 375.h,
            height:375.w,
           ),
             ),
           
            
          Scaffold(
            backgroundColor: Colors.transparent,
            
            body: Stack(
              children: [
                Center(
                  child: Padding(
                    padding:EdgeInsets.all(34) ,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                      SizedBox(height: 50,),
                      TextFormField(
                        controller: _controllers["Nom"],
                        decoration: InputDecoration(labelText: "Nom"),
                        validator: (value) => value!.isEmpty ? "Champ requis" : null,
                      ),
                      TextFormField(
                        controller: _controllers["Date"],
                        decoration: InputDecoration(labelText: "Date"),
                        validator: (value) => value!.isEmpty ? "Champ requis" : null,
                      ),
                      TextFormField(
                        controller: _controllers["Montant"],
                        decoration: InputDecoration(labelText: "Montant"),
                        validator: (value) => value!.isEmpty ? "Champ requis" : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Map<String, String> formData = {};
                            _controllers.forEach((key, controller) {
                              formData[key] = controller.text;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PdfQuill(formData: formData, documentModel: widget.template,),
                              ),
                            );
                          }
                        },
                        child: Text("Suivant : Rédiger le motif"),
                      ),
                        ],
                      ),
                    ),
                  ),
                )

              ]





            )  
          ),
        ],
      ),
    );
  }


}