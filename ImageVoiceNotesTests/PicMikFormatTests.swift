import AVFAudio
import UIKit
import UniformTypeIdentifiers
import XCTest
@testable import PicMik

final class PicMikFormatTests: XCTestCase {
    // This fixture is independent of FileToSaveWith so a format change breaks the test.
    private let legacyJSON = """
        {
          "nameOfCreation": "Café at dawn 🌅",
          "imagePickedData": "iVBORw0KGgoA",
          "audioPickedData": "//sQAA==",
          "createdDate": 720000000.25,
          "isImported": true,
          "importedDate": 720086400.5
        }
        """

    func testReadsLegacyPicMikFile() throws {
        let document = try FileToSaveWith.read(from: temporaryPicMikURL(contents: legacyJSON))

        XCTAssertEqual(document.nameOfCreation, "Café at dawn 🌅")
        XCTAssertEqual(document.imagePickedData, Data([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00]))
        XCTAssertEqual(document.audioPickedData, Data([0xFF, 0xFB, 0x10, 0x00]))
        XCTAssertEqual(document.createdDate, Date(timeIntervalSinceReferenceDate: 720_000_000.25))
        XCTAssertTrue(document.isImported)
        XCTAssertEqual(document.importedDate, Date(timeIntervalSinceReferenceDate: 720_086_400.5))
    }

    func testSampleMediaRoundTripsThroughPicMik() throws {
        let url = try temporaryPicMikURL()
        let image = try XCTUnwrap(NSDataAsset(name: "sampleImageData")?.data)
        let audio = try XCTUnwrap(NSDataAsset(name: "music")?.data)
        let original = FileToSaveWith(
            nameOfCreation: "湖の朝",
            imagePickedData: image,
            audioPickedData: audio,
            createdDate: Date(timeIntervalSinceReferenceDate: 721_000_000.5),
            isImported: false,
            importedDate: Date(timeIntervalSinceReferenceDate: 721_086_400.25)
        )

        try original.write(to: url)

        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: Data(contentsOf: url)) as? [String: Any])
        XCTAssertEqual(Set(json.keys), [
            "nameOfCreation", "imagePickedData", "audioPickedData", "createdDate", "isImported", "importedDate",
        ])
        XCTAssertEqual(json["nameOfCreation"] as? String, original.nameOfCreation)
        XCTAssertEqual(json["imagePickedData"] as? String, image.base64EncodedString())
        XCTAssertEqual(json["audioPickedData"] as? String, audio.base64EncodedString())
        XCTAssertEqual(json["createdDate"] as? Double, 721_000_000.5)
        XCTAssertEqual(json["isImported"] as? Bool, false)
        XCTAssertEqual(json["importedDate"] as? Double, 721_086_400.25)

        let decoded = try FileToSaveWith.read(from: url)
        XCTAssertEqual(decoded.nameOfCreation, original.nameOfCreation)
        XCTAssertEqual(decoded.imagePickedData, image)
        XCTAssertEqual(decoded.audioPickedData, audio)
        XCTAssertEqual(decoded.createdDate, original.createdDate)
        XCTAssertFalse(decoded.isImported)
        XCTAssertEqual(decoded.importedDate, original.importedDate)
        XCTAssertNotNil(UIImage(data: decoded.imagePickedData))
        XCTAssertNotNil(UIImage(named: "sampleImage"))
        XCTAssertGreaterThan(try AVAudioPlayer(data: decoded.audioPickedData).duration, 0)
    }

    func testRejectsMalformedJSON() throws {
        let url = try temporaryPicMikURL(contents: "{")

        XCTAssertThrowsError(try FileToSaveWith.read(from: url)) { error in
            guard case DecodingError.dataCorrupted = error else {
                return XCTFail("Expected malformed JSON to be rejected, got \(error)")
            }
        }
    }

    func testRejectsMissingAudio() throws {
        let incomplete = legacyJSON.replacingOccurrences(of: #""audioPickedData": "//sQAA==","#, with: "")
        let url = try temporaryPicMikURL(contents: incomplete)

        XCTAssertThrowsError(try FileToSaveWith.read(from: url)) { error in
            guard case DecodingError.keyNotFound(let key, _) = error else {
                return XCTFail("Expected a missing audio field error, got \(error)")
            }
            XCTAssertEqual(key.stringValue, "audioPickedData")
        }
    }

    func testRejectsInvalidBase64() throws {
        let invalid = legacyJSON.replacingOccurrences(of: "iVBORw0KGgoA", with: "!!!")
        let url = try temporaryPicMikURL(contents: invalid)

        XCTAssertThrowsError(try FileToSaveWith.read(from: url)) { error in
            guard case DecodingError.dataCorrupted(let context) = error else {
                return XCTFail("Expected invalid image data to be rejected, got \(error)")
            }
            XCTAssertEqual(context.codingPath.last?.stringValue, "imagePickedData")
        }
    }

    func testAppRegistersPicMikDocumentType() throws {
        let identifier = "com.jeevanjotsinghvital.picmik"
        XCTAssertEqual(UTType.picmik.identifier, identifier)
        let exportedTypes = try XCTUnwrap(Bundle.main.object(forInfoDictionaryKey: "UTExportedTypeDeclarations") as? [[String: Any]])
        let declaration = try XCTUnwrap(exportedTypes.first { $0["UTTypeIdentifier"] as? String == identifier })
        let tags = try XCTUnwrap(declaration["UTTypeTagSpecification"] as? [String: [String]])
        XCTAssertEqual(tags["public.filename-extension"], ["picmik"])
        let documentTypes = try XCTUnwrap(Bundle.main.object(forInfoDictionaryKey: "CFBundleDocumentTypes") as? [[String: Any]])
        XCTAssertTrue(documentTypes.contains { ($0["LSItemContentTypes"] as? [String])?.contains(identifier) == true })
    }

    private func temporaryPicMikURL(contents: String? = nil) throws -> URL {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: false)
        addTeardownBlock { try FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("Note.picmik")
        if let contents {
            try Data(contents.utf8).write(to: url)
        }
        return url
    }
}
