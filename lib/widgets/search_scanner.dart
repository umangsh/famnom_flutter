import 'package:code_scan/code_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/search/search.dart';

class SearchScanner extends StatefulWidget {
  const SearchScanner({Key? key}) : super(key: key);

  @override
  State<SearchScanner> createState() => _SearchScannerState();
}

class _SearchScannerState extends State<SearchScanner>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CodeScanner(
      onScan: (code, details, controller) {
        BlocProvider.of<SearchCubit>(context)
            .getSearchResultsWithQuery(barcode: code);
      },
      onAccessDenied: (error, controller) {
        BlocProvider.of<SearchCubit>(context).clearSearchBar();
        return false;
      },
      formats: const [
        BarcodeFormat.upca,
        BarcodeFormat.upce,
        BarcodeFormat.ean8,
        BarcodeFormat.ean13,
      ],
      once: true,
    );
  }
}
