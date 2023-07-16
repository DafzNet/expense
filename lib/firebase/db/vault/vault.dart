// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/models/vault.dart';

import '../../../models/version.dart';

class FirebaseVaultDb{
  dynamic uid;

  FirebaseVaultDb({this.uid});

  final CollectionReference vaultCollection = FirebaseFirestore.instance.collection('vault');

  ///Takee a list of incomes and aadd them to firestore 
  Future addVaults(List<VaultModel> vaults)async{
    for (var vault in vaults){
      await addVault(vault);
    }
  }

  ///Takee an expense and aadd them to firestore 
  Future addVault(VaultModel vault)async{
      await vaultCollection.doc(uid).collection(uid).doc(vault.id.toString())
        .get().then((value)async{
          if (!value.exists){
            await vaultCollection.doc(uid).collection(uid).doc(vault.id.toString())
              .set(vault.toMap()).onError((error, stackTrace) => null);
          }
        });
      await updateFirebaseDbVersion(uid, vaultDbVersion: 1);
    
  }


  Future<List<VaultModel>> getVaults()async{
    QuerySnapshot<Map<String, dynamic>> vaults = await vaultCollection.doc(uid).collection(uid).get();
    List<VaultModel> vaultDocs = vaults.docs.map((e){
      Map<String, dynamic> _data = e.data();
      return VaultModel.fromMap(_data);
    }).toList();

    return vaultDocs;
  }

  ///retturns the corresponding expense
  Future update(VaultModel vault)async{
    await vaultCollection.doc(uid).collection(uid).doc(vault.id.toString()).update(vault.toMap());
  }

  Future delete(VaultModel vault)async{
    await vaultCollection.doc(uid).collection(uid).doc(vault.id.toString()).delete();
    await updateFirebaseDbVersion(uid, vaultDbVersion: 1);
  }
}