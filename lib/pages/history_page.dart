import 'package:drift_app/helper/const.dart';
import 'package:drift_app/pages/map_page.dart';
import 'package:drift_app/widgets/custom_button.dart';
import 'package:drift_app/widgets/filter_button.dart';
import 'package:drift_app/widgets/glass_cont.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  static String id = 'History page';

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String selectedFilter = 'Ride';

  // Replace with real data later
  final List trips = [];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.surface.withOpacity(0.7),
                colors.background,
                colors.surface.withOpacity(0.7),
                colors.background,
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // ── Header ──────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: GlassCont(
                  height: 250,
                  bottom: BorderSide(
                    color: colors.onBackground.withOpacity(0.4),
                    width: 1.5,
                  ),
                  right: BorderSide(
                    color: colors.onBackground.withOpacity(0.4),
                    width: 1.5,
                  ),
                  left: BorderSide(
                    color: colors.onBackground.withOpacity(0.4),
                    width: 1.5,
                  ),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            size: 35,
                            color: colors.onSurface,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Trip History',
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: fontFamily,
                              color: colors.onSurface,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 7),
                            FilterButton(
                              text: 'Ride',
                              isSelected: selectedFilter == 'Ride',
                              onTap: () {
                                setState(() => selectedFilter = 'Ride');
                              },
                            ),
                            FilterButton(
                              text: 'City to City',
                              isSelected: selectedFilter == 'City to City',
                              onTap: () {
                                setState(() => selectedFilter = 'City to City');
                              },
                            ),
                            FilterButton(
                              text: 'Delivery',
                              isSelected: selectedFilter == 'Delivery',
                              onTap: () {
                                setState(() => selectedFilter = 'Delivery');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ── Body ────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: GlassCont(
                  height: 490,
                  top: BorderSide(
                    color: colors.onBackground.withOpacity(0.4),
                    width: 1.5,
                  ),
                  bottom: BorderSide(
                    color: colors.onBackground.withOpacity(0.4),
                    width: 1.5,
                  ),
                  right: BorderSide(
                    color: colors.onBackground.withOpacity(0.4),
                    width: 1.5,
                  ),
                  left: BorderSide(
                    color: colors.onBackground.withOpacity(0.4),
                    width: 1.5,
                  ),
                  child: Expanded(
                    child: trips.isEmpty
                        ? _buildEmptyState(colors)
                        : _buildTripList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Empty State ──────────────────────────────────────────────────
  Widget _buildEmptyState(ColorScheme colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 250, child: Image.asset(logoPath2)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "You didn't make trips yet",
              style: TextStyle(
                color: colors.onSurface,
                fontFamily: fontFamily,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
              width: 390,
              child: CustomButtom(
                onTap: () => Navigator.pushNamed(context, MapPage.id),
                backgroundColor: colors.surface,
                text: 'Make one Now',
                icon: IconButton(
                  onPressed: () => Navigator.pushNamed(context, MapPage.id),
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    size: 35,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Trip List (ready for when data exists) ───────────────────────
  Widget _buildTripList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(title: Text(trip.toString())),
        );
      },
    );
  }
}
