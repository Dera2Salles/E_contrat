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
    final scheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(context.rs(8)),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: context.rs(20)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: context.rf(20),
            fontWeight: FontWeight.w700,
            fontFamily: 'Outfit',
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const Linear(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.rs(24), vertical: context.rs(16)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: context.rs(20), vertical: context.rs(4)),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(context.rs(20)),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.white, fontSize: context.rf(16)),
                      decoration: InputDecoration(
                        icon: Icon(Icons.search_rounded, color: Colors.white70, size: context.rs(24)),
                        hintText: 'Rechercher un modèle...',
                        hintStyle: TextStyle(color: Colors.white60, fontSize: context.rf(15)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
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
