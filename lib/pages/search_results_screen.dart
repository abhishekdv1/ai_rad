import 'package:airad/widgets/song_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchResultsScreen extends StatefulWidget {
  final List? m;

  SearchResultsScreen({super.key, required this.m});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final _fireStore = FirebaseFirestore.instance;

  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fireStore.collection(_firebaseAuth.currentUser!.uid).add({
      'songName': widget.m?[0]['name']['\$t'],
      'artist': widget.m?[0]['artist']['\$t']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Vx.black,
      ),
      body: widget.m == null
          ? const Text('No result')
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: ListView.builder(
                itemCount: widget.m?.length,
                itemBuilder: (context, index) {
                  return SongCard(
                      songName: widget.m?[index]['name']['\$t'],
                      songArtist: widget.m?[index]['artist']['\$t']);
                },
              ),
            ),
    );
  }
}
