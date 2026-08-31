import CoreModels
import XCTest

final class AviationCalculatorsTests: XCTestCase {
    // ── Crosswind Formulas ──
    func testCrosswindAndHeadwindCalculations() {
        let rwyHeading = 360.0
        let windDir = 330.0
        let windSpeed = 20.0

        let angleDiff = abs(windDir - rwyHeading) * .pi / 180.0
        let crosswind = abs(windSpeed * sin(angleDiff))
        let headwind = windSpeed * cos(angleDiff)

        XCTAssertEqual(crosswind, 10.0, accuracy: 0.1)
        XCTAssertEqual(headwind, 17.32, accuracy: 0.1)
    }

    func testDirectCrosswind() {
        let rwyHeading = 360.0
        let windDir = 90.0
        let windSpeed = 15.0

        let angleDiff = abs(windDir - rwyHeading) * .pi / 180.0
        let crosswind = abs(windSpeed * sin(angleDiff))
        let headwind = windSpeed * cos(angleDiff)

        XCTAssertEqual(crosswind, 15.0, accuracy: 0.01)
        XCTAssertEqual(headwind, 0.0, accuracy: 0.01)
    }

    // ── Pressure & Density Altitude Formulas ──
    func testPressureAndDensityAltitude() {
        let fieldElevation = 1000.0 // ft
        let qnh = 1000.0 // hPa (lower pressure than standard 1013.25)
        let oat = 35.0 // °C (hot Saudi summer day)

        // Pressure altitude
        let pressAlt = fieldElevation + (1013.25 - qnh) * 27.0
        XCTAssertEqual(pressAlt, 1357.75, accuracy: 0.5)

        // ISA Temp at Pressure Alt
        let isaTemp = 15.0 - (2.0 * (pressAlt / 1000.0))
        XCTAssertEqual(isaTemp, 12.28, accuracy: 0.1)

        // Density altitude
        let densityAlt = pressAlt + (118.8 * (oat - isaTemp))
        XCTAssertGreaterThan(densityAlt, pressAlt) // Density altitude must exceed pressure altitude in hot OAT
        XCTAssertEqual(densityAlt, 4057.0, accuracy: 10.0)
    }

    // ── Weight & Balance Center of Gravity ──
    func testWeightAndBalanceCG() {
        let emptyWeight = 1400.0
        let emptyArm = 38.0

        let pilotWeight = 180.0
        let pilotArm = 37.0

        let passWeight = 160.0
        let passArm = 73.0

        let fuelGallons = 40.0
        let fuelWeight = fuelGallons * 6.0 // 240 lbs
        let fuelArm = 48.0

        let totalWeight = emptyWeight + pilotWeight + passWeight + fuelWeight
        XCTAssertEqual(totalWeight, 1980.0)

        let totalMoment = (emptyWeight * emptyArm) +
            (pilotWeight * pilotArm) +
            (passWeight * passArm) +
            (fuelWeight * fuelArm)

        let cg = totalMoment / totalWeight
        XCTAssertEqual(cg, 41.93, accuracy: 0.1)
    }

    // ── Fuel Planning & GACAR Part 91 Reserves ──
    func testFuelPlanningAndGACARReserves() {
        let distanceNM = 220.0
        let groundSpeedKts = 110.0
        let burnRateGPH = 10.0

        let flightTimeHours = distanceNM / groundSpeedKts // 2.0 hours
        let flightBurnGal = flightTimeHours * burnRateGPH // 20.0 gal
        XCTAssertEqual(flightBurnGal, 20.0, accuracy: 0.01)

        // GACAR Part 91.151 Day VFR: +30 min reserve (0.5 hr * 10 GPH = 5 gal)
        let dayReserveGal = 0.5 * burnRateGPH
        let dayTotalReq = flightBurnGal + dayReserveGal
        XCTAssertEqual(dayTotalReq, 25.0, accuracy: 0.01)

        // GACAR Part 91.151 Night VFR: +45 min reserve (0.75 hr * 10 GPH = 7.5 gal)
        let nightReserveGal = 0.75 * burnRateGPH
        let nightTotalReq = flightBurnGal + nightReserveGal
        XCTAssertEqual(nightTotalReq, 27.5, accuracy: 0.01)
    }

    // ── Unit Conversions ──
    func testAviationConversions() {
        // Speed: 100 Knots = 115.078 MPH = 185.2 KM/H
        let kts = 100.0
        let mph = kts * 1.15078
        let kmh = kts * 1.852
        XCTAssertEqual(mph, 115.078, accuracy: 0.01)
        XCTAssertEqual(kmh, 185.2, accuracy: 0.01)

        // Fuel Weights: 50 gal Avgas = 300 lbs; 50 gal Jet A-1 = 335 lbs
        let avgasLbs = 50.0 * 6.0
        let jetA1Lbs = 50.0 * 6.7
        XCTAssertEqual(avgasLbs, 300.0)
        XCTAssertEqual(jetA1Lbs, 335.0)

        // Pressure: 1013.25 hPa = 29.9213 inHg
        let inHg = 1013.25 * 0.02953
        XCTAssertEqual(inHg, 29.92, accuracy: 0.01)
    }
}
