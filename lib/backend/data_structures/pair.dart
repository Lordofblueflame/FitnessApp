class Pair<T, U> {
  T first;
  U second;

  Pair(this.first, this.second);

  T accessFirst() => first;
  U accessSecond() => second;

  @override
  String toString() => '($first, $second)';
}