import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:toggle_list/toggle_list.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  var icon = [Icons.call, LineIcons.facebookMessenger, Icons.email_outlined];
  var title = ['Phone No', 'Message', 'Email'];
  var val = ['955887****', '123446798', 'mistryyash123@gmail.com'];
  @override
  Widget build(BuildContext context) {
    var mdheight = MediaQuery.sizeOf(context).height;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: mdheight * 0.025,
              ),
              title: const Text('Help Center'),
              backgroundColor: Colors.deepPurple.shade800,
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              centerTitle: true,
              bottom: const TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      text: 'FAQ',
                    ),
                    Tab(
                      text: 'Contact Us',
                    ),
                  ]),
            ),
            body: TabBarView(
                children: [
                  Container(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ToggleList(
                      divider: const SizedBox(height: 15),
                      toggleAnimationDuration: const Duration(
                          milliseconds: 400),
                      scrollPosition: AutoScrollPosition.begin,
                      trailing: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.expand_more),
                      ),
                      children: List.generate(
                        title.length, (index) =>
                          ToggleListItem(
                            leading: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(icon[index]),
                            ),
                            title: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title[index],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  )),
                              ]),
                            ),
                            divider: const Divider(
                              color: Colors.white,
                              height: 2,
                              thickness: 2,
                            ),
                            content: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                                color: Colors.grey.withOpacity(0.25),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    val[index],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400
                                    )
                                  ),
                                  const Divider(
                                    color: Colors.white,
                                    height: 2,
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            ),
                            headerDecoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(20)),
                            ),
                            expandedHeaderDecoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.50),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),),
                            ),
                          ),
                      ),
                    ),
                  ),
                ])));
  }
}