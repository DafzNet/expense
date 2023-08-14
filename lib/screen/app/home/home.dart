
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expense/models/budget.dart';
import 'package:expense/models/savings_model.dart';
import 'package:expense/models/user_model.dart';
import 'package:expense/screen/app/home/widgets/daily_spending_card.dart';
import 'package:expense/screen/app/home/widgets/deadline_savings.dart';
import 'package:expense/screen/app/more/screen/income/add_income.dart';
import 'package:expense/screen/app/more/screen/planner/planner.dart';
import 'package:expense/utils/constants/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../../dbs/budget_db.dart';
import '../../../dbs/income_db.dart';
import '../../../dbs/saving_db.dart';
import '../../../firebase/db/user.dart';
import '../../../models/income_model.dart';
import '../../../utils/adManager/ad_mob.dart';
import '../../../utils/capitalize.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/month.dart';
import '../expense/add_expense.dart';
import '../more/screen/about/about.dart';
import '../more/screen/budget/add_budget.dart';
import '../more/screen/category/add_cat.dart';
import '../more/screen/vaults/add_vault.dart';
import '../saving/add_saving.dart';
import 'widgets/overspent_budget.dart';
import 'widgets/overspent_income.dart';


class HomeScreen extends StatefulWidget {
  final User? user;
  final LightUser? user2;

  const HomeScreen({
    this.user,
    this.user2,
    super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

///////Google ads
 BannerAd? _bannerAd;


////////////////////////////////////////////////////
//////////////////////////////////////////////////
/////////////////////////////////////////////////
  LightUser? _currentUser;

    void myUser(uid)async{
      FirebaseUserDb firebaseUserDb = FirebaseUserDb(uid:uid);
      _currentUser = await firebaseUserDb.getUserData();
      setState(() {
        
      });
    }



    IncomeDb incomeDb = IncomeDb();
    BudgetDb budgetDb = BudgetDb();
    SavingsDb savingsDb = SavingsDb();

    List<IncomeModel> incomesAboutFinishing = [];
    List<BudgetModel> budgetsAboutFinishing = [];
    List<TargetSavingModel> savingsReachingLimit = [];




    void getIncomesFinishing()async{
      Filter filter = Filter.custom((record){
        final data = record.value as Map<String, dynamic>;
        final _income = IncomeModel.fromMap(data);

        return ((_income.balance/_income.amount)*100) < 20 && _income.month == DateTime.now().month;

      });

      incomesAboutFinishing = await incomeDb.retrieveBasedOn(filter);

      setState(() {
        
      });
    }


    void getSavingsFinishing()async{
      Filter filter = Filter.custom((record){
        final data = record.value as Map<String, dynamic>;
        final _savings = TargetSavingModel.fromMap(data);

        return _savings.targetDate.difference(DateTime.now()).inDays < 20;

      });

      savingsReachingLimit = await savingsDb.retrieveBasedOn(filters: [filter]);

      setState(() {
        
      });
    }


  void getBudgetsFinishing()async{
      Filter filter = Filter.custom((record){
              final budg = record.value as Map<String, dynamic>;
              final myBudg = BudgetModel.fromMap(budg);

              if (myBudg.startDate == myBudg.endDate) {
                return myBudg.month == Month().currentMonthNumber && myBudg.year == DateTime.now().year && (((myBudg.balance/myBudg.amount)*100)<20);
              }else{
                return DateTime.now().isAfter(myBudg.startDate!) && DateTime.now().isBefore(myBudg.endDate!) && (((myBudg.balance/myBudg.amount)*100)<20);
              }
              
            });

      budgetsAboutFinishing = await budgetDb.retrieveBasedOn(filter);

      setState(() {
        
      });
    }

  @override
  void initState() {
    widget.user2 != null ? _currentUser = widget.user2 : myUser(widget.user!.uid);
    getIncomesFinishing();
    getBudgetsFinishing();
    getSavingsFinishing();


    BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    request: const AdRequest(),
    size: AdSize.banner,
    listener: BannerAdListener(
      onAdLoaded: (ad) {
        setState(() {
          _bannerAd = ad as BannerAd;
        });
      },
      onAdFailedToLoad: (ad, err) {
        ad.dispose();
      },
    ),
  ).load();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentUser != null ? NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar(
            automaticallyImplyLeading: false,

            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),

            expandedHeight: 180,
            toolbarHeight: 20,
            
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 40,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 16
                              ),
                            ),


                            Text(
                              '${capitalize(_currentUser!.firstName!)} ${_currentUser!.lastName != null && _currentUser!.lastName!.isNotEmpty? capitalize(_currentUser!.lastName!):''}',
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.4,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: appOrange,
                                width: .4
                              )
                            ),
                            child: ClipOval(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: const AboutScreen(), //PieChartSample2(), //
                                      type: PageTransitionType.fade
                                    )
                                  );
                                },
                                child: Image.asset(lifiIcon)
                              )
                              
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 15,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        SizedBox(width: 5,),
                        Text(
                          'Quickly Add',

                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 5,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [
                        QuickActionButton(
                          label: 'Income',
                          imageProvider: const AssetImage(
                            incomeIcon
                          ),
                          onTap: () {
                            Navigator.push(
                              context, 
                              PageTransition(
                                child: const AddIncomeScreen(), 
                                type: PageTransitionType.fade)
                            );
                          },
                        ),


                        QuickActionButton(
                          label: 'Expense',
                          icon: MdiIcons.walletOutline,
                          onTap: () {
                            Navigator.push(
                              context, 
                              PageTransition(
                                child: const AddExpenseScreen(), 
                                type: PageTransitionType.fade)
                            );
                          },
                        ),

                        QuickActionButton(
                          label: 'Budget',
                          imageProvider: const AssetImage(
                            budgetIcon
                          ),
                          onTap: () {
                            Navigator.push(
                              context, 
                              PageTransition(
                                child: const AddBudgetScreen(), 
                                type: PageTransitionType.fade)
                            );
                          },
                        ),

                        QuickActionButton(
                          label: 'Saving',
                          icon: MdiIcons.bullseyeArrow,
                          onTap: () {
                            Navigator.push(
                              context, 
                              PageTransition(
                                child: const AddFinancialGoalScreen(), 
                                type: PageTransitionType.fade)
                            );
                          },
                        ),

                        QuickActionButton(
                          label: 'Vault',
                          icon: MdiIcons.bankOutline,

                          onTap: () {
                            Navigator.push(
                              context, 
                              PageTransition(
                                child: const AddVaultScreen(), 
                                type: PageTransitionType.fade)
                            );
                          },
                        ),

                        QuickActionButton(
                          label: 'Category',
                          imageProvider: const AssetImage(
                            categoryIcon
                          ),
                          onTap: () {
                            Navigator.push(
                              context, 
                              PageTransition(
                                child: const AddCategoryScreen(), 
                                type: PageTransitionType.fade)
                            );
                          },
                        ),


                      ]
                    )


                  ],
                ),
              )
            ),
          ),
        ],

/////////////////////////////
////////////////////////////
        body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20,),
        
              SizedBox(
                height: 320,
        
                child: Stack(

                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(31, 244, 244, 244),
                        border: Border.all(width: .4),
                        borderRadius: BorderRadius.circular(12)
                      ),

                      child: const HomeSummary(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15,),

              if(_bannerAd != null)
              ...[
                SizedBox(
                  height: 50,
                  child: AdWidget(ad: _bannerAd!),
                )
              ],


              ListTile(

                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const BudgetPlanner(
                      ), type: PageTransitionType.fade)
                  );
                },

                leading: const Icon(
                  MdiIcons.menuOpen,
                  color: Color.fromARGB(255, 54, 53, 53),
                  size: 30,
                ),

                trailing: const Icon(
                  MdiIcons.chevronRight,
                  color: Color.fromARGB(255, 54, 53, 53),
                ),

                title: const Text('Open Planners'),
              ),


              
        
        
              const SizedBox(height: 15,),

              if(incomesAboutFinishing.isNotEmpty)
                ...[
                  const SessionTopic(
                    label: 'Incomes running low',
                  ),

                  const SizedBox(height: 5,),

                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: incomesAboutFinishing.map((e) => 
                        SizedBox(
                          width: 150,
                          child: OverspentIncome(
                            income: e
                          ),
                        )
                       ).toList()
                    ),
                  )

                ],


                const SizedBox(height: 15,),

              if(budgetsAboutFinishing.isNotEmpty)
                ...[
                  const SessionTopic(
                    label: 'Budgets running low',
                  ),

                  const SizedBox(height: 5,),

                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(budgetsAboutFinishing.length, (index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 150,
                          child: OverspentBudget(
                            budget: budgetsAboutFinishing[index]
                          )
                        ),
                      )),
                    ),
                  )

                ],


                const SizedBox(height: 15,),

              if(savingsReachingLimit.isNotEmpty)
                ...[
                  const SessionTopic(
                    label: 'Savings Close to Deadline',
                  ),

                  const SizedBox(height: 5,),

                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(savingsReachingLimit.length, (index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 150,
                          child: SavingsAproachingDeadline(
                            saving: savingsReachingLimit[index]
                          )
                        ),
                      )),
                    ),
                  )

                ]



              
        
        
        
        
            ],
          ),
        ),
      ))
      :
      Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class SessionTopic extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  const SessionTopic({
    required this.label,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,

          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),

        GestureDetector(
          onTap: onTap??(){},
          child: Row(
            children: const [
              Text(
                'See all',
        
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),

              SizedBox(width: 8,),
        
              Icon(
                MdiIcons.chevronRightCircleOutline,
                size: 13,
              )
            ],
          ),
        )
      ],
    );
  }
}

class QuickActionButton extends StatelessWidget {
  final IconData? icon;
  final ImageProvider? imageProvider;
  final VoidCallback? onTap;
  final String label;

  const QuickActionButton({
    this.icon,
    this.imageProvider,
    this.onTap,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                // border: Border.all(
                //   color: appOrange.shade500
                // )
              ),
              child: imageProvider != null ? Center(
                child: ImageIcon(
                  imageProvider
                ),
              ) : Center(child: Icon(icon))
              
            ),
          ),
    
          const SizedBox(height: 5,),
    
          Text(
            label,
            style: const TextStyle(
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}