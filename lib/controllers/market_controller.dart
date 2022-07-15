import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import '../services/base_client.dart';

class MarketNameController extends GetxController {
  List<String> marketList = <String>[].obs;
  Future<List<String>> getMarketList(String filter) async {
    var data = {
      's': filter,
    };
    var response =
        await BaseClient().dioPost('/search-market', json.encode(data));
    if (response != null && response['success']) {
      List marketsJson = response['data'];
      marketList.clear();
      for (var market in marketsJson) {
        marketList.add(market['market_name']);
      }
    }
    return marketList;
  }
}
