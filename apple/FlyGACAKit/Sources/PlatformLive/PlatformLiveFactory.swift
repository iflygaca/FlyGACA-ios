import AppServices
import CoreModels
import Foundation

/// Factory helper providing live PlatformLive instances for injection at the app root.
public enum PlatformLiveFactory {
    public static func makeAuth(userID: String? = nil) -> any AuthProviding {
        LiveAuthService(userID: userID)
    }

    public static func makeProgressSync(
        endpointURL: URL = URL(string: "https://flygaca.com/api/progress/summary")!,
        authProvider: any AuthProviding
    ) -> any ProgressSyncing {
        LiveProgressSync(endpointURL: endpointURL, authProvider: authProvider)
    }

    public static func makeProgressSync(
        projectID: String,
        authProvider: any AuthProviding
    ) -> any ProgressSyncing {
        LiveProgressSync(projectID: projectID, authProvider: authProvider)
    }

    public static func makeChatClient(
        endpoint: URL = URL(string: "https://flygaca.com/api/chat")!
    ) -> any ChatClient {
        CaptainAdelSSEClient(baseURL: endpoint)
    }

    public static func makePaymentService(apiKey: String) -> any PaymentProviding {
        MoyasarPaymentService(apiKey: apiKey)
    }
}

