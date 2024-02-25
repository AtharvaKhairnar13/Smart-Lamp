import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartlamp1/alarmpage.dart';
import 'package:smartlamp1/lampmain.dart';

class lamppage extends StatefulWidget{
  const lamppage({super.key});

  @override
  State<lamppage> createState() => _lamppageState();
}

class _lamppageState extends State<lamppage> {
  int _currentIndex=0;

  Color currentColor = Colors.amber;
  void changeColor(Color color) => setState(() => currentColor = color);
  final List<Widget> _body =[
    const lampscreen(),
    const AlarmPage(),
  ];
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var currenttime=DateFormat('HH:mm').format(now);
    var currentdate=DateFormat('EEE, d MMM').format(now);
    return Consumer<LampAppProvider> (
      builder: (context, lampAppProvider, child) {
        return Scaffold(
          body: Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: IndexedStack(
                      index: _currentIndex,
                      children: _body,
                    )
                ),
                Container(
                  height: 200,

                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.deepOrange,
                          Colors.deepOrangeAccent,
                          Colors.orange,
                          Colors.orangeAccent
                        ],
                        stops: [0.0, 0.15, 0.60, 0.75],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(4, 4),
                        ),
                      ],
                      color: Colors.orangeAccent,
                      borderRadius: const BorderRadius.only(
                          //bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(60.0)
                      )

                  ),

                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60, right: 30),
                  child: SizedBox(

                    height: 200,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            currenttime,
                            style: const TextStyle(
                              color: Colors.white70,

                              fontSize: 74,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 213),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                color: Colors.white70,
                                size: 24,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                currentdate,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),


                   Padding(
                     padding: const EdgeInsets.all(30.0),
                     child: SafeArea(
                       child: Align(
                         alignment: const Alignment(0.0, 1.0),
                         child: ClipRRect(
                           borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                           child: IgnorePointer(
                             ignoring: lampAppProvider.appState.isPowerOn? false:true,
                             child: Container(
                               foregroundDecoration: BoxDecoration(
                                 color: lampAppProvider.appState.isPowerOn?  null:Colors.grey ,
                                 backgroundBlendMode: lampAppProvider.appState.isPowerOn? null:BlendMode.saturation ,
                               ),
                               child: BottomNavigationBar(
                                   backgroundColor: Colors.black87.withOpacity(0.8),
                                   unselectedItemColor: Colors.grey,
                                   onTap: (int index) {
                                     setState(() {
                                       _currentIndex = index;
                                     });
                                   },
                                   currentIndex: _currentIndex,
                                   items: const [
                                     BottomNavigationBarItem(
                                       icon: Icon(Icons.light_outlined),
                                       label: 'Lamp',
                                     ),
                                     BottomNavigationBarItem(
                                       icon: Icon(Icons.alarm_outlined),
                                       label: 'Alarm',
                                     ),
                                   ]),
                             ),
                           ),
                         ),
                       ),
                     ),
                   ),


              ]
          ),
        );
      }
    );
  }
}