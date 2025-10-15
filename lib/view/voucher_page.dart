import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winkclone/model/voucher.dart';
import 'package:winkclone/view-model/voucher_page_view_model.dart';
import 'package:winkclone/view/voucher_detail_page.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<VoucherPageViewModel>(context, listen: false).fetchVouchers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<VoucherPageViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Vouchers")),
      body: vm.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: vm.vouchers.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final voucher = vm.vouchers[index];
                final double cost = (voucher.cost as num).toDouble();
                final String costStr = cost.toStringAsFixed(2);

                return VoucherListTile(voucher: voucher, vm: vm, costStr: costStr);
              },
            ),
    );
  }
}

class VoucherListTile extends StatelessWidget {
  const VoucherListTile({
    super.key,
    required this.voucher,
    required this.vm,
    required this.costStr,
  });

  final Voucher voucher;
  final VoucherPageViewModel vm;
  final String costStr;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        voucher.name ?? '',
        style: TextStyle(fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      subtitle: Text(
        voucher.description ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      trailing: ElevatedButton(
        onPressed: (voucher.isRedeemed == true)
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        VoucherDetailPage(id: voucher.id ?? 0),
                  ),
                );
              }
            :vm.isProcessing
            ? null
            : (){
                vm.grabVoucher(context, voucher);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: voucher.isRedeemed == true
              ? Colors.green
              : Colors.blue,
        ),
    
        child: Text(
          voucher.isRedeemed == true ? 'VIEW' : '\$$costStr',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
