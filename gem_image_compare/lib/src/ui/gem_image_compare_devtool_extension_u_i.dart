import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'image_comparison_cubit.dart';

import 'compare_widget.dart';
import 'history_item.dart';

class GemImageCompareDevtoolExtensionUI extends StatelessWidget {
  const GemImageCompareDevtoolExtensionUI({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageComparisonCubit(),
      child: DevToolsExtension(
        child: BlocBuilder<ImageComparisonCubit, ImageComparisonState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 2 - 50, child: const CompareWidget()),
                const Divider(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2 - 50,
                  child: ListView(
                    children: List.generate(
                      state.history.length,
                      (index) => HistoryItem(
                        data: state.history[index],
                        index: index,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
