
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../../utils/constants/colors.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     

      appBar: AppBar(

        toolbarHeight: 50,

        // leading: IconButton(
        //   onPressed: (){
        //     Navigator.pop(context);
        //   }, 
        //   icon: const Icon(Icons.arrow_back, color: Colors.white)
        // ),

        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark
        ),
      ),

      body: Column(
        children: [
        ],
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          
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
    );
  }
}
