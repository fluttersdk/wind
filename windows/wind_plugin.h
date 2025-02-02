#ifndef FLUTTER_PLUGIN_WIND_PLUGIN_H_
#define FLUTTER_PLUGIN_WIND_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace wind {

class WindPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WindPlugin();

  virtual ~WindPlugin();

  // Disallow copy and assign.
  WindPlugin(const WindPlugin&) = delete;
  WindPlugin& operator=(const WindPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace wind

#endif  // FLUTTER_PLUGIN_WIND_PLUGIN_H_
