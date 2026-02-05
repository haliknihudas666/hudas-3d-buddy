import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/print_job_entity.dart';

/// Local data source for print job data using SharedPreferences
class PrintJobLocalDataSource {
  final SharedPreferences _prefs;

  PrintJobLocalDataSource(this._prefs);

  /// Get all print jobs from local storage
  Future<List<PrintJobEntity>> getPrintJobs() async {
    final data = _prefs.getString(AppConstants.printJobsKey);
    if (data == null) return [];

    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((json) => PrintJobEntity.fromJson(json)).toList();
  }

  /// Get a single print job by ID
  Future<PrintJobEntity?> getPrintJobById(String id) async {
    final jobs = await getPrintJobs();
    try {
      return jobs.firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Save a new print job
  Future<void> savePrintJob(PrintJobEntity job) async {
    final jobs = await getPrintJobs();
    final newJob = job.copyWith(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    jobs.add(newJob);
    await _savePrintJobs(jobs);
  }

  /// Update an existing print job
  Future<void> updatePrintJob(PrintJobEntity job) async {
    final jobs = await getPrintJobs();
    final index = jobs.indexWhere((j) => j.id == job.id);
    if (index != -1) {
      jobs[index] = job.copyWith(updatedAt: DateTime.now());
      await _savePrintJobs(jobs);
    }
  }

  /// Delete a print job by ID
  Future<void> deletePrintJob(String id) async {
    final jobs = await getPrintJobs();
    jobs.removeWhere((j) => j.id == id);
    await _savePrintJobs(jobs);
  }

  /// Delete all print jobs
  Future<void> deleteAllPrintJobs() async {
    await _prefs.remove(AppConstants.printJobsKey);
  }

  /// Get print jobs within a date range
  Future<List<PrintJobEntity>> getPrintJobsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final jobs = await getPrintJobs();
    return jobs.where((job) {
      final createdAt = job.createdAt;
      if (createdAt == null) return false;
      return createdAt.isAfter(start) && createdAt.isBefore(end);
    }).toList();
  }

  /// Save print jobs list to storage
  Future<void> _savePrintJobs(List<PrintJobEntity> jobs) async {
    final jsonList = jobs.map((j) => j.toJson()).toList();
    await _prefs.setString(AppConstants.printJobsKey, jsonEncode(jsonList));
  }
}
