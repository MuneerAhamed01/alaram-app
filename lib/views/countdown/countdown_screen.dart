import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:alaram_app/views/countdown/contdown_controller.dart';

class CountdownScreen extends GetView<CountdownController> {
  const CountdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CountdownController>(
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                const Text(
                  'CountDown',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 20),
                if (!controller.isRunning) ...[
                  SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTimePicker(
                          'Hrs.',
                          23,
                          (value) => controller.hours = value,
                        ),
                        _buildTimePicker(
                          'Mins.',
                          59,
                          (value) => controller.minutes = value,
                        ),
                        _buildTimePicker(
                          'Secs.',
                          59,
                          (value) => controller.seconds = value,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStartTimer()
                ] else ...[
                  Center(
                    child: Text(
                      '${controller.hours.toString().padLeft(2, '0')}:${controller.minutes.toString().padLeft(2, '0')}:${controller.seconds.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // _buildResetTimer(),
                  // const SizedBox(height: 20),
                  _buildDeleteTimer()
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Padding _buildStartTimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: controller.onStartTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Start Countdown'),
        ),
      ),
    );
  }

  Padding _buildDeleteTimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: controller.onDeleteTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          child: const Text('Delete'),
        ),
      ),
    );
  }

  Padding _buildResetTimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: const Text('Reset'),
        ),
      ),
    );
  }

  Widget _buildTimePicker(String label, int maxValue, Function(int) onChanged) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32,
              onSelectedItemChanged: (index) => onChanged(index),
              children: List.generate(
                maxValue + 1,
                (index) => Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          Text(label),
        ],
      ),
    );
  }
}
