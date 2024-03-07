import 'package:bar_widget_neodocs/models/commonTestMetadataTemplate.dart';
import 'package:flutter/material.dart';

//Here we can define the metadata for different types of test. 
//Since the format is same for all tests, we use the same class template.

//ASSUMPTIONS: MetaData for any test is provided, sorted in ascending order of its ranges.

var a_test_metadata = [
  CommonTestMetaDataTemplate(0, 30, "Dangerous", Colors.red),
  CommonTestMetaDataTemplate(30, 40, "Moderate", Colors.amberAccent),
  CommonTestMetaDataTemplate(40, 60, "Ideal", Colors.green),
  CommonTestMetaDataTemplate(60, 70, "Moderate", Colors.amberAccent),
  CommonTestMetaDataTemplate(70, 120, "Dangerous", Colors.red),
];

var b_test_metadata = [
  CommonTestMetaDataTemplate(0, 100, "Dangerous", Colors.red),
  CommonTestMetaDataTemplate(100, 130, "Moderate", Colors.amberAccent),
  CommonTestMetaDataTemplate(130, 180, "Ideal", Colors.green),
  CommonTestMetaDataTemplate(180, 210, "Moderate", Colors.amberAccent),
  CommonTestMetaDataTemplate(210, 300, "Dangerous", Colors.red),
];
