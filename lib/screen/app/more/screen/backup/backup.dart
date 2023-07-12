

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Backup extends StatefulWidget {
  const Backup({super.key});

  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {
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
            
            title: Text('Backup'),
        
          ),
        ],

        body:Column(
          children: [
            ListTile(
              title: Text('Backup Now'),

              leading: Icon(
                MdiIcons.backupRestore
              ),

              trailing: Icon(
                MdiIcons.chevronRight
              ),
            ),

            const SizedBox(height: 10,),

            ListTile(
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