import 'package:e_contrat/page/listsample.dart';
import 'package:e_contrat/page/linear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:e_contrat/page/sample.dart';

class Template extends StatelessWidget {
  
    Template({super.key});




  final List<IconData> icons = [
    FontAwesomeIcons.cartShopping,
FontAwesomeIcons.handHoldingDollar,
  FontAwesomeIcons.key,
  FontAwesomeIcons.briefcase,
  FontAwesomeIcons.userTie,
  FontAwesomeIcons.users,
  FontAwesomeIcons.fileInvoice,
  FontAwesomeIcons.gift,
  FontAwesomeIcons.rightLeft,
  ];
  final List<String> labels = [
   'Vente',
  'Prêt',
  'Location',
  'Service',
  'Travail',
  'Partenariat',
  'Prestation',
  'Don',
  'Cession',
  ];

  final List<String> destination = [
    '/list',
     '/list',
      '/list',
       '/list',
        '/list',
         '/list',
          '/list',
           '/list',
            '/list',
    
  ];

   final List<List<Map<String, dynamic>>> template = [
      contractVente,
      contractPret,
      contractLocation,
      contractService,
      contractTravail,
      contractPartenariat,
      contractPrestation,
      contractDon,
      contractCession,
    
  ];


  @override
  Widget build(BuildContext context) {
    return      Stack(
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
      alignment: Alignment(-0.03.w, -0.04.h),
         child: SvgPicture.asset(
      'assets/svg/Consent.svg',
      width: 75.w ,
      height:75.h,
         ),
       ), 
      Align(
        alignment: Alignment(-0.05.w, 0.02.h),
        child: SizedBox(
      width: 70.w,
      height: 70.h,
      child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 colonnes
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 30,
                    ),
                    itemCount: 9, // 3x3 = 9 items
                    itemBuilder: (context, index) {
                      return  Column(
                        children: [
                          SizedBox(
                            width: 17.w,
                            height: 8.h,
                            child: FloatingActionButton(
                              heroTag: "fab_grid_$index",
                              elevation: 1,
                                            shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50)
                                      ) ,
                            onPressed: () {
                             Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContractListScreen(data: template[index], title: labels[index],),
                                    ),
                                  );
                            },
                            child:
                                Icon(icons[index],
                                size: 30,),
                                
                              
                            ),
                          ),
                          SizedBox(height: 0.5.h,),
                          Text(labels[index],
                          style: TextStyle(
           color:  Color(0xFF3200d5),
           fontWeight: FontWeight.bold
        ),
                          )
                        ],
                      );
                    },
                ),
        ),
      ),
         ],
        );  
  }
}