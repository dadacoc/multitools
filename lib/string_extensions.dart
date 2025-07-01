extension StringExtensions on String {
  String get withoutDiacritics {
    const diacritics =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    const nonDiacritics =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    return split('').map((char) {
      final index = diacritics.indexOf(char);
      return index >= 0 ? nonDiacritics[index] : char;
    }).join('');
  }
}