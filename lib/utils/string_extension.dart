extension StringExtension on String {
  List<String> toChars() {
    final chars = <String>[];

    for (int i = 0; i < length; i++) {
      chars.add(this[i]);
    }

    return chars;
  }
}