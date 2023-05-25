import 'package:expense/widgets/home_tile.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),


                    Text(
                      'Ebiondo Daniel',
                      style: TextStyle(
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
    );
  }
}