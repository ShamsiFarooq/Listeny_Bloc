// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listeny/Controller/playlist/playlist_bloc.dart';
import 'package:listeny/Model/playlist_model/playlist_model.dart';
import 'package:listeny/View/widgets/screen_title.dart';
import 'package:listeny/View/widgets/snacbar.dart';
import 'package:listeny/constants/constants.dart';

class AddToPlaylist extends StatelessWidget {
  final int id;
  const AddToPlaylist({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PlaylistBloc>(context).add(GetAllPlaylist());
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            screenTitle('Playlists'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: playlists(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: addButton(context),
    );
  }

  FloatingActionButton addButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: themeColor,
      onPressed: () {
        addPlaylistPopUP(context);
      },
      child: const Icon(Icons.add),
    );
  }

  playlists() {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state.playlists.isEmpty) {
          return noPlaylistMessge();
        }
        return GridView.builder(
          itemCount: state.playlists.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 149,
              mainAxisSpacing: 50,
              crossAxisSpacing: 20),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                final playlist = state.playlists[index];
                if (playlist.songIds.contains(id)) {
                  warningSncakbar(context, 'Song Already in playlist');
                } else {
                  BlocProvider.of<PlaylistBloc>(context)
                      .add(AddSongToPlaylist(id: id, playlistId: index));
                  snacbarWidget(context, 'Song Added to playlist');
                }
                Navigator.of(context).pop();
              },
              child: Column(
                children: [
                  Stack(children: [
                    playlistImage(),
                    playlistDelete(index, context),
                  ]),
                  playlistName(state.playlists[index].name)
                ],
              ),
            );
          },
        );
      },
    );
  }

  Center noPlaylistMessge() {
    return const Center(
      child: Text(
        "No Playlist Created yet",
        style: TextStyle(
          color: textColor,
          fontSize: 20,
        ),
      ),
    );
  }

  Text playlistName(String name) {
    return Text(
      name,
      style: const TextStyle(color: textColor, fontSize: 20),
    );
  }

  Positioned playlistDelete(int index, BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      child: IconButton(
        onPressed: () {
          BlocProvider.of<PlaylistBloc>(context)
              .add(DeletePlaylist(index: index));
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }

  Container playlistImage() {
    return Container(
      height: 125,
      width: 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage(
            'lib/assets/Listeny.png',
          ),
        ),
      ),
    );
  }

  deletePlaylistDialog(playlist, index, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: bgPrimary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Are You Sure!!!',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            'Do you want to delete the playlist $playlist',
            style: const TextStyle(color: textColor),
          ),
          actions: [
            SizedBox(
              width: 140,
              child: ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(
              width: 140,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
                onPressed: () {
                  BlocProvider.of<PlaylistBloc>(context)
                      .add(DeletePlaylist(index: index));
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  addPlaylistPopUP(ctx) {
    TextEditingController controller = TextEditingController();
    return showDialog(
        context: ctx,
        builder: ((context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: bgPrimary,
            title: const Center(
              child: Text(
                "Create New Playlist",
                style: TextStyle(color: textColor),
              ),
            ),
            content: SizedBox(
              height: 90,
              child: Column(
                children: [
                  kHeight10,
                  TextField(
                    controller: controller,
                    style: const TextStyle(color: textColor),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: themeColor)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: themeColor)),
                      label: Text(
                        "Playlist Name",
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              kWidth10,
              playListAddButtons(
                  context: context, color: Colors.red, data: "Cancel", func: 0),
              kWidth10,
              playListAddButtons(
                  context: context,
                  color: Colors.green,
                  data: "Add",
                  func: 1,
                  controller: controller),
              kWidth10,
            ],
          );
        }));
  }

  SizedBox playListAddButtons({
    required BuildContext context,
    required Color color,
    required String data,
    required func,
    controller,
  }) {
    return SizedBox(
      width: 115,
      child: ElevatedButton(
        onPressed: () {
          if (func == 0) {
            Navigator.of(context).pop();
          } else {
            if (controller.text.isEmpty || controller.text == null) {
              Navigator.of(context).pop();
              warningSncakbar(context, 'Playlist name cannot be empty');
            } else {
              final value = PlaylistModel(name: controller.text, songIds: []);
              BlocProvider.of<PlaylistBloc>(context)
                  .add(AddPlaylist(playlist: value));
              Navigator.of(context).pop();
            }
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: Text(
          data,
          style: const TextStyle(color: textColor),
        ),
      ),
    );
  }
}
