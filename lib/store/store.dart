// import 'package:flutter_flux/flutter_flux.dart';
import 'package:redux/redux.dart';

class DisplayedPageState {
  DisplayedPageState({required this.title});
  final String title;
}

enum DisplayedPageActionType {
  updateTitle,
}

class DisplayedPageAction {
  DisplayedPageActionType type;
  String newTitle;

  DisplayedPageAction({required this.type, required this.newTitle});

  static DisplayedPageAction updateTitle(String title) => DisplayedPageAction(
      type: DisplayedPageActionType.updateTitle, newTitle: title);
}

DisplayedPageState displayedPageActionReducer(
    DisplayedPageState state, dynamic action) {
  if (!(action is DisplayedPageAction)) return state;
  if (action.type == DisplayedPageActionType.updateTitle) {
    return DisplayedPageState(title: action.newTitle);
  }
  return state;
}

Store<DisplayedPageState> createDisplayedPageStore() {
  return Store<DisplayedPageState>(
    displayedPageActionReducer,
    initialState: DisplayedPageState(title: 'undefined'),
    middleware: [],
  );
}
