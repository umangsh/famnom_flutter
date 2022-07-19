import 'package:constants/constants.dart' as constants;
import 'package:flutter_test/flutter_test.dart';
import 'package:search_repository/search_repository.dart';

void main() {
  group('SearchResult', () {
    group('fromJson', () {
      test('returns SearchResult', () {
        expect(
          SearchResult.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'name': constants.testSearchResultName,
              'url': constants.testSearchResultURI,
              'brand_name': constants.testBrandName,
              'brand_owner': constants.testBrandOwner
            },
          ),
          isA<SearchResult>()
              .having(
                (SearchResult s) => s.externalId,
                'external_id',
                equals(constants.testUUID),
              )
              .having(
                (SearchResult s) => s.name,
                'name',
                equals(constants.testSearchResultName),
              )
              .having(
                (SearchResult s) => s.url,
                'url',
                equals(constants.testSearchResultURI),
              )
              .having(
                (SearchResult s) => s.brandName,
                'brandName',
                equals(constants.testBrandName),
              )
              .having(
                (SearchResult s) => s.brandOwner,
                'brandOwner',
                equals(constants.testBrandOwner),
              ),
        );
      });
    });

    group('brand details', () {
      test('empty', () {
        const searchResult = SearchResult(
          externalId: constants.testUUID,
          name: constants.testSearchResultName,
          url: constants.testSearchResultURI,
        );
        expect(searchResult.brandDetails, isNull);
      });

      test('brand name only', () {
        const searchResult = SearchResult(
          externalId: constants.testUUID,
          name: constants.testSearchResultName,
          url: constants.testSearchResultURI,
          brandName: constants.testBrandName,
        );
        expect(searchResult.brandDetails, equals('test_brand_name'));
      });

      test('brand owner only', () {
        const searchResult = SearchResult(
          externalId: constants.testUUID,
          name: constants.testSearchResultName,
          url: constants.testSearchResultURI,
          brandOwner: constants.testBrandOwner,
        );
        expect(searchResult.brandDetails, equals('test_brand_owner'));
      });

      test('brand name and owner', () {
        const searchResult = SearchResult(
          externalId: constants.testUUID,
          name: constants.testSearchResultName,
          url: constants.testSearchResultURI,
          brandName: constants.testBrandName,
          brandOwner: constants.testBrandOwner,
        );
        expect(
          searchResult.brandDetails,
          equals('test_brand_name, test_brand_owner'),
        );
      });
    });
  });
}
