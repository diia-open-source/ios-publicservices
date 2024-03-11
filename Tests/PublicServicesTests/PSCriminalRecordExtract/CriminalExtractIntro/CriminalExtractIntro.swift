import XCTest
import DiiaUIComponents
@testable import DiiaPublicServices

class CriminalExtractIntro: XCTestCase {
    
    var view: CriminalExtractIntroMockView!
    var contextMenuProvider: ContextMenuProviderMock!
    
    override func tearDown() {
        contextMenuProvider = nil
        view = nil
        super.tearDown()
    }
    
    func testIntroModelLoaded() {
        // Given
        let sut = createSut()
        
        // When
        sut.configureView()
        
        // Then
        XCTAssertEqual(view.state, Constants.expectedLoadedState)
        XCTAssertEqual(view.model.title, Constants.expectedIntroModelTitle)
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
    
    func testLoadInfoTemplate() {
        // Given
        let sut = createSut(service: CriminalExtractListStubTemplateService())
        let expectation = self.expectation(description: "fetch countries template")
        var isTemplateShowing = false
        view.onTemplateShow = { isTemplateVisible in
            isTemplateShowing = isTemplateVisible
            expectation.fulfill()
        }

        // When
        sut.configureView()

        // Then
        waitForExpectations(timeout: 2)
        XCTAssertTrue(isTemplateShowing)
    }
    
    func testDidShowRequestPickerModule() {
        // Given
        let sut = createSut()
        
        // When
        sut.didTapActionButton()

        // Then
        XCTAssertTrue(view.isRequestPickerModuleCalled)
    }
    
    func testDidShowRequesterNameModule() {
        // Given
        let sut = createSut()
        
        // When
        sut.configureView()
        sut.didTapActionButton()

        // Then
        XCTAssertTrue(view.isRequesterNameModuleCalled)
    }
}

private extension CriminalExtractIntro {
    func createSut(service: CriminalExtractApiClientProtocol = CriminalExtractStubService()) -> CriminalExtractIntroPresenter {
        view = CriminalExtractIntroMockView()
        let flowCoordinator = CriminalExtractCoordinatorImpl(rootView: view)
        contextMenuProvider = ContextMenuProviderMock()
        return CriminalExtractIntroPresenter(
            view: view,
            contextMenuProvider: contextMenuProvider,
            flowCoordinator: flowCoordinator,
            requestModel: CriminalExtractRequestModel(),
            apiClient: service,
            networkingContext: .stub()
        )
    }
}

private extension CriminalExtractIntro {
    enum Constants {
        static let expectedLoadedState = LoadingState.ready
        static let expectedIntroModelTitle = "Вітаємо"
    }
}
