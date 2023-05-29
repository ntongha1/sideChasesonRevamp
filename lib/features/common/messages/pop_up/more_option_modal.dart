import "package:flutter/material.dart";
import "package:sonalysis/lang/strings.dart";
import "package:sonalysis/style/styles.dart";

class MoreChatOptionsModal extends StatelessWidget {
  const MoreChatOptionsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
          top: false,
          child: Container(
            color: sonaLightBlack,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: const Text('Mute', style: TextStyle(color: Colors.white, fontSize: 14)),
                  leading: Image.asset(
                    imagesDir + '/co_notifications_off.png',
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    width: 30,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Search', style: TextStyle(color: Colors.white, fontSize: 14)),
                  leading: Image.asset(
                    imagesDir + '/co_search.png',
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    width: 30,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
                ListTile(
                  title: const Text('Clear Chat', style: TextStyle(color: Colors.white, fontSize: 14)),
                  leading: Image.asset(
                    imagesDir + '/co_delete.png',
                    fit: BoxFit.cover,
                    repeat: ImageRepeat.noRepeat,
                    width: 30,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ));
  }
}