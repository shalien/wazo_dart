enum WazoCalldApplicationDtmf {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  star,
  hash;

  @override
  String toString() {
    switch (this) {
      case WazoCalldApplicationDtmf.zero:
        return '0';
      case WazoCalldApplicationDtmf.one:
        return '1';
      case WazoCalldApplicationDtmf.two:
        return '2';
      case WazoCalldApplicationDtmf.three:
        return '3';
      case WazoCalldApplicationDtmf.four:
        return '4';
      case WazoCalldApplicationDtmf.five:
        return '5';
      case WazoCalldApplicationDtmf.six:
        return '6';
      case WazoCalldApplicationDtmf.seven:
        return '7';
      case WazoCalldApplicationDtmf.eight:
        return '8';
      case WazoCalldApplicationDtmf.nine:
        return '9';
      case WazoCalldApplicationDtmf.star:
        return '*';
      case WazoCalldApplicationDtmf.hash:
        return '#';
    }
  }
}
