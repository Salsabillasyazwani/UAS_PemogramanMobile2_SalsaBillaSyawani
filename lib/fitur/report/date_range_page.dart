import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'report_controller.dart';

class DateRangePage extends StatefulWidget {
  const DateRangePage({super.key});

  @override
  State<DateRangePage> createState() => _DateRangePageState();
}

class _DateRangePageState extends State<DateRangePage> {
  final ctrl = Get.find<ReportController>();
  String tempSelected = "Hari ini";
  DateTime tempStart = DateTime.now();
  DateTime tempEnd = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rentang Waktu",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildOption("Hari ini"),
                  _buildOption("7 Hari Terakhir"),
                  _buildOption("Pilih Bulan"),
                  if (tempSelected == "Pilih Bulan") _monthPickerTile(),
                  _buildOption("Pilih Tanggal"),
                  if (tempSelected == "Pilih Tanggal") _buildDatePickers(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    String label = tempSelected;
                    if (tempSelected == "Pilih Tanggal") {
                      label =
                          "${DateFormat('dd MMM').format(tempStart)} - ${DateFormat('dd MMM').format(tempEnd)}";
                    } else if (tempSelected == "Pilih Bulan") {
                      label = DateFormat('MMMM yyyy').format(tempStart);
                    }
                    ctrl.updateRange(tempStart, tempEnd, label);
                    Get.back();
                  },
                  child: const Text(
                    "Terapkan",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String label) {
    return ListTile(
      title: Text(label),
      trailing: Radio<String>(
        value: label,
        groupValue: tempSelected,
        onChanged: (val) {
          setState(() {
            tempSelected = val!;
            if (val == "Hari ini") {
              tempStart = DateTime.now();
              tempEnd = DateTime.now();
            } else if (val == "7 Hari Terakhir") {
              tempStart = DateTime.now().subtract(const Duration(days: 7));
              tempEnd = DateTime.now();
            }
          });
        },
      ),
    );
  }

  Widget _monthPickerTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () => _showMonthYearPicker(context),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat('MMMM yyyy').format(tempStart)),
              const Icon(Icons.calendar_month, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tempStart,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: "PILIH BULAN (Klik Tahun/Bulan)",
    );
    if (picked != null) {
      setState(() {
        tempStart = DateTime(picked.year, picked.month, 1);
        tempEnd = DateTime(picked.year, picked.month + 1, 0);
      });
    }
  }

  Widget _buildDatePickers() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _dateTile(
              "Mulai",
              tempStart,
              (d) => setState(() => tempStart = d),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _dateTile(
              "Akhir",
              tempEnd,
              (d) => setState(() => tempEnd = d),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTile(String label, DateTime date, Function(DateTime) onPick) {
    return InkWell(
      onTap: () async {
        DateTime? p = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (p != null) onPick(p);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              DateFormat('dd MMM yyyy').format(date),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
