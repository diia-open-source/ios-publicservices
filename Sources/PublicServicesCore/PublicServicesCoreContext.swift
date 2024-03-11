import Foundation
import Alamofire
import DiiaNetwork
import DiiaUIComponents

public struct PublicServicesCoreContext {
    internal let network: PublicServiceCoreNetworkContext
    /// the array is used in PublicServiceOpener to build a service with specific type
    internal let publicServiceRouteManager: PublicServiceRouteManager
    internal let storeHelper: PublicServicesStorage
    internal let imageNameProvider: DSImageNameProvider

    public init(network: PublicServiceCoreNetworkContext,
                publicServiceRouteManager: PublicServiceRouteManager,
                storage: PublicServicesStorage,
                imageNameProvider: DSImageNameProvider) {
        self.network = network
        self.publicServiceRouteManager = publicServiceRouteManager
        self.storeHelper = storage
        self.imageNameProvider = imageNameProvider
    }
}
