import XCTest
import DiiaUIComponents
@testable import DiiaPublicServices

class CriminalExtractRegistrationPlaceTests: XCTestCase {
    
    var view: CriminalExtractRegistrationPlaceMockView!
    var contextMenuProvider: ContextMenuProviderMock!
    
    override func tearDown() {
        contextMenuProvider = nil
        view = nil
        super.tearDown()
    }
    
    func testUkraineAddressLoaded() {
        // Given
        let sut = createSut(service: CriminalExtractStubService(addressType: .country))
        let expectation = self.expectation(description: "loading address")
        expectation.expectedFulfillmentCount = 4
        
        var state: LoadingState?
        view.onStateChange = { newState in
            state = newState
            expectation.fulfill()
        }
        
        // When
        sut.configureView()
        
        // Then
        waitForExpectations(timeout: 2) { [weak view] error in
            XCTAssertNil(error)
            XCTAssertEqual(state, .ready)
            XCTAssertTrue(view?.isCurrentDistrictHidden ?? false)
            XCTAssertTrue(view?.isCurrentCityHidden ?? false)
            XCTAssertEqual(view?.buttonState, .solid)
        }
    }
    
    func testCurrentCitySearchSucceed() {
        // Given
        let sut = createSut(service: CriminalExtractStubService(addressType: .city))
        
        // When
        sut.configureView()
        let expectation = self.expectation(description: "city searched")
        
        var isCityUpdated = false
        view.onListElementChange = { isUpdated in
            isCityUpdated = isUpdated
            expectation.fulfill()
        }
        sut.openDetailedScreen(adressType: .city)
        
        // Then
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
            XCTAssertTrue(isCityUpdated)
        }
    }
    
    func testOpenContextMenu() {
        // Given
        let sut = createSut(service: CriminalExtractStubService())
        
        // When
        sut.openContextMenu()
        
        // Then
        XCTAssertTrue(view === contextMenuProvider.viewPassedInOpenContextMenu)
    }
    
    func testActionTapped() {
        // Given
        let mockFlowCoordinator = CriminalExtractCoordinatorMock()
        let sut = createSut(service: CriminalExtractStubService(), flowCoordinator: mockFlowCoordinator)
        
        // When
        sut.actionTapped()
        
        // Then
        XCTAssertTrue(mockFlowCoordinator.isOpenNextScreenCalled)
    }
    
    func testGetRegistrationAdressFailure() {
        // Given
        let sut = createSut(service: CriminalExtractStubErrorService())
        let expectation = self.expectation(description: "get registration adress failure")
        var isGeneralErrorShowing = false
        view.onGeneralErrorShow = { isGeneralErrorVisible in
            isGeneralErrorShowing = isGeneralErrorVisible
            expectation.fulfill()
        }
        
        // When
        sut.configureView()
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertTrue(isGeneralErrorShowing)
    }
}

// MARK: - Private Methods
private extension CriminalExtractRegistrationPlaceTests {
    func createSut(service: CriminalExtractApiClientProtocol,
                   flowCoordinator: CriminalExtractCoordinator? = nil) -> CriminalExtractRegistrationPlacePresenter {
        view = CriminalExtractRegistrationPlaceMockView()
        contextMenuProvider = ContextMenuProviderMock()
        let flowCoordinator = flowCoordinator ?? CriminalExtractCoordinatorImpl(rootView: view)
        return CriminalExtractRegistrationPlacePresenter(view: view,
                                                         contextMenuProvider: contextMenuProvider,
                                                         flowCoordinator: flowCoordinator,
                                                         apiClient: service,
                                                         requestModel: CriminalExtractRequestModel(),
                                                         networkingContext: .stub())
    }
}
