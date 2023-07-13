

// ignore_for_file: use_build_context_synchronously

import 'package:expense/models/user_model.dart';
import 'package:expense/widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../utils/backup/backup.dart';

class Backup extends StatefulWidget {
  final LightUser user;
  const Backup({
    required this.user,
    super.key});

  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {

  bool _backingup = false;

  BackupAndSync? backupAndSync;

  Future _backup()async{
    await backupAndSync!.backup(force: true);
  }



  @override
  void initState() {
    backupAndSync = BackupAndSync(widget.user.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled)=>[
          SliverAppBar.medium(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark
            ),
            
            title: const Text('Backup'),
        
          ),
        ],

        body:Column(
          children: [
            ListTile(
              title: const Text('Backup Now'),

              onTap: () async{
                showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //backgroundColor: appOrange,
                            title: const Text('Back Up'),
                            content:  SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  Text('This may take some time to complete'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Confirm'),
                                onPressed: () async {
                                  
                                  Navigator.pop(context);

                                  setState(() {
                                    _backingup = true;
                                  });

                                  await _backup();

                                  _backingup = false;

                                  setState(() {
                                    
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    financeSnackBar('Backup Completed')
                                  );
                                  

                                },
                              ),
                            ],
                          );}
                        );
              },

              leading: const Icon(
                MdiIcons.backupRestore
              ),

              trailing: _backingup ?
              const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(),
              ):
               const Icon(
                MdiIcons.chevronRight
              ),
            ),

            const SizedBox(height: 10,),

            const ListTile(
              title: Text('Sync '),

              leading: Icon(
                MdiIcons.restore
              ),

              trailing: Icon(
                MdiIcons.chevronRight
              ),
            )
          ],
        ),
      )
    );
  }
}