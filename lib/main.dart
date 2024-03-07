import 'package:bar_widget_neodocs/assets/models/testsMetadata.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(NeoDocsAssignment());
}

class NeoDocsAssignment extends StatelessWidget {
  NeoDocsAssignment({super.key});
  final ValueNotifier<double> pointerValue = ValueNotifier<double>(0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[400],
          title: const Text('NeoDocs Test Meter'),
          centerTitle: true,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Widget-1: Bar
              Bar(pointerValue: pointerValue),
              const SizedBox(height: 50),
              //Widget-2: TextField
              TextFieldWidget(pointerValue: pointerValue),
            ],
          ),
        ),
      ),
    );
  }
}

//Defining the Bar() Widget
class Bar extends StatelessWidget {
  final ValueNotifier<double> pointerValue;
  final testMetadata = a_test_metadata;
  Bar({super.key, required this.pointerValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //_buildScale()
        Container(
          child: Row(
            children: _buildScale(context),
          ),
        ),
        //_buildSections()
        SizedBox(
          height: 20,
          child: Row(
            children: _buildSections(context),
          ),
        ),
        //_buildPointerPoition()
        ValueListenableBuilder<double>(
            valueListenable: pointerValue,
            builder: (context, value, _) {
              return Row(
                children: _buildPointerPosition(value, context),
              );
            }),
      ],
    );
  }

  //Defining _buildScale() : Range scale of a given test
  List<Widget> _buildScale(BuildContext context) {
    List<Widget> scale = [];
    double totalWidth = MediaQuery.of(context).size.width - 40;
    for (var metadata in testMetadata) {
      scale.add(
        Expanded(
          flex: ((metadata.end - metadata.start) *
                  totalWidth ~/
                  testMetadata.last.end)
              .toInt(),
          child: Text(
            metadata.start.toInt().toString(),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      );
    }
    scale.add(
      Text(
        testMetadata.last.end.toInt().toString(),
        style: const TextStyle(fontSize: 12),
      ),
    );
    return scale;
  }

  //Defining _buildSections() : ColoredBars
  List<Widget> _buildSections(BuildContext context) {
    List<Widget> sections = [];
    double totalWidth = MediaQuery.of(context).size.width - 40;
    for (var metadata in testMetadata) {
      sections.add(
        Expanded(
          flex: ((metadata.end - metadata.start) *
                  totalWidth ~/
                  testMetadata.last.end)
              .toInt(),
          child: Container(
            decoration: BoxDecoration(
                color: metadata.color,
                //only rounding the left and right edges
                borderRadius: metadata == testMetadata.first 
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15))
                    : metadata == testMetadata.last
                        ? const BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15))
                        : BorderRadius.circular(0)),
          ),
        ),
      );
    }
    return sections;
  }

  //Defining _BuildPointerPosition() : Pointer marker position based on the value input
  List<Widget> _buildPointerPosition(double value, BuildContext context) {
    List<Widget> sections = [];
    double totalWidth = MediaQuery.of(context).size.width - 40;
    sections.add(
      Expanded(
        flex: ((value / testMetadata.last.end) * totalWidth).toInt(),
        child: Container(
            // alignment: Alignment.centerRight,
            color: Colors.red),
      ),
    );
    sections.add(
      Column(children: [
        const Icon(
          Icons.arrow_drop_up,
          size: 20,
        ),
        Text(
          value.toInt().toString(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        )
      ]),
    );
    sections.add(
      Expanded(
        flex: (((testMetadata.last.end - value) / testMetadata.last.end) *
                totalWidth)
            .toInt(),
        child: Container(),
      ),
    );

    return sections;
  }
}

//Defining the TextField Widget
class TextFieldWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<double> pointerValue;
  final testMetadata = a_test_metadata;


  TextFieldWidget({super.key, required this.pointerValue});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              child: TextFormField(
                controller: _controller,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),

                keyboardType: TextInputType.number,
                //Handling input field validations
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a value';
                  }
                  final double parsedValue = double.tryParse(value)!;
                  if (parsedValue < testMetadata.first.start || parsedValue > testMetadata.last.end) {
                    return 'Value must be between 0 and 120';
                  }
                  return null; // Return null for valid input
                },
                // // If we uncomment the section below, we can see the pointer shifting 
                // // as soon as we enter some value in the input field, instead of doing button's onPress()
                //
                // onChanged: (value) {
                //   double parsedValue = double.tryParse(value) ?? 0;
                //   pointerValue.value = parsedValue;
                // },
                //
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            IconButton(
              icon: const Icon(
                Icons.arrow_circle_right_rounded,
                size: 40,
              ),
              color: Colors.black,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Form is valid, perform action here
                  double parsedValue = double.tryParse(_controller.value.text) ?? 0;
                  // Perform action with the valid value
                  pointerValue.value = parsedValue;
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
