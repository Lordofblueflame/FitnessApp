import 'pair.dart';

class PairList<T, U> {
  final List<Pair<T, U>> _pairs = [];

  PairList(Type meal, Type product);

  void add(T first, U second) {
    _pairs.add(Pair(first, second));
  }

  void remove(T first, U second) {
    _pairs.removeWhere((pair) => pair.first == first && pair.second == second);
  }

  Pair<T, U>? get(int index) {
    if (index < 0 || index >= _pairs.length) {
      return null; 
    }
    return _pairs[index];
  }

  void set(int index, T newFirst, U newSecond) {
    if (index < 0 || index >= _pairs.length) {
      return;
    }
    _pairs[index] = Pair(newFirst, newSecond);
  }

  int find(T first, U second) {
    return _pairs.indexWhere((element) => element.first == first && element.second == second);
  }

  List<Pair<T, U>> getAllPairsForFirst(T value) {
    return _pairs.where((pair) => pair.first == value).toList();
  }
  
  @override
  String toString() => _pairs.toString();
}