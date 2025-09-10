import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:todo/data/db/event_db.dart';
import 'package:todo/data/model/event_model.dart';
import 'package:todo/data/model/eventdata_model.dart';
import 'package:todo/data/repository/event_repository.dart';

class AddEventPopup extends StatefulWidget {
  final bool editFlag;
  final EventData? data;
  const AddEventPopup({super.key, this.editFlag = false, this.data});

  @override
  State<AddEventPopup> createState() => _AddEventPopupState();
}

class _AddEventPopupState extends State<AddEventPopup> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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

    final event = CalendarEvent<EventData>(
      dateTimeRange: DateTimeRange(start: startDateTime, end: endDateTime),
      data: EventData(
        title: _titleController.text,
        description: _descriptionController.text,
        color: _selectedColor,
        start: startDateTime,
        end: endDateTime,
      ),
    );

    Navigator.of(context).pop(event);
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.editFlag) {
      // Load existing event data for editing
      // For demonstration, using placeholder data
      EventData edata = widget.data!;
      _titleController.text = edata.title;
      _descriptionController.text = edata.description ?? '';
      _startDate = edata.start;
      _endDate = edata.end;
      _startTime = TimeOfDay.fromDateTime(edata.start);
      _endTime = TimeOfDay.fromDateTime(edata.end);
      _selectedColor = edata.color;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        insetPadding: EdgeInsets.zero,

        title: widget.editFlag ? Text('Update Event') : Text('Add Event'),
        content: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Event Title',
                    border: OutlineInputBorder(), // <-- Add border
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Event description',
                    border: OutlineInputBorder(), // <-- Add border
                  ),
                  maxLines: 4, // <-- Set to 4 lines
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
                          _endTime == null
                              ? 'End Time'
                              : _endTime!.format(context),
                        ),
                        onPressed: _pickEndTime,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.editFlag ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }
}
