import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    super.key,
    required this.songName,
    required this.songArtist,
  });

  final String songName;
  final String songArtist;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          songName,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
        subtitle: Text(
          songArtist,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
