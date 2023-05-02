import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

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
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        tileColor: Vx.green200,
        title: Text(
          songName,
          style:
              const TextStyle(overflow: TextOverflow.ellipsis, color: Vx.black),
        ),
        subtitle: Text(
          songArtist,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
