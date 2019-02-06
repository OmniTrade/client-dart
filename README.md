# OmniTrade API Dart Client

**OmniTrade API Dart Client** is an open-source Dart that integrates the OmniTrade API.
You can read the API documentation by visiting [this link](https://omnitrade.io/documents/api_v2)

## Getting Started

You can use in your project adding the dependency on `pubspec.yml`

````yml
dependencies:
  ...
  omnitrade_client:
    git: https://github.com/OmniTrade/client-dart
````

## Usage example

1. Import package to use it

````dart
import 'package:omnitrade_client/omnitrade_client.dart';
````

2. Create new instance of OmniTrade Client

````dart
final client = OmniTradeClient();
```` 

3. Call Api method that you need

`````dart
Future<void> yourFunction() async {
  final response = await client.fetchMarkets();
}
`````

## Available methods

- fetchMarkets
- fetchTickets
- fetchTicketsFromMarket
- fetchDepth
- fetchTrades
- fetchK
- fetchKWithPendingTrades
- fetchTimestamp
- generateTrezorChallenge

## Todo

- [] Add support to private API