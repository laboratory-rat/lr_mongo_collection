import 'dart:mirrors';

class HelperEntityActivator {
  static dynamic activate(Type type, [Symbol constructor = const Symbol(''), List arguments = const []]) {
    ClassMirror c = reflectClass(type);
    InstanceMirror im = c.newInstance(constructor, arguments);
    return im.reflectee;
  }
}