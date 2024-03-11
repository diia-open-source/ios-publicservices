import XCTest
@testable import DiiaPublicServicesCore

class PublicServiceRouteManagerTests: XCTestCase {
    
    func test_presenter_routeFor_knownServiceTypeCode() {
        // Arrange
        let sut = makeSUT()
        let knownServiceTypeCode = "ps_test"

        // Act
        let result = sut.routeFor(serviceType: knownServiceTypeCode, contextMenuItems: [])

        // Assert
        XCTAssertNotNil(result)
    }
    
    func test_presenter_routeFor_unknownServiceTypeCode() {
        // Arrange
        let sut = makeSUT()
        let unknownServiceTypeCode = "test"

        // Act
        let result = sut.routeFor(serviceType: unknownServiceTypeCode, contextMenuItems: [])

        // Assert
        XCTAssertNil(result)
    }
    
    
}

private extension PublicServiceRouteManagerTests {
    func makeSUT() -> PublicServiceRouteManager {
        let routeCreateHandlers: [ServiceTypeCode: PublicServiceRouteCreateHandler] = ["ps_test": { _ in return PublicServiceRouteMock() }]
        return .init(routeCreateHandlers: routeCreateHandlers)
    }
}
