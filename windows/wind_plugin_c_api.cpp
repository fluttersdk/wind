#include "include/wind/wind_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "wind_plugin.h"

void WindPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  wind::WindPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
