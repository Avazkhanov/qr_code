import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code/bloc/scanner_bloc.dart';
import 'package:qr_code/bloc/scanner_event.dart';
import 'package:qr_code/bloc/scanner_state.dart';
import 'package:qr_code/data/models/form_status.dart';
import 'package:qr_code/data/models/scaner_model.dart';
import 'package:qr_code/utils/app_colors/app_colors.dart';
import 'package:qr_code/utils/extension/size_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../show/show_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.c_333333,
        title: Text(
          "History",
          style: TextStyle(
            color: AppColors.c_D9D9D9,
            fontSize: 27.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              backgroundColor: AppColors.c_333333.withOpacity(.84),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
            onPressed: () {},
            child: Icon(
              Icons.menu,
              size: 30.sp,
              color: AppColors.c_FDB623,
            ),
          ),

        ],
      ),
      backgroundColor: AppColors.c_333333.withOpacity(.84),
      body: BlocBuilder<ScannerBloc, ScannerState>(
        builder: (context, state) {
          if (state.status == FormStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.status == FormStatus.error) {
            return Center(
              child: Text(state.statusText),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return RepaintBoundary(
                      key: Key(state.products[index].qrCode),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: AppColors.c_333333.withOpacity(.84),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: 46.w, vertical: 10.h),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoScreen(
                                  scannerModel: ScannerModel(
                                    name: state.products[index].name,
                                    qrCode: state.products[index].qrCode,
                                  ),
                                ),
                              ),
                            );
                          },
                          leading: SizedBox(
                            width: 70.w,
                            height: 70.h,
                            child: QrImageView(
                              data: state.products[index].qrCode,
                              version: QrVersions.auto,
                              size: 100,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              context.read<ScannerBloc>().add(
                                  RemoveScannerEvent(
                                      scannerId: state.products[index].id!));
                            },
                            icon: Icon(
                              Icons.delete_forever,
                              size: 30.sp,
                              color: AppColors.c_FDB623,
                            ),
                          ),
                          title: Text(
                            state.products[index].qrCode,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            state.products[index].name,
                            style: TextStyle(
                              color: AppColors.c_A4A4A4,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
