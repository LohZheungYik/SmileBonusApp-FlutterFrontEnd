import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/theme/winktheme.dart';
import 'package:winkclone/view-model/voucher_detail_page_view_model.dart';

class VoucherDetailPage extends StatefulWidget {
  final int id;
  const VoucherDetailPage({super.key, required this.id});

  @override
  State<VoucherDetailPage> createState() => _VoucherDetailPageState();
}

class _VoucherDetailPageState extends State<VoucherDetailPage> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask((){
      Provider.of<VoucherDetailPageViewModel>(context, listen: false).fetchVoucherDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<VoucherDetailPageViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Voucher Details")),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.voucher == null
              ? const Center(child: Text("Failed to load voucher"))
              : VoucherPreview(vm: vm),
    );
  }
}

class VoucherPreview extends StatelessWidget {
  const VoucherPreview({
    super.key,
    required this.vm,
  });

  final VoucherDetailPageViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              vm.voucher?['name'] ?? '',
              style: WinkTheme.blackHeaderText,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: BarcodeWidget(
                barcode: Barcode.code128(),
                data: vm.voucher?['code'] ?? '', // barcode string
                width: 200,
                height: 80,
                drawText: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(vm.voucher?['description'] ?? ''),
          ),
        ],
      );
  }
}