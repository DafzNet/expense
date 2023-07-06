import 'dart:io';

import 'package:expense/utils/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../models/budget.dart';
import '../../models/expense_model.dart';
import '../../models/income_model.dart';
import '../../utils/month.dart';

class LifiPDF{

  // final lifiLogo = MemoryImage(
  //   File(lifiIcon).readAsBytesSync()
  // );
  
  final pdfDoc = Document();

  Future generatePdf(String currency, String period, {List<ExpenseModel>? expenses, List<IncomeModel>? incomes, List<BudgetModel>? budgets, String? name})async{
    pdfDoc.addPage(
      MultiPage(
        
        pageFormat: PdfPageFormat.a4,
        build: (context){
          return [

            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: PdfColors.orange
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LiFi',

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.white
                    )
                  )
                ]
              )
            ),

            SizedBox(height: 6),


             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name??'Name Not Specified',

                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.black
                    )
                  )
                ]
              ),

              SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Financial Statement For the Period of $period',

                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.black
                    )
                  )
                ]
              ),

              SizedBox(height: 12),

              if(incomes !=null && incomes.isNotEmpty)...
              [
              
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  color: PdfColors.orange200,
                  child: Text('Incomes')
                ),
                
                Table(
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: PdfColors.orange100
                      ),
                      children: [
                        Text('S/N'),
                        Text('Title'),
                        Text('Amount ${currency}'),
                        Text('Source'),
                        Text('Vault'),
                        Text('Date'),
                      ]),


                      ...List.generate(incomes.length, (index){
                        return TableRow(
                          children: [
                            Text('${index+1}'),
                            Text(incomes[index].name!),
                            Text(incomes[index].amount.toString()),
                            Text(incomes[index].source!),
                            Text(incomes[index].incomeVault!.name),
                            Text(DateFormat.yMMMd().format(incomes[index].date)),
                          ]
                        );
                      })
                  ]
                )
              ],


            if(budgets !=null && budgets.isNotEmpty)...
              [
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  color: PdfColors.orange200,
                  child: Text('Budgets')
                ),
                Table(
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: PdfColors.orange100
                      ),
                      children: [
                        Text('S/N'),
                        Text('Title'),
                        Text('Budgeted Amount ${currency}'),
                        Text('Amount Spent ${currency}'),
                        Text('Variance ${currency}'),
                        Text('Category'),
                        Text('Period'),
                        Text('Remark'),
                      ]),


//////////////////////
///

                      ...List.generate(budgets.length, (index){
                        return TableRow(
                          children: [
                            Text('${index+1}'),
                            Text(budgets[index].name),
                            Text(budgets[index].amount.toString()),
                            Text((budgets[index].amount-budgets[index].balance).toString()),
                            Text(((budgets[index].amount - (budgets[index].amount-budgets[index].balance))).toString(),
                                    style: TextStyle(
                                      color: (budgets[index].amount - (budgets[index].amount-budgets[index].balance)) == 0 ?
                                        PdfColors.black :
                                            (budgets[index].amount - (budgets[index].amount-budgets[index].balance)) > 0? PdfColors.green : PdfColors.red
                                    ),),
                            Text(budgets[index].category!.name),
                            Text(
                                    budgets[index].startDate == budgets[index].endDate?
                                      '${Month().getMonth(budgets[index].month)} ${budgets[index].year}' :
                                        budgets[index].startDate!.year == budgets[index].endDate!.year?
                                          '${DateFormat.MMMd().format(budgets[index].startDate!)} - ${DateFormat.yMMMd().format(budgets[index].endDate!)}':
                                            '${DateFormat.yMMMd().format(budgets[index].startDate!)} - ${DateFormat.yMMMd().format(budgets[index].endDate!)}', 
                                  )
                          ]
                        );
                      })
                  ]
                )
              ],

            

            if(expenses !=null && expenses.isNotEmpty)...
              [
                SizedBox(height: 6),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  color: PdfColors.orange200,
                  child: Text('Expenses')
                ),
                Table(
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: PdfColors.orange100
                      ),
                      children: [
                        Text('S/N'),
                        Text('Title'),
                        Text('Amount ${currency}'),
                        Text('Income'),
                        Text('Category'),
                        Text('Date'),
                      ]),


                      ...List.generate(expenses.length, (index){
                        return TableRow(
                          children: [
                            Text('${index+1}'),
                            Text(expenses[index].title),
                            Text(expenses[index].amount.toString()),
                            Text(expenses[index].income!.name!),
                            Text(expenses[index].category!.name),
                            Text(DateFormat.yMMMd().format(expenses[index].date)),
                          ]
                        );
                      })
                  ]
                )
              ]
          ];
        }
      )
    );
  }


  Future<File> savePdf(String name, String currency, String period, {String? username, List<ExpenseModel>?expenses, List<BudgetModel>?budgets, List<IncomeModel>? incomes})async{

    await generatePdf(currency, period, expenses: expenses, incomes: incomes, budgets: budgets, name: username);

    final pdfAsBytes = await pdfDoc.save();
    final dir = await getApplicationSupportDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(pdfAsBytes);

    return file;
  }


  Future openPDF(File pdfFile)async{
    await OpenFile.open(pdfFile.path);
  }

}