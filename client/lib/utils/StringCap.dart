extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : this;
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach =>
      this.split(' ').map((str) => str.inCaps).join(' ');
}
