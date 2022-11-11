import 'package:flutter/material.dart';
import 'package:shader_example/my_shader/my_shader.dart';
import 'package:umbra_flutter/umbra_flutter.dart';

class UmbraShaderView extends StatefulWidget {
  const UmbraShaderView({Key? key}) : super(key: key);

  @override
  State<UmbraShaderView> createState() => _MyShaderState();
}

class _MyShaderState extends State<UmbraShaderView> {
  late Future<MyShader> helloWorld;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    helloWorld = MyShader.compile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<MyShader>(
        future: helloWorld,
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
                  resolution: rect.size,
                  color: Vector3(
                    0.6,
                    0,
                    1,
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
