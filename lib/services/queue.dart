class SoulQueue<T> extends Iterable {
  final int arraySize;
  final List<T?> items;
  int top;
  SoulQueue({required this.arraySize, required this.items, this.top = -1});
  factory SoulQueue.fromList(List<T> items) =>
      SoulQueue(arraySize: items.length, items: items, top: items.length - 1);

  void add(T item) {
    if (top < items.length - 1) {
      items[++top] = item;
    } else {
      top = -1;
      items[++top] = item;
    }
  }

  void align() {
    var index = items.indexWhere((element) => element == null);
    for (int i = index; i < items.length - 1; i++) {
      items[i] = items[i + 1];
    }
    items[items.length - 1] = null;
    --top;
  }

  int indexWhere(bool Function(T?) test) {
    return items.indexWhere(test);
  }

  @override
  bool contains(Object? element) {
    return items.contains(element);
  }

  T? get(int index) {
    return items[index];
  }

  void removeWhere(bool Function(T? item) test, {bool realign = true}) {
    var index = items.indexWhere(test);

    if (index != -1) {
      items[index] = null;
    }
    if (realign) {
      align();
    }
  }

  @override
  int get length {
    return items.length;
  }

  bool get isFull {
    var filtered = items.where((element) => element != null);
    if (filtered.length != items.length) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Iterator get iterator => items.iterator;
}
