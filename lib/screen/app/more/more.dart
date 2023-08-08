import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense/dbs/budget_db.dart';
import 'package:expense/dbs/category_db.dart';
import 'package:expense/dbs/income_db.dart';
import 'package:expense/dbs/plan_exp_db.dart';
import 'package:expense/dbs/planner_db.dart';
import 'package:expense/dbs/saving_db.dart';
import 'package:expense/dbs/settings.dart';
import 'package:expense/dbs/vault_db.dart';
import 'package:expense/dbs/versions.dart';
import 'package:expense/firebase/auth/auth.dart';
import 'package:expense/firebase/db/expense/fs_expense.dart';
import 'package:expense/screen/app/more/screen/accountability/accountability.dart';
import 'package:expense/screen/app/more/screen/budget/budget.dart';
import 'package:expense/screen/app/more/screen/category/category.dart';
import 'package:expense/screen/app/more/screen/income/income.dart';
import 'package:expense/screen/app/more/screen/planner/planner.dart';
import 'package:expense/screen/app/more/screen/purchase.dart';
import 'package:expense/screen/app/more/screen/reports/reports.dart';
import 'package:expense/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../dbs/expense.dart';
import '../../../firebase/db/user.dart';
import '../../../models/user_model.dart';
import '../../../utils/capitalize.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/images.dart';
import '../../../widgets/upload/selector.dart';
import 'screen/about/about.dart';
import 'screen/backup/backup.dart';
import 'screen/feedback/feedback.dart';
import 'screen/setting/setting.dart';
import 'screen/vaults/vault.dart';

class MoreScreen extends StatefulWidget {

  final LightUser user;

  const MoreScreen({
    required this.user,
    super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {

  ImagePickerCropper imagePickerCropper = ImagePickerCropper();
  File? image;
  final ExpenseDb expDB = ExpenseDb();
  FirebaseExpenseDb? fsExpDb;

  void createFBExpsModel(){
    fsExpDb = FirebaseExpenseDb(uid: widget.user.id);
    setState(() {
      
    });
  }


  bool loading = false;

  @override
  void initState() {
    createFBExpsModel();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 15,


        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark
          ),
      ),

      body: LoadingIndicator(
        loading: loading,
        child: Column(
          children: [
      
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Stack(
                                children: [
                                  SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: ClipOval(
                                      child: widget.user.dp != null && widget.user.dp!.isNotEmpty?
                                          CachedNetworkImage(
                                            imageUrl: widget.user.dp!,
                                          ):
                                          Container(
                                        color: appOrange,
                                  
                                        child: Center(
                                          child: Text(
                                            '${widget.user.firstName!.substring(0,1).toUpperCase()}${widget.user.lastName!.substring(0,1).toUpperCase()}',
                                                            
                                            style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              shadows: [
                                                Shadow(
                                                  blurRadius: 10,
                                                  offset: Offset(1, 1)
                                                )
                                              ]
                                            ),
                                          ),
                                        ),
                                      )
                                    ),
                                  ),
                      
                                  Positioned(
                                      right: 5,
                                      bottom: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context, 
                                            builder: (context){
                                              return ClipRRect(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                                child: Container(
                                                  color: Colors.white,
                                                  height: 100,
                      
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      ClipOval(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                              color: appOrange.shade100
                                                            ),
                                                            padding: EdgeInsets.all(20),
                                                          child: IconButton(
                                                            onPressed: ()async{
                                                              Navigator.pop(context);
                                                              FirebaseUserDb firebaseUserDb = FirebaseUserDb(uid: widget.user.id);
                                                              image = await imagePickerCropper.imgFromCamera(crop: false);
                                                              
                                                              String downloadLink = await imagePickerCropper.uploadFile(widget.user.id);
                      
                                                              LightUser updatedUser = widget.user.copyWith(
                                                                dp: downloadLink
                                                              );
                      
                                                              await firebaseUserDb.updateUser(updatedUser);
                      
                                                            }, 
                                                            icon: Icon(
                                                              MdiIcons.camera
                                                            )
                                                          ),
                                                        ),
                                                      ),
                      
                                                      ClipOval(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            color: appOrange.shade100
                                                          ),
                                                          padding: EdgeInsets.all(20),
                                                          child: IconButton(
                                                            onPressed: ()async{
                                                              Navigator.pop(context);
                                                              FirebaseUserDb firebaseUserDb = FirebaseUserDb(uid: widget.user.id);
                                                              image = await imagePickerCropper.imgFromGallery(quality: 70, crop: false);
                                                              
                                                              String downloadLink = await imagePickerCropper.uploadFile(widget.user.id);
                      
                                                              LightUser updatedUser = widget.user.copyWith(
                                                                dp: downloadLink
                                                              );
                      
                                                              await firebaseUserDb.updateUser(updatedUser);
                                                            },
                                                      
                                                            icon: const Icon(
                                                              MdiIcons.imageAlbum
                                                            )
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  
                                                ),
                                              );
                                            }
                                          );
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.white,
                                            padding: EdgeInsets.all(2.5),
                                            child: Icon(
                                                MdiIcons.cameraOutline,
                                                size: 14,
                                              ),
                                          ),
                                        ),
                                      ),
                                    )
                      
                                ],
                              ),

                              SizedBox(width: 10,),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      '${capitalize(widget.user.firstName!)} ${capitalize(widget.user.lastName!)}',
                                              
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600
                                      ),
                                    ),

                                    Text(
                                      widget.user.email!,
                              
                                      style: TextStyle(
                                        fontSize: 14
                                      ),
                                    ),
                                  ],
                                )
                              )
                          ],
                        ),
                      ),
              
                      const SizedBox(
                        height: 8,
                      ),
                          
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const IncomeScreen(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      ImageIcon(
                                        AssetImage(
                                          incomeIcon,
                                        )
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Income', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            ),
      
                            const Divider(),
                      
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const BudgetScreen(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      ImageIcon(
                                        AssetImage(
                                          budgetIcon,
                                        )
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Budget', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            ),
      
                            
      
                            const Divider(),
                      
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const CategoryScreen(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      ImageIcon(
                                        AssetImage(
                                          categoryIcon,
                                        )
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Categories', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            ),

                            const Divider(),
                      
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const VaultScreen(),
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const[
                                      Icon(MdiIcons.bank),
                                      SizedBox(width: 10,),
                                      Text('Income/Savings Vaults', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            ),

                            const Divider(),
                      
                            TextButton(
                              onPressed: (){
                                 Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const BudgetPlanner(), //PieChartSample2(), //
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        MdiIcons.menuOpen,
                                        size: 26,
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Planners', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            ),
      
                            const Divider(),
                      
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: Accountability(
                                      user: widget.user,
                                    ), //PieChartSample2(), //
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      ImageIcon(
                                        AssetImage(
                                          accountabilityIcon,
                                        )
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Accountability', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            ),

                            
      

                            const Divider(),
                      
                            TextButton(
                              onPressed: (){
                                 Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const ReportScreen(), //PieChartSample2(), //
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      ImageIcon(
                                        AssetImage(
                                          reportIcon,
                                        )
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Financial Reports', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            ),
      
                            const Divider(),
                      
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: Backup(
                                      user: widget.user,
                                    ), //PieChartSample2(), //
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        MdiIcons.backupRestore
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Backup and Sync', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            ),
      
                            const Divider(),

                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: FeedbackScreen(user: widget.user,), //PieChartSample2(), //
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      ImageIcon(
                                        AssetImage(
                                         feedbackIcon,
                                        )
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Feedback', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            ),
                      
                            const Divider(),
                      
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: PurchaseScreen(), //PieChartSample2(), //
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.ad_units_outlined
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Subscribe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(
                                    MdiIcons.chevronRight
                                  )
                                ],)
                            ),

                            const Divider(),
                      
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const SettingScreen(), //PieChartSample2(), //
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        MdiIcons.tools
                                      ),
                                      SizedBox(width: 10,),
                                      Text('Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            ),
                      
                            const Divider(),
                      
                            
                      
                            TextButton(
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const AboutScreen(), //PieChartSample2(), //
                                    type: PageTransitionType.fade
                                  )
                                );
                              },
                              style: TextButton.styleFrom(
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                        SizedBox(
                                          height: 26,
                                          width: 26,
                                          child: Image(
                                            image: AssetImage(lifiIcon),
                                          
                                                                              ),
                                        ),
                                      SizedBox(width: 10,),
                                      Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                                    ],
                                  ),
                                  const Icon(MdiIcons.chevronRight)
                                ],)
                            )
                          ],
                        ),
                      ),
      
      
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: TextButton(
      
                                onPressed: ()async{
      
                                  setState(() {
                                    loading = true;
                                  });

                                  await ExpenseDb().wipe();
                                  await IncomeDb().wipe();
                                  await BudgetDb().wipe();
                                  await CategoryDb().wipe();
                                  await VaultDb().wipe();
                                  await PlannerDb().wipe();
                                  await PlannerExpDb().wipe();
                                  await SavingsDb().wipe();
                                  await SettingsDb().wipe();
                                  await VersionDb().wipe();

                                  await FireAuth().signout();
      
                                  setState(() {
                                    loading = false;
                                  });
                                }, 
                                                
                                child: Text('Log Out', style: TextStyle(color: appDanger, fontSize: 18, fontWeight: FontWeight.w500),)
                              ),
                            ),
                          ],
                        ),
                      )
                
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}