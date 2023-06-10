import 'package:expense/models/user_model.dart';
import 'package:expense/widgets/home_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../firebase/db/user.dart';
import '../../../utils/capitalize.dart';
import '../../../utils/constants/colors.dart';


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
      appBar: AppBar(),

      body: _currentUser != null ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
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


            Expanded(
              child: ListView(
                children: const [
                  SizedBox(height: 60,),

                  HomeTile(
                    targetBudget: '₦90000',
                  ),

                  SizedBox(height: 30,),
                  
                  HomeTile(
                    subtitle: '80% budget spent',
                    title: 'Expenses',
                    percentage: 0.8,
                  ),


                  SizedBox(height: 30,),
                  
                  HomeTile(
                    subtitle: '20% budget spent',
                    percentage: 0.2,
                    title: 'Saved Budget',
                  ),

                ],
              ),
            )





          ],
        ),
      )
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