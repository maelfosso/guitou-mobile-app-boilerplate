import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class XormDetails {
  final String id;
  List<XormSection> sections;

  XormDetails({this.id, this.sections});

  factory XormDetails.fromJson(String id, Map<String, dynamic> parsedJson) {

    final XormSection finalSection = XormSection(
      id: "section_final",
      params: XormSectionParams(
        key: "section_final", 
        title: "Thank you for filling that form", 
        description: "Please, sign here to confirm your data entry and then validate"
      ),
      questions: <XormQuestion>[
        XormQuestionString(id: "section_final__name", title: "Your name", hint: "", type: "string"),
        XormQuestionText(id: "section_final__obs", title: "Your observations", hint: "", type: "text"),
        XormQuestionOptional(id: "section_final__again", title: "Are you going to enter another data?", hint: "", type: "optional"),
      ]
    );

    final List<XormSection> sections = parsedJson.entries
      .map((entry) => XormSection.fromJson(entry.key, entry.value))
      .toList();
    if (sections.last.id != 'section_final') {
      sections.add(finalSection);
    }
    

    return new XormDetails(
      id: id,
      sections: sections
    );
  }

  Map<String, dynamic> toJson() {
    return Map.fromIterable(sections, 
      key: (d) => d.id,
      value: (d) => d.toJson()
    );
    // { id: sections };
    // {
    //   "id": id,
    //   "sections": sections
    // };
  }

  Widget view(Map data) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final section = this.sections[index];
        
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                section.params.title.trim(),
                style: Theme.of(context).textTheme.title,
              ),
              Text(
                section.params.description.trim(),
                style: Theme.of(context).textTheme.subtitle,
              ),

              section.view(data[section.id])
            ],
          ),
        );
      },
      itemCount: this.sections.length,
    );
  }
}

class XormSection {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final String id;
  final XormSectionParams params;
  final List<XormQuestion> questions;
  
  XormSection({this.id, this.params, this.questions});

  factory XormSection.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormSection(
      id: id,
      params: XormSectionParams.fromJson(parsedJson['_params']),
      questions: Map<String, dynamic>.from(parsedJson['questions'])
        .entries.map((entry) {
          String type = entry.value['type'];

          switch (type) {
            case 'string':
              return XormQuestionString.fromJson(entry.key, entry.value);
            case 'number':
              return XormQuestionNumber.fromJson(entry.key, entry.value);
            case 'text':
              return XormQuestionText.fromJson(entry.key, entry.value);
            case 'date':
              return XormQuestionDate.fromJson(entry.key, entry.value);
            case 'time':
              return XormQuestionTime.fromJson(entry.key, entry.value);
            case 'optional':
              return XormQuestionOptional.fromJson(entry.key, entry.value);
            case 'single_choice_select':
              return XormQuestionSingleChoiceSelect.fromJson(entry.key, entry.value);
            case 'single_choice':
              return XormQuestionSingleChoice.fromJson(entry.key, entry.value);
            case 'yes-no':
              return XormQuestionYesNo.fromJson(entry.key, entry.value);
            case 'yes-no-dont':
              return XormQuestionYesNoDont.fromJson(entry.key, entry.value);
            case 'multiple_choice':
              return XormQuestionMultipleChoice.fromJson(entry.key, entry.value);
            case 'tidesc':
              return XormQuestionTitleDesc.fromJson(entry.key, entry.value);     
            case 'datatable':
              return XormQuestionDatatable.fromJson(entry.key, entry.value);            
            default:
              return XormQuestionString.fromJson(entry.key, entry.value); 
          }
        })
        .toList()
    );
  }

  GlobalKey<FormBuilderState> get sectionKey {
    return _fbKey;
  }

  Widget build({ @required BuildContext context, @required GlobalKey<FormBuilderState> globalKey, Map<String, dynamic> data }) {
    print("\nBUILD.... \t ${id}");
    print(data);
    print("\n");
    print(toJson());
    print("\nNOW IS FORMBUILDER.... \n");

    return FormBuilder(
      key: globalKey,
      initialValue: data.map((key, value) {
        print("\nBUILDING INITIAL VIEW - ${key} - ${value}");
        XormQuestion q = this.questions.firstWhere(
          (q) => q.id == key || key.startsWith(q.id),
          orElse: () => null
        );
        switch (q.type) {
          case 'string':
            return MapEntry(key, value);
          case 'number':
            return MapEntry(key, value);
          case 'text':
            return MapEntry(key, value);
          case 'date':
            return MapEntry(key, DateTime.tryParse(value));
          case 'time':
            return MapEntry(key, DateTime.tryParse(value));
          case 'optional':
            return MapEntry(key, value.toString().toLowerCase() == 'true');
          case 'single_choice_select':
            return MapEntry(key, value);
          case 'single_choice':
            return MapEntry(key, value);
          case 'yes-no':
            return MapEntry(key, value);
          case 'yes-no-dont':
            return MapEntry(key, value);
          case 'multiple_choice':
            return MapEntry(key, value);
          // case 'datatable':
          //   return ;
          default:
            return MapEntry(key, ""); 
        }
      }),
      autovalidate: true,
      child: Column(
        children: this.questions.map((q) => q.build(context: context)).toList()
      )
    );
  }

  Widget view(Object data) {
    print("\nVIEW SECTION .... ${id}\n");
    print(this.params.toJson());
    if (this.params.repeat ?? false) {
      print("\nIS REPEATED.... \n");
      return Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: questions.map((question) {
                return DataColumn(
                  label: Text(question.title)
                );
              })
              .toList(),
            rows: (data as List).map((datum) {
              return DataRow(
                selected: false,
                cells: datum.entries.map((entry) {
                  return DataCell(Text(entry.value));
                }).cast<DataCell>().toList()
              );
            }).cast<DataRow>().toList(),
          ),
        )
      );
    } else {
      print("\nIS SIMPLET....\n");

      
      return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: this.questions.length,
        itemBuilder: (context, index) {
          final question = this.questions[index];
          if (question.type == 'datatable') {
            Map<String, String> values = Map.from(data as Map);
            values.removeWhere((k, v) => !k.toString().startsWith(question.id));
              // .cast<Map<String, String>>();
            // Map.from(data)
              // .removeWhere((k, v) => k.toString().startsWith(question.id))
              // .map((k) => MapEntry<String, String>(k, (data as Map)[k]));
              // .cast<String, String>();
            return (question as XormQuestionDatatable).view(values);
          } else {
            return question.view((data as Map)[question.id]);
          }
          
        }
      );
    }
    
  }

  Map<String, dynamic> toJson() {
    return {
      "_params": params.toJson(),
      "questions": Map.fromIterable(questions, 
        key: (d) => d.id,
        value: (d) => d.toJson()
      )
    };
    // {
    //   "id": id,
    //   "_params": params,
    //   "questions": Map.fromIterable(questions, 
    //     key: (d) => d.id,
    //     value: (d) => d.sections
    //   )
    // };
  }
}

class XormSectionParams {
  final String title;
  final String description;
  final String key;
  final bool repeat;
  final String repeatMaxTimes; // Inner - Unlimitted - Fixed - Variable
  final String repeatMaxTimesInner;
  final String repeatMaxTimesVariable;
  int repeatMaxTimesFixed;

  XormSectionParams({
    @required this.title, 
    @required this.key, 
    @required this.description, 
    this.repeat = false, this.repeatMaxTimes,
    this.repeatMaxTimesInner, this.repeatMaxTimesFixed, this.repeatMaxTimesVariable
  });

  factory XormSectionParams.fromJson(Map<String, dynamic> json) {
    print("\nIN XORMS SECTION PARAM");
    print(json);

    return new XormSectionParams(
      title: json['title'] as String,
      description: json['description'] as String,
      key: json['key'] as String,
      repeat: json['repeat'] as bool,
      repeatMaxTimes: json['repeat_max_times'] as String,
      repeatMaxTimesInner: json['repeat_max_times_inner'] as String,
      repeatMaxTimesFixed: json['repeat_max_times_fixed'] as int,
      repeatMaxTimesVariable: json['repeat_max_times_variable'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "key": key,
      "repeat": repeat,
      "repeat_max_times": repeatMaxTimes,
      "repeat_max_times_inner": repeatMaxTimesInner,
      "repeat_max_times_fixed": repeatMaxTimesFixed,
      "repeat_max_times_variable": repeatMaxTimesVariable,
    };
  }
}

abstract class XormQuestion {
  String id;
  String title;
  String hint;
  String type;

  XormQuestion({this.id, this.title, this.hint, this.type});

  Widget build({ @required BuildContext context, String value });

  Widget view(String value) {
    print("\n QUESTION... Views... ${id}");
    print("${title} -- ${type}");
    print(value);
    
    return ListTile(
      title: Text(this.title),
      subtitle: Text(value),
      dense: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type
    };
  }

}

class XormQuestionTitleDesc extends XormQuestion {

  XormQuestionTitleDesc({String id, String title, String hint, String type}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionTitleDesc.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionTitleDesc(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type']
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.left,
          )
        ]
      )
    );
  }

  @override
  Widget view(String value) {
    return Text(title);
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type
    };
  }

}

class XormQuestionString extends XormQuestion {

  XormQuestionString({String id, String title, String hint, String type}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionString.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionString(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type']
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderTextField(
            attribute: this.id,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            ),
            maxLines: 1,
          ),
        ]
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type
    };
  }

}

class XormQuestionNumber extends XormQuestion {

  XormQuestionNumber({String id, String title, String hint, String type}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionNumber.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionNumber(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type']
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderTextField(
            attribute: this.id,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            ),
            maxLines: 1,
            validators: [
              FormBuilderValidators.numeric(errorText: "You should enter a number")
            ],
          )
        ]
      )
    );
    
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type
    };
  }

}

class XormQuestionText extends XormQuestion {
  XormQuestionText({String id, String title, String hint, String type}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionText.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionText(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type']
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderTextField(
            attribute: this.id,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            ),
            minLines: 5,
          )
        ]
      )
    );
    
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type
    };
  }

}

class XormQuestionDate extends XormQuestion {
  XormQuestionDate({String id, String title, String hint, String type}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionDate.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionDate(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type']
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderDateTimePicker(
            attribute: this.id,
            inputType: InputType.date,
            format: DateFormat("yyyy-MM-dd"),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            )
          )
        ]
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type
    };
  }

}

class XormQuestionTime extends XormQuestion {
  XormQuestionTime({String id, String title, String hint, String type}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionTime.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionTime(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type']
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderDateTimePicker(
            attribute: this.id,
            inputType: InputType.time,
            format: DateFormat("HH:mm"),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            )
          )
        ]
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type
    };
  }

}

class XormQuestionOptional extends XormQuestion {

  XormQuestionOptional({ String id, String title, String hint, String type }) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionOptional.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionOptional(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type'],
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderCheckbox(
            attribute: this.id,
            label: Text(this.title),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            )
          )
        ]
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type
    };
  }

}

class XormQuestionSingleChoiceSelect extends XormQuestion {
  Map<String, String> kv;

  XormQuestionSingleChoiceSelect({ String id, String title, String hint, String type, this.kv}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionSingleChoiceSelect.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionSingleChoiceSelect(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type'],
      kv: Map<String, String>.from(parsedJson['kv_full'])
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    List<DropdownMenuItem> items = this.kv.entries
        .map((entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value)
      )).toList();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderDropdown(
            attribute: this.id,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            ),
            initialValue: null,
            hint: Text('Select a choice'),
            items: items
          )
        ]
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type,
      "kv_full": kv
    };
  }

}

class XormQuestionSingleChoice extends XormQuestion {
  Map<String, String> kv;

  XormQuestionSingleChoice({ String id, String title, String hint, String type, this.kv}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionSingleChoice.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionSingleChoice(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type'],
      kv: Map<String, String>.from(parsedJson['kv_full'])
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    List<FormBuilderFieldOption> options = this.kv.entries
        .map((entry) => FormBuilderFieldOption(value: entry.value)).toList();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderRadio(
            attribute: this.id,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            ),
            initialValue: null,
            options: options,
          )
        ]
      )
    );
    
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type,
      "kv_full": kv
    };
  }

}

class XormQuestionYesNo extends XormQuestion {
  Map<String, String> kv;

  XormQuestionYesNo({ String id, String title, String hint, String type, this.kv}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionYesNo.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionYesNo(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type'],
      kv: Map<String, String>.from(parsedJson['kv_full'])
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    List<FormBuilderFieldOption> options = this.kv.entries
        .map((entry) => FormBuilderFieldOption(value: entry.value)).toList();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderRadio(
            attribute: this.id,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            ),
            initialValue: null,
            options: options,
          )
        ]
      )
    );
    
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type,
      "kv_full": kv
    };
  }

}

class XormQuestionYesNoDont extends XormQuestion {
  Map<String, String> kv;

  XormQuestionYesNoDont({ String id, String title, String hint, String type, this.kv}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionYesNoDont.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionYesNoDont(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type'],
      kv: Map<String, String>.from(parsedJson['kv_full'])
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    List<FormBuilderFieldOption> options = this.kv.entries
        .map((entry) => FormBuilderFieldOption(value: entry.value)).toList();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderRadio(
            attribute: this.id,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            ),
            initialValue: null,
            options: options,
          )
        ]
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type,
      "kv_full": kv
    };
  }

}

class XormQuestionMultipleChoice extends XormQuestion {
  Map<String, String> kv;

  XormQuestionMultipleChoice({ String id, String title, String hint, String type, this.kv}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionMultipleChoice.fromJson(String id, Map<String, dynamic> parsedJson) {
    return new XormQuestionMultipleChoice(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type'],
      kv: Map<String, String>.from(parsedJson['kv_full'])
    );
  }

  @override
  Widget build({ @required BuildContext context,  String value }) {
    List<FormBuilderFieldOption> options = this.kv.entries
        .map((entry) => FormBuilderFieldOption(value: entry.value)).toList();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          FormBuilderCheckboxList(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
              hasFloatingPlaceholder: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                gapPadding: 0.0
              )
            ),
            attribute: this.id,
            options: options,
          )
        ]
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type,
      "kv_full": kv
    };
  }

}

class XormQuestionDatatable extends XormQuestion {
  List<String> rows;
  List<String> cols;

  XormQuestionDatatable({ 
    String id, String title, String hint, String type, 
    @required this.rows, 
    @required this.cols}) : super(id: id, title:title, hint:hint, type:type);

  factory XormQuestionDatatable.fromJson(String id, Map<String, dynamic> parsedJson) {
    print("\nXormQuestionDataTable... ${id}");
    print(parsedJson);
    print(parsedJson["rows"]);
    print(parsedJson["cols"]);

    return new XormQuestionDatatable(
      id: id,
      title: parsedJson['title'],
      hint: parsedJson['hint'],
      type: parsedJson['type'],
      rows: (parsedJson['rows'] as List<dynamic>).map((r) {
        // print("\nDATA TABLE PARSING... ");
        // print(r);
        return (r as Map)['text'].toString();
      }).toList(),
      cols: (parsedJson['cols'] as List) //.map((c) => c.toString())
      .map((c) {
        print("\nDATA TABLE COLDD ---- ${c.toString()}");
        return (c as Map)['text'].toString();
      }).toList(),
    );
  }

  @override
  Widget build({ @required BuildContext context, String value }) {
    List<String> fullCols = [""];
    fullCols.addAll(cols);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.id + ".  " + this.title,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all()
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:  DataTable(
              columns: fullCols.map((col) {
                return DataColumn(
                  label: Text(col),

                );
              }).toList(),
              rows: rows.asMap().entries.map((row) {
                List<String> fullRow = [row.value];
                fullRow.addAll(List(cols.length).map((c) => ""));
                
                return DataRow(
                  selected: false,

                  cells: fullRow.asMap().entries.map((entry) {
                    if (entry.key == 0) {
                      return DataCell(
                        Text(entry.value)
                      );
                    } else {
                      return DataCell(
                        Container(
                          width: 100, //SET width
                          child: FormBuilderTextField(
                            attribute: "${this.id}__row_${row.key}__col_${entry.key}",
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
                              hasFloatingPlaceholder: false,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0)),
                                gapPadding: 0.0
                              )
                            ),
                          )
                        )
                      );
                    }
                    
                  }).cast<DataCell>().toList()
                );
              }).toList(),
            )
            )
          )
        ]
      )
    );
  }

  @override
  Widget view(Object values) {
    print("\nDATA TABLE VIEWS...");
    print(values);
    List<String> fullCols = [""];
    fullCols.addAll(cols);

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child:  DataTable(
          columns: fullCols.map((col) {
            return DataColumn(label: Text(col));
          }).toList(),
          rows: rows.asMap().entries.map((row) {
            List<String> fullRow = [row.value];
            fullRow.addAll(List(cols.length).map((c) => ""));
            
            return DataRow(
              selected: false,
              cells: fullRow.asMap().entries.map((entry) {
                if (entry.key == 0) {
                  return DataCell(
                    Text(entry.value)
                  );
                } else {
                  var id = "${this.id}__row_${row.key}__col_${entry.key}";
                  return DataCell(
                    Text((values as Map)[id].toString())
                  );  
                }
                              
              }).cast<DataCell>().toList()
            );
          }).toList(),
        )
      )
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // "id": id,
      "title": title,
      "hint": hint,
      "type": type,
      "rows": rows.map((r) {
        Map obj = {
          "text": r
        };
        return obj;
      }).toList(),
      "cols": cols.map((c) {
        Map obj = {
          "text": c
        };
        return obj;
      }).toList(),
    };
  }

}
