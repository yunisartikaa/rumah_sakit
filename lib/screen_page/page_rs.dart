
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rumah_sakit/screen_page/page_detail_rs.dart';
import '../model/model_rs.dart';

class PageRumahSakit extends StatefulWidget {
  final String idKabupaten;

  const PageRumahSakit({Key? key, required this.idKabupaten}) : super(key: key);

  @override
  State<PageRumahSakit> createState() => _PageRumahSakitState();
}

class _PageRumahSakitState extends State<PageRumahSakit> {
  ModelRs? modelRs;
  List<Datum>? rumahSakitList;

  @override
  void initState() {
    super.initState();
    fetchRumahSakit();
  }

  Future<void> fetchRumahSakit() async {
    final response = await http.get(Uri.parse('http://192.168.120.97/rumah_sakit/getRs.php?id_kabupaten=${widget.idKabupaten}'));
    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = json.decode(response.body);
        modelRs = ModelRs.fromJson(jsonResponse);
        rumahSakitList = modelRs?.data?.where((rs) => rs.kabupatenId == widget.idKabupaten).toList() ?? [];
      });
    } else {
      throw Exception('Gagal memuat data rumah sakit');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Rumah Sakit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: rumahSakitList != null
            ? ListView.builder(
          itemCount: rumahSakitList!.length,
          itemBuilder: (context, index) {
            final rumahSakit = rumahSakitList![index];
            return Card(
              child: ListTile(
                leading: Image.network(
                  'http://192.168.120.97/rumah_sakit/gambar_rs/${rumahSakit.gambar}', // Menggunakan URL dari database API
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(rumahSakit.namaRs),
                subtitle: Text(rumahSakit.alamat),
                trailing: Icon(Icons.arrow_forward), // Tambahkan ikon panah di sini
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailRumahSakit(rumahSakit: rumahSakit),
                    ),
                  );
                },
              ),
            );
          },
        )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
