import 'package:flame/components.dart';

class ObjectPool<T extends Component> {
  final int initialSize;
  final T Function() factory;
  final void Function(T obj) resetFunction;

  final List<T> _activeObjects = [];
  final List<T> _inactiveObjects = [];

  ObjectPool({
    required this.initialSize,
    required this.factory,
    required this.resetFunction,
  }) {
    _initializePool();
  }

  void _initializePool() {
    for (var i = 0; i < initialSize; i++) {
      _inactiveObjects.add(factory());
    }
  }

  T spawn() {
    T object;
    if (_inactiveObjects.isEmpty) {
      object = factory();
    } else {
      object = _inactiveObjects.removeLast();
    }
    _activeObjects.add(object);
    resetFunction(object);
    return object;
  }

  void release(T object) {
    if (_activeObjects.remove(object)) {
      object.removeFromParent();
      resetFunction(object);
      _inactiveObjects.add(object);
    }
  }

  void releaseAll() {
    for (var object in _activeObjects) {
      object.removeFromParent();
      resetFunction(object);
      _inactiveObjects.add(object);
    }
    _activeObjects.clear();
  }
}
