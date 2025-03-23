import 'dart:convert';
import 'dart:typed_data';
import 'dart:io'; 
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:top_sale/core/preferences/preferences.dart';
import 'package:top_sale/core/utils/circle_progress.dart';
import 'package:top_sale/core/utils/app_strings.dart';
import 'package:share_plus/share_plus.dart'; 
import 'package:path_provider/path_provider.dart'; 

class PdfViewerPage extends StatefulWidget {
  const PdfViewerPage({super.key, required this.baseUrl});
  final String baseUrl;

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late Uint8List pdfBytes;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPdfWithSession();
  }

  Future<void> fetchPdfWithSession() async {
    String? sessionId = await Preferences.instance.getSessionId();
   bool isVisitor = await Preferences.instance.getIsVisitor();
      String odooUrl =  isVisitor ? AppStrings.demoBaseUrl :
          await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
    String cookie = 'frontend_lang=en_US;session_id=$sessionId';
    try {
      final dio = Dio();
      final response = await dio.get(
        odooUrl + widget.baseUrl,
        options: Options(
          headers: {
            'Cookie': cookie, // Pass the session cookie
            // 'Content-Type': 'application/pdf',
            // 'Accept': '*/*',
            // 'Accept-Encoding': 'gzip, deflate, br',
            // 'Connection': 'keep-alive',
          },
          receiveTimeout: const Duration(seconds: 60),
          responseType:
              ResponseType.bytes, // Ensure response is in bytes for PDF
        ),
      );
      print(odooUrl + widget.baseUrl);
      print(sessionId);
      if (response.statusCode == 200) {
        // Encode PDF bytes to Base64
        String base64Pdf = base64Encode(response.data);
        print("Base64 PDF: $base64Pdf"); // Use this for debugging/logging

        setState(() {
          pdfBytes = response.data;
          isLoading = false;
        });

        // Additional: Write Base64 to a temporary file (optional)
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/base64pdf.txt');
        await file.writeAsString(base64Pdf);
      } else {
        print('Failed to load PDF');
      }
    } catch (e) {
      print('Error fetching PDF: $e');
    }
  }
  // Future<void> fetchPdfWithSession() async {
  //   String? sessionId = "49f72366ca27868282a587d439e63da44d9771a3";
  //   // String? sessionId = "49f72366ca27868282a587d439e63da44d9771a3";
  //   // String? sessionId = await Preferences.instance.getSessionId();
  //   String odooUrl =
  //       await Preferences.instance.getOdooUrl() ?? AppStrings.demoBaseUrl;
  //   String cookie = 'frontend_lang=en_US;session_id=$sessionId';

  //   try {
  //     final dio = Dio();
  //     final response = await dio.get(
  //       "https://nada.codaxhub.com//report/pdf/sale.report_saleorder/837",
  //       // "https://novapolaris-stage-branche-17590763.dev.odoo.com/report/pdf/sale.report_saleorder/613"
  //       // odooUrl + widget.baseUrl,
  //       options: Options(
  //         headers: {
  //           'Cookie': cookie, // Pass the session cookie
  //           'Content-Type': 'application/pdf',
  //           'Accept': '*/*',
  //           'Accept-Encoding': 'gzip, deflate, br',
  //           'Connection': 'keep-alive',

  //         },
  //         receiveTimeout: const Duration(seconds: 60),
  //         responseType:
  //             ResponseType.bytes, // Ensure response is in bytes for PDF
  //       ),
  //     );
  //     print(
  //       odooUrl + widget.baseUrl,
  //     );
  //     print(
  //       sessionId,
  //     );
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         pdfBytes = response.data;
  //         isLoading = false;
  //       });
  //     } else {
  //       print('Failed to load PDF');
  //     }
  //   } catch (e) {
  //     print('Error fetching PDF: $e');
  //   }
  // }

  //  share
  void sharePdf() async {
    final tempDir = await getTemporaryDirectory(); 
    final file = File('${tempDir.path}/document.pdf');
    await file.writeAsBytes(pdfBytes);

  
    final xFile = XFile(file.path);

    await Share.shareXFiles([xFile], text: 'Check out this PDF document!');
  }

  void printPdf() async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: isLoading ? null : printPdf, 
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: isLoading ? null : sharePdf,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CustomLoadingIndicator())
          : SfPdfViewer.memory(pdfBytes),
    );
  }
}
