part of flutter_plugin_bloc;

class BlocModule<T> {
  final String tag;

  BlocModule({@required this.tag}) : assert(tag != null);

  var _countController = StreamController<T>.broadcast();

  Stream<T> get stream => _countController.stream;

  StreamController get controller => _countController;

  dispose() {
    _countController.close();
  }
}

class BlocModuleProvider extends InheritedModel<String> {
  final List<BlocModule> modules;
  final Widget child;

  BlocModuleProvider({Key key, @required this.modules, @required this.child})
      : assert(child != null),
        assert(modules != null),
        super(child: child);

  @override
  bool updateShouldNotify(BlocModuleProvider oldWidget) => true;

  @override
  bool updateShouldNotifyDependent(
      BlocModuleProvider oldWidget, Set<String> dependencies) {
    return _checkDependencies(dependencies);
  }

  static BlocModule of(BuildContext context, {@required String aspect}) {
    if (aspect == null) {
      throw Exception("Please check your aspect param.");
    }

    BlocModule module;

    BlocModuleProvider provider =
        InheritedModel.inheritFrom<BlocModuleProvider>(context, aspect: aspect);

    if (provider == null) {
      ///error
      throw new Exception(
          'Please check your aspect param, module don`t contain the target aspect');
    }

    module = _findTargetModule(aspect, provider.modules);

    return module;
  }

  bool _checkDependencies(Set<String> dependencies) {
    bool tag;

    for (String dependency in dependencies) {
      tag = false;
      for (BlocModule module in modules) {
        if (dependency == module.tag) {
          tag = true;
          break;
        }
      }

      if (tag) {
        return true;
      }
    }

    return false;
  }

  static BlocModule _findTargetModule(String aspect, List<BlocModule> modules) {
    for (var module in modules) {
      if (module.tag == aspect) {
        return module;
      }
    }

    return null;
  }
}
