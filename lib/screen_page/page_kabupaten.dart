import 'dart:convert'; // Tambahkan ini untuk menguraikan JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rumah_sakit/screen_page/page_rs.dart';

import '../model/model_kabupaten.dart';


class PageKabupaten extends StatefulWidget {
  final String idProvinsi; // Tambahkan ini

  const PageKabupaten({Key? key, required this.idProvinsi}) : super(key: key); // Tambahkan ini

  @override
  State<PageKabupaten> createState() => _PageKabupatenState();
}

class _PageKabupatenState extends State<PageKabupaten> {
  ModelKabupaten? modelKabupaten;
  TextEditingController searchController = TextEditingController();
  List<DatumKabupaten>? kampusList;
  List<DatumKabupaten>? filteredKampusList;

  @override
  void initState() {
    super.initState();
    fetchModelKampus();
  }

  Future<void> fetchModelKampus() async {
    final response = await http.get(Uri.parse('http://192.168.120.97/rumah_sakit/getKabupaten.php?id_provinsi=${widget.idProvinsi}'));
    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = json.decode(response.body);
        modelKabupaten = ModelKabupaten.fromJson(jsonResponse);
        kampusList = modelKabupaten?.data ?? [];
        filteredKampusList = kampusList;
      });
    } else {
      throw Exception('Gagal memuat model Kabupaten');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('List Kabupaten'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            filteredKampusList = kampusList
                                ?.where((element) =>
                            element.namaKabupaten.toLowerCase().contains(value.toLowerCase()) ||
                                element.id.toLowerCase().contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueGrey,
                          labelText: "Search",
                          hintText: "Search",
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(color: Colors.blueGrey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            borderSide: BorderSide(color: Colors.blueGrey),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (filteredKampusList != null)
                for (DatumKabupaten datum in filteredKampusList!)
                // Tambahkan kondisi untuk memeriksa idProvinsi
                  if (datum.provinsiId == widget.idProvinsi) // <-- Tambahkan ini
                    Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageRumahSakit(idKabupaten: datum.id),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 75, // Ubah tinggi sesuai kebutuhan Anda
                          child: Center(
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                              title: Text(
                                datum.namaKabupaten,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}