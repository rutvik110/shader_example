import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ShaderExample(title: 'Flutter Demo Home Page'),
    );
  }
}

class ShaderExample extends StatefulWidget {
  const ShaderExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ShaderExample> createState() => _ShaderExampleState();
}

class _ShaderExampleState extends State<ShaderExample> {
  Future<ui.FragmentProgram> compileShader() async {
    final ByteData data = await rootBundle.load('shaders/gradient_shader.frag');
    final fragmentProgram =
        await ui.FragmentProgram.compile(spirv: data.buffer);

    return fragmentProgram;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    compileShader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<ui.FragmentProgram>(
        future: compileShader(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final resolution = MediaQuery.of(context).size;
            return ShaderMask(
              child: const SizedBox.expand(
                child: ColoredBox(
                  color: Colors.white,
                ),
              ),
              shaderCallback: (rect) {
                return snapshot.data!.shader(
                  floatUniforms: Float32List.fromList([
                    resolution.width,
                    resolution.height,
                  ]),
                  samplerUniforms: [],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
