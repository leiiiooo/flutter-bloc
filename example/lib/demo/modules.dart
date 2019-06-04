import 'package:flutter_plugin_bloc/flutter_plugin_bloc.dart';
import 'package:meta/meta.dart';

class IntBlocModule extends BlocModule<int> {
  static var INT_BLOC_MODULE_TAG = "IntBlocModule";

  IntBlocModule({@required String subTag}) : super(tag: subTag);

  int count = 0;

  increase() {
    controller.sink.add(++count);
  }
}

class StringBlocModule extends BlocModule<String> {
  static var STRING_BLOC_MODULE_TAG = "StringBlocModule";

  StringBlocModule({@required String subTag}) : super(tag: subTag);

  String initString = "";

  append() {
    initString += "abc";
    controller.sink.add(initString);
  }
}
