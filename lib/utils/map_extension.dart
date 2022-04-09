extension MapExtension<K, V> on Map<K, V> {
  Map<K, V> exclude(bool Function(K key, V value) condition) {
    return Map.from(this)..removeWhere(condition);
  }
}
