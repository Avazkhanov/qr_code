import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code/bloc/scanner_bloc.dart';
import 'package:qr_code/bloc/scanner_event.dart';
import 'package:qr_code/data/models/scaner_model.dart';
import 'package:qr_code/screens/generate/generate_screen.dart';
import 'package:qr_code/screens/history/history_screen.dart';
import 'package:qr_code/screens/qr_scaner/qr_scaner_screen.dart';
import 'package:qr_code/utils/app_colors/app_colors.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  List<Widget> _screens = [];
  int _activeIndex = 1;

  @override
  void initState() {
    _screens = [
      const GenerateScreen(),
      const HistoryScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_activeIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newActiveIndex) {
          _activeIndex = newActiveIndex;
          setState(() {});
        },
        currentIndex: _activeIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 16,
        unselectedFontSize: 14,
        backgroundColor: AppColors.c_333333,
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.qr_code_scanner,
              color: AppColors.c_FDB623,
              size: 40,
            ),
            icon: Icon(
              Icons.qr_code_scanner,
              color: AppColors.white,
              size: 40,
            ),
            label: "Generate",
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(
              Icons.history,
              color: AppColors.c_FDB623,
              size: 40,
            ),
            icon: Icon(
              Icons.history,
              color: AppColors.white,
              size: 40,
            ),
            label: "History",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 70.w,
        height: 70.h,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.c_FDB623,
              blurRadius: 30,
              spreadRadius: 0,
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          backgroundColor: AppColors.c_FDB623,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return QrScannerScreen(
                    barcode: (barcode) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(barcode.code.toString()),
                        ),
                      );
                      context.read<ScannerBloc>().add(
                            AddScannerEvent(
                              scannerModel: ScannerModel(
                                name: "Data",
                                qrCode: barcode.code.toString(),
                              ),
                            ),
                          );
                    },
                  );
                },
              ),
            );
          },
          child: Icon(
            Icons.document_scanner_outlined,
            size: 30.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
