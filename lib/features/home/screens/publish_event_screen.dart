import 'dart:io';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gdsc_atmiya/bloc/event/event_details_bloc.dart';
import 'package:gdsc_atmiya/bloc/event/publish/publish_event_bloc.dart';
import 'package:gdsc_atmiya/constants/assets_constants.dart';
import 'package:gdsc_atmiya/theme/colors.dart';
import 'package:gdsc_atmiya/utils/ui_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class PublishEventScreen extends StatefulWidget {
  const PublishEventScreen({super.key});

  @override
  State<PublishEventScreen> createState() => _PublishEventScreenState();
}

class _PublishEventScreenState extends State<PublishEventScreen> {
  File? thumbnailFile;
  File? bannerFile;
  File? speakerImage;
  final picker = ImagePicker();
  late TextEditingController speakerNameController;
  late TextEditingController speakerOrganizationController;
  late TextEditingController speakerRoleController;
  List<Map<String, dynamic>> speakers = [];

  @override
  void initState() {
    speakerNameController = TextEditingController();
    speakerOrganizationController = TextEditingController();
    speakerRoleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    speakerNameController.dispose();
    speakerOrganizationController.dispose();
    speakerRoleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext? dialogContext;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Publish Event',
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: BlocListener<PublishEventBloc, PublishEventState>(
        listener: (context, state) {
          if (state is EventPublished) {
            context.go('/home');
          } else if (state is PublishingEvent) {
            showDialog(
              context: context,
              builder: (context) {
                dialogContext = context;
                return const SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            );
          } else if (state is EventPublishError) {
            if (dialogContext != null) Navigator.of(dialogContext!).pop();
            dev.log('Got event error: ${state.message}', name: 'Event');
          }
        },
        child: BlocProvider(
          create: (context) => EventDetailsBloc(),
          child: Builder(
            builder: (context) {
              final eventDetailsBloc = context.read<EventDetailsBloc>();

              return FormBlocListener<EventDetailsBloc, Map<String, dynamic>,
                  String>(
                onSubmitting: (context, state) {},
                onSuccess: (context, state) {
                  dev.log('Publishing event: ${state.successResponse}',
                      name: 'Event');
                  final eventData = state.successResponse!;

                  eventData['thumbnailImage'] = thumbnailFile;
                  eventData['bannerImage'] = bannerFile;
                  eventData['speakers'] = speakers;

                  context.read<PublishEventBloc>().add(PublishEvent(eventData));
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
                          label: 'Title',
                          bloc: eventDetailsBloc.title,
                          minLines: 1,
                          maxLines: 2,
                          maxLength: 100,
                          inputAction: TextInputAction.done,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTextFieldBloc(
                          label: 'Short Description',
                          bloc: eventDetailsBloc.shortDescription,
                          minLines: 2,
                          maxLines: 5,
                          maxLength: 400,
                          inputAction: TextInputAction.newline,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTextFieldBloc(
                          label: 'Description',
                          bloc: eventDetailsBloc.description,
                          minLines: 5,
                          maxLines: 20,
                          maxLength: 10000,
                          inputAction: TextInputAction.newline,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildMultipleChoiceChips(
                          label: 'Tags',
                          bloc: eventDetailsBloc.eventTags,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildUploadBannerSection(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildUploadThumbnailSection(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildAddSpeakersSection(),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildEventVenueField(
                          bloc: eventDetailsBloc.eventVenue,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildDateTimeSection(
                          'Event starts',
                          eventDetailsBloc.eventStartTime,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildDateTimeSection(
                          'Event ends',
                          eventDetailsBloc.eventEndTime,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildVenueSection(
                          eventDetailsBloc.eventVenueLine1,
                          eventDetailsBloc.eventVenueLine2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTextFieldBloc(
                          label: 'RSVP Link',
                          bloc: eventDetailsBloc.rsvpLink,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildTextFieldBloc(
                          label: 'Platform Link',
                          bloc: eventDetailsBloc.platformLink,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: eventDetailsBloc.submit,
                          child: const Text('Publish'),
                        ),
                        const SizedBox(
                          height: 10,
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

  Widget _buildAddSpeakersSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Speakers',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return _buildAddSpeakerDialog();
                  },
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ...List.generate(speakers.length, (index) {
          return _buildSpeaker(speakers[index]);
        }),
      ],
    );
  }

  Widget _buildAddSpeakerDialog() {
    return Dialog(
      child: StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Speaker',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontFamily: 'Roboto',
                      ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Add a speaker of the event',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFamily: 'Roboto',
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildTextField(speakerNameController, 'Name'),
                const SizedBox(
                  height: 10,
                ),
                _buildTextField(speakerOrganizationController, 'Organization'),
                const SizedBox(
                  height: 10,
                ),
                _buildTextField(speakerRoleController, 'Role'),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 120,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: (speakerImage != null)
                              ? DecorationImage(
                                  image: FileImage(
                                    speakerImage!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage(
                                    AssetsConstants.eventThumbnail,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            // setState(() {
                            //   getSpeakerImage(speakerImageFile);
                            // });
                            final pickedFile = await picker.pickImage(
                                source: ImageSource.gallery);
                            XFile? xFilePick = pickedFile;
                            setState(
                              () {
                                if (xFilePick != null) {
                                  speakerImage = File(pickedFile!.path);
                                } else {
                                  showSnackBar(
                                    context,
                                    message: 'Nothing is selected!',
                                    icon: Icons.info_outline,
                                    color: Colors.grey,
                                  );
                                }
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        speakerNameController.clear();
                        speakerOrganizationController.clear();
                        speakerRoleController.clear();
                        speakerImage = null;
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final speakerData = {
                          'name' : speakerNameController.text,
                          'organization' : speakerOrganizationController.text,
                          'role' : speakerRoleController.text,
                          'image' : speakerImage,
                        };

                        speakerNameController.clear();
                        speakerOrganizationController.clear();
                        speakerRoleController.clear();
                        speakerImage = null;

                        this.setState(() {
                          speakers.add(speakerData);
                          Navigator.pop(context);
                        });
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
      ),
    );
  }

  Widget _buildSpeaker(Map<String, dynamic> speakerData) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey,
              image: speakerData['image'] != null
                  ? DecorationImage(
                      image: FileImage(speakerData['image'] as File),
                fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 14,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                speakerData['name'],
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'OpenSans',
                    ),
              ),
              Text(
                speakerData['organization'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.slateGray,
                    ),
              ),
              Text(
                speakerData['role'],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.slateGray,
                    ),
              ),
            ],
          ),
          Expanded(child: Container()),
          IconButton(onPressed: () {
            setState(() {
              speakers.removeWhere((element) => element == speakerData);
            });
          }, icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }

  Widget _buildVenueSection(TextFieldBloc line1Bloc, TextFieldBloc line2Bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Venue',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
        ),
        _buildTextFieldBloc(label: 'Line1', bloc: line1Bloc),
        const SizedBox(
          height: 5,
        ),
        _buildTextFieldBloc(label: 'Line2', bloc: line2Bloc),
      ],
    );
  }

  Widget _buildDateTimeSection(
    String label,
    InputFieldBloc<DateTime, Object> bloc,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 200,
          child: DateTimeFieldBlocBuilder(
            textStyle: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              labelText: label,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
            ),
            dateTimeFieldBloc: bloc,
            canSelectTime: true,
            format: DateFormat('dd-MM-yyyy hh:mm'),
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2024),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBannerSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upload Event Banner',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              onPressed: removeBannerImage,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          child: AspectRatio(
            aspectRatio: 2560 / 650,
            child: Container(
              decoration: BoxDecoration(
                image: (bannerFile != null)
                    ? DecorationImage(
                        image: FileImage(
                          bannerFile!,
                        ),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage(
                          AssetsConstants.eventBanner,
                        ),
                        fit: BoxFit.cover,
                      ),
              ),
              child: IconButton(
                onPressed: () {
                  getBannerImage();
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadThumbnailSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upload Event Thumbnail',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
            ),
            IconButton(
              onPressed: removeThumbnailImage,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 150,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                image: (thumbnailFile != null)
                    ? DecorationImage(
                        image: FileImage(
                          thumbnailFile!,
                        ),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: AssetImage(
                          AssetsConstants.eventThumbnail,
                        ),
                        fit: BoxFit.cover,
                      ),
              ),
              child: IconButton(
                onPressed: () {
                  getThumbnailImage();
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
    TextInputAction? inputAction,
    String? prefixText,
    String? hintText,
    int? minLines,
    int? maxLines,
    int? maxLength,
  }) {
    return TextFieldBlocBuilder(
      textFieldBloc: bloc,
      keyboardType: inputType,
      textInputAction: inputAction,
      textCapitalization: TextCapitalization.sentences,
      minLines: minLines,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
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

  Widget _buildEventVenueField({
    required SelectFieldBloc bloc,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          child: Text(
            'Event Venue',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: DropdownFieldBlocBuilder(
            selectFieldBloc: bloc,
            textOverflow: TextOverflow.ellipsis,
            textStyle: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
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
          ),
        ),
      ],
    );
  }

  void addSpeaker() {}

  void removeThumbnailImage() {
    if (thumbnailFile != null) {
      setState(() {
        thumbnailFile = null;
      });
    }
  }

  void removeBannerImage() {
    if (bannerFile != null) {
      setState(() {
        bannerFile = null;
      });
    }
  }

  Future getSpeakerImage(File? speakerImageFile) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    XFile? xFilePick = pickedFile;
    setState(
      () {
        if (xFilePick != null) {
          speakerImage = File(pickedFile!.path);
        } else {
          showSnackBar(
            context,
            message: 'Nothing is selected!',
            icon: Icons.info_outline,
            color: Colors.grey,
          );
        }
      },
    );
    // if (xFilePick != null) {
    //   speakerImageFile = File(pickedFile!.path);
    // } else {
    //   showSnackBar(
    //     context,
    //     message: 'Nothing is selected!',
    //     icon: Icons.info_outline,
    //     color: Colors.grey,
    //   );
    // }
  }

  Future getThumbnailImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    XFile? xFilePick = pickedFile;
    setState(
      () {
        if (xFilePick != null) {
          thumbnailFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  Future getBannerImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    XFile? xFilePick = pickedFile;
    setState(
      () {
        if (xFilePick != null) {
          bannerFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
