
// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'package:expense/screen/app/expense/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../utils/constants/colors.dart';
import '../firebase/db/user.dart';
import '../models/user_model.dart';
import 'app/home/home.dart';
import 'app/more/more.dart';
import 'app/saving/saving.dart';

class AppBaseNavigation extends StatefulWidget {
  final User user;
  const AppBaseNavigation({
    required this.user,
    super.key});

  @override
  State<AppBaseNavigation> createState() => _AppBaseNavigationState();
}

class _AppBaseNavigationState extends State<AppBaseNavigation> {

    LightUser? _currentUser;

    void myUser(uid)async{
      FirebaseUserDb firebaseUserDb = FirebaseUserDb(uid: uid);
      _currentUser = await firebaseUserDb.getUserData();
      setState(() {
        
      });
    }

    Widget? _currentPage;
    int _currentIndex = 0;


    void getCurrentPage(index){

      final List<Widget> _pages = [
      HomeScreen(
        user: widget.user,
        user2: _currentUser,
      ),
      ExpenseScreen(),
      SavingsScreen(),
      MoreScreen(
        user: _currentUser!,
      ),
    ];

      _currentIndex = index;
      _currentPage = _pages[index];

      setState(() {
        
      });

    }


    @override
  void initState() {
    myUser(widget.user.uid);
    _currentPage = HomeScreen(user: widget.user);
    super.initState();
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: _currentPage,


      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color.fromARGB(197, 39, 39, 39),
        selectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        type: BottomNavigationBarType.fixed,

        //backgroundColor: Color(0xffFAFAFF),
        currentIndex: _currentIndex,
        onTap: (index){
          getCurrentPage(index);
        },
      
        items:  [

          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.homeOutline
            ),

            activeIcon: Icon(
              MdiIcons.home
            ),
      
            label: 'Home'
          ),

          
          /////Chat
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.walletOutline
            ),
      
            activeIcon: Icon(
              MdiIcons.wallet
            ),
      
            label: 'Expense'
          ),
      
          
      
      
          BottomNavigationBarItem(
            icon: Icon(
              MdiIcons.bullseye
            ),
      
            activeIcon:  Icon(
              MdiIcons.bullseyeArrow
            ),
            
            label: 'Savings'
          ),
      
      
          /////Profile
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: appOrange,
                borderRadius: BorderRadius.circular(50)
              ),


              child: Text(
                _currentUser!.firstName!.substring(0,1).toUpperCase()+_currentUser!.lastName!.substring(0,1).toUpperCase(),//'${widget.user.firstName.substring(0,1).toUpperCase()}${widget.user.lastName.substring(0,1).toUpperCase()}',

                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ),

            label: 'Profile'
          ),
      
      
        ]
      ),
    );

  }
}