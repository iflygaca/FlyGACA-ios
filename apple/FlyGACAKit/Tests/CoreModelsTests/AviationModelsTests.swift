import CoreModels
import XCTest

final class AviationModelsTests: XCTestCase {
    func testCatalogItemDecoding() throws {
        let json = """
        {
            "version": "1.0.0",
            "modules": [
                {
                    "id": "ppl-exam",
                    "folder": "ppl-exam",
                    "name_en": "Private Pilot License",
                    "name_ar": "رخصة طيار خاص",
                    "badge": "PPL",
                    "category": "licensing",
                    "icon": "airplane",
                    "summary_en": "Ground school syllabus",
                    "summary_ar": "المنهج الدراسي"
                }
            ]
        }
        """.data(using: .utf8)!

        let catalog = try JSONDecoder().decode(CatalogFile.self, from: json)
        XCTAssertEqual(catalog.modules.count, 1)
        let first = catalog.modules[0]
        XCTAssertEqual(first.id, "ppl-exam")
        XCTAssertEqual(first.localizedName(isArabic: false), "Private Pilot License")
        XCTAssertEqual(first.localizedName(isArabic: true), "رخصة طيار خاص")
    }

    func testAirportDecoding() throws {
        let json = """
        [
            {
                "icao": "OEJN",
                "iata": "JED",
                "name_en": "King Abdulaziz International Airport",
                "name_ar": "مطار الملك عبدالعزيز الدولي",
                "city_en": "Jeddah",
                "city_ar": "جدة",
                "country_en": "Saudi Arabia",
                "country_ar": "المملكة العربية السعودية",
                "lat": 21.6796,
                "lon": 39.1565,
                "elev_ft": 48,
                "rwys": [{"id": "16R/34L", "len": 13123, "surf": "Asphalt"}],
                "freqs": [{"l": "TWR", "v": "118.1"}]
            }
        ]
        """.data(using: .utf8)!

        let airports = try JSONDecoder().decode([Airport].self, from: json)
        XCTAssertEqual(airports.count, 1)
        let jed = airports[0]
        XCTAssertEqual(jed.icao, "OEJN")
        XCTAssertEqual(jed.iata, "JED")
        XCTAssertEqual(jed.rwys.count, 1)
        XCTAssertEqual(jed.freqs.count, 1)
    }

    func testGACARRegulationsDecoding() throws {
        let json = """
        {
            "generated": "2026-06-13",
            "count": 1,
            "categories": [{"id": "general", "label": "General"}],
            "documents": [
                {
                    "part": "91",
                    "partNum": 91,
                    "title": "General Operating and Flight Rules",
                    "category": "airspace",
                    "slug": "part-91",
                    "pages": 215,
                    "outline": ["Subpart A", "Subpart B"]
                }
            ]
        }
        """.data(using: .utf8)!

        let index = try JSONDecoder().decode(GACARIndex.self, from: json)
        XCTAssertEqual(index.documents.count, 1)
        XCTAssertEqual(index.documents[0].part, "91")
        XCTAssertEqual(index.documents[0].outline?.count, 2)
    }
}
