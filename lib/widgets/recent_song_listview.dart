import 'package:airad/model/recent_song_mode.dart';
import 'package:airad/widgets/song_card.dart';
import 'package:flutter/material.dart';

class RecentSongListView extends StatelessWidget {
  final List<RecentSong> x;
  const RecentSongListView({
    super.key,
    required this.x,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return SongCard(
            songName: x[index].songName,
            songArtist: x[index].artist,
          );
        },
        itemCount: x.length,
      ),
    );
  }
}
