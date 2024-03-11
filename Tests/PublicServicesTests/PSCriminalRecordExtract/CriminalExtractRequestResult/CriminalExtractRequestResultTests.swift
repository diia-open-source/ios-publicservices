import XCTest
import DiiaUIComponents
@testable import DiiaPublicServices

class CriminalExtractRequestResultTests: XCTestCase {
    
    var view: CriminalExtractRequestResultMockView!
    var contextMenuProvider: ContextMenuProviderMock!
    
    override func tearDown() {
        view = nil
        contextMenuProvider = nil
        super.tearDown()
    }
    
    func testConfirmationInfoLoaded() {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "loading confirmation")
        expectation.expectedFulfillmentCount = 2
        
        var state: LoadingState?
        view.onStateChange = { newState in
            state = newState
            expectation.fulfill()
        }
        
        // When
        sut.configureView()
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertEqual(state, .ready)
        XCTAssertTrue(self.view.configureViewsDidCall)
    }
    
    func testConfirmationButtonInactive() {
        // Given
        let sut = createSut()
        let viewModel = sut.geContactViewModel()
        
        // When
        sut.validateViewModel()
        
        // Then
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(view.isActionButtonActive)
    }
    
    func testConfirmationButtonActive() {
        // Given
        let sut = createSut()
        let viewModel = sut.geContactViewModel()
        viewModel?.isChecked = true
        
        // When
        sut.validateViewModel()
        
        // Then
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(view.isActionButtonActive)
    }
    
    func testSendApplicationSucceed() {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "sending application")
        expectation.expectedFulfillmentCount = 2
        
        var state: LoadingStateButton.LoadingState?
        view.onLoadingState = { newState in
            state = newState
            expectation.fulfill()
        }
        
        // When
        sut.didTapActionButton()
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertEqual(state, .solid)
    }
    
    func testOpenContextMenu() {
        // Given
        let sut = createSut()
        
        // When
        sut.openContextMenu()
        
        // Then
        XCTAssertTrue(view === contextMenuProvider.viewPassedInOpenContextMenu)
    }
    
    func testLoadInfoFailure() {
        // Given
        let sut = createSut(service: CriminalExtractStubErrorService())
        let expectation = self.expectation(description: "load info failure")
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

private extension CriminalExtractRequestResultTests {
    func createSut(service: CriminalExtractApiClientProtocol = CriminalExtractStubService()) -> CriminalExtractRequestResultPresenter {
        view = CriminalExtractRequestResultMockView()
        contextMenuProvider = ContextMenuProviderMock()
        let requestModel = CriminalExtractRequestStubModel().model
        return CriminalExtractRequestResultPresenter(view: view,
                                                     contextMenuProvider: contextMenuProvider,
                                                     flowCoordinator: CriminalExtractCoordinatorMock(),
                                                     requestModel: requestModel,
                                                     apiClient: service,
                                                     networkingContext: .stub())
    }
}
