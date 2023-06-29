import 'package:expense/models/user_model.dart';
import 'package:expense/screen/app/home/widgets/daily_spending_card.dart';
import 'package:expense/screen/app/more/screen/income/add_income.dart';
import 'package:expense/utils/constants/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import '../../../firebase/db/user.dart';
import '../../../utils/capitalize.dart';
import '../../../utils/constants/colors.dart';
import '../expense/add_expense.dart';
import '../more/screen/budget/add_budget.dart';
import '../more/screen/vaults/add_vault.dart';
import '../saving/add_saving.dart';
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

  LightUser? _currentUser;

    void myUser(uid)async{
      FirebaseUserDb firebaseUserDb = FirebaseUserDb(uid:uid);
      _currentUser = await firebaseUserDb.getUserData();

      setState(() {
        
      });
    }



  @override
  void initState() {
    widget.user2 != null ? _currentUser = widget.user2 : myUser(widget.user!.uid);
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
                              '${capitalize(_currentUser!.firstName!)} ${capitalize(_currentUser!.lastName!)}',
                              style: const TextStyle(
                                fontSize: 18,
                                height: 1.4,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 60,
                          width: 60,
                          child: ClipOval(
                            child: Container(
                              color: appOrange,

                              child: Center(
                                child: Text(
                                  _currentUser!.firstName!.substring(0,1).toUpperCase()+_currentUser!.lastName!.substring(0,1).toUpperCase(),
                                  style: const TextStyle(
                                        fontSize: 24,
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
                height: 300,
        
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
        
              // Expanded(
              //   child: ListView(
              //     children: const [
        
              //       HomeTile(
              //         targetBudget: '₦90000',
              //       ),
        
              //       SizedBox(height: 30,),
                    
              //       HomeTile(
              //         subtitle: '80% budget spent',
              //         title: 'Expenses',
              //         percentage: 0.8,
              //       ),
        
        
              //       SizedBox(height: 30,),
                    
              //       HomeTile(
              //         subtitle: '20% budget spent',
              //         percentage: 0.2,
              //         title: 'Saved Budget',
              //       ),
        
              //     ],
              //   ),
              // )
        
              const SizedBox(height: 15,),

              if(true)
                ...[
                  const SessionTopic(
                    label: 'Incomes Over 80% Spent',
                  ),

                  const SizedBox(height: 5,),

                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(10, (index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 150,
                          child: OverspentIncome()
                        ),
                      )),
                    ),
                  )

                ],


                const SizedBox(height: 15,),

              if(true)
                ...[
                  const SessionTopic(
                    label: 'Budget',
                  ),

                  const SizedBox(height: 5,),

                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(10, (index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 150,
                          child: Container(
                            color: appOrange,
                          ),
                        ),
                      )),
                    ),
                  )

                ],


                const SizedBox(height: 15,),

              if(true)
                ...[
                  const SessionTopic(
                    label: 'Incomes',
                  ),

                  const SizedBox(height: 5,),

                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(10, (index) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: SizedBox(
                          width: 150,
                          child: Container(
                            color: appOrange,
                          ),
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