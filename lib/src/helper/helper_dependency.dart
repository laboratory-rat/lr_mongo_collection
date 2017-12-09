import 'dart:mirrors';

class HelperDependency {
  Map<ClassMirror, HelperDependencyNode> _collection = new Map();

  HelperDependency bind(Type base, Type injection, List args) {
    var rc = reflectClass(base);
    if (!_collection.containsKey(rc)) {
      _collection[rc] = new HelperDependencyNode(injection, args);
    }

    return this;
  }

  dynamic from(Type base) {
    var rc = reflectClass(base);
    if (!_collection.containsKey(rc)) throw new Exception('No injection defined on type ' + rc.qualifiedName.toString());

    var classReflect = reflectClass(_collection[rc].injection);
    var instance = classReflect.newInstance(const Symbol(''), _collection[rc].args);

    return instance.reflectee;
  }
}

class HelperDependencyNode {
  Type injection;
  List args;

  HelperDependencyNode(this.injection, this.args);
}