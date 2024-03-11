import DiiaCommonTypes
import Foundation

public typealias ServiceTypeCode = String

public typealias PublicServiceRouteCreateHandler =
    (_ contextMenuItems: [ContextMenuItem]) -> RouterProtocol

public class PublicServiceRouteManager {
    private let routeCreateHandlers: [ServiceTypeCode: PublicServiceRouteCreateHandler]

    public init(routeCreateHandlers: [ServiceTypeCode: PublicServiceRouteCreateHandler]) {
        self.routeCreateHandlers = routeCreateHandlers
    }

    func routeFor(serviceType: ServiceTypeCode, contextMenuItems: [ContextMenuItem]) -> RouterProtocol? {
        guard let routeCreateHandler = routeCreateHandlers[serviceType] else {
            return nil
        }
        return routeCreateHandler(contextMenuItems)
    }
}
