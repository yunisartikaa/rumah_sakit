import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/model_provinsi.dart';
import 'page_kabupaten.dart'; // Import halaman kabupaten

class PageProvinsi extends StatefulWidget {
  const PageProvinsi({Key? key}) : super(key: key);

  @override
  State<PageProvinsi> createState() => _PageProvinsiState();
}

class _PageProvinsiState extends State<PageProvinsi> {
  ModelProvinsi? modelProvinsi;
  TextEditingController searchController = TextEditingController();
  List<DatumProvinsi>? kampusList;
  List<DatumProvinsi>? filteredKampusList;

  @override
  void initState() {
    super.initState();
    fetchModelKampus();
  }

  Future<void> fetchModelKampus() async {
    final response = await http.get(Uri.parse('http://192.168.120.97/rumah_sakit/getProvinsi.php'));
    if (response.statusCode == 200) {
      setState(() {
        var jsonResponse = json.decode(response.body);
        modelProvinsi = ModelProvinsi.fromJson(jsonResponse);
        kampusList = modelProvinsi?.data ?? [];
        filteredKampusList = kampusList;
      });
    } else {
      throw Exception('Gagal memuat model kampus');
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
        title: Text('List Provinsi'),
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
                            element.namaProvinsi.toLowerCase().contains(value.toLowerCase()) ||
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
                for (DatumProvinsi datum in filteredKampusList!)
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PageKabupaten(idProvinsi: datum.id),
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
                              datum.namaProvinsi,
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