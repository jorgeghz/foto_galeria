import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(PhotoGalleryApp());

class PhotoGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text('Gallery')),
      body: Gallery(),
    ));
  }
}

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool loading=true;
  List<String> ids;
  final String _gallery_url = 'https://picsum.photos/';

  @override
  void initState() {
    loading = true;
    ids = [];
    _loadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ImagePage(ids[index]),
                ),
            );
          },
          child: Image.network(_gallery_url+'id/'+ids[index]+'/300/300')
        );
      },
      itemCount: ids.length,
    );
  }

  void _loadImages() async {
    final response = await http.get('https://picsum.photos/v2/list');
    final json = jsonDecode(response.body);
    List<String> _ids = [];
    for (var image in json) {
      _ids.add(image['id']);
    }

    setState(() {
      loading = false;
      ids = _ids;
    });
  }
}

class ImagePage extends StatelessWidget {
  final String id;
  final String _gallery_url = 'https://picsum.photos/';
  ImagePage(this.id);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
      body: Center(
        child: Image.network(_gallery_url+'id/'+id+'/600/600'),
      )
      );
  }
}
