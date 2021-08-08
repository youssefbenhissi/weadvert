import 'package:flutter/material.dart';
import 'styles.dart';
import 'package:imageview360/imageview360.dart';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';

/// {@template add_todo_button}
/// Button to add a new [Todo].
///
/// Opens a [HeroDialogRoute] of [_AddTodoPopupCard].
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
///
class AddTodoButton extends StatelessWidget {
  /// {@macro add_todo_button}
  const AddTodoButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return AddTodoPopupCardMoyenne();
          }));
        },
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: AppColors.accentColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              Icons.add_rounded,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tag-value used for the add todo popup button.
const String _heroAddTodo = 'add-todo-hero';

/// {@template add_todo_popup_card}
/// Popup card to add a new [Todo]. Should be used in conjuction with
/// [HeroDialogRoute] to achieve the popup effect.
///
/// Uses a [Hero] with tag [_heroAddTodo].
/// {@endtemplate}
class AddTodoPopupCardMoyenne extends StatefulWidget {
  List<AssetImage> imageList;

  /// {@macro add_todo_popup_card}
  AddTodoPopupCardMoyenne({this.imageList});

  @override
  _AddTodoPopupCardState createState() =>
      _AddTodoPopupCardState(imageList: this.imageList);
}

class _AddTodoPopupCardState extends State<AddTodoPopupCardMoyenne> {
  _AddTodoPopupCardState({this.imageList});
  List<AssetImage> imageList = List<AssetImage>();
  List<AssetImage> imageListMoyenne = List<AssetImage>();
  List<AssetImage> imageListGrande = List<AssetImage>();
  bool autoRotate = true;
  int rotationCount = 2;
  int swipeSensitivity = 2;
  bool allowSwipeToRotate = true;
  RotationDirection rotationDirection = RotationDirection.anticlockwise;
  Duration frameChangeDuration = Duration(milliseconds: 50);
  bool imagePrecached = false;
  bool imagePrecachedPetit = false;
  bool imagePrecachedGrand = false;
  void updateImageList(BuildContext context) async {
    for (int i = 1; i <= 36; i++) {
      imageList.add(AssetImage('assets/images/$i moyenne.jpg'));
      //* To precache images so that when required they are loaded faster.
      await precacheImage(AssetImage('assets/images/$i moyenne.jpg'), context);
    }
    setState(() {
      imagePrecached = true;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => updateImageList(context));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: AppColors.accentColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 400,
                      child: (imagePrecached == true)
                          ? ImageView360(
                              key: UniqueKey(),
                              imageList: imageList,
                              autoRotate: false,
                              rotationCount: 2,
                              rotationDirection:
                                  RotationDirection.anticlockwise,
                              frameChangeDuration: Duration(milliseconds: 170),
                              swipeSensitivity: swipeSensitivity,
                              allowSwipeToRotate: allowSwipeToRotate,
                            )
                          : Text("Pre-Caching images..."),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
