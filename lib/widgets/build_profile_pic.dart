import 'package:drift_app/cubits/user_profile_cubit/user_profile_cubit.dart';
import 'package:drift_app/cubits/user_profile_cubit/user_profile_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildProfilePic extends StatefulWidget {
  final User user;
  const BuildProfilePic({super.key, required this.user});

  @override
  State<BuildProfilePic> createState() => _BuildProfilePicState();
}

class _BuildProfilePicState extends State<BuildProfilePic> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, profileState) {
        final isUpdating = profileState is UserProfilePhotoUpdating;
        final photoUrl = widget.user.photoURL;

        return Stack(
          children: [
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.surface,
                border: Border.all(color: colors.onSurface, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: colors.onSurface.withOpacity(0.6),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: ClipOval(
                child: photoUrl != null
                    ? Image.network(
                        photoUrl,
                        fit: BoxFit.cover,
                        key: ValueKey(photoUrl),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 60,
                            color: colors.onSurface,
                          );
                        },
                      )
                    : Icon(Icons.person, size: 60, color: colors.onSurface),
              ),
            ),
            if (isUpdating)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.onSurface,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: colors.onSurface,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Semantics(
                label: 'Change profile picture',
                button: true,
                child: Material(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: isUpdating
                        ? null
                        : () => context
                              .read<UserProfileCubit>()
                              .updateProfilePicture(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: colors.surface,
                        border: Border.all(color: colors.background, width: 3),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
