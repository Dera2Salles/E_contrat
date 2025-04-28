import 'package:e_contrat/page/contrat_item.dart';
import 'package:e_contrat/page/linear.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class ContractListScreen extends StatelessWidget {

  final String title;
  final List<Map<String, dynamic>> data;
  const ContractListScreen({super.key,required this.data , required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false ,
       extendBodyBehindAppBar: true,
      appBar: AppBar(
      automaticallyImplyLeading: false,
       backgroundColor: Colors.transparent,
      
      
      ),
      body: Stack(
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
          SizedBox(
            height: 150.h,
            child: PageView.builder(
              scrollDirection: Axis.vertical, // Vertical scrolling
              itemCount: data.length,
              itemBuilder: (context, index) {
                final contract = data[index];
                return ContractItem(
                  totalItems: data.length,
                  index: index,
                  placeholders: List<String>.from(contract['placeholders']),
                  data: contract['data'],
                  partie:contract['partie'],
                  title: title ,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

