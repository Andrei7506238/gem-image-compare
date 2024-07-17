// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:devtools_extensions/devtools_extensions.dart';

import '../image_comparison_data.dart';

class ImageComparisonState {
  final List<ImageComparisonData> history;
  final ImageComparisonData? current;

  final double xp;
  final double yp;

  ImageComparisonState({
    this.history = const [],
    this.current,
    this.xp = 0,
    this.yp = 0,
  });

  ImageComparisonState copyWith({
    List<ImageComparisonData>? history,
    ImageComparisonData? current,
    double? xp,
    double? yp,
  }) {
    return ImageComparisonState(
      history: history ?? this.history,
      current: current ?? this.current,
      xp: xp ?? this.xp,
      yp: yp ?? this.yp,
    );
  }

  ImageComparisonState copyWithNullCurrent() {
    return ImageComparisonState(history: history);
  }
}

class ImageComparisonCubit extends Cubit<ImageComparisonState> {
  StreamSubscription? extensionEventSubscription;

  ImageComparisonCubit() : super(ImageComparisonState()) {
    serviceManager.onServiceAvailable.then((vmService) {
      extensionEventSubscription = vmService.onExtensionEvent.listen((event) {
        if (isClosed) return;

        if (event.extensionKind == 'ext.gem_kit_integration_tests.image_compare_stream') {
          final value = event.extensionData!.data['value'];
          final newState = ImageComparisonData.fromMap(value);
          //addNewData(newState);
        } else if (event.extensionKind == 'ext.gem_kit_integration_tests.logs_stream') {
          final value = event.extensionData!.data['value'];
          final List<dynamic> logs = value as List<dynamic>;
          emit(ImageComparisonState(
            history: logs.map((e) => ImageComparisonData.fromMap(e)).toList(),
            current: null,
            xp: 0,
            yp: 0,
          ));
        }
      });
    });
  }

  addNewData(ImageComparisonData newData) {
    emit(state.copyWith(history: [...state.history, newData], current: newData, xp: 0, yp: 0));
  }

  presentCurrentData(int index) {
    emit(state.copyWith(current: state.history[index], xp: 0, yp: 0));
  }

  setCoordinates(double xp, double yp) {
    emit(state.copyWith(xp: xp, yp: yp));
  }

  @override
  Future<void> close() async {
    if (extensionEventSubscription != null) {
      await extensionEventSubscription!.cancel();
      extensionEventSubscription = null;
    }
    return super.close();
  }
}
