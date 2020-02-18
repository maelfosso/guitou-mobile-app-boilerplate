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
        XormQuestionString(id: "section_final__name", title: "Enter your name", hint: "", type: "string"),
        XormQuestionOptional(id: "section_final__again", title: "Are you going to enter another data?", hint: "", type: "optional")
      ]
    );

    final List<XormSection> sections = parsedJson.entries
      .map((entry) => XormSection.fromJson(entry.key, entry.value))
      .toList();
    sections.add(finalSection);

    return new XormDetails(
      id: id,
      sections: sections
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
            default:
              return null; 
          }
        })
        .toList()
    );
  }

  GlobalKey<FormBuilderState> get sectionKey {
    return _fbKey;
  }

  Widget build({ Map<String, dynamic> data }) {
    return FormBuilder(
      key: _fbKey,
      initialValue: data,
      autovalidate: true,
      child: Column(
        children: this.questions.map((q) => q.build()).toList()
      )
    );
  }
}

class XormSectionParams {
  final String title;
  final String description;
  final String key;

  XormSectionParams({this.title, this.key, this.description});

  factory XormSectionParams.fromJson(Map<String, dynamic> json) {
    return new XormSectionParams(
      title: json['title'] as String,
      description: json['description'] as String,
      key: json['key'] as String,
    );
  }
}

abstract class XormQuestion {
  String id;
  String title;
  String hint;
  String type;

  XormQuestion({this.id, this.title, this.hint, this.type});

  Widget build();
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
  Widget build() {
    // TODO: implement build
    return FormBuilderTextField(
      attribute: this.id,
      decoration: InputDecoration(labelText: this.title),
      maxLines: 1,
      // validators: [
      //   FormBuilderValidators.numeric(),
      //   FormBuilderValidators.max(70),
      // ],
    );
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
  Widget build() {
    // TODO: implement build
    return FormBuilderTextField(
      attribute: this.id,
      decoration: InputDecoration(labelText: this.title),
      minLines: 3,
      // validators: [
      //   FormBuilderValidators.numeric(),
      //   FormBuilderValidators.max(70),
      // ],
    );
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
  Widget build() {
    // TODO: implement build
    return FormBuilderDateTimePicker(
      attribute: this.id,
      inputType: InputType.date,
      format: DateFormat("yyyy-MM-dd"),
      decoration: InputDecoration(labelText: this.title),
    );
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
  Widget build() {
    // TODO: implement build
    return FormBuilderDateTimePicker(
      attribute: this.id,
      inputType: InputType.time,
      format: DateFormat("HH:mm"),
      decoration: InputDecoration(labelText: this.title),
    );
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
  Widget build() {
    // TODO: implement build
    return FormBuilderCheckbox(
      attribute: this.id,
      label: Text(this.title),
      
      // validators: [
      //   // FormBuilderValidators.requiredTrue(
      //   //   errorText: this.errorMessage
      //   //       // "You must accept terms and conditions to continue",
      //   // ),
      // ],
    );
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
  Widget build() {
    // TODO: implement build
    return FormBuilderDropdown(
      attribute: this.id,
      decoration: InputDecoration(labelText: this.title),
      // initialValue: 'Male',
      hint: Text('Select a choice'),
      // validators: [FormBuilderValidators.required()],
      items: this.kv.entries // ['Male', 'Female', 'Other']
        .map((entry) => DropdownMenuItem(
            value: entry.key,
            child: Text(entry.value)
      )).toList(),
    );
  }

}
