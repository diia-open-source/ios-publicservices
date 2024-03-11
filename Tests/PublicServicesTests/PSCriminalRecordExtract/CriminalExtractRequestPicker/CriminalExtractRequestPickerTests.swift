import XCTest
import DiiaUIComponents

@testable import DiiaPublicServices

class CriminalExtractRequestPickerTests: XCTestCase {
    
    var view: CriminalExtractRequestPickerMockView!
    var contextMenuProvider: ContextMenuProviderMock!
    
    override func tearDown() {
        view = nil
        contextMenuProvider = nil
        super.tearDown()
    }
    
    func testPickerFinalModelLoaded() {
        // Given
        let sut = createSut(screenType: .final)
        let expectation = self.expectation(description: "loading final picker model")
        expectation.expectedFulfillmentCount = 2
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
            XCTAssertEqual(view?.viewModel.items.count, Constants.expectedFinalModelsCount)
        }
    }
    
    func testPickerIntermediateModelLoaded() {
        // Given
        let sut = createSut(screenType: .intermediate)
        let expectation = self.expectation(description: "loading intermediate picker model")
        expectation.expectedFulfillmentCount = 2
        var state: LoadingState?
        
        view.onStateChange = { newState in
            state = newState
            expectation.fulfill()
        }
        
        // When
        sut.configureView()
        
        waitForExpectations(timeout: 2) { [weak view] error in
            XCTAssertNil(error)
            XCTAssertEqual(state, .ready)
            XCTAssertEqual(view?.viewModel.items.count, Constants.expectedIntermediateModelsCount)
        }
    }
    
    func testPickerGotTemplateAlert() {
        // Given
        let sut = createSut(
            screenType: .intermediate,
            service: CriminalExtractListStubTemplateService()
        )
        let expectation = self.expectation(description: "template alert")
        var istemplateShowing = false
        view.onTemplateShow = { isTemplateVisible in
            istemplateShowing = isTemplateVisible
            expectation.fulfill()
        }
        
        // When
        sut.configureView()
        waitForExpectations(timeout: 2)
        
        // Then
        XCTAssertTrue(istemplateShowing)
    }
    
    func testPickerSelectItem() {
        // Given
        let sut = createSut(screenType: .final)
        
        let expectation = self.expectation(description: "loading final picker model")
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
        sut.didSelectItem(id: Constants.selectedReasonId)
        XCTAssertTrue(view.isActionButtonActive)
    }
    
    func testOpenContextMenu() {
        // Given
        let sut = createSut(screenType: .final)
        
        // When
        sut.openContextMenu()
        
        // Then
        XCTAssertTrue(view === contextMenuProvider.viewPassedInOpenContextMenu)
    }
    
    func testLoadInfoFailure() {
        // Given
        let sut = createSut(screenType: .final, service: CriminalExtractStubErrorService())
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
    
    func testDidShowRequestPickerModule() {
        // Given
        let sut = createSut(screenType: .intermediate)
        
        // When
        sut.didTapActionButton()

        // Then
        XCTAssertTrue(view.isRequestPickerModuleCalled)
    }
    
    func testDidShowRequesterNameModule() {
        // Given
        let sut = createSut(screenType: .final)
        
        // When
        sut.configureView()
        sut.didTapActionButton()

        // Then
        XCTAssertTrue(view.isRequesterNameModuleCalled)
    }
}

private extension CriminalExtractRequestPickerTests {
    func createSut(screenType: ExtractPickerScreenType,
                   service: CriminalExtractApiClientProtocol = CriminalExtractStubService()) -> CriminalExtractRequestPickerPresenter {
        view = CriminalExtractRequestPickerMockView()
        contextMenuProvider = ContextMenuProviderMock()
        let flowCoordinator = CriminalExtractCoordinatorImpl(rootView: view)
        return CriminalExtractRequestPickerPresenter(
            view: view,
            contextMenuProvider: contextMenuProvider,
            flowCoordinator: flowCoordinator,
            screenType: screenType,
            requestModel: CriminalExtractRequestModel(),
            apiClient: service,
            networkingContext: .stub()
        )
    }
}

private extension CriminalExtractRequestPickerTests {
    enum Constants {
        static let expectedIntermediateModelsCount = 1
        static let expectedFinalModelsCount = 3
        static let selectedReasonId = "1"
    }
}
