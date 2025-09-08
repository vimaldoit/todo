import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalender/kalender.dart';
import 'package:todo/data/model/event_model.dart';
import 'package:todo/ui/screens/home/home_bloc.dart';
import 'package:todo/ui/screens/home/widgets/add_event_popup.dart';

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

  final calendarController = CalendarController<Event>();
  final eventsController = DefaultEventsController<Event>();
  late final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.week(
      displayRange: displayRange,
      firstDayOfWeek: 1,
    ),
    MultiDayViewConfiguration.singleDay(displayRange: displayRange),
    MultiDayViewConfiguration.workWeek(displayRange: displayRange),
    MultiDayViewConfiguration.custom(
      numberOfDays: 3,
      displayRange: displayRange,
    ),
    MonthViewConfiguration.singleMonth(),
    MultiDayViewConfiguration.freeScroll(
      displayRange: displayRange,
      numberOfDays: 4,
      name: "Free Scroll (WIP)",
    ),
  ];

  final now = DateTime.now();

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
                      // Since the visible DateTimeRange returned by the month view does not always start at the beginning of the month,
                      // we need to check the second week of the visibleDateTimeRange to determine the month and year.
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
          SizedBox(
            width: 120,
            child: DropdownMenu(
              dropdownMenuEntries:
                  viewConfigurations
                      .map((e) => DropdownMenuEntry(value: e, label: e.name))
                      .toList(),
              initialSelection: viewConfiguration,
              onSelected: (value) {
                if (value == null) return;
                setState(() => viewConfiguration = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<HomeBloc>().add(LoadEvents());
  }

  void _openAddEventDialog() async {
    final newEvent = await showDialog<CalendarEvent<Event>>(
      context: context,
      builder: (context) => AddEventPopup(),
    );

    if (newEvent != null) {
      context.read<HomeBloc>().add(AddCalendarEvent(newEvent));
      //   setState(() {
      //     eventsController.addEvent(newEvent);
      //   });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is CalendarLoaded) {
          eventsController.addEvents(state.events);
          //   eventsController.addEvents([
          //     CalendarEvent(
          //       dateTimeRange: DateTimeRange(
          //         start: now,
          //         end: now.add(const Duration(hours: 6)),
          //       ),
          //       data: const Event('My Event', Colors.green),
          //     ),
          //     CalendarEvent(
          //       dateTimeRange: DateTimeRange(
          //         start: now,
          //         end: now.add(const Duration(days: 1, hours: 1)),
          //       ),
          //       data: const Event('My Event', Colors.blue),
          //     ),
          //   ]);
        }
      },

      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Calendar')),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _openAddEventDialog(),
            child: const Icon(Icons.add),
          ),
          body: CalendarView<Event>(
            eventsController: eventsController,
            calendarController: calendarController,
            viewConfiguration: viewConfiguration,
            callbacks: CalendarCallbacks<Event>(
              onEventTapped:
                  (event, _) => calendarController.selectEvent(event),
              onEventCreate: (event) => event,
              onEventCreated: (event) {
                eventsController.addEvent(event);
                context.read<HomeBloc>().add(AddCalendarEvent(event));
              },
            ),
            header: Material(
              color: Theme.of(context).colorScheme.surface,
              elevation: 2,
              child: Column(
                children: [
                  _calendarToolbar(),
                  CalendarHeader<Event>(
                    multiDayTileComponents: _tileComponents(
                      context,
                      body: false,
                    ),
                  ),
                ],
              ),
            ),
            body: CalendarBody<Event>(
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
        );
      },
    );
  }

  //  Scaffold(
  //   appBar: AppBar(title: const Text("Events")),
  //   body: BlocConsumer<HomeBloc, HomeState>(
  //     listener: (context, state) {
  //       if (state is CalendarLoaded) {
  //         eventsController.addEvent(state.events.first);
  //       }
  //     },
  //     builder: (context, state) {
  //       if (state is CalendarLoaded) {
  //         return

  //         // CalendarView(
  //         //   eventsController: eventsController,
  //         //   calendarController: calendarController,
  //         //   viewConfiguration: MultiDayViewConfiguration.week(
  //         //     displayRange: DateTimeRange(
  //         //       start: DateTime.now().subtract(const Duration(days: 365)),
  //         //       end: DateTime.now().add(const Duration(days: 365)),
  //         //     ),
  //         //     firstDayOfWeek: 1,
  //         //   ),
  //         //   callbacks: CalendarCallbacks<Event>(
  //         //     onEventCreate: (event) => event,
  //         //     onEventCreated:
  //         //         (event) =>
  //         //             context.read<HomeBloc>().add(AddCalendarEvent(event)),
  //         //     onEventTapped:
  //         //         (event, _) => calendarController.selectEvent(event),
  //         //   ),
  //         // );
  //       }
  //       return const Center(child: CircularProgressIndicator());
  //     },
  //   ),
  //   floatingActionButton: FloatingActionButton(
  //     onPressed: _openAddEventDialog,
  //     child: Icon(Icons.add),
  //   ),
  // );
}

TileComponents<Event> _tileComponents(
  BuildContext context, {
  bool body = true,
}) {
  final color = Theme.of(context).colorScheme.primaryContainer;
  final radius = BorderRadius.circular(8);

  return TileComponents<Event>(
    tileBuilder: (event, _) {
      return Card(
        margin:
            body ? EdgeInsets.zero : const EdgeInsets.symmetric(vertical: 1),
        color: event.data?.color ?? color,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
