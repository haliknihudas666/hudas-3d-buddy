import '../../domain/entities/general_settings_entity.dart';
import '../../domain/entities/pre_processing_entity.dart';
import '../../domain/entities/post_processing_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

/// Implementation of SettingsRepository using local data source
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._localDataSource);

  @override
  Future<GeneralSettingsEntity> getGeneralSettings() {
    return _localDataSource.getGeneralSettings();
  }

  @override
  Future<void> saveGeneralSettings(GeneralSettingsEntity settings) {
    return _localDataSource.saveGeneralSettings(settings);
  }

  @override
  Future<PreProcessingEntity> getPreProcessingSettings() {
    return _localDataSource.getPreProcessingSettings();
  }

  @override
  Future<void> savePreProcessingSettings(PreProcessingEntity settings) {
    return _localDataSource.savePreProcessingSettings(settings);
  }

  @override
  Future<PostProcessingEntity> getPostProcessingSettings() {
    return _localDataSource.getPostProcessingSettings();
  }

  @override
  Future<void> savePostProcessingSettings(PostProcessingEntity settings) {
    return _localDataSource.savePostProcessingSettings(settings);
  }

  @override
  Future<void> resetAllSettings() {
    return _localDataSource.resetAllSettings();
  }
}
