enum WazoCalldDtmf {
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
      case WazoCalldDtmf.zero:
        return '0';
      case WazoCalldDtmf.one:
        return '1';
      case WazoCalldDtmf.two:
        return '2';
      case WazoCalldDtmf.three:
        return '3';
      case WazoCalldDtmf.four:
        return '4';
      case WazoCalldDtmf.five:
        return '5';
      case WazoCalldDtmf.six:
        return '6';
      case WazoCalldDtmf.seven:
        return '7';
      case WazoCalldDtmf.eight:
        return '8';
      case WazoCalldDtmf.nine:
        return '9';
      case WazoCalldDtmf.star:
        return '*';
      case WazoCalldDtmf.hash:
        return '#';
    }
  }
}
