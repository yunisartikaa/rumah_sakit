import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/model_rs.dart';

class DetailRumahSakit extends StatefulWidget {
  final Datum rumahSakit;

  const DetailRumahSakit({Key? key, required this.rumahSakit}) : super(key: key);

  @override
  State<DetailRumahSakit> createState() => _DetailRumahSakitState();
}

class _DetailRumahSakitState extends State<DetailRumahSakit> {
  @override
  Widget build(BuildContext context) {
    final rumahSakit = widget.rumahSakit;

    // Mengonversi lat dan long dari String ke double
    double latitude = double.tryParse(rumahSakit.lang) ?? 0.0;
    double longitude = double.tryParse(rumahSakit.long) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(rumahSakit.namaRs),
        backgroundColor: Colors.cyan,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4, right: 4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'http://192.168.120.97/rumah_sakit/gambar_rs/${rumahSakit.gambar}', // Menggunakan URL dari database API
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rumahSakit.namaRs,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text('Alamat'),
                Text(
                  rumahSakit.alamat,
                  style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                ),
                SizedBox(height: 10),
                Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            trailing: const Icon(
              Icons.star,
              color: Colors.red,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16, bottom: 16, left: 16),
            child: Text(
              rumahSakit.deskripsi,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Lokasi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
          Container(
            height: 300, // Tentukan tinggi untuk GoogleMap
            child: GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 16,
              ),
              mapType: MapType.normal,
              markers: {
                Marker(
                  markerId: MarkerId(rumahSakit.namaRs),
                  position: LatLng(latitude, longitude),
                  infoWindow: InfoWindow(
                    title: rumahSakit.namaRs,
                    snippet: rumahSakit.alamat,
                  ),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}