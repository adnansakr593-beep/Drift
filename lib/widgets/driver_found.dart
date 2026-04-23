import 'package:drift_app/helper/const.dart';
import 'package:flutter/material.dart';

class DriverFound extends StatelessWidget {
  final void Function()? onTap;
  const DriverFound({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF00C9A7).withOpacity(0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF00C9A7).withOpacity(0.4)),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF00C9A7),
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              'Driver Found!',
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your driver is on the way',
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF00C9A7),
                  child: Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adnan Sakr',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamily,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '⭐ 5.0 • Toyota Supra • SAk 272',
                      style: TextStyle(
                        color: colors.onSurface.withOpacity(0.5),
                        fontSize: 12,
                        fontFamily: fontFamily,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // call driver action
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C9A7).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.call_rounded,
                            color: Color(0xFF00C9A7),
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Call',
                            style: TextStyle(
                              color: Color(0xFF00C9A7),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close_rounded,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
