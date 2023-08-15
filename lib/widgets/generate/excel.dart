import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> generateExcel(BuildContext context, List<List<dynamic>> data, {required String name}) async {
  // Create an Excel workbook
  var excel = Excel.createExcel();

  // Add a sheet to the workbook
  var sheet = excel['Sheet1'];

  // Populate the sheet with data
  for (var row in data) {
    sheet.appendRow(row);
  }

  print('object');

  // DeviceInfoPlugin info = DeviceInfoPlugin();
  // AndroidDeviceInfo andInfo = await info.androidInfo;
  // print(andInfo.version.release);

  // Request external storage permission
  var status = await Permission.storage.request();

  if (status.isGranted) {
    // Let the user choose the storage location
    String? result = await FilePicker.platform.getDirectoryPath(dialogTitle: 'Save Path');
    if (result != null) {
      String chosenDirectory = result;

      String filePath = '$chosenDirectory/$name.xlsx';

      // Save the Excel file
      File file = File(filePath);
      await file.create(recursive: true);
      await file.writeAsBytes(excel.save()!);

      // Notify the media scanner about the new file
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final filePath = file.path;
        await MethodChannel('plugins.flutter.io/path_provider')
            .invokeMethod('refresh', <String, dynamic>{
          'file_path': filePath,
        });
      }
    }
  } else {
    throw PlatformException(
      code: 'PERMISSION_DENIED',
      message: 'Storage permission not granted.',
    );
  }
}
