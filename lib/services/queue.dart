class SoulQueue<T> extends Iterable {
  final int arraySize;
  final List<T?> items;
  int top;
  SoulQueue({required this.arraySize, required this.items, this.top = -1});
  factory SoulQueue.fromList(List<T?> items, {int? arraySize}) => SoulQueue(
      arraySize: arraySize ?? items.length,
      items: items,
      top: items.length - 1);

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

  List<T?> get flat {
    List<T?> flatList = items.toList();
    flatList.removeWhere((element) => element == null);
    return flatList;
  }

  void fill(int size) {
    if (items.length != size) {
      int deficit = arraySize - items.length;
      for (int i = deficit; i < arraySize; i++) {
        items.add(null);
      }
    }
  }

  T? get(int index) {
    return items[index];
  }

  void removeWhere(bool Function(T? item) test, {bool realign = true}) {
    int index = items.indexWhere(test);
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
