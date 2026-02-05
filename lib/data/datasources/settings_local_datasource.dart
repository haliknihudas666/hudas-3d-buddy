import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/general_settings_entity.dart';
import '../../domain/entities/pre_processing_entity.dart';
import '../../domain/entities/post_processing_entity.dart';

/// Local data source for settings data using SharedPreferences
class SettingsLocalDataSource {
  final SharedPreferences _prefs;

  SettingsLocalDataSource(this._prefs);

  // ==================== General Settings ====================

  /// Get general settings from local storage
  Future<GeneralSettingsEntity> getGeneralSettings() async {
    final data = _prefs.getString(AppConstants.generalSettingsKey);
    if (data == null) {
      return const GeneralSettingsEntity();
    }
    return GeneralSettingsEntity.fromJson(jsonDecode(data));
  }

  /// Save general settings
  Future<void> saveGeneralSettings(GeneralSettingsEntity settings) async {
    await _prefs.setString(
      AppConstants.generalSettingsKey,
      jsonEncode(settings.toJson()),
    );
  }

  // ==================== Pre-Processing Settings ====================

  /// Get pre-processing settings from local storage
  Future<PreProcessingEntity> getPreProcessingSettings() async {
    final data = _prefs.getString(AppConstants.preProcessingKey);
    if (data == null) {
      return const PreProcessingEntity();
    }
    return PreProcessingEntity.fromJson(jsonDecode(data));
  }

  /// Save pre-processing settings
  Future<void> savePreProcessingSettings(PreProcessingEntity settings) async {
    await _prefs.setString(
      AppConstants.preProcessingKey,
      jsonEncode(settings.toJson()),
    );
  }

  // ==================== Post-Processing Settings ====================

  /// Get post-processing settings from local storage
  Future<PostProcessingEntity> getPostProcessingSettings() async {
    final data = _prefs.getString(AppConstants.postProcessingKey);
    if (data == null) {
      return const PostProcessingEntity();
    }
    return PostProcessingEntity.fromJson(jsonDecode(data));
  }

  /// Save post-processing settings
  Future<void> savePostProcessingSettings(PostProcessingEntity settings) async {
    await _prefs.setString(
      AppConstants.postProcessingKey,
      jsonEncode(settings.toJson()),
    );
  }

  // ==================== Reset ====================

  /// Reset all settings to defaults
  Future<void> resetAllSettings() async {
    await _prefs.remove(AppConstants.generalSettingsKey);
    await _prefs.remove(AppConstants.preProcessingKey);
    await _prefs.remove(AppConstants.postProcessingKey);
  }
}
