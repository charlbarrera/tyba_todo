//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audio_session
import cloud_firestore
import firebase_core
import firebase_crashlytics
import firebase_storage
import path_provider_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioSessionPlugin.register(with: registry.registrar(forPlugin: "AudioSessionPlugin"))
  FLTFirebaseFirestorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseFirestorePlugin"))
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
  FLTFirebaseCrashlyticsPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCrashlyticsPlugin"))
  FLTFirebaseStoragePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseStoragePlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
}
