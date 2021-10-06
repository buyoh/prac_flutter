import 'package:redux/redux.dart';

class DisplayedPageState {
  final String? mindTreeKey;

  DisplayedPageState({this.mindTreeKey});

  DisplayedPageState.initialState():this.mindTreeKey = null;
}

class DisplayedPageActionChangeMindTreeKey {
  String mindTreeKey;

  DisplayedPageActionChangeMindTreeKey({required this.mindTreeKey});
}

DisplayedPageState displayedPageActionReducer(
    DisplayedPageState state, dynamic action) {
  if (action is DisplayedPageActionChangeMindTreeKey) {
    return DisplayedPageState(mindTreeKey: action.mindTreeKey);
  }
  return state;
}

Store<DisplayedPageState> createDisplayedPageStore() {
  return Store<DisplayedPageState>(
    displayedPageActionReducer,
    initialState: DisplayedPageState.initialState(),
    middleware: [],
  );
}
