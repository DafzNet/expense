
// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../../dbs/saving_db.dart';
import '../../../models/savings_model.dart';
import '../../../utils/constants/colors.dart';
import 'add_saving.dart';
import 'saving_detail.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {


  final SavingsDb savingsDb = SavingsDb();


  Database? _db;
  
   void dbOpen()async{
    _db = await savingsDb.openDb();
    setState(() {
      
    });
  }


  String sortBy = 'td';
  String _hint = 'Sort by';


  var savings = [];


  @override
  void initState() {
    dbOpen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        backgroundColor: Colors.black,
        toolbarHeight: 50,

        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
      ),

      body: Column(
        children: [
           SizedBox(
            height: 110,
             child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.only(left: 30, bottom: 10),
                   child: Row(
                     children: [
                       RichText(
                          text: TextSpan(
                            text: 'SAVINGS for\nFUTURE',
           
                            children: const [
                              TextSpan(
                                text: ' PLAN',
           
                                style: TextStyle(
                                  fontSize: 32,
                                  height: 1.4,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white
                                ),
           
                              )
                            ],
           
                            style: TextStyle(
                              fontSize: 32,
                              height: 1.4,
                              fontWeight: FontWeight.w700,
                              color: appOrange
                            ),
                          )
                        )     
                     ],
                   ),
                 
                 ),
           
                const SizedBox(height: 10,)
           
           
               ],
             ),
           ),


            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                child:  _db != null ? Container(
                  color: Colors.white,

                  child: Column(
                    children: [

                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //const SizedBox(width: 30,),
                          Flexible(
                            flex: 3,
                            fit: FlexFit.tight,
                            child: Row(
                              children: const[
                                SizedBox(width: 30,),
                                Text(
                                  'PLANS',
                                  style: TextStyle(
                                    fontSize: 20,
                                    height: 1.4,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                    color: Colors.black
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,
                            child: DropdownButton(
                              hint: Text(_hint),
                              elevation: 1,
                              items: const[
                                DropdownMenuItem(value: 'td',child: Text('Target date'),),
                                DropdownMenuItem(value: 'cd', child: Text('Date created')),
                                DropdownMenuItem(value: 'ta', child: Text('Target amount')),
                                DropdownMenuItem(value: 'ps', child: Text('Percentage')),
                                DropdownMenuItem(value: 'ca', child: Text('Currently saved'))
                              ], 
                              onChanged: (v){
                                sortBy = v!;

                                if (v=='td') {
                                  _hint = 'Target date';
                                }

                                if (v=='ps') {
                                  _hint = 'Percentage';
                                }

                                if (v=='cd') {
                                  _hint = 'Date created';
                                }

                                if (v=='ta') {
                                  _hint = 'Target amount';
                                }

                                if (v=='ca') {
                                  _hint = 'Currently saved';
                                }

                                setState(() {
                                  
                                });
                              })
                          ),

                           const SizedBox(width: 30,),
                        ],
                      ),

                      const SizedBox(height: 10,),
                      
                      Expanded(
                        child: StreamBuilder<List<TargetSavingModel>>(
                          stream: savingsDb.onSavings(_db!),
                          initialData: const [],
                          builder: (context, snapshot){

                            if (snapshot.hasData) {
                              savings = snapshot.data!;
                              

                              if (savings.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No Financial targets added'
                                  )
                                );
                              }

                              return ListView.builder(
                              itemCount: savings.length,
                              itemBuilder: (context, index){

                                if (sortBy=='td') {
                                  savings.sort((a,b){
                                    return b.targetDate
                                    .compareTo(a.targetDate);
                                  });
                                }

                              if (sortBy=='cd') {
                                  savings.sort((a,b){
                                    return b.dateCreated
                                    .compareTo(a.dateCreated);
                                  });
                                }

                              if (sortBy=='ps') {
                                  savings.sort((a,b){
                                    return ((b.currentAmount/b.targetAmount)/100)
                                    .compareTo(((a.currentAmount/a.targetAmount)/100));
                                  });
                                }



                              if (sortBy=='ta') {
                                  savings.sort((a,b){
                                    return b.targetAmount
                                    .compareTo(a.targetAmount);
                                  });
                                }

                              if (sortBy=='ca') {
                                  savings.sort((a,b){
                                    return b.currentAmount
                                    .compareTo(a.currentAmount);
                                  });
                                }
                                
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: SavingsTile(
                                   model: savings[index],
                                   index: index+1,
                                  ),
                                );
                              });
                            }else if(snapshot.connectionState == ConnectionState.waiting ){
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return const Center(child: CircularProgressIndicator(),);

                          }
                        )
                      ),
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
              )
            )

        ],
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            PageTransition(
              child: const AddFinancialGoalScreen(
                
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
    );
  }
}



class SavingsTile extends StatelessWidget {
  final TargetSavingModel model;
  final int index;
  const SavingsTile({
    required this.model,
    required this.index,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:  model.targetDate.difference(DateTime.now()).inDays < 7 ? appDanger.shade50 :Theme.of(context).scaffoldBackgroundColor,
      child: ListTile( 
        onTap: (){
          Navigator.push(
            context,
            PageTransition(
              child: SavingDetail(
                savingModel: model,
              ),
              
              type: PageTransitionType.rightToLeft)
          );
        },
    
        leading: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              color: appOrange.shade200,
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  '$index',
      
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16
                  ),
              
                ),
              ),
            ),
          ),
    
        title: Text(
          model.targetPurpose!
        ),
    
        subtitle: Text(
          'for ${model.noOfMonth} month${model.noOfMonth>1?'s':''}'
        ),
    
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              double.parse(((model.currentAmount/model.targetAmount)*100).toString()).toStringAsFixed(1)+'%'
            ),
    
            const Text('Saved')
          ],
        ),
      ),
    );
  }
}