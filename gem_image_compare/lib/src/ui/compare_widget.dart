import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'image_comparison_cubit.dart';
import '../image_comparison_data.dart';
import 'image_info.dart';

class CompareWidget extends StatelessWidget {
  const CompareWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageComparisonCubit, ImageComparisonState>(builder: (context, state) {
      if (state.current == null) return const Text("No data");
      final currentData = state.current!;
      return ListView(
        children: [
          Container(
            color: currentData.maeCurrent <= currentData.maeThreshold ? Colors.green : Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Current MAE: ${currentData.maeCurrent}; Max allowed: ${currentData.maeThreshold}",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black),
                ),
              ],
            ),
          ),
          Row(
            children: [
              ImageInfoWidget(
                name: "Actual",
                image: currentData.actualData,
                currentSize: Size(currentData.width.toDouble(), currentData.height.toDouble()),
                position: Offset(state.xp.toDouble(), state.yp.toDouble()),
              ),
              ImageInfoWidget(
                name: "Expected",
                image: currentData.expectedData,
                currentSize: Size(currentData.width.toDouble(), currentData.height.toDouble()),
                position: Offset(state.xp.toDouble(), state.yp.toDouble()),
              ),
              ImageInfoWidget(
                name: "Difference",
                image: currentData.getDifference(),
                currentSize: Size(currentData.width.toDouble(), currentData.height.toDouble()),
                position: Offset(state.xp.toDouble(), state.yp.toDouble()),
              ),
            ],
          ),
          const SizedBox(height: 25),
          SelectableText(currentData.filename),
        ],
      );
    });
  }
}
