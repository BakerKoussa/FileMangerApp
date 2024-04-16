import 'dart:io';

import 'package:file_manager_app/controller/files_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:storage_info/storage_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockStorageInfo extends Mock implements StorageInfo {
  Future<double> get getStorageTotalSpaceInGB async => 10.0;
  Future<double> get getStorageFreeSpaceInGB async => 5.0;
}

void main() {
  group('FilesController', () {
    test('calculateSize calculates size for documents', () async {
      final entities = [
        File('/storage/emulated/0/Documents/test.pdf'), // Adjust size as needed
        File(
            '/storage/emulated/0/Videos/video.mp4'), // Keep video file for other tests
      ];

      final controller = FilesController();
      controller.calculateSize(entities);

      expect(controller.documentSize, closeTo(-0.000001, 0.000001));
    });

    testWidgets('sort function shows a dialog', (WidgetTester tester) async {
      final controller = FilesController();
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () => controller.sort(context),
                child: const Text('Sort'),
              );
            },
          ),
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(Dialog), findsOneWidget);
    });

    group('FilesController', () {
      test(
          'calculateSize updates documentSize, videoSize, imageSize, and soundSize',
          () async {
        // Create a list of mock FileSystemEntity objects
        final entities = [
          File('test.pdf')..writeAsStringSync(' ' * 1000000), // 1 MB
          File('video.mp4')..writeAsStringSync(' ' * 2000000), // 2 MB
          File('image.jpg')..writeAsStringSync(' ' * 3000000), // 3 MB
          File('sound.mp3')..writeAsStringSync(' ' * 4000000), // 4 MB
        ];

        // Create an instance of FilesController
        final controller = FilesController();

        // Call the function
        controller.calculateSize(entities);

        // Verify updates
        expect(controller.documentSize, 1.0);
        expect(controller.videoSize, 2.0);
        expect(controller.imageSize, 3.0);
        expect(controller.soundSize, 4.0);
      });
    });
  });
}
