import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart' as famnom;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:search_repository/search_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template search_repository}
/// Repository which manages search and autocomplete.
/// {@endtemplate}
class SearchRepository {
  /// {@macro search_repository}
  SearchRepository({
    famnom.FamnomApiClient? famnomApiClient,
  }) : _famnomApiClient = famnomApiClient ?? famnom.FamnomApiClient();

  final famnom.FamnomApiClient _famnomApiClient;

  /// Number of autocomplete suggestions saved (LRU eviction).
  int maxSuggestions = 15;

  /// URI to fetch the next search page results.
  String? nextURI;

  /// Whether or not the current environment is web
  /// Should only be overridden for testing purposes. Otherwise,
  /// defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// Searches with a [query].
  ///
  /// Throws a [SearchFailure] if an exception occurs.
  Future<List<SearchResult>> searchWithQuery({
    String query = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final searchResponse = await _famnomApiClient.search(key, query, null);
      nextURI = searchResponse.next;
      return searchResponse.toResults;
    } on famnom.FamnomAPIException catch (e) {
      throw SearchFailure.fromAPIException(e);
    } catch (_) {
      throw const SearchFailure();
    }
  }

  /// Searches with a [nextURI].
  ///
  /// Throws a [SearchFailure] if an exception occurs.
  Future<List<SearchResult>> searchWithURI() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(constants.prefAuthToken) ?? '';

    try {
      final searchResponse = await _famnomApiClient.search(key, null, nextURI);
      nextURI = searchResponse.next;
      return searchResponse.toResults;
    } on famnom.FamnomAPIException catch (e) {
      throw SearchFailure.fromAPIException(e);
    } catch (_) {
      throw const SearchFailure();
    }
  }

  /// Reads autocomplete suggestions from shared preferences.
  Future<List<AutocompleteResult>> getAutocompleteResults() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(constants.prefAutocompleteSuggestions) ?? [])
        .map(
          (serialized) => AutocompleteResult.fromJson(
            jsonDecode(serialized) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  /// Writes autocomplete suggestions to shared preferences.
  Future<void> updateAutocompleteResults(
    String newSuggestion,
  ) async {
    final suggestions =
        ListQueue<AutocompleteResult>.from(await getAutocompleteResults())
          ..removeWhere((element) => element.query == newSuggestion)
          ..addFirst(
            AutocompleteResult(
              query: newSuggestion,
              timestamp: clock.now().millisecondsSinceEpoch,
            ),
          );

    if (suggestions.length > maxSuggestions) {
      suggestions.removeLast();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      constants.prefAutocompleteSuggestions,
      suggestions.map((element) => json.encode(element)).toList(),
    );
  }
}

extension on famnom.SearchResponse {
  List<SearchResult> get toResults {
    return results
        .map(
          (result) => SearchResult(
            externalId: result.externalId,
            name: result.dname,
            url: result.url,
            brandName: result.brandName,
            brandOwner: result.brandOwner,
          ),
        )
        .toList();
  }
}
