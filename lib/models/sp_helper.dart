import 'dart:convert';

import 'package:raven/models/debt_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpHelper {
  static final String kDebts = 'debts';
  // static final String kSettledDebts = 'settledDebts';
  static final String kPresets = 'presetNames';

  // static Future<Map> getAll() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List debts = jsonDecode(prefs.getString(kDebts) ?? '[]');
  //   List settledDebts = jsonDecode(prefs.getString(kSettledDebts) ?? '[]');
  //   List presetNames = jsonDecode(prefs.getString(kPresets) ?? '[]');
  //   return {
  //     'debts': List<Map>.from(debts),
  //     'settledDebts': List<Map>.from(settledDebts),
  //     'presetNames': List<String>.from(presetNames),
  //   };
  // }

  static Future<List<Debt>> getDebts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> debtStrings = prefs.getStringList(kDebts) ?? [];
    List<Debt> debts = debtStrings.map((String string) {
      Map debtJson = jsonDecode(string);
      return Debt.fromJson(debtJson);
    }).toList();
    return debts;
  }

  static Future<bool> saveDebts(List<Debt> debts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> debtStrings = debts.map((Debt debt) {
      Map debtJson = debt.toJson();
      return jsonEncode(debtJson);
    }).toList();
    return await prefs.setStringList(kDebts, debtStrings);
  }

  static Future<List<String>> getPresets() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(kPresets) ?? [];
  }

  static Future<bool> savePresets(List<String> presets) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(kPresets, presets);
  }
}
