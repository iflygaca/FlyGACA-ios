import AppServices
import CoreModels
import Foundation

/// Uploads progress summaries to backend REST sync at `https://flygaca.com/api/progress/summary`,
/// matching the web app's `ProgressSummary` data contract.
public struct LiveProgressSync: ProgressSyncing, Sendable {
    public let endpointURL: URL
    public let authProvider: any AuthProviding
    private let urlSession: URLSession

    public init(
        endpointURL: URL = URL(string: "https://flygaca.com/api/progress/summary")!,
        authProvider: any AuthProviding,
        urlSession: URLSession = .shared
    ) {
        self.endpointURL = endpointURL
        self.authProvider = authProvider
        self.urlSession = urlSession
    }

    public init(
        projectID: String,
        authProvider: any AuthProviding,
        urlSession: URLSession = .shared
    ) {
        self.init(
            endpointURL: URL(string: "https://flygaca.com/api/progress/summary")!,
            authProvider: authProvider,
            urlSession: urlSession
        )
    }

    public func upload(_ summary: ProgressSummary) async throws {
        guard let uid = authProvider.currentUserID, !uid.isEmpty else {
            // Unauthenticated users store progress locally; upload is best-effort.
            return
        }

        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(uid)", forHTTPHeaderField: "Authorization")

        let payload = ProgressDocumentEncoder.encode(summary)
        request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])

        let (_, response) = try await urlSession.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
    }
}

public typealias FirebaseProgressSync = LiveProgressSync

/// Utility for converting `ProgressSummary` into JSON document structure.
public enum ProgressDocumentEncoder {
    public static func encode(_ summary: ProgressSummary) -> [String: Any] {
        var fields: [String: Any] = [:]

        // quizBest: mapValue
        var quizMap: [String: [String: Any]] = [:]
        for (key, val) in summary.quizBest {
            quizMap[key] = ["integerValue": String(val)]
        }
        fields["quizBest"] = ["mapValue": ["fields": quizMap]]

        // examBest: integerValue or nullValue
        if let best = summary.examBest {
            fields["examBest"] = ["integerValue": String(best)]
        } else {
            fields["examBest"] = ["nullValue": NSNull()]
        }

        // examCount: integerValue
        fields["examCount"] = ["integerValue": String(summary.examCount)]

        // gsDone: arrayValue
        let doneValues = summary.gsDone.map { ["stringValue": $0] }
        fields["gsDone"] = ["arrayValue": ["values": doneValues]]

        // updatedAt: timestampValue (ISO8601 string)
        let formatter = ISO8601DateFormatter()
        fields["updatedAt"] = ["timestampValue": formatter.string(from: summary.updatedAt)]

        return ["fields": fields]
    }
}

public typealias FirestoreDocumentEncoder = ProgressDocumentEncoder
