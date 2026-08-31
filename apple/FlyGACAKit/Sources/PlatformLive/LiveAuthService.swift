import AppServices
import CoreModels
import Foundation

/// Production implementation of `AuthProviding` communicating with authentication services.
public final class LiveAuthService: AuthProviding, @unchecked Sendable {
    private var _userID: String?
    private let lock = NSLock()

    public init(userID: String? = nil) {
        self._userID = userID
    }

    public var currentUserID: String? {
        lock.withLock {
            _userID
        }
    }

    public func setUserID(_ id: String?) {
        lock.withLock {
            _userID = id
        }
    }

    public func signOut() async throws {
        lock.withLock {
            _userID = nil
        }
    }
}

public typealias FirebaseAuthService = LiveAuthService
