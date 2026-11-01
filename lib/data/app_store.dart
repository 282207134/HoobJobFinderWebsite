import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStore extends ChangeNotifier {
  final SharedPreferences preferences;
  final Set<String> savedJobs;
  final Set<String> savedCompanies;
  final Map<String, String> applications;
  String name;
  AppStore(this.preferences)
    : savedJobs = (preferences.getStringList('savedJobs') ?? []).toSet(),
      savedCompanies = (preferences.getStringList('savedCompanies') ?? [])
          .toSet(),
      applications = Map<String, String>.from(
        jsonDecode(preferences.getString('applications') ?? '{}') as Map,
      ),
      name = preferences.getString('name') ?? 'Cameron';
  Future<void> toggleJob(String id) async {
    savedJobs.contains(id) ? savedJobs.remove(id) : savedJobs.add(id);
    notifyListeners();
    await preferences.setStringList('savedJobs', savedJobs.toList());
  }

  Future<void> toggleCompany(String id) async {
    savedCompanies.contains(id)
        ? savedCompanies.remove(id)
        : savedCompanies.add(id);
    notifyListeners();
    await preferences.setStringList('savedCompanies', savedCompanies.toList());
  }

  Future<void> apply(
    String id,
    String applicant, {
    bool updates = false,
  }) async {
    applications[id] = DateTime.now().toIso8601String();
    name = applicant.trim().split(' ').first;
    notifyListeners();
    await preferences.setString('applications', jsonEncode(applications));
    await preferences.setString('name', name);
    await preferences.setBool('similarJobUpdates', updates);
  }

  Map<String, String> readDraft(String key) {
    final raw = preferences.getString(key);
    return raw == null ? {} : Map<String, String>.from(jsonDecode(raw) as Map);
  }

  Future<bool> saveDraft(String key, Map<String, String> draft) =>
      preferences.setString(key, jsonEncode(draft));
}

class StoreScope extends InheritedNotifier<AppStore> {
  const StoreScope({super.key, required AppStore store, required super.child})
    : super(notifier: store);
  static AppStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<StoreScope>()!.notifier!;
}
