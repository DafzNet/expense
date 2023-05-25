
// ignore_for_file: prefer_const_constructors

import 'package:expense/screen/app/expense/expense.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../utils/constants/colors.dart';
import '../models/user_model.dart';
import 'app/home/home.dart';
import 'app/more/more.dart';
import 'app/saving/saving.dart';

class AppBaseNavigation extends StatefulWidget {
  //final User user;
  const AppBaseNavigation({
    //required this.user,
    super.key});

  @override
  State<AppBaseNavigation> createState() => _AppBaseNavigationState();
}

class _AppBaseNavigationState extends State<AppBaseNavigation> {

     final List<Widget> _pages = [
      HomeScreen(),
      ExpenseScreen(),
      SavingsScreen(),
      MoreScreen(
        user: User(
          id: 1,
          firstName: 'Daniel',
          lastName: 'Ebiondo',
          email: 'dafz.daniel@gmail.com'
        ),
      ),
    ];

    Widget _currentPage = HomeScreen();
    int _currentIndex = 0;


    void getCurrentPage(index){
      _currentIndex = index;
      _currentPage = _pages[index];

      setState(() {
        
      });

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
                'DE',//'${widget.user.firstName.substring(0,1).toUpperCase()}${widget.user.lastName.substring(0,1).toUpperCase()}',

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