import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:ts_academy/constants/color_constants.dart';
import '../constants/constants.dart';
import '../controller/settings_cubit/settings_cubit.dart';

class PDFScreen extends StatefulWidget {
  const PDFScreen({Key? key, required this.link}) : super(key: key);
  final String link;

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    // document = await PDFDocument.fromURL(widget.link);
    /* cacheManager: CacheManager(
          Config(
            "customCacheKey",
            stalePeriod: const Duration(days: 2),
            maxNrOfCacheObjects: 10,
          ),
        ), */
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                if (_isLoading) Center(child: CircularProgressIndicator()),
                if (!_isLoading)
                  SfPdfViewer.network(
                    widget.link,
                    scrollDirection: PdfScrollDirection.vertical,
                    canShowPaginationDialog: true,
                    canShowPageLoadingIndicator: false,
                    enableDoubleTapZooming: true,
                  ),
                // PDFViewer(
                //
                //   document: document,
                //   lazyLoad: false,
                //   zoomSteps: 1,
                //   pickerButtonColor: ColorConstants.lightBlue,
                //   minScale: 1,
                //   maxScale: 50,
                //   showPicker: true,
                //   showNavigation: false,
                //   scrollDirection: Axis.vertical,
                //   numberPickerConfirmWidget: Text(
                //     local == "ar" ? "تأكيد" : "Confirm",
                //   ),
                //   tooltip: PDFViewerTooltip(pick: local == "ar" ?"اختر صفحة" : " Pick Page",),
                // ),
                // Positioned(
                //   top: 60,
                //   left: 20,
                //   child: Transform.rotate(
                //     angle: 75,
                //     child: Text(
                //       "$stuId",
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 30,
                //         color: Colors.black.withOpacity(double.parse(
                //             BlocProvider.of<SettingsCubit>(context)
                //                 .settingsModel!
                //                 .watermark_opacity
                //                 .toString())),
                //         fontFamily: 'Poppins',
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   top: 60,
                //   right: 20,
                //   child: Transform.rotate(
                //     angle: 75,
                //     child: Text(
                //       "$stuId",
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 30,
                //         color: Colors.black.withOpacity(double.parse(
                //             BlocProvider.of<SettingsCubit>(context)
                //                 .settingsModel!
                //                 .watermark_opacity
                //                 .toString())),
                //         fontFamily: 'Poppins',
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom: 60,
                //   left: 20,
                //   child: Transform.rotate(
                //     angle: 75,
                //     child: Text(
                //       "$stuId",
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 30,
                //         color: Colors.black.withOpacity(double.parse(
                //             BlocProvider.of<SettingsCubit>(context)
                //                 .settingsModel!
                //                 .watermark_opacity
                //                 .toString())),
                //         fontFamily: 'Poppins',
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom: 60,
                //   right: 20,
                //   child: Transform.rotate(
                //     angle: 75,
                //     child: Text(
                //       "$stuId",
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 30,
                //         color: Colors.black.withOpacity(double.parse(
                //             BlocProvider.of<SettingsCubit>(context)
                //                 .settingsModel!
                //                 .watermark_opacity
                //                 .toString())),
                //         fontFamily: 'Poppins',
                //       ),
                //     ),
                //   ),
                // ),
                Center(child: randomTextWidget()),
              ],
            )
          // Positioned(
          //   left: _xPosition,
          //   top: _yPosition,
          //   child: AnimatedContainer(
          //     duration: const Duration(seconds: 1),
          //     curve: Curves.easeInOut,
          //     child: Transform.rotate(
          //       angle: 75,
          //       child: Text(
          //         '$myName-$stuId',
          //         style: const TextStyle(
          //             fontSize: 24, color: Colors.blueAccent),
          //       ),
          //     ),
          //   ),
          // )
        ),
      ),
    );
  }

  Widget randomTextWidget() {
    return Opacity(
      opacity: .3,
      child: Transform.rotate(
        angle: 50,
        child: Stack(
          children: [
            Text(
              '$stuId',
              style: TextStyle(
                fontSize: 100,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 4
                  ..color = Colors.grey.withOpacity(0.8),
              ),
            ),
            Text(
              '$stuId',
              style: TextStyle(
                fontSize: 100,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

}