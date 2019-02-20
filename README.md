# OmniTrade API Dart Client

**OmniTrade API Dart Client** is an open-source Dart that integrates the OmniTrade API.
You can read the API documentation by visiting [this link](https://omnitrade.io/documents/api_v2)

## Getting Started

You can use in your project adding the dependency on `pubspec.yml`

```yml
dependencies:
  ...
  omnitrade_client:
    git: https://github.com/OmniTrade/client-dart
```

## Usage example

1. Import package to use it

```dart
import 'package:omnitrade_client/omnitrade_client.dart';
```

2. Create new instance of OmniTrade Client

```dart
final client = OmniTradeClient();
``` 

If you need to call private methods you'll be supposed to pass credentials

```dart
final client = OmniTradeClient(
  accessKey: 'xxx',
  privateKey: 'yyy'
);
```

You can got the credentials [here](https://staging.omnitrade.io/api_tokens)

3. Call Api method that you need

````dart
Future<void> yourFunction() async {
  final response = await client.fetchMarkets();
}
````

## Public methods (not required credentials)

- fetchMarkets
- fetchTickets
- fetchTicketsFromMarket
- fetchDepth
- fetchTrades
- fetchK
- fetchKWithPendingTrades
- fetchTimestamp
- generateTrezorChallenge

## Private methods (requires credentials)

- fetchMe
- fetchDeposits
- fetchDeposit
- fetchDepositAddress
- fetchOrders
- cancelOrders
- fetchOrder
- cancelOrder

## Todo

- createManyOrders
- cancelOrdersBottom