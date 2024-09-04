import 'dart:convert';

import 'package:codec_utils/src/codecs/uniform_resource/ur.dart';
import 'package:codec_utils/src/codecs/uniform_resource/ur_encoder.dart';
import 'package:test/test.dart';

void main() {
  UR actualUR = UR(
    type: 'eth-sign-request',
    serializedCbor: base64Decode(
        'pQHYJVAH4Ok7f7JAS5G9BEpPrwpuAlkBTldlbGNvbWUgdG8gT3BlblNlYSEKCkNsaWNrIHRvIHNpZ24gaW4gYW5kIGFjY2VwdCB0aGUgT3BlblNlYSBUZXJtcyBvZiBTZXJ2aWNlIChodHRwczovL29wZW5zZWEuaW8vdG9zKSBhbmQgUHJpdmFjeSBQb2xpY3kgKGh0dHBzOi8vb3BlbnNlYS5pby9wcml2YWN5KS4KClRoaXMgcmVxdWVzdCB3aWxsIG5vdCB0cmlnZ2VyIGEgYmxvY2tjaGFpbiB0cmFuc2FjdGlvbiBvciBjb3N0IGFueSBnYXMgZmVlcy4KCldhbGxldCBhZGRyZXNzOgoweGQ2YzYzMjY1ODU3YzUxZWU3OTQ5NjRkMmY5ODQzMWIwMmRiODdlZTcKCk5vbmNlOgo3Mjk3NmEzOS1jMjQ5LTQzMzYtYjkzNS1hNmRjNTFlNjI3NTUDAwXZATCiAYoYLPUYPPUA9QD0APQCGpddTfEGVNbGMmWFfFHueUlk0vmEMbAtuH7n'),
  );

  group('Tests of UREncoder.encodeWhole() process', () {
    group('Tests for simple UR (single-fragment)', () {
      UREncoder actualUREncoder = UREncoder(ur: actualUR, maxFragmentLength: 1000);

      test('Should [return 1] as total fragments [length == 1]', () {
        // Act
        int actualLength = actualUREncoder.fragmentsCount;

        // Assert
        int expectedLength = 1;

        expect(actualLength, expectedLength);
      });

      test('Should [return list] with single UR element', () {
        // Act
        List<String> actualParts = actualUREncoder.encodeWhole();

        // Assert
        List<String> expectedParts = <String>[
          'UR:ETH-SIGN-REQUEST/ONADTPDAGDATVTWLFRLBPRFZGRMERYAAGEGWPEBKJTAOHKADGLHGIHJZIAJLJNIHCXJYJLCXGWJOIHJTGUIHHSCLBKBKFXJZINIAJECXJYJLCXJKINIOJTCXINJTCXHSJTIECXHSIAIAIHJOJYCXJYISIHCXGWJOIHJTGUIHHSCXGHIHJPJNJKCXJLIYCXGUIHJPKOINIAIHCXDEISJYJYJOJKFTDLDLJLJOIHJTJKIHHSDMINJLDLJYJLJKDTCXHSJTIECXGDJPINKOHSIAKKCXGDJLJZINIAKKCXDEISJYJYJOJKFTDLDLJLJOIHJTJKIHHSDMINJLDLJOJPINKOHSIAKKDTDMBKBKGHISINJKCXJPIHJSKPIHJKJYCXKTINJZJZCXJTJLJYCXJYJPINIOIOIHJPCXHSCXIDJZJLIAJEIAISHSINJTCXJYJPHSJTJKHSIAJYINJLJTCXJLJPCXIAJLJKJYCXHSJTKKCXIOHSJKCXIYIHIHJKDMBKBKHGHSJZJZIHJYCXHSIEIEJPIHJKJKFTBKDYKSIEENIAENEOEYENECETECEMIAECEHIHIHEMESEEESENEEIEEYIYESETEEEOEHIDDYEYIEIDETEMIHIHEMBKBKGLJLJTIAIHFTBKEMEYESEMENHSEOESDPIAEYEEESDPEEEOEOENDPIDESEOECDPHSENIEIAECEHIHENEYEMECECAXAXAHTAADDYOEADLECSDWYKCSFNYKAEYKAEWKAEWKAOCYMSHLGTWNAMGHTBSWEYIHLPKEGYWYKKGAIETDYTLREHPFDPROKBVDOYMNEOAM',
        ];

        expect(actualParts, expectedParts);
      });
    });

    group('Tests for simple UR (multi-fragments)', () {
      UREncoder actualUREncoder = UREncoder(ur: actualUR, maxFragmentLength: 100);

      test('Should [return 5] as total fragments [length == 5]', () {
        // Act
        int actualLength = actualUREncoder.fragmentsCount;

        // Assert
        int expectedLength = 5;

        expect(actualLength, expectedLength);
      });

      test('Should [return list] with 5 UR elements', () {
        // Act
        List<String> actualParts = actualUREncoder.encodeWhole();

        // Assert
        List<String> expectedParts = <String>[
          'UR:ETH-SIGN-REQUEST/1-5/LPADAHCFADMKCYOYMNEOAMHDGMONADTPDAGDATVTWLFRLBPRFZGRMERYAAGEGWPEBKJTAOHKADGLHGIHJZIAJLJNIHCXJYJLCXGWJOIHJTGUIHHSCLBKBKFXJZINIAJECXJYJLCXJKINIOJTCXINJTCXHSJTIECXHSIAIAIHJOJYCXJYISIHCXGWJOIHJTKGSFCTBN',
          'UR:ETH-SIGN-REQUEST/2-5/LPAOAHCFADMKCYOYMNEOAMHDGMGUIHHSCXGHIHJPJNJKCXJLIYCXGUIHJPKOINIAIHCXDEISJYJYJOJKFTDLDLJLJOIHJTJKIHHSDMINJLDLJYJLJKDTCXHSJTIECXGDJPINKOHSIAKKCXGDJLJZINIAKKCXDEISJYJYJOJKFTDLDLJLJOIHJTJKIHHSDMGTTAPDWL',
          'UR:ETH-SIGN-REQUEST/3-5/LPAXAHCFADMKCYOYMNEOAMHDGMINJLDLJOJPINKOHSIAKKDTDMBKBKGHISINJKCXJPIHJSKPIHJKJYCXKTINJZJZCXJTJLJYCXJYJPINIOIOIHJPCXHSCXIDJZJLIAJEIAISHSINJTCXJYJPHSJTJKHSIAJYINJLJTCXJLJPCXIAJLJKJYCXHSJTKKCXIONTLNDEPY',
          'UR:ETH-SIGN-REQUEST/4-5/LPAAAHCFADMKCYOYMNEOAMHDGMHSJKCXIYIHIHJKDMBKBKHGHSJZJZIHJYCXHSIEIEJPIHJKJKFTBKDYKSIEENIAENEOEYENECETECEMIAECEHIHIHEMESEEESENEEIEEYIYESETEEEOEHIDDYEYIEIDETEMIHIHEMBKBKGLJLJTIAIHFTBKEMEYESEMENCHCFRESF',
          'UR:ETH-SIGN-REQUEST/5-5/LPAHAHCFADMKCYOYMNEOAMHDGMHSEOESDPIAEYEEESDPEEEOEOENDPIDESEOECDPHSENIEIAECEHIHENEYEMECECAXAXAHTAADDYOEADLECSDWYKCSFNYKAEYKAEWKAEWKAOCYMSHLGTWNAMGHTBSWEYIHLPKEGYWYKKGAIETDYTLREHPFDPROKBVDAEAEFTFNHHSR',
        ];

        expect(actualParts, expectedParts);
      });
    });
  });

  group('Tests of UREncoder.nextPart() process', () {
    group('Tests for simple UR (single-fragment)', () {
      UREncoder actualUREncoder = UREncoder(ur: actualUR, maxFragmentLength: 1000);

      test('Should [return 1] as total fragments [length == 1]', () {
        // Act
        int actualLength = actualUREncoder.fragmentsCount;

        // Assert
        int expectedLength = 1;

        expect(actualLength, expectedLength);
        expect(actualUREncoder.isComplete, false);
      });

      test('Should [return UR element] without sequence number', () {
        // Act
        String actualPart = actualUREncoder.nextPart();

        // Assert
        String expectedPart =
            'UR:ETH-SIGN-REQUEST/ONADTPDAGDATVTWLFRLBPRFZGRMERYAAGEGWPEBKJTAOHKADGLHGIHJZIAJLJNIHCXJYJLCXGWJOIHJTGUIHHSCLBKBKFXJZINIAJECXJYJLCXJKINIOJTCXINJTCXHSJTIECXHSIAIAIHJOJYCXJYISIHCXGWJOIHJTGUIHHSCXGHIHJPJNJKCXJLIYCXGUIHJPKOINIAIHCXDEISJYJYJOJKFTDLDLJLJOIHJTJKIHHSDMINJLDLJYJLJKDTCXHSJTIECXGDJPINKOHSIAKKCXGDJLJZINIAKKCXDEISJYJYJOJKFTDLDLJLJOIHJTJKIHHSDMINJLDLJOJPINKOHSIAKKDTDMBKBKGHISINJKCXJPIHJSKPIHJKJYCXKTINJZJZCXJTJLJYCXJYJPINIOIOIHJPCXHSCXIDJZJLIAJEIAISHSINJTCXJYJPHSJTJKHSIAJYINJLJTCXJLJPCXIAJLJKJYCXHSJTKKCXIOHSJKCXIYIHIHJKDMBKBKHGHSJZJZIHJYCXHSIEIEJPIHJKJKFTBKDYKSIEENIAENEOEYENECETECEMIAECEHIHIHEMESEEESENEEIEEYIYESETEEEOEHIDDYEYIEIDETEMIHIHEMBKBKGLJLJTIAIHFTBKEMEYESEMENHSEOESDPIAEYEEESDPEEEOEOENDPIDESEOECDPHSENIEIAECEHIHENEYEMECECAXAXAHTAADDYOEADLECSDWYKCSFNYKAEYKAEWKAEWKAOCYMSHLGTWNAMGHTBSWEYIHLPKEGYWYKKGAIETDYTLREHPFDPROKBVDOYMNEOAM';

        expect(actualPart, expectedPart);
        expect(actualUREncoder.isComplete, true);
      });

      test('Should [repeat UR element] without sequence number', () {
        // Act
        String actualPart = actualUREncoder.nextPart();

        // Assert
        String expectedPart =
            'UR:ETH-SIGN-REQUEST/ONADTPDAGDATVTWLFRLBPRFZGRMERYAAGEGWPEBKJTAOHKADGLHGIHJZIAJLJNIHCXJYJLCXGWJOIHJTGUIHHSCLBKBKFXJZINIAJECXJYJLCXJKINIOJTCXINJTCXHSJTIECXHSIAIAIHJOJYCXJYISIHCXGWJOIHJTGUIHHSCXGHIHJPJNJKCXJLIYCXGUIHJPKOINIAIHCXDEISJYJYJOJKFTDLDLJLJOIHJTJKIHHSDMINJLDLJYJLJKDTCXHSJTIECXGDJPINKOHSIAKKCXGDJLJZINIAKKCXDEISJYJYJOJKFTDLDLJLJOIHJTJKIHHSDMINJLDLJOJPINKOHSIAKKDTDMBKBKGHISINJKCXJPIHJSKPIHJKJYCXKTINJZJZCXJTJLJYCXJYJPINIOIOIHJPCXHSCXIDJZJLIAJEIAISHSINJTCXJYJPHSJTJKHSIAJYINJLJTCXJLJPCXIAJLJKJYCXHSJTKKCXIOHSJKCXIYIHIHJKDMBKBKHGHSJZJZIHJYCXHSIEIEJPIHJKJKFTBKDYKSIEENIAENEOEYENECETECEMIAECEHIHIHEMESEEESENEEIEEYIYESETEEEOEHIDDYEYIEIDETEMIHIHEMBKBKGLJLJTIAIHFTBKEMEYESEMENHSEOESDPIAEYEEESDPEEEOEOENDPIDESEOECDPHSENIEIAECEHIHENEYEMECECAXAXAHTAADDYOEADLECSDWYKCSFNYKAEYKAEWKAEWKAOCYMSHLGTWNAMGHTBSWEYIHLPKEGYWYKKGAIETDYTLREHPFDPROKBVDOYMNEOAM';

        expect(actualPart, expectedPart);
        expect(actualUREncoder.isComplete, true);
      });

      test('Should [reset encoder state]', () {
        // Act
        actualUREncoder.reset();

        // Assert
        expect(actualUREncoder.isComplete, false);
      });
    });

    group('Tests for simple UR (multi-fragments)', () {
      UREncoder actualUREncoder = UREncoder(ur: actualUR, maxFragmentLength: 100);

      test('Should [return 5] as total fragments [length == 5]', () {
        // Act
        int actualLength = actualUREncoder.fragmentsCount;

        // Assert
        int expectedLength = 5;

        expect(actualLength, expectedLength);
        expect(actualUREncoder.isComplete, false);
      });

      test('Should [return 1st UR element] with sequence number [1-5]', () {
        // Act
        String actualPart = actualUREncoder.nextPart();

        // Assert
        String expectedPart =
            'UR:ETH-SIGN-REQUEST/1-5/LPADAHCFADMKCYOYMNEOAMHDGMONADTPDAGDATVTWLFRLBPRFZGRMERYAAGEGWPEBKJTAOHKADGLHGIHJZIAJLJNIHCXJYJLCXGWJOIHJTGUIHHSCLBKBKFXJZINIAJECXJYJLCXJKINIOJTCXINJTCXHSJTIECXHSIAIAIHJOJYCXJYISIHCXGWJOIHJTKGSFCTBN';

        expect(actualPart, expectedPart);
        expect(actualUREncoder.isComplete, false);
      });

      test('Should [return 2nd UR element] with sequence number [2-5]', () {
        // Act
        String actualPart = actualUREncoder.nextPart();

        // Assert
        String expectedPart =
            'UR:ETH-SIGN-REQUEST/2-5/LPAOAHCFADMKCYOYMNEOAMHDGMGUIHHSCXGHIHJPJNJKCXJLIYCXGUIHJPKOINIAIHCXDEISJYJYJOJKFTDLDLJLJOIHJTJKIHHSDMINJLDLJYJLJKDTCXHSJTIECXGDJPINKOHSIAKKCXGDJLJZINIAKKCXDEISJYJYJOJKFTDLDLJLJOIHJTJKIHHSDMGTTAPDWL';

        expect(actualPart, expectedPart);
        expect(actualUREncoder.isComplete, false);
      });

      test('Should [return 3rd UR element] with sequence number [3-5]', () {
        // Act
        String actualPart = actualUREncoder.nextPart();

        // Assert
        String expectedPart =
            'UR:ETH-SIGN-REQUEST/3-5/LPAXAHCFADMKCYOYMNEOAMHDGMINJLDLJOJPINKOHSIAKKDTDMBKBKGHISINJKCXJPIHJSKPIHJKJYCXKTINJZJZCXJTJLJYCXJYJPINIOIOIHJPCXHSCXIDJZJLIAJEIAISHSINJTCXJYJPHSJTJKHSIAJYINJLJTCXJLJPCXIAJLJKJYCXHSJTKKCXIONTLNDEPY';

        expect(actualPart, expectedPart);
        expect(actualUREncoder.isComplete, false);
      });

      test('Should [return 4th UR element] with sequence number [4-5]', () {
        // Act
        String actualPart = actualUREncoder.nextPart();

        // Assert
        String expectedPart =
            'UR:ETH-SIGN-REQUEST/4-5/LPAAAHCFADMKCYOYMNEOAMHDGMHSJKCXIYIHIHJKDMBKBKHGHSJZJZIHJYCXHSIEIEJPIHJKJKFTBKDYKSIEENIAENEOEYENECETECEMIAECEHIHIHEMESEEESENEEIEEYIYESETEEEOEHIDDYEYIEIDETEMIHIHEMBKBKGLJLJTIAIHFTBKEMEYESEMENCHCFRESF';

        expect(actualPart, expectedPart);
        expect(actualUREncoder.isComplete, false);
      });

      test('Should [return 5th UR element] with sequence number [5-5]', () {
        // Act
        String actualPart = actualUREncoder.nextPart();

        // Assert
        String expectedPart =
            'UR:ETH-SIGN-REQUEST/5-5/LPAHAHCFADMKCYOYMNEOAMHDGMHSEOESDPIAEYEEESDPEEEOEOENDPIDESEOECDPHSENIEIAECEHIHENEYEMECECAXAXAHTAADDYOEADLECSDWYKCSFNYKAEYKAEWKAEWKAOCYMSHLGTWNAMGHTBSWEYIHLPKEGYWYKKGAIETDYTLREHPFDPROKBVDAEAEFTFNHHSR';

        expect(actualPart, expectedPart);
        expect(actualUREncoder.isComplete, true);
      });

      test('Should [reset encoder state]', () {
        // Act
        actualUREncoder.reset();

        // Assert
        expect(actualUREncoder.isComplete, false);
      });
    });
  });
}
