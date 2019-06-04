import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_bloc/flutter_plugin_bloc.dart';

import 'demo/modules.dart';

void main() => runApp(BlocModuleProvider(
      modules: [
        IntBlocModule(subTag: IntBlocModule.INT_BLOC_MODULE_TAG),
        StringBlocModule(subTag: StringBlocModule.STRING_BLOC_MODULE_TAG),
      ],
      child: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Tools.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  BlocModule intBloc;
  BlocModule stringBloc;

  @override
  void dispose() {
    super.dispose();

    intBloc?.dispose();
    stringBloc?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    intBloc = BlocModuleProvider.of(context,
        aspect: IntBlocModule.INT_BLOC_MODULE_TAG) as IntBlocModule;
    stringBloc = BlocModuleProvider.of(context,
        aspect: StringBlocModule.STRING_BLOC_MODULE_TAG) as StringBlocModule;

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          StreamBuilder<int>(
            stream: intBloc.stream,
            initialData: (intBloc as IntBlocModule).count,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return TextWidget(
                data: "current value is ${snapshot.data}",
                tag: "IntBloc",
              );
            },
          ),
          StreamBuilder<String>(
            stream: stringBloc.stream,
            initialData: (stringBloc as StringBlocModule).initString,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return TextWidget(
                data: "current value is ${snapshot.data}",
                tag: "StringBloc",
              );
            },
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Text("add first value"),
                  onTap: () {
                    (intBloc as IntBlocModule).increase();
                  },
                ),
                flex: 1,
              ),
              Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: Text("add second string value"),
                    onTap: () {
                      (stringBloc as StringBlocModule).append();
                    },
                  ))
            ],
          )
        ],
      )),
    ));
  }
}

/////////////demo
class TextWidget extends StatefulWidget {
  final String tag;
  String data;

  TextWidget({@required this.tag, this.data});

  @override
  State<StatefulWidget> createState() => _TextState();
}

class _TextState extends State<TextWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    debugPrint("didChangeDependencies===>${widget.tag}");
  }

  @override
  void initState() {
    super.initState();
    debugPrint("initState===>${widget.tag}");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build===>${widget.tag}");

    return Text("${widget.data}");
  }
}
