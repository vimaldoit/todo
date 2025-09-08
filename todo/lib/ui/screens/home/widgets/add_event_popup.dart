import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:todo/data/model/event_model.dart';

class AddEventPopup extends StatefulWidget {
  const AddEventPopup({super.key});

  @override
  State<AddEventPopup> createState() => _AddEventPopupState();
}

class _AddEventPopupState extends State<AddEventPopup> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  Color _selectedColor = Colors.blue;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  Future<void> _pickDateRange() async {
    final now = DateTime.now();

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDateRange: DateTimeRange(
        start: _startDate ?? now,
        end: _endDate ?? now.add(const Duration(days: 1)),
      ),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  void _submit() {
    if (_titleController.text.isEmpty ||
        _startDate == null ||
        _endDate == null ||
        _startTime == null ||
        _endTime == null) {
      return;
    }

    final startDateTime = DateTime(
      _startDate!.year,
      _startDate!.month,
      _startDate!.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    final endDateTime = DateTime(
      _endDate!.year,
      _endDate!.month,
      _endDate!.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    if (endDateTime.isBefore(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    final event = CalendarEvent<Event>(
      dateTimeRange: DateTimeRange(start: startDateTime, end: endDateTime),
      data: Event(_titleController.text, _selectedColor),
    );

    Navigator.of(context).pop(event);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Event'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            SizedBox(height: 20),
            TextButton.icon(
              icon: Icon(Icons.date_range),
              label: Text(
                _startDate == null || _endDate == null
                    ? 'Select Date Range'
                    : '${_startDate!.toLocal().toString().split(' ')[0]} → ${_endDate!.toLocal().toString().split(' ')[0]}',
              ),
              onPressed: _pickDateRange,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _startTime == null
                          ? 'Start Time'
                          : _startTime!.format(context),
                    ),
                    onPressed: _pickStartTime,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _endTime == null ? 'End Time' : _endTime!.format(context),
                    ),
                    onPressed: _pickEndTime,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: Navigator.of(context).pop, child: Text("Cancel")),
        ElevatedButton(onPressed: _submit, child: Text('Add')),
      ],
    );
  }
}
