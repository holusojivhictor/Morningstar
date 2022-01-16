import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:morningstar/domain/extensions/string_extensions.dart';

part 'tier_list_form_bloc.freezed.dart';
part 'tier_list_form_event.dart';
part 'tier_list_form_state.dart';

const _initialState = TierListFormState.loaded(name: '', isNameDirty: false, isNameValid: false);

class TierListFormBloc extends Bloc<TierListFormEvent, TierListFormState> {
  TierListFormBloc() : super(_initialState);

  static int nameMaxLength = 25;

  @override
  Stream<TierListFormState> mapEventToState(TierListFormEvent event) async* {
    final s = event.map(
      nameChanged: (e) {
        final isValid = e.name.isNotNullEmptyOrWhitespace && e.name.length <= nameMaxLength;
        final isDirty = e.name != state.name;

        return state.copyWith.call(name: e.name, isNameDirty: isDirty, isNameValid: isValid);
      },
    );

    yield s;
  }
}