import 'dart:io';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pim/constants.dart';
import 'package:pim/screens/forum/controllers/FBStorage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'commons/const.dart';
import 'commons/utils.dart';
import 'controllers/FBCloudStore.dart';
import 'controllers/FBStorage.dart';

class WritePost extends StatefulWidget {
  final MyProfileData myData;
  WritePost({this.myData});
  @override
  State<StatefulWidget> createState() => _WritePost();
}

class _WritePost extends State<WritePost> {
  TextEditingController writingTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  bool _isLoading = false;
  File _postImageFile;

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: _nodeText1,
        ),
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: writingTextFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  print('Select Image');
                  _getImageAndCrop();
                },
                child: Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_photo_alternate, size: 28),
                      Text(
                        tr("Add Image"),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ],
        ),
      ],
    );
  }

  void _postToFB() async {
    setState(() {
      _isLoading = true;
    });
    String postID = Utils.getRandomString(8) + Random().nextInt(500).toString();
    String postImageURL;
    if (_postImageFile != null) {
      postImageURL = await FBStorage.uploadPostImages(
          postID: postID, postImageFile: _postImageFile);
    }
    FBCloudStore.sendPostInFirebase(postID, writingTextController.text,
        widget.myData, postImageURL ?? 'NONE');

    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Writing Post')),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
              onPressed: () => _postToFB(),
              child: Text(
                tr('Post'),
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
      body: Stack(
        children: <Widget>[
          KeyboardActions(
            config: _buildConfig(context),
            child: Column(
              children: <Widget>[
                Container(
                    width: size.width,
                    height: size.height -
                        MediaQuery.of(context).viewInsets.bottom -
                        80,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14.0, left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: Container(
                                      width: 40,
                                      height: 40,
                                      child: widget.myData.myThumbnail == null
                                          ? Image.asset(
                                              "assets/images/avatar1.png")
                                          : Image.network(link +
                                              '/file/' +
                                              widget.myData.myThumbnail)),
                                ),
                              ),
                              Text(
                                widget.myData.myName,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            color: Colors.black,
                          ),
                          TextFormField(
                            autofocus: true,
                            focusNode: writingTextFocus,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: tr('Writing anything.'),
                              hintMaxLines: 4,
                            ),
                            controller: writingTextController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                          ),
                          _postImageFile != null
                              ? Image.file(
                                  _postImageFile,
                                  fit: BoxFit.fill,
                                )
                              : Container(),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Utils.loadingCircle(_isLoading),
        ],
      ),
    );
  }

  Future<void> _getImageAndCrop() async {
    File imageFileFromGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFileFromGallery != null) {
      File cropImageFile = await Utils.cropImageFile(
          imageFileFromGallery); //await cropImageFile(imageFileFromGallery);
      if (cropImageFile != null) {
        setState(() {
          _postImageFile = cropImageFile;
        });
      }
    }
  }
}
