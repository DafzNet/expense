
import 'package:expense/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../../../../dbs/category_db.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../widgets/cards/category_card.dart';
import 'add_cat.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  final CategoryDb categoryDb = CategoryDb();
  Database? db;

  void getCategoryDB()async{
    db = await categoryDb.openDb();
    setState(() {
      
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getCategoryDB();
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('Categories'),


            actions: [
              IconButton(onPressed: ()async{
                showMenu(
                  context: context, 
                  position: RelativeRect.fromLTRB(200, 70, 30, 0), items: [
                    PopupMenuItem(
                      child: Text('Categories separate your spendings into groups for easy referencing, reports and comparison. They also link your expenses to their respective budgets')
                    )
                  ]);
              }, icon: const Icon(MdiIcons.helpCircleOutline))
            ],
        
          ),
        ],

/////////////////////////////
////////////////////////////
        body: db != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: StreamBuilder<List<CategoryModel>>(
            initialData: const[],
            stream: categoryDb.onCategories(db!),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Column();
              }
              
              final categories = snapshot.data;

              return categories!.isNotEmpty ?  ListView.builder(
                itemCount: categories.length,

                itemBuilder: (context, index){
                  return CategoryCard(
                    index: (index+1).toString(),
                    ctx: context,
                    category: categories[index]);
                }
              )
              :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text('No Categories added yet'),
                  )
                ],
              );
            }
          )
        ) 
        
        :

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        )
        
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context, 
            PageTransition(
              child: const AddCategoryScreen(),
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
