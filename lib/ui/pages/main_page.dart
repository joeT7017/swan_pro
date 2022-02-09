import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swan_pro/ui/pages/form_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff3585A7),
        shadowColor: Colors.black12,
        title: Text(widget.title),
      ),
      body: const FormPage(),
    );
  }
}
