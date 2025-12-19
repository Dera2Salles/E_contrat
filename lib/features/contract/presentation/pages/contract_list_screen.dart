import 'package:e_contrat/features/contract/presentation/widgets/contract_item.dart';
import 'package:e_contrat/core/widgets/linear.dart';
import 'package:e_contrat/features/contract/presentation/responsive.dart';
import 'package:flutter/material.dart';

class ContractListScreen extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;

  const ContractListScreen({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          const Linear(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final contract = data[index];
                      return ContractItem(
                        totalItems: data.length,
                        index: index,
                        placeholders: List<String>.from(contract['placeholders']),
                        data: contract['data'],
                        partie: contract['partie'],
                        title: title,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
