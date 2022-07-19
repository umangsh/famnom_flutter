import 'package:app_repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:famnom_flutter/details/details.dart';
import 'package:famnom_flutter/home/home.dart';
import 'package:famnom_flutter/log/log.dart';
import 'package:famnom_flutter/widgets/widgets.dart';

class DetailsDBFoodView extends StatefulWidget {
  const DetailsDBFoodView({Key? key, required this.externalId})
      : super(key: key);

  final String externalId;

  @override
  State<DetailsDBFoodView> createState() => _DetailsDBFoodViewState();
}

class _DetailsDBFoodViewState extends State<DetailsDBFoodView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const MyAppBar(showLogo: false),
        body: BlocListener<DetailsDBFoodCubit, DetailsState>(
          listener: (context, state) {
            if (state.status == DetailsStatus.requestFailure ||
                state.status == DetailsStatus.saveRequestFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      state.errorMessage ??
                          'Something went wrong, please try again.',
                    ),
                  ),
                );
            }
          },
          child: BlocBuilder<DetailsDBFoodCubit, DetailsState>(
            builder: (context, state) {
              switch (state.status) {
                case DetailsStatus.init:
                  context
                      .read<DetailsDBFoodCubit>()
                      .loadPageData(externalId: widget.externalId);
                  return const EmptySpinner();
                case DetailsStatus.requestSubmitted:
                case DetailsStatus.requestFailure:
                  return const EmptySpinner();
                case DetailsStatus.requestSuccess:
                case DetailsStatus.portionSelected:
                case DetailsStatus.saveRequestSubmitted:
                case DetailsStatus.saveRequestSuccess:
                case DetailsStatus.saveRequestFailure:
                case DetailsStatus.deleteRequestCancelled:
                case DetailsStatus.deleteRequestSubmitted:
                case DetailsStatus.deleteRequestSuccess:
                  return RefreshIndicator(
                    backgroundColor: theme.scaffoldBackgroundColor,
                    color: theme.colorScheme.secondary,
                    onRefresh: () {
                      return context
                          .read<DetailsDBFoodCubit>()
                          .loadPageData(externalId: widget.externalId);
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                      children: <Widget>[
                        /// Food name
                        Text(
                          state.dbFood!.name,
                          softWrap: true,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 16),

                        /// Brand details
                        if (state.dbFood!.brand != null)
                          BrandDetails(brand: state.dbFood!.brand!),

                        /// Portion details
                        PortionDetails(
                          portions: state.dbFood!.portions!,
                          defaultPortion: state.dbFood!.defaultPortion!,
                          onChangedServings: (value) {
                            context
                                .read<DetailsDBFoodCubit>()
                                .selectPortion(portion: value! as Portion);
                          },
                          onChangedQuantity: (value) {
                            context.read<DetailsDBFoodCubit>().setQuantity(
                                  quantity:
                                      value == null || value.toString().isEmpty
                                          ? 1
                                          : double.parse(value.toString()),
                                );
                          },
                        ),

                        /// Log form
                        BlocProvider(
                          create: (_) =>
                              LogDBFoodCubit(context.read<AppRepository>()),
                          child: LogDBFoodForm(externalId: widget.externalId),
                        ),

                        /// Nutrition label
                        NutritionLabel(
                          nutrients: state.dbFood!.nutrients!,
                          portion: state.selectedPortion,
                          quantity: state.quantity,
                          fdaRDIs: state.fdaRDIs,
                          nutritionPreferences: state.nutritionPreferences,
                        )
                      ],
                    ),
                  );
              }
            },
          ),
        ),
        floatingActionButton: BlocBuilder<DetailsDBFoodCubit, DetailsState>(
          builder: (context, state) {
            return Visibility(
              visible: [
                    DetailsStatus.requestSuccess,
                    DetailsStatus.portionSelected,
                    DetailsStatus.saveRequestSuccess
                  ].contains(state.status) &&
                  state.dbFood?.lfoodExternalId == null,
              child: state.status == DetailsStatus.saveRequestSuccess
                  ? FloatingActionButton.extended(
                      onPressed: () {},
                      label: const Text('Added!'),
                      icon: const Icon(Icons.check),
                      backgroundColor: const Color(0xFF007BFF),
                    )
                  : FloatingActionButton.extended(
                      onPressed: () {
                        context
                            .read<DetailsDBFoodCubit>()
                            .saveDBFood(externalId: widget.externalId);
                      },
                      label: const Text('Add to Kitchen'),
                      icon: const Icon(Icons.kitchen),
                      backgroundColor: theme.primaryColor,
                    ),
            );
          },
        ),
        bottomNavigationBar: BottomBar(
          onTap: (index) async {
            await Navigator.of(context)
                .push(HomePage.route(selectedTab: index));
          },
        ),
      ),
    );
  }
}
