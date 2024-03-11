import XCTest
@testable import DiiaPublicServicesCore

class PublicServiceOpenerTests: XCTestCase {
    private var psRouteMock: PublicServiceRouteMock!
    
    override func tearDown() {
        psRouteMock = nil
        
        super.tearDown()
    }
    
    func test_presenter_openPublicService_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        let serviceTypeCode = "ps_test"

        // Act
        sut.openPublicService(type: serviceTypeCode, in: AnyPublicServiceMockView())

        // Assert
        XCTAssertTrue(psRouteMock.isPublicServiceOpened)
    }
    
    func test_presenter_canOpenPublicService_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        let serviceTypeCode = "ps_test"

        // Act
        let result = sut.canOpenPublicService(type: serviceTypeCode)

        // Assert
        XCTAssertTrue(result)
    }
    
    func test_presenter_openCategory_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        let mockView = AnyPublicServiceMockView()
        let categoryCode = "socialSupport"

        // Act
        sut.openCategory(code: categoryCode, in: mockView)

        // Assert
        XCTAssertTrue(mockView.isPublicServiceCategoryOpened)
    }
    
    
}

private extension PublicServiceOpenerTests {
    func makeSUT() -> PublicServiceOpener {
        psRouteMock = PublicServiceRouteMock()
        let routeCreateHandlers: [ServiceTypeCode: PublicServiceRouteCreateHandler] = ["ps_test": { _ in return self.psRouteMock }]
        return .init(
            apiClient: PublicServicesAPIServiceMock(context: .init(session: .default, host: "", headers: nil)),
            routeManager: .init(routeCreateHandlers: routeCreateHandlers)
        )
    }
}
