import 'dart:io';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdsc_atmiya/bloc/register/edit_profile_bloc.dart';
import 'package:gdsc_atmiya/constants/assets_constants.dart';
import 'package:gdsc_atmiya/model/user_model.dart';
import 'package:gdsc_atmiya/utils/ui_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/user/user_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? imageFile;
  final picker = ImagePicker();
  bool removeProfilePhoto = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserRegistered) {
            dev.log('Going to HomeScreen from EditProfileScreen');
            context.go('/my_profile');
          } else if (state is UserRegistering) {
            // showDialog(
            //   context: context,
            //   builder: (context) {
            //     return const SizedBox(
            //       width: 50,
            //       height: 50,
            //       child: Center(child: CircularProgressIndicator()),
            //     );
            //   },
            // );
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
          create: (context) {
            final user =
                (context.read<UserBloc>().state as UserRegistered).user;
            return EditProfileBloc(user.toMap());
          },
          child: Builder(
            builder: (context) {
              final editProfileBloc = context.read<EditProfileBloc>();

              return FormBlocListener<EditProfileBloc, Map<String, dynamic>,
                  String>(
                onSubmitting: (context, state) {},
                onSuccess: (context, state) {
                  var userData = state.successResponse!;
                  final user =
                      (context.read<UserBloc>().state as UserRegistered).user;

                  BlocProvider.of<UserBloc>(context).add(UpdateUserProfile(
                    user: user,
                    userData: userData,
                    profilePhoto: imageFile,
                    removeProfilePhoto: removeProfilePhoto,
                  ));
                },
                onSubmissionFailed: (context, state) {},
                onFailure: (context, state) {},
                child: BlocBuilder<EditProfileBloc, FormBlocState>(
                  builder: (context, state) {
                    if (state is FormBlocLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is FormBlocLoadFailed) {
                      return Center(
                        child: ElevatedButton(
                          onPressed: context.read<EditProfileBloc>().reload,
                          child: const Text('Reload'),
                        ),
                      );
                    } else if (state is FormBlocSubmitting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            Text('Updating user profile'),
                          ],
                        ),
                      );
                    }

                    return (context.read<UserBloc>().state is UserRegistered)
                        ? SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: Column(
                                children: [
                                  _buildTextFieldBloc(
                                    label: 'First Name',
                                    bloc: editProfileBloc.firstName,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildTextFieldBloc(
                                    label: 'Last Name',
                                    bloc: editProfileBloc.lastName,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildTextFieldBloc(
                                    label: 'Registration Number',
                                    bloc: editProfileBloc.registrationNumber,
                                    inputType: TextInputType.number,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildDropdownField(
                                    label: 'Department',
                                    bloc: editProfileBloc.department,
                                  ),
                                  _buildTextFieldBloc(
                                    label: 'Department',
                                    bloc: editProfileBloc.otherDepartment,
                                    hintText: 'Ex. B.Sc. -- Microbiology',
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildDropdownField(
                                    label: 'Semester',
                                    bloc: editProfileBloc.semester,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildMultipleChoiceChips(
                                    label: 'Areas of Interest',
                                    bloc: editProfileBloc.areasOfInterests,
                                  ),
                                  CheckboxFieldBlocBuilder(
                                    booleanFieldBloc:
                                        editProfileBloc.addOtherAreas,
                                    body: const Text('Add other areas'),
                                    textStyle: const TextStyle(fontSize: 14),
                                  ),
                                  TextFieldBlocBuilder(
                                    textFieldBloc:
                                        editProfileBloc.otherAreaOfInterest,
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
                                    bloc: editProfileBloc.description,
                                    minLines: 2,
                                    maxLines: 10,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  _buildTextFieldBloc(
                                    label: 'Contact Number',
                                    bloc: editProfileBloc.contactNumber,
                                    inputType: TextInputType.number,
                                    prefixText: '+91 ',
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        bloc: editProfileBloc.linkedInUrl,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      _buildSocialMediaSection(
                                        logoAsset: AssetsConstants.githubLogo,
                                        label: 'GitHub Profile Url',
                                        bloc: editProfileBloc.githubUrl,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      _buildSocialMediaSection(
                                        logoAsset: AssetsConstants.discordLogo,
                                        label: 'Discord Username',
                                        bloc: editProfileBloc.discordUserName,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  _buildUploadImageSection((context
                                          .read<UserBloc>()
                                          .state as UserRegistered)
                                      .user),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: editProfileBloc.submit,
                                    child: const Text('Submit'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : const CircularProgressIndicator();
                  },
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

  Widget _buildUploadImageSection(UserModel user) {
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
              onPressed: () {
                removeImage();
              },
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
                    : (user.photoUrl != null && !removeProfilePhoto)
                        ? DecorationImage(
                            image: NetworkImage(user.photoUrl!),
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
      textInputAction: TextInputAction.newline,
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
    setState(() {
      imageFile = null;
      removeProfilePhoto = true;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    XFile? xFilePick = pickedFile;
    setState(
      () {
        if (xFilePick != null) {
          imageFile = File(pickedFile!.path);
          removeProfilePhoto = false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

// void _onRegister() {
//   final user = UserModel(
//     email: (context.read<AuthBloc>().state as Authenticated).email,
//     name: nameController.text,
//     userType: 'club-member',
//   );
//
//   BlocProvider.of<UserBloc>(context).add(RegisterUser(user: user));
// }
}
