import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/print_job_entity.dart';
import '../../domain/entities/printer_entity.dart';
import '../../domain/entities/filament_entity.dart';
import '../constants/app_constants.dart';

class PdfGenerator {
  static Future<Uint8List> generatePrintJobPdf({
    required PrintJobEntity job,
    required PrinterEntity? printer,
    required FilamentEntity? filament,
  }) async {
    final pdf = pw.Document();

    // Load font if needed, otherwise use standard
    final theme = pw.ThemeData.withFont(
      base: await PdfGoogleFonts.openSansRegular(),
      bold: await PdfGoogleFonts.openSansBold(),
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              pw.SizedBox(height: 20),
              _buildJobDetails(job),
              pw.SizedBox(height: 20),
              _buildMaterials(printer, filament),
              pw.SizedBox(height: 20),
              _buildCostBreakdown(job),
              pw.Spacer(),
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          AppConstants.appName,
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.Text(
          'Version ${AppConstants.appVersion}',
          style: const pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey700,
          ),
        ),
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Print Job Quotation',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now()),
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildJobDetails(PrintJobEntity job) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Job Details',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Job Name:'),
              pw.Text(job.name ?? 'Untitled Job',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ],
          ),
          if (job.description != null && job.description!.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 5),
              child: pw.Text('Description: ${job.description}'),
            ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              _buildDetailItem('Print Time', '${job.printTimeHours} hrs'),
              pw.SizedBox(width: 20),
              _buildDetailItem('Weight', '${job.filamentWeightGrams} g'),
              pw.SizedBox(width: 20),
              _buildDetailItem('Quantity', '${job.quantity}'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMaterials(
      PrinterEntity? printer, FilamentEntity? filament) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Printer',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(printer?.name ?? 'Unknown Printer'),
              pw.Text(printer?.model ?? '',
                  style: const pw.TextStyle(
                      fontSize: 10, color: PdfColors.grey600)),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Filament',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(filament?.name ?? 'Unknown Filament'),
              pw.Text('${filament?.material} - ${filament?.brand}',
                  style: const pw.TextStyle(
                      fontSize: 10, color: PdfColors.grey600)),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildCostBreakdown(PrintJobEntity job) {
    final currency = NumberFormat.currency(symbol: '₱');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Cost Breakdown',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14)),
        pw.Divider(),
        _buildCostRow('Filament Cost', job.filamentCost, currency),
        _buildCostRow('Electricity', job.electricityCost, currency),
        _buildCostRow('Machine Depreciation', job.printerCost, currency),
        _buildCostRow('Labor', job.laborCost, currency),
        if (job.preProcessingCost > 0)
          _buildCostRow('Pre-Processing', job.preProcessingCost, currency),
        if (job.postProcessingCost > 0)
          _buildCostRow('Post-Processing', job.postProcessingCost, currency),
        pw.Divider(),
        _buildCostRow('Subtotal', job.subtotal, currency, isBold: true),
        if (job.failureBuffer > 0)
          _buildCostRow('Failure Buffer', job.failureBuffer, currency),
        if (job.markup > 0) _buildCostRow('Markup', job.markup, currency),
        if (job.packagingCost > 0)
          _buildCostRow('Packaging', job.packagingCost, currency),
        if (job.shippingCost > 0)
          _buildCostRow('Shipping', job.shippingCost, currency),
        if (job.tax > 0) _buildCostRow('Tax', job.tax, currency),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          color: PdfColors.blue50,
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Price',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 16)),
              pw.Text(currency.format(job.totalCost),
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                      color: PdfColors.blue900)),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Center(
      child: pw.Text(
        'Generated by Hudas 3D Buddy',
        style: const pw.TextStyle(color: PdfColors.grey500, fontSize: 10),
      ),
    );
  }

  static pw.Widget _buildDetailItem(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.Text(value, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  static pw.Widget _buildCostRow(
      String label, double amount, NumberFormat formatter,
      {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style:
                  isBold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null),
          pw.Text(formatter.format(amount),
              style:
                  isBold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null),
        ],
      ),
    );
  }
}
