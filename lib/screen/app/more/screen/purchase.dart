

import 'package:expense/providers/subscribe.dart';
import 'package:expense/utils/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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
        
        body: Provider.of<SubscriptionProvider>(context).premiumUser?
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Center(
                child: Image.asset(
                  lifiIcon,
              
                  
                ),
              ),

              Text(
                'You\'re Subscribed',

                style: TextStyle(
                  fontSize: 18,
                  color: appSuccess
                ),
              ),

              SizedBox(height: 30,),

              DefaultButton(
                text: 'Unsubscribe',

                onTap: () async{
                  Provider.of<SubscriptionProvider>(context, listen: false).getSubscriptionStatus();
                  setState(() {
                    
                  });
                },
              )


            ]
          )
         )

        :
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Get full access to all features'
              ),

              const SizedBox(height: 30,),

              const PurchaseTile(
                title: 'Remove Ads',
                icon: MdiIcons.advertisementsOff,
              ),

              const SizedBox(height: 15,),

              const PurchaseTile(
                title: 'Unlimited Categories',
                image: categoryIcon,
              ),

              const SizedBox(height: 15,),

              const PurchaseTile(
                title: 'Unlimited Budgets',
                image: budgetIcon,
              ),

              const SizedBox(height: 15,),

              const PurchaseTile(
                title: 'Unlimited Planners',
                icon: MdiIcons.menuOpen,
              ),

              const SizedBox(height: 15,),

              const PurchaseTile(
                title: 'Export your infornation (PDF, CSV)',
                icon: MdiIcons.filePdfBox,
              ),

              const SizedBox(height: 15,),

              const PurchaseTile(
                title: 'Access to Full Reports',
                image: reportIcon,
              ),

              const SizedBox(height: 15,),

              const PurchaseTile(
                title: 'Multiple devices support',
                icon: MdiIcons.menuOpen,
              ),

              

              const SizedBox(height: 15,),

              const PurchaseTile(
                title: 'Backup and Restore',
                icon: MdiIcons.backupRestore,
              ),

              const SizedBox(height: 35,),

              DefaultButton(
                text: 'Subscribe',

                onTap: () async{
                  Provider.of<SubscriptionProvider>(context, listen: false).getSubscriptionStatus();
                  setState(() {
                    
                  });
                },
              ),

              const SizedBox(height: 35,),


              
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