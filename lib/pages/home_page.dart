import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_pbm7/models/database.dart';
import 'package:tugas_pbm7/models/transaction_with_category.dart';
import 'package:tugas_pbm7/pages/transaction_page.dart';
import 'package:flutter/src/foundation/key.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;

  const HomePage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MyDatabase database = MyDatabase();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Dashoboard Total Pemasukan dan Pengeluaran
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              child: Row(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Icon(Icons.download, color: Colors.teal),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pemasukan",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Rp 3.800.000",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // Row Kedua
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Icon(Icons.upload, color: Colors.red),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pengeluaran",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Rp 3.800.000",
                            style: GoogleFonts.roboto(
                                color: Colors.white, fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(16)),
            ),
          ),

          //Text Transaksi
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Transaksi",
              style:
                  GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          StreamBuilder<List<TransactionWithCategory>>(
              stream: database.getTransactionByDateRepo(widget.selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasData) {
                    if (snapshot.data!.length > 0) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Card(
                              elevation: 10,
                              child: ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          await database.deleteTransactionRepo(
                                              snapshot
                                                  .data![index].transaction.id);
                                          setState(() {});
                                        }),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => TransactionPage(
                                            transactionWithCategory:
                                                snapshot.data![index],
                                          ),
                                        ));
                                      },
                                    )
                                  ],
                                ),
                                title: Text("Rp " +
                                    snapshot.data![index].transaction.amount
                                        .toString()),
                                subtitle: Text(
                                    snapshot.data![index].category.name +
                                        " (" +
                                        snapshot.data![index].transaction.name +
                                        ")"),
                                leading: Container(
                                  child: (snapshot.data![index].category.type ==
                                          2)
                                      ? Icon(Icons.upload, color: Colors.red)
                                      : Icon(Icons.download,
                                          color: Colors.teal),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text("Data Transaksi Masih Kosong!"),
                      );
                    }
                  } else {
                    return Center(
                      child: Text("Tidak Ada Data!"),
                    );
                  }
                }
              }),
        ],
      )),
    );
  }
}
