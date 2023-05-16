import 'package:flutter/material.dart';
import 'package:mp_flutter_runtime/mp_flutter_runtime.dart';
import 'package:mp_switch_runtime/mp_switch_runtime.dart';
// import 'package:mp_switch_runtime/mp_switch_runtime.dart';

class TemplateMethodChannel extends MPMethodChannel {
  TemplateMethodChannel() : super('com.mpflutter.templateMethodChannel');

  @override
  Future? onMethodCall(String method, params) async {
    print("method TemplateMethodChannel : "+method);

    if (method == 'getDeviceName') {
      return 'FlutterClient';
    }
    return super.onMethodCall(method, params);
  }
}

class TemplateFooView extends MPPlatformView {
  TemplateFooView({
    Key? key,
    Map? data,
    Map? parentData,
    required componentFactory,
  }) : super(
          key: key,
          data: data,
          parentData: parentData,
          componentFactory: componentFactory,
        );

  @override
  Future onMethodCall(String method, params) {
    // Handle method call here.
    return super.onMethodCall(method, params);
  }

  @override
  Widget builder(BuildContext context) {
    return Container(
      color: Colors.yellow,
    );
  }
}

class TemplateTextView extends MPPlatformView {
  TemplateTextView({
    Key? key,
    Map? data,
    Map? parentData,
    required componentFactory,
  }) : super(
    key: key,
    data: data,
    parentData: parentData,
    componentFactory: componentFactory,
  );

  @override
  Future onMethodCall(String method, params) {
    // Handle method call here.
    return super.onMethodCall(method, params);
  }

  @override
  Widget builder(BuildContext context) {
    return SizedBox(
                height: 40,
                width: 100,
                child: TextField(
                    controller: TextEditingController(),
                    focusNode: FocusNode(),
                    style: TextStyle()),

              );
  }
}

void extMain() {

  MPPluginRegister.registerChannel(
    'com.mpflutter.templateMethodChannel',
    () => TemplateMethodChannel(),
  );
  MPPluginRegister.registerPlatformView(
    'com.mpflutter.templateFooView',
    (key, data, parentData, componentFactory) => TemplateFooView(
      key: key,
      data: data,
      parentData: parentData,
      componentFactory: componentFactory,
    ),
  );
  MPPluginRegister.registerPlatformView(
    'com.mpflutter.templateTextView',
        (key, data, parentData, componentFactory) => TemplateTextView(
      key: key,
      data: data,
      parentData: parentData,
      componentFactory: componentFactory,
    ),
  );
  registerSwitch();

  // MPPluginRegister.registerPlatformView(
  //   'com.mpflutter.templateTextView',
  //       (key, data, parentData, componentFactory) =>
  //       SizedBox(
  //         height: 40,
  //         width: 100,
  //         child: TextField(
  //             controller: TextEditingController(),
  //             focusNode: FocusNode(),
  //             style: TextStyle()),
  //
  //       ),
  // );
}
