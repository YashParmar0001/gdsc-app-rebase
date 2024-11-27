import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:gdsc_atmiya/bloc/announcement/announcement_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../model/announcement_model.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  late final TextEditingController titleTextController;
  late final TextEditingController descriptionTextController;

  @override
  void initState() {
    super.initState();
    titleTextController = TextEditingController();
    descriptionTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleTextController.dispose();
    descriptionTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement', style: TextStyle(fontSize: 22),),
      ),
      body: BlocListener<AnnouncementBloc, AnnouncementState>(
        child:  BlocBuilder<AnnouncementBloc, AnnouncementState>(
          builder: (context, state) {
            if (state is AnnouncementInitial) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTextField(
                        maxLine: 1,
                        label: 'Title',
                        controller: titleTextController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _buildTextField(
                        maxLine: 4,
                        label: 'Short Description',
                        controller: descriptionTextController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final AnnouncementModel announcement =
                          AnnouncementModel(
                            time: DateTime.now(),
                            title: titleTextController.text,
                            description: descriptionTextController.text,
                          );
                          context
                              .read<AnnouncementBloc>()
                              .add(AddAnnouncement(announcement));
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              );
            }
            else if(state is AnnouncementAdding ){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            else if(state is AnnouncementError){
              return const Center( child :Text('Some Error Occurred '));
            }
            else{
            return const Center(child : Text("Some thing is happen"));
            }

          },
        ),
          listener: (context, state) {

        if(state is AnnouncementSuccessed){
          context.pop();
        }

      }

      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required TextEditingController controller,
      required int maxLine}) {
    return TextField(
      maxLines: maxLine,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 15,
        ),
      ),
      style: const TextStyle(fontSize: 14),
    );
  }
}
