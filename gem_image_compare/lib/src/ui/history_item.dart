import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'image_comparison_cubit.dart';
import '../image_comparison_data.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.data,
    required this.index,
  });

  final ImageComparisonData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = data.maeCurrent <= data.maeThreshold ? Colors.green : Colors.red;
    String functionName = data.filename;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: color.withAlpha(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "#$index (act: ${data.maeCurrent} max: ${data.maeThreshold})",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(functionName, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                BlocProvider.of<ImageComparisonCubit>(context).presentCurrentData(index);
              },
              icon: const Icon(Icons.play_arrow),
            )
          ],
        ),
      ),
    );
  }
}
