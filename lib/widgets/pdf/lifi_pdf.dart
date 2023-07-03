import 'dart:io';

import 'package:expense/utils/constants/images.dart';
import 'package:path/path.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class LifiPDF{

  final lifiLogo = MemoryImage(
    File(lifiIcon).readAsBytesSync()
  );
  
  final pdfDoc = Document();

  Future generatePdf()async{
    pdfDoc.addPage(
      MultiPage(
        pageTheme: PageTheme(
          pageFormat: PdfPageFormat.a4,
          buildBackground: (context) => Opacity(
            opacity: .3,
            child: Image(
            lifiLogo,
            fit: BoxFit.cover,

          )
          )
          
        ),
        pageFormat: PdfPageFormat.a4,
        build: (context){
          return [

          ];
        }
      )
    );
  }
}