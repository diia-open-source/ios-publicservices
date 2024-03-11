import Foundation
import DiiaCommonTypes

public struct PSCriminalRecordExtractConfiguration {
    let ratingServiceOpener: RateServiceProtocol
    let networkingContext: PSCriminalRecordExtractNetworkingContext
    let urlOpener: URLOpenerProtocol

    public init(ratingServiceOpener: RateServiceProtocol,
                networkingContext: PSCriminalRecordExtractNetworkingContext,
                urlOpener: URLOpenerProtocol) {
        self.ratingServiceOpener = ratingServiceOpener
        self.networkingContext = networkingContext
        self.urlOpener = urlOpener
    }
}
