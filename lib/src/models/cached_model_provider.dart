import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_cube/flutter_cube.dart';

import 'package:path/path.dart' as path;

class CachedAssetModelProvider extends ModelProvider {
  CachedAssetModelProvider(
    this.objectPath, {
    AssetBundle? assetBundle,
  }) : _assetBundle = assetBundle ?? rootBundle;

  final String objectPath;
  final AssetBundle _assetBundle;
  late String basePath = path.dirname(objectPath);

  // add some caching to the asset loading
  String? _cachedObject;
  final Map<String, String> _cachedMaterials = {};
  final Map<String, Uint8List> _cachedTextures = {};

  @override
  Future<Uint8List> loadAsset(String name) async {
    if (_cachedTextures.containsKey(name)) {
      return _cachedTextures[name]!;
    }
    unawaited(
      _assetBundle.load(path.join(basePath, name)).then((value) {
        _cachedTextures[name] = value.buffer.asUint8List();
      }),
    );
    var byteData = await _assetBundle.load(path.join(basePath, name));
    return byteData.buffer.asUint8List();
  }

  @override
  Future<String> loadMaterial(String mtl) {
    if (_cachedMaterials.containsKey(mtl)) {
      return Future.value(_cachedMaterials[mtl]);
    }
    unawaited(
      _assetBundle.loadString(path.join(basePath, mtl)).then((value) {
        _cachedMaterials[mtl] = value;
      }),
    );
    return _assetBundle.loadString(path.join(basePath, mtl));
  }

  @override
  Future<String> loadObject() {
    if (_cachedObject != null) {
      return Future.value(_cachedObject);
    }
    unawaited(
      _assetBundle.loadString(objectPath).then((value) {
        _cachedObject = value;
      }),
    );
    return _assetBundle.loadString(objectPath);
  }
}
