import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalender/kalender.dart';
import 'package:todo/data/model/event_model.dart';
import 'package:todo/data/model/eventdata_model.dart';
import 'package:todo/data/model/user_model.dart';
import 'package:todo/ui/screens/home/home_bloc.dart';
import 'package:todo/ui/screens/home/widgets/add_event_popup.dart';
import 'package:intl/intl.dart';
import 'package:todo/ui/screens/home/widgets/eventsearch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final displayRange = DateTimeRange(
    start: now.subtractDays(363),
    end: now.addDays(365),
  );

  /// Set the initial view configuration.
  late ViewConfiguration viewConfiguration = viewConfigurations[0];

  final calendarController = CalendarController<EventData>();
  final eventsController = DefaultEventsController<EventData>();
  late final viewConfigurations = <ViewConfiguration>[
    MonthViewConfiguration.singleMonth(),
    // MultiDayViewConfiguration.week(
    //   displayRange: displayRange,
    //   firstDayOfWeek: 1,
    // ),
    // MultiDayViewConfiguration.singleDay(displayRange: displayRange),
    // MultiDayViewConfiguration.workWeek(displayRange: displayRange),
    // MultiDayViewConfiguration.custom(
    //   numberOfDays: 3,
    //   displayRange: displayRange,
    // ),

    // MultiDayViewConfiguration.freeScroll(
    //   displayRange: displayRange,
    //   numberOfDays: 4,
    //   name: "Free Scroll (WIP)",
    // ),
  ];

  final now = DateTime.now();
  AppUser? _currentUser;

  Widget _calendarToolbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: calendarController.visibleDateTimeRangeUtc,
                  builder: (context, value, child) {
                    final String month;
                    final int year;

                    if (viewConfiguration is MonthViewConfiguration) {
                      final secondWeek = value.start.addDays(7);
                      year = secondWeek.year;
                      month = secondWeek.monthNameLocalized();
                    } else {
                      year = value.start.year;
                      month = value.start.monthNameLocalized();
                    }
                    return FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(160, kMinInteractiveDimension),
                      ),
                      child: Text('$month $year'),
                    );
                  },
                ),
              ],
            ),
          ),

          IconButton.filledTonal(
            onPressed: () => calendarController.animateToDate(DateTime.now()),
            icon: const Icon(Icons.today),
          ),
          SizedBox(width: 10),
          DropdownButton<AppUser>(
            value: _currentUser,
            underline: const SizedBox(),
            items:
                users
                    .map((u) => DropdownMenuItem(value: u, child: Text(u.name)))
                    .toList(),
            onChanged: (u) {
              if (u != null) {
                setState(() => _currentUser = u);
                context.read<HomeBloc>().add(SwitchUserEvent(u));
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentUser = users[0];
    context.read<HomeBloc>().add(LoadEvents());
  }

  void _openAddEventDialog({bool editFlag = false, EventData? data}) async {
    final newEvent = await showDialog<CalendarEvent<EventData>>(
      context: context,
      builder: (context) => AddEventPopup(editFlag: editFlag, data: data),
    );

    if (newEvent != null) {
      if (!mounted) return;
      final updateEvent = newEvent.data!.copyWith(id: data?.id);
      if (editFlag) {
        context.read<HomeBloc>().add(EditCalendarEvent(updateEvent));
      } else {
        context.read<HomeBloc>().add(AddCalendarEvent(newEvent));
      }
    }
  }

  void showBookingBottomSheet(BuildContext context, {required bool booked}) {
    final icon = booked ? Icons.check_circle : Icons.cancel;
    final color = booked ? Colors.green : Colors.red;
    final title = booked ? "Booking Successful!" : "Booking Cancelled";
    final message =
        booked
            ? "You have successfully booked this event."
            : "Your booking has been cancelled.";

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 60),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(message),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openEventDetails(CalendarEvent<EventData> event, BuildContext cntxt) {
    showModalBottomSheet(
      context: cntxt,
      isScrollControlled: true,
      backgroundColor: Theme.of(cntxt).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (cntxt) => Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: MediaQuery.of(cntxt).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  event.data?.title ?? "No Title",
                  style: Theme.of(cntxt).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                _currentUser!.id != ''
                    ? SizedBox()
                    : Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.redAccent, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          "Favorites: ${event.data?.favoriteCount ?? 0}",
                          style: Theme.of(cntxt).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.book_online, color: Colors.green, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          "Booked: ${event.data?.bookCount ?? 0}",
                          style: Theme.of(cntxt).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                Divider(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 22,
                      color: Theme.of(cntxt).colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${DateFormat('yyyy-MM-dd').format(event.dateTimeRange.start)}\n${DateFormat('hh:mm a').format(event.dateTimeRange.start)}",
                            style: Theme.of(cntxt).textTheme.bodyMedium,
                          ),
                          Spacer(),
                          Text("- to -"),
                          Spacer(),
                          Text(
                            "${DateFormat('yyyy-MM-dd').format(event.dateTimeRange.end)}\n${DateFormat('hh:mm a').format(event.dateTimeRange.end)}",
                            style: Theme.of(cntxt).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 0),
                if (event.data?.description != null &&
                    event.data!.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 4, right: 4),
                    child: Text(
                      "Description",
                      style: Theme.of(cntxt).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (event.data?.description != null &&
                    event.data!.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 4,
                    ),
                    child: Text(event.data!.description.toString()),
                  ),
                const SizedBox(height: 24),
                _currentUser!.id == ''
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement edit
                            Navigator.of(context).pop();
                            _openAddEventDialog(
                              editFlag: true,
                              data: event.data,
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(cntxt).colorScheme.primaryContainer,
                            foregroundColor:
                                Theme.of(cntxt).colorScheme.onPrimaryContainer,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement delete
                            context.read<HomeBloc>().add(
                              RemoveCalendarEvent(event),
                            );
                            Navigator.pop(cntxt);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement edit
                            Navigator.of(context).pop();
                            context.read<HomeBloc>().add(
                              ToggleFavoriteEvent(
                                userId: _currentUser!.id,
                                eventId: event.data!.id!,
                                isFavorite:
                                    event.data!.favoriteFlag == 1
                                        ? false
                                        : true,
                              ),
                            );
                          },
                          icon: Icon(Icons.favorite),
                          label: const Text("favorite"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                event.data!.favoriteFlag == 1
                                    ? Colors.red
                                    : Colors.grey,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed:
                              event.data!.bookFlag == 1
                                  ? () {
                                    Navigator.of(context).pop();
                                    showBookingBottomSheet(
                                      context,
                                      booked: false,
                                    );
                                    context.read<HomeBloc>().add(
                                      ToggleBookingEvent(
                                        userId: _currentUser!.id,
                                        eventId: event.data!.id!,
                                        isBooked: false,
                                      ),
                                    );
                                  }
                                  : () {
                                    // TODO: Implement delete

                                    Navigator.of(context).pop();
                                    showBookingBottomSheet(
                                      context,
                                      booked: true,
                                    );
                                    context.read<HomeBloc>().add(
                                      ToggleBookingEvent(
                                        userId: _currentUser!.id,
                                        eventId: event.data!.id!,
                                        isBooked: true,
                                      ),
                                    );
                                  },
                          icon: const Icon(Icons.book_online),
                          label: Text(
                            event.data!.bookFlag == 1 ? 'Booked' : "Book Event",
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                event.data!.bookFlag == 1
                                    ? Colors.grey
                                    : Colors.green.shade400,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is CalendarLoaded) {
          eventsController.clearEvents();
          eventsController.addEvents(state.events);
        }
      },

      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Events'),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.search),
          //     onPressed: () {
          //       showSearch(
          //         context: context,
          //         delegate: EventSearchDelegate(context.read<HomeBloc>()),
          //       );
          //     },
          //   ),
          // ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openAddEventDialog(),
          child: const Icon(Icons.add),
        ),
        body: CalendarView<EventData>(
          eventsController: eventsController,
          calendarController: calendarController,
          viewConfiguration: viewConfiguration,
          callbacks: CalendarCallbacks<EventData>(
            // onEventTapped:
            //     (event, _) => calendarController.selectEvent(event),
            onEventCreate: (event) => event,
            onEventCreated: (event) {
              eventsController.addEvent(event);
              context.read<HomeBloc>().add(AddCalendarEvent(event));
            },
            onEventTapped: (event, _) => _openEventDetails(event, context),
          ),
          header: Material(
            color: Theme.of(context).colorScheme.surface,
            elevation: 2,
            child: Column(
              children: [
                _calendarToolbar(),
                Indicators(),
                CalendarHeader<EventData>(
                  multiDayTileComponents: _tileComponents(context, body: false),
                ),
              ],
            ),
          ),
          body: CalendarBody<EventData>(
            multiDayTileComponents: _tileComponents(context),
            monthTileComponents: _tileComponents(context, body: false),
            //   scheduleTileComponents: _scheduleTileComponents(context),
            multiDayBodyConfiguration: MultiDayBodyConfiguration(
              showMultiDayEvents: false,
            ),
            monthBodyConfiguration: MultiDayHeaderConfiguration(),
            scheduleBodyConfiguration: ScheduleBodyConfiguration(),
          ),
        ),
      ),
    );
  }
}

class Indicators extends StatelessWidget {
  const Indicators({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(color: Colors.redAccent),
            ),
            Text(" Favorite"),
          ],
        ),
        SizedBox(width: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 15,
              width: 15,
              decoration: BoxDecoration(color: Colors.green),
            ),
            Text(" Booked"),
          ],
        ),
      ],
    );
  }
}

TileComponents<EventData> _tileComponents(
  BuildContext context, {
  bool body = true,
}) {
  final color = Theme.of(context).colorScheme.primaryContainer;
  final radius = BorderRadius.circular(5);

  return TileComponents<EventData>(
    tileBuilder: (event, _) {
      return Container(
        decoration: BoxDecoration(
          color: event.data?.color ?? color,
          borderRadius: radius,
        ),
        margin:
            body ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 1),

        child: Padding(
          padding: const EdgeInsets.only(left: 4, right: 4),
          child: Text(event.data?.title ?? "No title"),
        ),
      );
    },
    dropTargetTile:
        (_) => DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(80),
              width: 2,
            ),
            borderRadius: radius,
          ),
        ),
    feedbackTileBuilder:
        (event, size) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: size.width * 0.8,
          height: size.height,
          decoration: BoxDecoration(
            color: color.withAlpha(100),
            borderRadius: radius,
          ),
        ),
    tileWhenDraggingBuilder:
        (_) => Container(
          decoration: BoxDecoration(
            color: color.withAlpha(80),
            borderRadius: radius,
          ),
        ),
    dragAnchorStrategy: pointerDragAnchorStrategy,
  );
}
