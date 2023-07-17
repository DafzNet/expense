
// ignore_for_file: prefer_const_declarations, unused_local_variable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/constants/colors.dart';


class ImagePickerCropper{

  final ImagePicker _picker = ImagePicker();
  File? _photo;

  Future<File?> _cropImage(File? photo) async {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: photo!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Rightly',
              toolbarColor: appOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'LiFi',
          ),
        ],
      );
      
      return File(croppedFile!.path);
  }

  Future<File?> imgFromGallery({int quality=100, bool crop=true}) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: quality,
      );

      if (pickedFile != null) {
        if (crop==true){
         _photo = await _cropImage(File(pickedFile.path));
         return _photo;
        }
        _photo = File(pickedFile.path);
        return _photo;
      }
      return null;
    }


  Future imgFromCamera({int quality=70, bool crop = true}) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: quality,
    );

        if (pickedFile != null) {
          if (crop==true){
            _photo = await _cropImage(File(pickedFile.path));
            return _photo;
          }
        _photo = File(pickedFile.path);
        return _photo;
      }
  }

  // Future<String> uploadFile(String uid, {String dest='users/'}) async {
  //   if (_photo == null) return '';
  //   final fileName = basename(_photo!.path);
  //   final destination = dest;

  //   try {
  //     final ref = _storage.ref(destination).child(uid);
  //     await ref.putFile(_photo!);

  //   final String downloadLink = await ref.getDownloadURL();

  //   return downloadLink;

  //   } catch (e) {
  //     return '';
  //   }
  // }
}
