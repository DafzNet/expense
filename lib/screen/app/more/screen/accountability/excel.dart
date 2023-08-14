import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';

class ExcelOptions extends StatefulWidget {
  const ExcelOptions({super.key});

  @override
  State<ExcelOptions> createState() => _ExcelOptionsState();
}

class _ExcelOptionsState extends State<ExcelOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Column(
        children: [
          Divider(height: 3,),

          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: appOrange.shade100
                  ),
                )
              ],
            ),
          )


        ],
      ),
    );
  }
}