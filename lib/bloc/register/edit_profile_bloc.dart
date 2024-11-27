import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import '../../constants/string_constants.dart';

class EditProfileBloc extends FormBloc<Map<String, dynamic>, String> {
  EditProfileBloc(this.preFilledUserData) : super(isLoading: true) {
    addFieldBlocs(fieldBlocs: [
      firstName,
      lastName,
      registrationNumber,
      department,
      semester,
      areasOfInterests,
      addOtherAreas,
      description,
      contactNumber,
      linkedInUrl,
      githubUrl,
      discordUserName,
    ]);

    department.onValueChanges(
      onData: (previous, current) async* {
        if (current.value == 'Other') {
          addFieldBloc(fieldBloc: otherDepartment);
        } else {
          removeFieldBloc(fieldBloc: otherDepartment);
        }
      },
    );

    addOtherAreas.onValueChanges(
      onData: (previous, current) async* {
        if (current.value) {
          addFieldBloc(fieldBloc: otherAreaOfInterest);
        } else {
          removeFieldBloc(fieldBloc: otherAreaOfInterest);
        }
      },
    );
  }

  final Map<String, dynamic> preFilledUserData;

  final firstName = TextFieldBloc(
    validators: [
          (value) {
        if (value.isEmpty) {
          return 'First name should not be empty!';
        }
        if (value.contains(' ')) {
          return 'First name should not have spaces!';
        }
        return null;
      }
    ],
  );
  final lastName = TextFieldBloc(
    validators: [
          (value) {
        if (value.isEmpty) {
          return 'Last name should not be empty!';
        }
        if (value.contains(' ')) {
          return 'Last name should not have spaces!';
        }
        return null;
      }
    ],
  );
  final registrationNumber = TextFieldBloc(
    validators: [
          (value) {
        final RegExp numberRegex = RegExp(r'^[0-9]+$');

        if (value.isNotEmpty && !numberRegex.hasMatch(value)) {
          return 'Registration number should only contain numbers';
        }
        return null;
      }
    ],
  );
  final department = SelectFieldBloc(
    items: UserDataConstants.departments,
    validators: [
          (value) {
        if (value == null) {
          return 'Select department';
        }
        return null;
      }
    ],
  );

  final otherDepartment = TextFieldBloc(
    validators: [
          (value) {
        final departmentRegex = RegExp(r'^[A-Za-z0-9\s-.]+$');
        if (value.isNotEmpty && !departmentRegex.hasMatch(value)) {
          return "Shouldn't contain special characters except '-' and '.'";
        }
        return null;
      }
    ],
  );

  final semester = SelectFieldBloc(
    items: [for (int i = 1; i <= 8; i++) i.toString()],
    validators: [
          (value) {
        if (value == null) {
          return 'Select semester';
        }
        return null;
      }
    ],
  );
  final areasOfInterests = MultiSelectFieldBloc(
    items: UserDataConstants.areasOfInterests,
    initialValue: ['AI / ML', 'Flutter'],
    validators: [
          (value) {
        if ((value as List<String>).length < 2) {
          return 'Select at least two areas of interests!';
        }
        return null;
      }
    ],
  );

  final addOtherAreas = BooleanFieldBloc();
  final otherAreaOfInterest = TextFieldBloc();

  final description = TextFieldBloc();
  final contactNumber = TextFieldBloc(
    validators: [
          (value) {
        if (value.length < 10 || value.length > 10) {
          return 'Contact number must be exactly 10 digits long!';
        }
        return null;
      }
    ],
  );

  final linkedInUrl = TextFieldBloc(
    validators: [
          (value) {
        final RegExp linkedInRegex =
        RegExp(r'^https://www\.linkedin\.com/in/[A-Za-z0-9_-]+.*$');

        if (value.isNotEmpty && !linkedInRegex.hasMatch(value)) {
          return 'Please enter a valid LinkedIn profile URL!';
        }
        return null;
      }
    ],
  );
  final githubUrl = TextFieldBloc(
    validators: [
          (value) {
        final RegExp gitHubRegex =
        RegExp(r'^https://github\.com/[A-Za-z0-9_-]+.*$');

        if (value.isNotEmpty && !gitHubRegex.hasMatch(value)) {
          return 'Please enter a valid GitHub profile URL!';
        }
        return null;
      }
    ],
  );
  final discordUserName = TextFieldBloc(
    validators: [
          (value) {
        final RegExp discordUsernameRegex = RegExp(r'^[A-Za-z0-9_]+#[0-9]{4}$');

        if (value.isNotEmpty && !discordUsernameRegex.hasMatch(value)) {
          return 'Please enter a valid Discord username!';
        }
        return null;
      }
    ],
  );

  @override
  FutureOr<void> onLoading() {
    try {
      final names = (preFilledUserData['name'] as String).split(' ');
      firstName.updateInitialValue(names[0].trim());
      lastName.updateInitialValue(names[1].trim());

      registrationNumber.updateInitialValue(preFilledUserData['registrationNumber'].toString());

      final userDepartment = preFilledUserData['department'] as String;
      if (!UserDataConstants.departments.contains(userDepartment)) {
        department.updateInitialValue('Other');
        otherDepartment.updateInitialValue(userDepartment);
      }else {
        department.updateInitialValue(userDepartment);
      }

      semester.updateInitialValue(preFilledUserData['semester'] as String);
      description.updateInitialValue(preFilledUserData['description'] as String);

      final userAreasOfInterests = preFilledUserData['areasOfInterest'] as List<String>;
      final primaryAreas = userAreasOfInterests.where((element) => UserDataConstants.areasOfInterests.contains(element)).toList();
      final otherAreas = userAreasOfInterests.where((element) => !UserDataConstants.areasOfInterests.contains(element)).toList();
      areasOfInterests.updateInitialValue(primaryAreas);
      if (otherAreas.isNotEmpty) {
        addOtherAreas.updateInitialValue(true);
        otherAreaOfInterest.updateInitialValue(otherAreas.join(', '));
      }

      contactNumber.updateInitialValue(preFilledUserData['contactNumber'].toString());
      linkedInUrl.updateInitialValue((preFilledUserData['linkedInUrl'] ?? '') as String);
      githubUrl.updateInitialValue((preFilledUserData['githubUrl'] ?? '') as String);
      discordUserName.updateInitialValue((preFilledUserData['discordUserName'] ?? '') as String);

      emitLoaded();
    } catch(e) {
      dev.log('Got error: $e');
      emitLoadFailed();
    }
  }

  @override
  FutureOr<void> onSubmitting() {
    try {
      List<String> areasOfInterestList = areasOfInterests.value.toList();

      if (otherAreaOfInterest.value != '') {
        for (String area in otherAreaOfInterest.value.split(',')) {
          if (area.isNotEmpty && area != '') {
            areasOfInterestList.add(area.trim());
          }
        }
      }

      final userData = {
        'name': '${firstName.value.trim()} ${lastName.value.trim()}',
        'registrationNumber': registrationNumber.value,
        'department': (department.value == 'Other')
            ? otherDepartment.value
            : department.value!,
        'semester': semester.value!,
        'areasOfInterest': areasOfInterestList,
        'contactNumber': contactNumber.value,
        'description': description.value,
        'linkedInUrl': linkedInUrl.value.trim(),
        'githubUrl': githubUrl.value.trim(),
        'discordUserName': discordUserName.value.trim(),
      };

      dev.log('Updating user: $userData', name: 'Update');

      Future.delayed(const Duration(seconds: 0), () {
        emitSuccess(successResponse: userData);
      });
    } catch (e) {
      dev.log('Got error: $e', name: 'Register');
      emitFailure(failureResponse: e.toString());
    }
  }

  @override
  void onChange(Change<FormBlocState<Map<String, dynamic>, String>> change) {
    dev.log(change.nextState.toString(), name: 'Update');
    super.onChange(change);
  }
}
