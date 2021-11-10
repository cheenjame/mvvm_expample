import 'dart:async';

Stream<T> periodicStream<T>(Duration period, Future<T> Function() computation) {
  final controller = StreamController<T>();
  final watch = Stopwatch();
  controller.onListen = () {
    Future sendEvent(_) async {
      watch.reset();
      if (computation != null) {
        T event;
        try {
          event = await computation();
        } catch (e, s) {
          controller.addError(e, s);
          return;
        }
        controller.add(event);
      } else {
        controller.add(null as T);
      }
    }

    Timer timer = Timer.periodic(period, sendEvent);
    controller
      ..onCancel = () {
        timer.cancel();
        return Future.value(null);
      }
      ..onPause = () {
        watch.stop();
        timer.cancel();
      }
      ..onResume = () {
        final elapsed = watch.elapsed;
        watch.start();
        timer = Timer(period - elapsed, () {
          timer = Timer.periodic(period, sendEvent);
          sendEvent(null);
        });
      };
  };

  return controller.stream;
}
