/// Public SDK surface for `rxdart_devtools`.
///
/// Import this library from your app code to call [RxDartDevtools.init] and
/// to access the `.track()` and `.enableInjection()` chain on Subjects and
/// Streams.
library;

export 'src/sdk/init.dart' show RxDartDevtools;
export 'src/sdk/track.dart' show StreamTrackingExtension, SubjectTrackingExtension;
export 'src/sdk/types.dart' show TrackedStream, TrackedSubject;
