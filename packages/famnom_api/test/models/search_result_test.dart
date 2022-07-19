import 'package:constants/constants.dart' as constants;
import 'package:famnom_api/famnom_api.dart';
import 'package:test/test.dart';

void main() {
  group('SearchResult', () {
    group('fromJson', () {
      test('returns SearchResult', () {
        expect(
          SearchResult.fromJson(
            const <String, dynamic>{
              'external_id': constants.testUUID,
              'dname': constants.testSearchResultName,
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
                (SearchResult s) => s.dname,
                'dname',
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
  });
}
