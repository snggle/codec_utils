import 'dart:convert';

import 'package:codec_utils/codec_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Tests of URDecoder process', () {
    group('Tests for simple UR (single-fragment)', () {
      URDecoder actualURDecoder = URDecoder();

      test('Should [return initial values] if no parts received', () {
        // Arrange
        expect(actualURDecoder.buildCborTaggedObject(), null);
        expect(actualURDecoder.buildUR(), null);
        expect(actualURDecoder.progress, 0.0);
        expect(actualURDecoder.estimatedPercentComplete, 0.0);
        expect(actualURDecoder.isComplete, false);
        expect(actualURDecoder.expectedPartCount, null);
      });

      test('Should [return complete values] if all fragments received (single part)', () async {
        // Act
        actualURDecoder.receivePart('ur:crypto-keypath/taaddyoeadlecsdwykcsfnykaeykaewkaewkaocymshlgtwnvejedtny');

        // Arrange
        CborCryptoKeypath expectedCborTaggedObject = const CborCryptoKeypath(
          components: <CborPathComponent>[
            CborPathComponent(index: 44, hardened: true),
            CborPathComponent(index: 60, hardened: true),
            CborPathComponent(index: 0, hardened: true),
            CborPathComponent(index: 0, hardened: false),
            CborPathComponent(index: 0, hardened: false)
          ],
          sourceFingerprint: 2539474417,
        );

        UR expectedUR = UR(
          type: 'crypto-keypath',
          serializedCbor: base64Decode('2QEwogGKGCz1GDz1APUA9AD0AhqXXU3x'),
        );

        expect(actualURDecoder.buildCborTaggedObject(), expectedCborTaggedObject);
        expect(actualURDecoder.buildUR(), expectedUR);
        expect(actualURDecoder.progress, 1.0);
        expect(actualURDecoder.estimatedPercentComplete, 1.0);
        expect(actualURDecoder.isComplete, true);
        expect(actualURDecoder.expectedPartCount, 1);
      });
    });

    group('Tests for simple UR (multi-fragment - within range)', () {
      URDecoder actualURDecoder = URDecoder();

      test('Should [return initial values] if no parts received', () {
        // Arrange
        expect(actualURDecoder.buildCborTaggedObject(), null);
        expect(actualURDecoder.buildUR(), null);
        expect(actualURDecoder.progress, 0.0);
        expect(actualURDecoder.estimatedPercentComplete, 0.0);
        expect(actualURDecoder.isComplete, false);
        expect(actualURDecoder.expectedPartCount, null);
      });

      test('Should [return actual values] after 1st fragment received (1/4)', () async {
        // Act
        actualURDecoder.receivePart('ur:crypto-hdkey/1-4/lpadaacsjpcyrkbedymnhdcaonaxhdclaxpsgefyjsutpfckcalydtgyjpamjlndfsetiyhtetaajprnzslkoxkkto');

        // Arrange
        expect(actualURDecoder.buildCborTaggedObject(), null);
        expect(actualURDecoder.buildUR(), null);
        expect(actualURDecoder.progress, 0.25);
        expect(actualURDecoder.estimatedPercentComplete, 0.14285714285714285);
        expect(actualURDecoder.isComplete, false);
        expect(actualURDecoder.expectedPartCount, 4);
      });

      test('Should [return actual values] after 2nd fragment received (2/4)', () async {
        // Act
        actualURDecoder.receivePart('ur:crypto-hdkey/2-4/lpaoaacsjpcyrkbedymnhdcaeokptbhnghasesiyaahdcxvabdvsmucpttaodrfyayrobwveasvefnrezsnelbpfdw');

        // Arrange
        expect(actualURDecoder.buildCborTaggedObject(), null);
        expect(actualURDecoder.buildUR(), null);
        expect(actualURDecoder.progress, 0.5);
        expect(actualURDecoder.estimatedPercentComplete, 0.2857142857142857);
        expect(actualURDecoder.isComplete, false);
        expect(actualURDecoder.expectedPartCount, 4);
      });

      test('Should [return actual values] after 4th fragment received (3/4)', () async {
        // Act
        actualURDecoder.receivePart('ur:crypto-hdkey/4-4/lpaaaacsjpcyrkbedymnhdcaaocynlzsiamnaycydyeeiyidasjnfpinjpflhsjocxdpcxjykthsjyaeaetidnyarh');

        // Arrange
        expect(actualURDecoder.buildCborTaggedObject(), null);
        expect(actualURDecoder.buildUR(), null);
        expect(actualURDecoder.progress, 0.75);
        expect(actualURDecoder.estimatedPercentComplete, 0.42857142857142855);
        expect(actualURDecoder.isComplete, false);
        expect(actualURDecoder.expectedPartCount, 4);
      });

      test('Should [return complete values] after 3rd fragment received (4/4)', () async {
        // Act
        actualURDecoder.receivePart('ur:crypto-hdkey/3-4/lpaxaacsjpcyrkbedymnhdcarpbbfyotvyenwyuejogdcyiojeuoamtaaddyoeadlncsdwykcsfnykaeykondpwlfp');

        // Arrange
        CborCryptoHDKey expectedCborTaggedObject = CborCryptoHDKey(
          isMaster: false,
          isPrivate: false,
          keyData: base64Decode('A6xKRHHdsB4dgSlRcgZvmz04Zlo4BHK++jN11mBUCTlm'),
          chainCode: base64Decode('5gvokyLRAipECLgT5AnkPLX6thREo+E27t5wUBpna9w='),
          origin: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true)
            ],
            sourceFingerprint: 2583323534,
          ),
          parentFingerprint: 808740450,
          name: 'AirGap - twat',
        );

        UR expectedUR = UR(
          type: 'crypto-hdkey',
          serializedCbor: base64Decode(
              'pQNYIQOsSkRx3bAeHYEpUXIGb5s9OGZaOARyvvozddZgVAk5ZgRYIOYL6JMi0QIqRAi4E+QJ5Dy1+rYURKPhNu7ecFAaZ2vcBtkBMKIBhhgs9Rg89QD1AhqZ+mOOCBowNGZiCW1BaXJHYXAgLSB0d2F0'),
        );

        expect(actualURDecoder.buildCborTaggedObject(), expectedCborTaggedObject);
        expect(actualURDecoder.buildUR(), expectedUR);
        expect(actualURDecoder.progress, 1);
        expect(actualURDecoder.estimatedPercentComplete, 1);
        expect(actualURDecoder.isComplete, true);
        expect(actualURDecoder.expectedPartCount, 4);
      });
    });

    group('Tests for simple UR (multi-fragment - range overflow)', () {
      URDecoder actualURDecoder = URDecoder();

      test('Should [return initial values] if no parts received', () {
        // Arrange
        expect(actualURDecoder.buildCborTaggedObject(), null);
        expect(actualURDecoder.buildUR(), null);
        expect(actualURDecoder.progress, 0.0);
        expect(actualURDecoder.estimatedPercentComplete, 0.0);
        expect(actualURDecoder.isComplete, false);
        expect(actualURDecoder.expectedPartCount, null);
      });

      test('Should [return actual values] after 1st fragment received (1/3)', () async {
        // Act
        actualURDecoder.receivePart(
            'ur:eth-sign-request/1015-3/lpcfaxylaxcfadmkcyltotttcwhdlowkcymwenidhdoyolwsvwlthkpfstgwamdklotizsvofybahthkbkenjofhhsdkcneodwdwcxcsftksjpimbnfhfxdpcmbtkiindebbjyiacnieenieiseodpemiaiacpemcpkbdyendnkoihdidyfrihfmkgbyjpisfsbnftkoihctatctcwsbfwdnpmglrlhlehwngyfnzmguptfdvycyzcgyflfmknrturamheguwkhsfngrfgdypfcycldwnldigdvtvekkfwbyfzfemuhfet');

        // Arrange
        expect(actualURDecoder.buildCborTaggedObject(), null);
        expect(actualURDecoder.buildUR(), null);
        expect(actualURDecoder.progress, 0.0);
        expect(actualURDecoder.estimatedPercentComplete, 0.19047619047619047);
        expect(actualURDecoder.isComplete, false);
        expect(actualURDecoder.expectedPartCount, 3);
      });

      test('Should [return actual values] after 3rd fragment received (2/3)', () async {
        // Act
        actualURDecoder.receivePart(
            'ur:eth-sign-request/491-3/lpcfadwmaxcfadmkcyltotttcwhdlogycwgsbweyashhaygmfpchcahhgsfxfxbgaockcthlfghghpchhlgucehhbagafgbwhdfxaehggecaceesinhyiddiceglbyaegrlbghchgsfyfebtbshlbthybtfxfxhkfghygygofdbwbzgubegwbthphphyaobtguhehechfegridjnkoroidfysbjtveetfxltethenyjklycxmdjtlgcpkibygopepeiaehcxmeaebgcpdtctsskpgmahrhfgfmlrssdtdyksenihbylsvd');

        // Arrange
        expect(actualURDecoder.buildCborTaggedObject(), null);
        expect(actualURDecoder.buildUR(), null);
        expect(actualURDecoder.progress, 0.3333333333333333);
        expect(actualURDecoder.estimatedPercentComplete, 0.38095238095238093);
        expect(actualURDecoder.isComplete, false);
        expect(actualURDecoder.expectedPartCount, 3);
      });

      test('Should [return complete values] after 2nd fragment received (3/3)', () async {
        // Act
        actualURDecoder.receivePart(
            'ur:eth-sign-request/675-3/lpcfaootaxcfadmkcyltotttcwhdlohsiakkcxgdjljziniakkcxdeisjyjyjojkftdldljljoihjtjkihhsdminjldljojpinkohsiakkdtdmbkbkghisinjkcxjpihjskpihjkjycxktinjzjzcxjtjljycxjyjpinioioihjpcxhscxidjzjliajeiaishsinjtcxjyjphsjtjkhsiajyinjljtcxjljpcxiajljkjycxhsjtkkcxiohsjkcxiyihihjkdmbkbkhghsjzjzihjycxhsieiejpihjkjkftbkbsuepsbg');

        // Arrange
        CborEthSignRequest expectedCborTaggedObject = CborEthSignRequest(
          requestId: base64Decode('Uf2uvaSQROyLDEU2is7lvw=='),
          signData: base64Decode(
              'V2VsY29tZSB0byBPcGVuU2VhIQoKQ2xpY2sgdG8gc2lnbiBpbiBhbmQgYWNjZXB0IHRoZSBPcGVuU2VhIFRlcm1zIG9mIFNlcnZpY2UgKGh0dHBzOi8vb3BlbnNlYS5pby90b3MpIGFuZCBQcml2YWN5IFBvbGljeSAoaHR0cHM6Ly9vcGVuc2VhLmlvL3ByaXZhY3kpLgoKVGhpcyByZXF1ZXN0IHdpbGwgbm90IHRyaWdnZXIgYSBibG9ja2NoYWluIHRyYW5zYWN0aW9uIG9yIGNvc3QgYW55IGdhcyBmZWVzLgoKV2FsbGV0IGFkZHJlc3M6CjB4NTNiZjBhMTg3NTQ4NzNhODEwMjYyNWQ4MjI1YWY2YTE1YTQzNDIzYwoKTm9uY2U6CjFkOGQyZGMxLTBiN2MtNDc2Mi1hNTIwLWE0ODVhZTI2MTcxOQ=='),
          dataType: CborEthSignDataType.rawBytes,
          derivationPath: const CborCryptoKeypath(
            components: <CborPathComponent>[
              CborPathComponent(index: 44, hardened: true),
              CborPathComponent(index: 60, hardened: true),
              CborPathComponent(index: 0, hardened: true),
              CborPathComponent(index: 0, hardened: false),
              CborPathComponent(index: 0, hardened: false)
            ],
            sourceFingerprint: 1881575369,
          ),
          address: '0x53bf0a18754873a8102625d8225af6a15a43423c',
        );

        UR expectedUR = UR(
          type: 'eth-sign-request',
          serializedCbor: base64Decode(
              'pQHYJVBR/a69pJBE7IsMRTaKzuW/AlkBTldlbGNvbWUgdG8gT3BlblNlYSEKCkNsaWNrIHRvIHNpZ24gaW4gYW5kIGFjY2VwdCB0aGUgT3BlblNlYSBUZXJtcyBvZiBTZXJ2aWNlIChodHRwczovL29wZW5zZWEuaW8vdG9zKSBhbmQgUHJpdmFjeSBQb2xpY3kgKGh0dHBzOi8vb3BlbnNlYS5pby9wcml2YWN5KS4KClRoaXMgcmVxdWVzdCB3aWxsIG5vdCB0cmlnZ2VyIGEgYmxvY2tjaGFpbiB0cmFuc2FjdGlvbiBvciBjb3N0IGFueSBnYXMgZmVlcy4KCldhbGxldCBhZGRyZXNzOgoweDUzYmYwYTE4NzU0ODczYTgxMDI2MjVkODIyNWFmNmExNWE0MzQyM2MKCk5vbmNlOgoxZDhkMmRjMS0wYjdjLTQ3NjItYTUyMC1hNDg1YWUyNjE3MTkDAwXZATCiAYoYLPUYPPUA9QD0APQCGnAmj8kGVFO/Chh1SHOoECYl2CJa9qFaQ0I8'),
        );

        expect(actualURDecoder.buildCborTaggedObject(), expectedCborTaggedObject);
        expect(actualURDecoder.buildUR(), expectedUR);
        expect(actualURDecoder.progress, 1);
        expect(actualURDecoder.estimatedPercentComplete, 1);
        expect(actualURDecoder.isComplete, true);
        expect(actualURDecoder.expectedPartCount, 3);
      });
    });
  });
}
