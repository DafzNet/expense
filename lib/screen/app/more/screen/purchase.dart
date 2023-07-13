

import 'package:expense/utils/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../widgets/default_button.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('Subscribe'),
        
          ),
        ], 
        
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Get full access to all features'
              ),

              SizedBox(height: 30,),

              PurchaseTile(
                title: 'Remove Ads',
                icon: MdiIcons.advertisementsOff,
              ),

              SizedBox(height: 15,),

              PurchaseTile(
                title: 'Unlimited Categories',
                image: categoryIcon,
              ),

              SizedBox(height: 15,),

              PurchaseTile(
                title: 'Unlimited Budgets',
                image: budgetIcon,
              ),

              SizedBox(height: 15,),

              PurchaseTile(
                title: 'Export your infornation (PDF, CSV)',
                icon: MdiIcons.filePdfBox,
              ),

              SizedBox(height: 15,),

              PurchaseTile(
                title: 'Access to Full Reports',
                image: reportIcon,
              ),

              SizedBox(height: 15,),

              PurchaseTile(
                title: 'Unlimited Planners',
                icon: MdiIcons.menuOpen,
              ),

              SizedBox(height: 15,),

              PurchaseTile(
                title: 'Backup and Restore',
                icon: MdiIcons.backupRestore,
              ),

              SizedBox(height: 65,),


              DefaultButton(
                text: 'Subscribe',
              )




              
            ],
          ),
        ),

      )
      
    );
  }
}

class PurchaseTile extends StatelessWidget {
  final String title;
  final String? image;
  final IconData? icon;

  const PurchaseTile({
    required this.title,
    this.icon,
    this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(width: .2, color: appSuccess.shade200),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 16
            ),
          ),

          image != null ?
          ImageIcon(
            AssetImage(image!),
            color: appDanger,
            size: 20,
          ):
          Icon(
            icon,

            color: appDanger,
          ),
        ],
      ),
    );
  }
}