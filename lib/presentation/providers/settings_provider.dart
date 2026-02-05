import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/general_settings_entity.dart';
import '../../domain/entities/pre_processing_entity.dart';
import '../../domain/entities/post_processing_entity.dart';
import 'di_providers.dart';

// ==================== General Settings ====================

/// State notifier for managing general settings
class GeneralSettingsNotifier extends AsyncNotifier<GeneralSettingsEntity> {
  @override
  Future<GeneralSettingsEntity> build() async {
    return _loadSettings();
  }

  Future<GeneralSettingsEntity> _loadSettings() async {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.getGeneralSettings();
  }

  /// Update general settings
  Future<void> updateSettings(GeneralSettingsEntity settings) async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.saveGeneralSettings(settings);
    ref.invalidateSelf();
  }

  /// Update a single field
  Future<void> updateField({
    String? currency,
    double? electricityRatePerKwh,
    double? laborRatePerHour,
    double? failureRatePercent,
    double? markupPercent,
    double? packagingCostPerItem,
    double? shippingBasePrice,
    bool? includeTax,
    double? taxPercent,
  }) async {
    final current = await future;
    final updated = current.copyWith(
      currency: currency ?? current.currency,
      electricityRatePerKwh: electricityRatePerKwh ?? current.electricityRatePerKwh,
      laborRatePerHour: laborRatePerHour ?? current.laborRatePerHour,
      failureRatePercent: failureRatePercent ?? current.failureRatePercent,
      markupPercent: markupPercent ?? current.markupPercent,
      packagingCostPerItem: packagingCostPerItem ?? current.packagingCostPerItem,
      shippingBasePrice: shippingBasePrice ?? current.shippingBasePrice,
      includeTax: includeTax ?? current.includeTax,
      taxPercent: taxPercent ?? current.taxPercent,
    );
    await updateSettings(updated);
  }
}

/// Provider for general settings
final generalSettingsProvider =
    AsyncNotifierProvider<GeneralSettingsNotifier, GeneralSettingsEntity>(
  GeneralSettingsNotifier.new,
);

// ==================== Pre-Processing Settings ====================

/// State notifier for managing pre-processing settings
class PreProcessingSettingsNotifier extends AsyncNotifier<PreProcessingEntity> {
  @override
  Future<PreProcessingEntity> build() async {
    return _loadSettings();
  }

  Future<PreProcessingEntity> _loadSettings() async {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.getPreProcessingSettings();
  }

  /// Update pre-processing settings
  Future<void> updateSettings(PreProcessingEntity settings) async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.savePreProcessingSettings(settings);
    ref.invalidateSelf();
  }
}

/// Provider for pre-processing settings
final preProcessingSettingsProvider =
    AsyncNotifierProvider<PreProcessingSettingsNotifier, PreProcessingEntity>(
  PreProcessingSettingsNotifier.new,
);

// ==================== Post-Processing Settings ====================

/// State notifier for managing post-processing settings
class PostProcessingSettingsNotifier extends AsyncNotifier<PostProcessingEntity> {
  @override
  Future<PostProcessingEntity> build() async {
    return _loadSettings();
  }

  Future<PostProcessingEntity> _loadSettings() async {
    final repository = ref.read(settingsRepositoryProvider);
    return repository.getPostProcessingSettings();
  }

  /// Update post-processing settings
  Future<void> updateSettings(PostProcessingEntity settings) async {
    final repository = ref.read(settingsRepositoryProvider);
    await repository.savePostProcessingSettings(settings);
    ref.invalidateSelf();
  }
}

/// Provider for post-processing settings
final postProcessingSettingsProvider =
    AsyncNotifierProvider<PostProcessingSettingsNotifier, PostProcessingEntity>(
  PostProcessingSettingsNotifier.new,
);

// ==================== Theme Settings ====================

/// Provider for theme mode (dark/light)
final isDarkModeProvider = StateProvider<bool>((ref) => false);
