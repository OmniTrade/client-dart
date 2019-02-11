enum Env {
  TEST,
  PROD,
}

class Injector {
  static final Injector _singleton = Injector._internal();
  static Env _repoType;
  static void configure(Env repoType) {
    _repoType = repoType;
  }

  factory Injector() {
    return _singleton;
  }

  Injector._internal();

  int get tonce {
    switch (_repoType) {
      case Env.TEST:
        return 123456789;
      default:
        return DateTime.now().millisecondsSinceEpoch;
    }
  }
}