import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryapp/helpers/function.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _selectedDate = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _selectedDate,
            calendarFormat: calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
              });
            },
            headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(
                  color: Color.fromARGB(255, 100, 63, 181),
                  fontWeight: FontWeight.bold ,
                  fontFamily: 'cereal')),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontFamily: 'cereal'),
            ),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
              });
            },
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notes')
                .where('date',
                    isGreaterThanOrEqualTo: _formatDate(_selectedDate))
                .where('date',
                    isLessThan:
                        _formatDate(_selectedDate.add(const Duration(days: 1))))
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("There is no entry for this date"),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text('There is no entry for this date'));
              }
              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              border: Border.all(color: Colors.grey.shade300)),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(getDay(data['date']),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      getMonth(data['date']),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      getYear(data['date']),
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              getIconByFeeling(data['feeling'])!,
                              const SizedBox(
                                width: 30,
                              ),
                              Container(
                                width: 2,
                                height: 50,
                                decoration:
                                    BoxDecoration(color: Colors.grey.shade500),
                              ),
                              const SizedBox(width: 30),
                              Text(
                                data['title'],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Builder(builder: (context) {
                                  return SingleChildScrollView(
                                    child: SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.8,
                                        height: data['content'].length < 100
                                            ? MediaQuery.sizeOf(context)
                                                    .height *
                                                0.3
                                            : MediaQuery.sizeOf(context)
                                                    .height *
                                                0.6,
                                        child: Column(
                                          children: [
                                            Text(
                                              DateFormat("EEEE, MMMM d, yyyy")
                                                  .format(DateTime.parse(
                                                      data['date']))
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.8,
                                              height: 2,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "My feeling:",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                getIconByFeeling(
                                                    data['feeling'])!
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.8,
                                              height: 2,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black),
                                            ),
                                            const SizedBox(height: 10,),
                                            Center(child: Text(data['title'], 
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold
                                              ),)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              data['content'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )),
                                  );
                                }),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('notes')
                                            .doc(doc.id)
                                            .delete();
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Delete this entry',
                                        style: TextStyle(color: Colors.red),
                                      ))
                                ],
                              );
                            },
                          );
                        }),
                  );
                }).toList(),
              );
            },
          ))
        ],
      ),
    ));
  }

  Future<List<DateTime>> fetchEventDates() async {
    final List<DateTime> eventDates = [];
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('notes').get();
    for (var note in snapshot.docs) {
      final date = DateTime.parse(note['date']);
      eventDates.add(date);
    }
    return eventDates;
  }

  Future<Map<DateTime, List<dynamic>>> getEventMap() async {
    List<DateTime> dates = await fetchEventDates();
    Map<DateTime, List<dynamic>> events = {};

    for (DateTime date in dates) {
      events[date] = ['evenements'];
    }
    return events;
  }
}
