import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:swan_pro/ui/widgets/button_widget.dart';
import 'package:swan_pro/ui/widgets/swan_pro_text_field.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:developer';
import 'dart:typed_data';

// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  /// Variables ///
  late ByteData data;
  late Uint8List bytes;
  late Excel excel;
  String file = "assets/rules.xlsx";
  late Database database;
  List<Map> dataInputs = [
    {'dateTime': DateTime.now(), 'fieldName': 'Date of birth'},
    {'dateTime': DateTime.now(), 'fieldName': 'From date'},
    {'dateTime': DateTime.now(), 'fieldName': 'To Date'},
  ];
  bool isLoading = false;

  submitValue({required BuildContext context}) async {

    if((dataInputs[2]['dateTime'].difference(dataInputs[1]['dateTime']).inDays / 365).floor()>0){
      List<Map> priceList = await database.query('swan', columns: ['min_age','max_age','price','dateFrom'],);
      List<Map> categoryList = await database.query('swan', columns: ['min_age','max_age','category','dateFrom',],);
      List<Map> codeList = await database.query('swan', columns: ['min_age','max_age','code','dateFrom',],);

      /// Inputs ///
      int age = (DateTime.now().difference(dataInputs[0]['dateTime']).inDays / 365).floor();
      int diffInDates = (dataInputs[2]['dateTime'].difference(dataInputs[1]['dateTime']).inDays / 365).floor();

      dynamic
      resultPrice = priceList.firstWhere((element) =>
      ((age >= element['min_age'] && age <= element['max_age']) && element['dateFrom'].toString() == diffInDates.toString()));
      dynamic
      resultCategory = categoryList.firstWhere((element) =>
      ((age >= element['min_age'] && age <= element['max_age']) && element['dateFrom'].toString() == diffInDates.toString()));
      dynamic
      resultCode = codeList.firstWhere((element) =>
      ((age >= element['min_age'] && age <= element['max_age']) && element['dateFrom'].toString() == diffInDates.toString()));


      log(age.toString());
      log(diffInDates.toString());

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Swan Pro Result'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Category: ${resultCategory['category']}'),
                  Text('Code: ${resultCode['code']}'),
                  Text('Price: ${resultPrice['price']}'),
                ],
              ),
            );
          });
    }else{
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Swan Pro Alert'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('From should be before to'),
                ],
              ),
            );
          });
    }
  }

  loadDatabase() async {
    setState(() {
      isLoading = true;
    });
    data = await rootBundle.load("lib/assets/rules.xlsx");
    bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    excel = Excel.decodeBytes(bytes);
    setState(() {});
    try {
      database = await openDatabase(
        join(await getDatabasesPath(), 'database.db'),
        onCreate: (Database db, int version) async {
        },
        version: 1,
      );
      await database.execute("DROP TABLE IF EXISTS swan");
      await database.execute(
          "CREATE TABLE swan (id INTEGER PRIMARY KEY, dateTo TEXT, dateFrom TEXT, code TEXT, category TEXT, min_age INTEGER, max_age INTEGER, price REAL)");
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        if (row != null && row.isNotEmpty && row[0] != null) {
          log("${row}");
          int id1 = await database.rawInsert(
              'INSERT INTO swan(dateTo, dateFrom, code, category, min_age, max_age, price)'
              ' VALUES("${row[4]}", "${row[3]}", "${row[7]}", "${row[6]}", "${row[1]}", "${row[2]}", ${row[8]})');
          print('inserted1: $id1');
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      loadDatabase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                stops: [0.0, 1.0],
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
                tileMode: TileMode.repeated,
                colors: [
                  Color(0xff3585A7),
                  Color(0xff5885A7),
                ],
              ),
            ),
            child: Stack(
              children: <Widget>[
                /// Intro ///
                Positioned(
                  top: constraints.maxHeight * .05,
                  right: constraints.maxWidth * .12,
                  left: constraints.maxWidth * .12,
                  child: Container(
                    height: constraints.maxWidth * .15,
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        'Fill in your appropriate data',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: const Color(0xffFFFFFF),
                            fontSize: constraints.maxWidth * .05),
                      ),
                    ),
                  ),
                ),

                /// Name Text Field ///
                Positioned(
                    top: constraints.maxHeight * .2,
                    bottom: constraints.maxHeight * .2,
                    right: constraints.maxWidth * .0,
                    left: constraints.maxWidth * .0,
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                          children: dataInputs.map((dataInput) {
                        return Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.all(5.0),
                            color: Colors.transparent,
                            child: Column(
                              children: [
                                SizedBox(
                                    height: constraints.maxWidth * .05,
                                    child: Text(
                                      '${dataInput['fieldName']}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                                SizedBox(
                                  height: constraints.maxWidth * .15,
                                  child: Container(
                                    color: const Color(0xffc0c0c0),
                                    child: ScrollDatePicker(
                                      selectedDate: dataInput['dateTime'],
//                                  minimumDate: DateTime.now(),
                                      maximumDate: dataInput['fieldName'] ==
                                              "Date of birth"
                                          ? DateTime.now()
                                          : DateTime(2025),
                                      locale: DatePickerLocale.enUS,
                                      onDateTimeChanged: (DateTime value) {
                                        dataInput['dateTime'] = value;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList()),
                    )),

                /// Submit Button ///
                Positioned(
                  bottom: constraints.maxHeight * .033,
                  right: constraints.maxWidth * .1,
                  left: constraints.maxWidth * .1,
                  child: Container(
                    color: Colors.transparent,
                    height: constraints.maxHeight * .075,
                    child: ButtonWidget(
                      constraints: constraints,
                      buttonColor: const Color(0xff43B0D9),
                      borderRadius: 12.0,
                      buttonName: 'Submit Data',
                      triggerFunction: () {
                        submitValue(context: context);
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),

                /// Loading ///
                if (isLoading)
                  Container(
                    color: const Color(0xdd43B0D9),
                    child: const Center(
                        child: Padding(
                      padding: EdgeInsets.all(35.0),
                      child: LinearProgressIndicator(),
                    )),
                  )
                else
                  Container()
              ],
            ),
          );
        },
      ),
    );
  }
}
