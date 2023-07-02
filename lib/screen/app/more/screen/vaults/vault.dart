
import 'package:expense/models/vault.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sembast/sembast.dart';
import '../../../../../dbs/vault_db.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../widgets/vault_card.dart';
import 'add_vault.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {

  final VaultDb vaultDb = VaultDb();
  Database? db;

  void getVaultDB()async{

    db = await vaultDb.openDb();

    setState(() {
      
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    getVaultDB();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('Vaults'),
        
          ),
        ],

/////////////////////////////
////////////////////////////
        body: db != null ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: StreamBuilder<List<VaultModel>>(
            initialData: const[],
            stream: vaultDb.onVaults(db!),
            builder: (context, snapshot){
              if(snapshot.hasError){
                return Column();
              }
              
              final vaults = snapshot.data;

              return vaults!.isNotEmpty ?  ListView.builder(
                itemCount: vaults.length,

                itemBuilder: (context, index){
                  return VaultCard(
                    vault: vaults[index],
                    index: (index+1).toString(),
                    ctx: context,
                  );
                }
              )
              :
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text('No Vaults currently added yet'),
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
              child: const AddVaultScreen(),
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
