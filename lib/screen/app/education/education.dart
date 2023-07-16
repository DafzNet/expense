

import 'package:expense/models/user_model.dart';
import 'package:expense/screen/app/education/screens/budgeting.dart';
import 'package:expense/screen/app/education/screens/general.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../../utils/constants/colors.dart';
import 'screens/add_fexpert.dart';
import 'screens/debts.dart';
import 'screens/invest.dart';

class Fexperts extends StatefulWidget {
  final LightUser user;
  const Fexperts({
    required this.user,
    super.key});

  @override
  State<Fexperts> createState() => _FexpertsState();
}

class _FexpertsState extends State<Fexperts> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(

          title: Text('Fexperts'),

          actions: [
            IconButton(
              onPressed: (){
                
              }, 
              icon: Icon(
                Icons.search
              )
            )
          ],

          bottom:  TabBar(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16
            ),
            indicator: BoxDecoration(
              color: appOrange.shade900,
              borderRadius: BorderRadius.circular(25)
            ),
            tabs: const [
               Tab(text: 'General',),
               Tab(text: 'Investing',),
               Tab(text: 'Budgeting',),
               Tab(text: 'Debts',)
            ]),
        ),


        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TabBarView(
            children: [
              GeneralFexpert(
                user: widget.user,
              ),
              InvestmentFexpert(
                user: widget.user,
              ),
              BudgetFexpert(
                user: widget.user,
              ),
              DebtFexpert(
                user: widget.user,
              )
        
            ]
          ),
        ),



        floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            PageTransition(
              child: AddFexpert(
                user: widget.user,
              ),

              type: PageTransitionType.bottomToTop
            )
          );
        },

        backgroundColor: appOrange,
        elevation: 3,

        shape: const CircleBorder(

        ),

         child: const Icon(
          MdiIcons.plus,
          color: Colors.white,
        ),
      ),

        
      ),

    );
  }
}