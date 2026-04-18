import 'package:drift_app/cubits/google_signin/google_signin_cubit.dart';
import 'package:drift_app/cubits/user_profile_cubit/user_profile_cubit.dart';
import 'package:drift_app/cubits/user_profile_cubit/user_profile_state.dart';
import 'package:drift_app/helper/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildNameSection extends StatefulWidget {
  final User user;
  const BuildNameSection({super.key, required this.user});

  @override
  State<BuildNameSection> createState() => _BuildNameSectionState();
}

class _BuildNameSectionState extends State<BuildNameSection> {
  final _nameController = TextEditingController();
  bool isEditingName = false;
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validateName(String name) {
    if (name.isEmpty) return 'Name cannot be empty';
    if (name.length < 2) return 'Name must be at least 2 characters';
    if (name.length > 50) return 'Name is too long';
    return null;
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveName() {
    final newName = _nameController.text.trim();
    final error = _validateName(newName);

    if (error != null) {
      _showSnackBar(error, isError: true);
      return;
    }

    context.read<UserProfileCubit>().updateDisplayName(newName);
  }

  void _cancelEdit() {
    setState(() {
      isEditingName = false;
      _nameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocConsumer<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileNameUpdateSuccess) {
          setState(() => isEditingName = false);
          _showSnackBar('Name updated successfully!');
          if (state.updatedUser != null) {
            context.read<GoogleSigninCubit>().updateUserState(
              state.updatedUser,
            );
          }
          // context.read<UserProfileCubit>().resetState();
        }
      },
      builder: (context, profileState) {
        final isUpdating = profileState is UserProfileNameUpdating;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: isEditingName
              ? Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      enabled: !isUpdating,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.5),
                          fontFamily: fontFamily,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: colors.primary),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isUpdating)
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else ...[
                          TextButton.icon(
                            onPressed: _cancelEdit,
                            icon: const Icon(Icons.close, size: 18),
                            label: const Text(
                              'Cancel',
                              style: TextStyle(fontFamily: fontFamily),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: colors.error,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton.icon(
                            onPressed: _saveName,
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text(
                              'Save',
                              style: TextStyle(fontFamily: fontFamily),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.user.displayName ?? 'No name',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                          fontFamily: fontFamily,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Container(
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                          color: colors.onSurface,
                        ),
                        onPressed: isUpdating
                            ? null
                            : () {
                                setState(() {
                                  isEditingName = true;
                                  _nameController.text =
                                      widget.user.displayName ?? '';
                                });
                              },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
