import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kssem/Utilities/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class CodeOfConduct extends StatefulWidget {
  @override
  _CodeOfConductState createState() => _CodeOfConductState();
}

class _CodeOfConductState extends State<CodeOfConduct> {
  final PageController ctrl = PageController(viewportFraction: 0.9);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: ctrl,
        itemCount: 4,
        itemBuilder: (context, int currentIdx) {
          if (currentIdx == 3) {
            bool active = currentIdx == currentPage;
            return _buildStoryPage(active,
                title: title[currentIdx],
                content: content[currentIdx],
                widget: ButtonLink());
          }
          // Active page
          bool active = currentIdx == currentPage;
          return _buildStoryPage(active,
              title: title[currentIdx], content: content[currentIdx]);
        },
      ),
    );
  }

  _buildStoryPage(
    bool active, {
    Widget widget,
    String title,
    String content,
  }) {
    // Animated Properties
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;

    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          //   image: DecorationImage(
          //     fit: BoxFit.cover,
          //     image: AssetImage(slideList),
          //   ),
          boxShadow: [
            BoxShadow(color: Colors.black87
                // blurRadius: blur,
                // offset: Offset(offset, offset)
                )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  content,
                  style:
                      GoogleFonts.openSans(fontSize: 15, color: Colors.white),
                ),
                
                widget != null ? widget : Container()
              ],
            ),
          ),
        ));
  }

  List<String> title = [
    "Code of Conduct",
    "How to use this app",
    "A Note from the Developer",
    "Terms & Coniditions"
  ];
  List<String> content = [
    '''The following guidelines represent the rules to be adhered by while using this app,please go through them carefully and ensure that you do not violate any of them while being an active member of this app.

Violation of any of these rules will ensure strict action and deactivation of the account from the platform.

1. Usage of language that is obscene is not be allowed or to be tolerated.

2. No topics including political association, propaganda, or religious matters will be entertained.

3. Addressing any member of the forum including Faculty, teaching, non-teaching and students in a unrespectful language is not allowed.

4. Topics without relevance or random posts that do not provide any value to the forum will be deleted immediately.

5. Usage of language other than English is not entertained.

6. Content that is not in the category of  Education, Career development, Engineering, or Productivity will be removed from the forum.
''',
    '''This app was Intended and developed to enable better communication, collaboration, and bring together a community of individuals with like-minded intentions and goals so they could collaborate better on ideas and accomplish a task.

1 Any individual can write a post about expressing information, ideas, or useful resources. 

2 Write a post with more than 200 words of information and relevant links to navigate for more information 

3 Write a post describing your interview, Hackathon, or Event experience mentioning everything you learned from it.

4 This forum is a one-way interaction and was designed to be informative to the audience, Hence the posts shall not contain any topics that shall lead to a discussion or debate.

5 Do not write any controversial statements with respect to anything happening in the college or the world.

6 Maintain a positive or neutral tone in your post and never write anything negative about any entity.

7 Do not post redundant information, If a post with similar information exists, suggest an edit to th person rather than posting the same thing again.''',
    '''I designed this app to help students get to know each other better and enable collaboration amongst them for ideas and innovation. 
And to help a student get exposure to the numerous events, opportunities, to grow as a professional that often go missed in a student's life. 
So, learn the most, become skillful, and most importantly, enjoy the process. 
And Collaborate because None of us is as smart as all of us.''',
    '''This app is the sole property of the developer, unauthorized usage, or access to this app outside the premises or by non-members of KS School Of Engineering and Management will be held responsible by the court of law. 
This app was specifically designed to meet the needs of KS School Of Engineering and Management and its members and hence will be authorized only within the campus.

The developer reserves all rights to add, modify, delete features, content, users, and restrictions at any time, and by any means, he wishes to.

This app is Open Sourced under the license Apache-2.0 which is available at the link below

Please follow the guidelines for use, modification, and redistribution of source code to avoid Copyright Infringement Or license violation.

By using this app, you agree to the end user terms and conitions. 
'''
  ];
}

class ButtonLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth - 50),
      child: RaisedButton(
        padding: EdgeInsets.only(
          top: 20,
          bottom: 20,
        ),
        textColor: Colors.white,
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              MaterialCommunityIcons.github_circle,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              // flex: 1,
              child: Text(
                "Check out the source code!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
        onPressed: () async {
          final String uri = 'https://github.com/Sameerkash/KSSEM-Faculty';

          if (await canLaunch(uri)) {
            await launch(uri);
          } else {
            print('Could not launch $uri');
          }
        },
      ),
    );
  }
}
