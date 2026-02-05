import '../entities/general_settings_entity.dart';
import '../entities/pre_processing_entity.dart';
import '../entities/post_processing_entity.dart';

/// Repository interface for settings data operations
abstract class SettingsRepository {
  /// Get general settings
  Future<GeneralSettingsEntity> getGeneralSettings();

  /// Save general settings
  Future<void> saveGeneralSettings(GeneralSettingsEntity settings);

  /// Get pre-processing settings
  Future<PreProcessingEntity> getPreProcessingSettings();

  /// Save pre-processing settings
  Future<void> savePreProcessingSettings(PreProcessingEntity settings);

  /// Get post-processing settings
  Future<PostProcessingEntity> getPostProcessingSettings();

  /// Save post-processing settings
  Future<void> savePostProcessingSettings(PostProcessingEntity settings);

  /// Reset all settings to defaults
  Future<void> resetAllSettings();
}
