import '../../parser/wind_style.dart';

/// Default animation class map
const Map<String, WindAnimationType> animations = {
  'animate-spin': WindAnimationType.spin,
  'animate-ping': WindAnimationType.ping,
  'animate-pulse': WindAnimationType.pulse,
  'animate-bounce': WindAnimationType.bounce,
  'animate-none': WindAnimationType.none,
};
