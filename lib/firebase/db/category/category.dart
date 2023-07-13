// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/models/category_model.dart';


class FirebaseCategoryDb{
  dynamic uid;

  FirebaseCategoryDb({this.uid});

  final CollectionReference categoryCollection = FirebaseFirestore.instance.collection('category');

  ///Takee a list of incomes and aadd them to firestore 
  Future addcategories(List<CategoryModel> categories)async{
    for (var category in categories){
      await addcategory(category);
    }
  }

  ///Takee an expense and aadd them to firestore 
  Future addcategory(CategoryModel category)async{
      await categoryCollection.doc(uid).collection(uid).doc(category.id.toString())
        .get().then((value)async{
          if (!value.exists){
            await categoryCollection.doc(uid).collection(uid).doc(category.id.toString()).set(category.toMap()).onError((error, stackTrace) => null);
          }
        });
  }


  Future<List<CategoryModel>> getCategory()async{
    QuerySnapshot<Map<String, dynamic>> categories = await categoryCollection.doc(uid).collection(uid).get();
    List<CategoryModel> categoryDocs = categories.docs.map((e){
      Map<String, dynamic> _data = e.data();
      return CategoryModel.fromMap(_data);
    }).toList();

    return categoryDocs;
  }

  ///retturns the corresponding expense
  Future update(CategoryModel category)async{
    await categoryCollection.doc(uid).collection(uid).doc(category.id.toString()).update(category.toMap());
  }

  Future delete(CategoryModel category)async{
    await categoryCollection.doc(uid).collection(uid).doc(category.id.toString()).delete();
  }
}