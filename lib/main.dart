import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shader_example/my_shader/umbra_shader_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UmbraShaderView(),
    );
  }
}

class ShaderExample extends StatefulWidget {
  const ShaderExample({
    Key? key,
  }) : super(key: key);

  @override
  State<ShaderExample> createState() => _ShaderExampleState();
}

class _ShaderExampleState extends State<ShaderExample> {
  Future<ui.FragmentProgram> compileShader() async {
    final ByteData data = await rootBundle.load('assets/shader.sprv');
    final fragmentProgram =
        await ui.FragmentProgram.compile(spirv: data.buffer);

    return fragmentProgram;
  }

  @override
  void initState() {
    super.initState();
    compileShader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ui.FragmentProgram>(
        future: compileShader(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ShaderMask(
              child: const SizedBox.expand(
                child: ColoredBox(
                  color: Colors.white,
                ),
              ),
              shaderCallback: (rect) {
                return snapshot.data!.shader(
                  floatUniforms: Float32List.fromList(
                    [
                      0,
                      0,
                      1,
                    ],
                  ),
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
