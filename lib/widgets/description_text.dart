import 'package:flutter/material.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String ? text;

  const DescriptionTextWidget({super.key, required this.text});

  @override
  DescriptionTextWidgetState createState() => DescriptionTextWidgetState();
}

class DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();
    if (widget.text!.length > 300) {
      firstHalf = widget.text!.substring(0, 300);
      secondHalf = widget.text!.substring(300, widget.text!.length);
    } else {
      firstHalf = widget.text!;
      secondHalf = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(
              (flag ? (firstHalf) : (firstHalf + secondHalf))
                  .replaceAll(r'\n', '\n')
                  .replaceAll(r'\r', '')
                  .replaceAll(r"\'", "'"),
              style: TextStyle(
                fontSize: 14.0,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            )
          : Column(
              children: <Widget>[
                Text(
                  (flag ? ('$firstHalf...') : (firstHalf + secondHalf))
                      .replaceAll(r'\n', '\n\n')
                      .replaceAll(r'\r', '')
                      .replaceAll(r"\'", "'"),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Text(
                        flag ? 'Show More' : 'Show Less',
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
