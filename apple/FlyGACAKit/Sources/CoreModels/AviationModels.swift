import Foundation

// MARK: - Catalog Models

public struct CatalogItem: Codable, Identifiable, Sendable, Hashable {
    public let id: String
    public let folder: String
    public let nameEn: String
    public let nameAr: String
    public let badge: String
    public let category: String
    public let icon: String
    public let summaryEn: String
    public let summaryAr: String

    enum CodingKeys: String, CodingKey {
        case id
        case folder
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case badge
        case category
        case icon
        case summaryEn = "summary_en"
        case summaryAr = "summary_ar"
    }

    public init(
        id: String,
        folder: String,
        nameEn: String,
        nameAr: String,
        badge: String,
        category: String,
        icon: String,
        summaryEn: String,
        summaryAr: String
    ) {
        self.id = id
        self.folder = folder
        self.nameEn = nameEn
        self.nameAr = nameAr
        self.badge = badge
        self.category = category
        self.icon = icon
        self.summaryEn = summaryEn
        self.summaryAr = summaryAr
    }

    public func localizedName(isArabic: Bool) -> String {
        isArabic ? nameAr : nameEn
    }

    public func localizedSummary(isArabic: Bool) -> String {
        isArabic ? summaryAr : summaryEn
    }
}

public struct CatalogFile: Codable, Sendable {
    public let version: String
    public let modules: [CatalogItem]

    public init(version: String, modules: [CatalogItem]) {
        self.version = version
        self.modules = modules
    }
}

// MARK: - Airport & Weather Models

public struct AirportRunway: Codable, Sendable, Hashable {
    public let id: String
    public let len: Int?
    public let surf: String?

    public init(id: String, len: Int? = nil, surf: String? = nil) {
        self.id = id
        self.len = len
        self.surf = surf
    }
}

public struct AirportFrequency: Codable, Sendable, Hashable {
    public let l: String // Label e.g. TWR, ATIS, APP
    public let v: String // Value e.g. 118.1

    public init(l: String, v: String) {
        self.l = l
        self.v = v
    }
}

public struct Airport: Codable, Identifiable, Sendable, Hashable {
    public var id: String { icao }
    public let icao: String
    public let iata: String
    public let nameEn: String
    public let nameAr: String
    public let cityEn: String
    public let cityAr: String
    public let countryEn: String
    public let countryAr: String
    public let region: String?
    public let type: String?
    public let lat: Double
    public let lon: Double
    public let elevFt: Int
    public let rwys: [AirportRunway]
    public let freqs: [AirportFrequency]

    enum CodingKeys: String, CodingKey {
        case icao
        case iata
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case cityEn = "city_en"
        case cityAr = "city_ar"
        case countryEn = "country_en"
        case countryAr = "country_ar"
        case region
        case type
        case lat
        case lon
        case elevFt = "elev_ft"
        case rwys
        case freqs
    }

    public init(
        icao: String,
        iata: String,
        nameEn: String,
        nameAr: String,
        cityEn: String,
        cityAr: String,
        countryEn: String,
        countryAr: String,
        region: String? = nil,
        type: String? = nil,
        lat: Double,
        lon: Double,
        elevFt: Int,
        rwys: [AirportRunway] = [],
        freqs: [AirportFrequency] = []
    ) {
        self.icao = icao
        self.iata = iata
        self.nameEn = nameEn
        self.nameAr = nameAr
        self.cityEn = cityEn
        self.cityAr = cityAr
        self.countryEn = countryEn
        self.countryAr = countryAr
        self.region = region
        self.type = type
        self.lat = lat
        self.lon = lon
        self.elevFt = elevFt
        self.rwys = rwys
        self.freqs = freqs
    }

    public func localizedName(isArabic: Bool) -> String {
        isArabic ? nameAr : nameEn
    }

    public func localizedCity(isArabic: Bool) -> String {
        isArabic ? cityAr : cityEn
    }
}

public enum FlightRuleCategory: String, Codable, Sendable {
    case vfr = "VFR"
    case mvfr = "MVFR"
    case ifr = "IFR"
    case lifr = "LIFR"
}

public struct MetarReport: Sendable, Identifiable {
    public var id: String { station }
    public let station: String
    public let timestamp: Date
    public let windDir: Int
    public let windSpeedKts: Int
    public let windGustKts: Int?
    public let visibilitySM: Double
    public let ceilingFt: Int?
    public let temperatureC: Int
    public let dewpointC: Int
    public let altimeterHpa: Int
    public let altimeterInHg: Double
    public let flightRules: FlightRuleCategory
    public let rawText: String
    public let weatherConditions: String

    public init(
        station: String,
        timestamp: Date = Date(),
        windDir: Int,
        windSpeedKts: Int,
        windGustKts: Int? = nil,
        visibilitySM: Double,
        ceilingFt: Int? = nil,
        temperatureC: Int,
        dewpointC: Int,
        altimeterHpa: Int,
        altimeterInHg: Double,
        flightRules: FlightRuleCategory,
        rawText: String,
        weatherConditions: String
    ) {
        self.station = station
        self.timestamp = timestamp
        self.windDir = windDir
        self.windSpeedKts = windSpeedKts
        self.windGustKts = windGustKts
        self.visibilitySM = visibilitySM
        self.ceilingFt = ceilingFt
        self.temperatureC = temperatureC
        self.dewpointC = dewpointC
        self.altimeterHpa = altimeterHpa
        self.altimeterInHg = altimeterInHg
        self.flightRules = flightRules
        self.rawText = rawText
        self.weatherConditions = weatherConditions
    }
}

// MARK: - GACAR Regulations Models

public struct GACARCategory: Codable, Identifiable, Sendable, Hashable {
    public let id: String
    public let label: String

    public init(id: String, label: String) {
        self.id = id
        self.label = label
    }
}

public struct GACARDocument: Codable, Identifiable, Sendable, Hashable {
    public var id: String { slug }
    public let part: String
    public let partNum: Int
    public let title: String
    public let category: String
    public let slug: String
    public let pages: Int?
    public let outline: [String]?

    public init(
        part: String,
        partNum: Int,
        title: String,
        category: String,
        slug: String,
        pages: Int? = nil,
        outline: [String]? = nil
    ) {
        self.part = part
        self.partNum = partNum
        self.title = title
        self.category = category
        self.slug = slug
        self.pages = pages
        self.outline = outline
    }
}

public struct GACARIndex: Codable, Sendable {
    public let generated: String?
    public let count: Int
    public let categories: [GACARCategory]
    public let documents: [GACARDocument]

    public init(generated: String?, count: Int, categories: [GACARCategory], documents: [GACARDocument]) {
        self.generated = generated
        self.count = count
        self.categories = categories
        self.documents = documents
    }
}
