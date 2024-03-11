import Foundation
import DiiaPublicServices


extension PSCriminalRecordExtractNetworkingContext {
    static func stub() -> PSCriminalRecordExtractNetworkingContext {
        .init(session: .default,
              host: "",
              headers: nil)
    }
}
