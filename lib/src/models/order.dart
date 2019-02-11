enum OrderSide {
  sell, buy
}

enum OrdType {
  limit, market
}

class Order {
  Order(this.market, this.side, this.volume, {this.price, this.ordType});

  final String market;
  final OrderSide side;
  final String volume;
  final String price;
  final OrdType ordType;

  Map<String, dynamic> get asMap => {
    'market': market,
    'side': sideAsString,
    'volume': volume,
    'price': price,
    'ord_type': ordTypeAsString,
  };

  String get sideAsString => '$side'.substring('$side'.indexOf('.') + 1);

  String get ordTypeAsString =>
    (ordType == null) ? null :
    '$ordType'.substring('$ordType'.indexOf('.') + 1);
}
