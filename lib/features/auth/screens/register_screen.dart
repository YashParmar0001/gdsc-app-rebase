import 'dart:io';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_atmiya/bloc/register/register_bloc.dart';
import 'package:gdsc_atmiya/constants/assets_constants.dart';
import 'package:gdsc_atmiya/model/user_model.dart';
import 'package:gdsc_atmiya/utils/ui_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/user/user_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserRegistered) {
            context.go('/home');
          } else if (state is UserRegistering) {
            showDialog(
              context: context,
              builder: (context) {
                return const SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            );
          } else if (state is RegisterError) {
            Navigator.of(context).pop();
            dev.log('Got register error: ${state.message}', name: 'Register');
          } else if (state is UserError) {
            // context.go('/login');
            showSnackBar(
              context,
              message: 'Error: ${state.message}',
              icon: Icons.error,
            );
          }
        },
        child: BlocProvider(
          create: (context) => RegisterBloc(),
          child: Builder(
            builder: (context) {
              final registerBloc = context.read<RegisterBloc>();

              return FormBlocListener<RegisterBloc, Map<String, dynamic>,
                  String>(
                onSubmitting: (context, state) {},
                onSuccess: (context, state) {
                  var userData = state.successResponse!;
                  var user = UserModel(
                    email: (BlocProvider.of<AuthBloc>(context).state
                            as Authenticated)
                        .email,
                    name: userData['name'] as String,
                    userType: 'club-member',
                    photoUrl: '',
                    registrationNumber:
                        userData['registrationNumber'] as String,
                    department: userData['department'] as String,
                    semester: userData['semester'] as int,
                    areasOfInterest:
                        userData['areasOfInterest'] as List<String>,
                    description: userData['description'] as String,
                    contactNumber: userData['contactNumber'] as String,
                    linkedInUrl: (userData['linkedInUrl'] as String) != ''
                        ? (userData['linkedInUrl'] as String)
                        : null,
                    githubUrl: (userData['githubUrl'] as String) != ''
                        ? (userData['githubUrl'] as String)
                        : null,
                    discordUserName:
                        (userData['discordUsername'] as String) != ''
                            ? (userData['discordUsername'] as String)
                            : null,
                  );

                  BlocProvider.of<UserBloc>(context)
                      .add(RegisterUser(user: user, profilePhoto: imageFile));

                  // dev.log(
                  //   'Successfully registered: ${state.successResponse}',
                  //   name: 'Register',
                  // );
                },
                onSubmissionFailed: (context, state) {},
                onFailure: (context, state) {},
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Column(
                      children: [
                        _buildTextFieldBloc(
                          label: 'First Name',
                          bloc: registerBloc.firstName,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTextFieldBloc(
                          label: 'Last Name',
                          bloc: registerBloc.lastName,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTextFieldBloc(
                          label: 'Registration Number',
                          bloc: registerBloc.registrationNumber,
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildDropdownField(
                          label: 'Department',
                          bloc: registerBloc.department,
                        ),
                        _buildTextFieldBloc(
                          label: 'Department',
                          bloc: registerBloc.otherDepartment,
                          hintText: 'Ex. B.Sc. -- Microbiology',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildDropdownField(
                          label: 'Semester',
                          bloc: registerBloc.semester,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildMultipleChoiceChips(
                          label: 'Areas of Interest',
                          bloc: registerBloc.areasOfInterests,
                        ),
                        CheckboxFieldBlocBuilder(
                          booleanFieldBloc: registerBloc.addOtherAreas,
                          body: const Text('Add other areas'),
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                        TextFieldBlocBuilder(
                          textFieldBloc: registerBloc.otherAreaOfInterest,
                          textStyle: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Video editing, Business',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTextFieldBloc(
                          label: 'Description',
                          bloc: registerBloc.description,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTextFieldBloc(
                          label: 'Contact Number',
                          bloc: registerBloc.contactNumber,
                          inputType: TextInputType.number,
                          prefixText: '+91 ',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Social Media profiles (Optional)',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            _buildSocialMediaSection(
                              logoAsset: AssetsConstants.linkedInLogo,
                              label: 'LinkedIn Profile Url',
                              bloc: registerBloc.linkedInUrl,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildSocialMediaSection(
                              logoAsset: AssetsConstants.githubLogo,
                              label: 'GitHub Profile Url',
                              bloc: registerBloc.githubUrl,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            _buildSocialMediaSection(
                              logoAsset: AssetsConstants.discordLogo,
                              label: 'Discord Username',
                              bloc: registerBloc.discordUserName,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        _buildUploadImageSection(),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: registerBloc.submit,
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaSection({
    required String logoAsset,
    required String label,
    required TextFieldBloc bloc,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          logoAsset,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: _buildTextFieldBloc(
            label: label,
            bloc: bloc,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadImageSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upload Profile Pic',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              onPressed: removeImage,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 100,
          child: AspectRatio(
            aspectRatio: 213 / 304,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey,
                image: (imageFile != null)
                    ? DecorationImage(
                        image: FileImage(
                          imageFile!,
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: IconButton(
                onPressed: () {
                  getImage();
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ],
    );
  }

  FilterChipFieldBlocBuilder _buildMultipleChoiceChips({
    required String label,
    required MultiSelectFieldBloc bloc,
  }) {
    return FilterChipFieldBlocBuilder(
      multiSelectFieldBloc: bloc,
      chipPadding: const EdgeInsets.all(0),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentPadding: const EdgeInsets.all(0),
        border: InputBorder.none,
      ),
      itemBuilder: (context, value) {
        return ChipFieldItem(label: Text(value));
      },
    );
  }

  TextFieldBlocBuilder _buildTextFieldBloc({
    required String label,
    required TextFieldBloc bloc,
    TextInputType? inputType,
    String? prefixText,
    String? hintText,
    int? minLines,
    int? maxLines,
  }) {
    return TextFieldBlocBuilder(
      textFieldBloc: bloc,
      keyboardType: inputType,
      textCapitalization: TextCapitalization.sentences,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        prefixText: prefixText,
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        hintText: hintText,
      ),
      textStyle: const TextStyle(fontSize: 14),
    );
  }

  DropdownFieldBlocBuilder _buildDropdownField({
    required String label,
    required SelectFieldBloc bloc,
  }) {
    return DropdownFieldBlocBuilder(
      selectFieldBloc: bloc,
      textOverflow: TextOverflow.ellipsis,
      textStyle: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
      ),
      itemBuilder: (context, value) {
        return FieldItem(child: Text(value.toString()));
      },
    );
  }

  void removeImage() {
    if (imageFile != null) {
      setState(() {
        imageFile = null;
      });
    }
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    XFile? xFilePick = pickedFile;
    setState(
      () {
        if (xFilePick != null) {
          imageFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
