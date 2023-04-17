import 'dart:convert';

import 'package:airad/widgets/song_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lastfm/lastfm.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'search_results_screen.dart';
import '../utils/api_auth.dart';
import 'package:xml2json/xml2json.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController;
  bool _isLoading = false;
  Xml2Json xml2json = Xml2Json();
  LastFM lastfm = LastFMUnauthorized(ApiAuth.apiKey, ApiAuth.sharedSecret);
  List data = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<List?> findTrackByTrackName(String trackName) async {
    var result = await lastfm.read('track.search', {"track": trackName});
    var xmlString = result.toXmlString();
    xml2json.parse(xmlString);
    String jsonString = xml2json.toGData();
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    // debugPrint(jsonMap.toString());
    return jsonMap['lfm']['results']['trackmatches']['track'];
  }

  Future<List<String>> getArtistsFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot =
        await firestore.collection(_auth.currentUser!.uid).get();
    final keywords = querySnapshot.docs
        .map((doc) => doc.data()['artist'] as String)
        .toList();
    return keywords;
  }

// Function to make API calls using keywords
  Future<void> fetchDataUsingKeywords() async {
    final keywords = await getArtistsFromFirestore();
    for (final keyword in keywords) {
      var result = await lastfm
          .read('artist.getTopTracks', {"artist": keyword, "limit": "4"});
      var xmlString = result.toXmlString();
      xml2json.parse(xmlString);
      String jsonString = xml2json.toGData();
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      debugPrint(jsonMap['lfm']['results']['trackmatches']['track']);
      data.addAll(jsonMap['lfm']['results']['trackmatches']['track']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      // opacity: 0.3,
      color: Colors.transparent,
      inAsyncCall: _isLoading,
      blur: 2.0,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode _focusNode = FocusScope.of(context);
          if (!_focusNode.hasPrimaryFocus) {
            _focusNode.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Search'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.teal,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search_rounded),
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            List? trackResultsList = await findTrackByTrackName(
                                searchController.text);
                            setState(() {
                              _isLoading = false;
                            });
                            if (context.mounted) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchResultsScreen(
                                        m: trackResultsList),
                                  ));
                            }
                          },
                        )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text('Suggestions based on recent searches'),
                  FutureBuilder(
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: SongCard(
                                  songName: data[index]['name']['\$t'],
                                  songArtist: data[index]['artist']['\$t']),
                            );
                          },
                        ),
                      );
                    },
                    future: fetchDataUsingKeywords(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
