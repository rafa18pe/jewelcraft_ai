// Minimal stub to satisfy universal_html imports on non-web platforms.
// Only the APIs used in the app are provided as no-ops.

class Blob {
  final List<dynamic> parts;
  final String? type;
  Blob(this.parts, [this.type]);
}

class Url {
  static String createObjectUrlFromBlob(Blob blob) => '';
  static void revokeObjectUrl(String url) {}
}

class AnchorElement {
  AnchorElement({String? href});
  void setAttribute(String name, String value) {}
  void click() {}
}
