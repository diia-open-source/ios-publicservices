import XCTest
import DiiaUIComponents
@testable import DiiaPublicServices

class CriminalExtractRequestStatusTests: XCTestCase {
    
    var view: CriminalExtractRequestStatusMockView!
    var contextMenuProvider: ContextMenuProviderMock!
    
    override func tearDown() {
        PackageConstants.ratingServiceOpener = nil
        PackageConstants.urlOpener = nil
        view = nil
        contextMenuProvider = nil
        super.tearDown()
    }
    
    func testScreenTitleValie() {
        // Given
        let sut = createSut()
        let title = sut.getScreenTitle()
        
        // Then
        XCTAssertEqual(title, Constants.expectedScreenTitle)
    }
    
    func testApplicationStatusLoaded() {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "loading application status")
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
        XCTAssertTrue(view.configureScreenDidCall)
    }
    
    func testGetApplicationFileToShare() {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "downloading application file")
        var url: URL?
        view.onFileDownloadDidCall = { fileURL in
            url = fileURL
            expectation.fulfill()
        }
        
        // When
        sut.didTapShareCertificate()
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertNotNil(url)
    }
    
    func testGetApplicationFileToView() {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "downloading application file")
        var url: URL?
        view.onFilePreviewDidCall = { fileURL in
            url = fileURL
            expectation.fulfill()
        }
        
        // When
        sut.didTapViewCertificate()
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertNotNil(url)
    }
    
    func testApplicationStatusLoadedFailure() {
        // Given
        let sut = createSut(service: CriminalExtractStubErrorService())
        let expectation = self.expectation(description: "loading application status failure")
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
    
    func testGetApplicationFileToShareFailure() {
        // Given
        let sut = createSut(service: CriminalExtractStubErrorService())
        let expectation = self.expectation(description: "downloading application file failure")
        var isGeneralErrorShowing = false
        view.onGeneralErrorShow = { isGeneralErrorVisible in
            isGeneralErrorShowing = isGeneralErrorVisible
            expectation.fulfill()
        }
        
        // When
        sut.didTapShareCertificate()
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertTrue(isGeneralErrorShowing)
    }
    
    func testGetApplicationFileToViewFailure() {
        // Given
        let sut = createSut(service: CriminalExtractStubErrorService())
        let expectation = self.expectation(description: "downloading application file failure")
        var isGeneralErrorShowing = false
        view.onGeneralErrorShow = { isGeneralErrorVisible in
            isGeneralErrorShowing = isGeneralErrorVisible
            expectation.fulfill()
        }
        
        // When
        sut.didTapViewCertificate()
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertTrue(isGeneralErrorShowing)
    }
    
    func testLoadInfoTemplate() {
        // Given
        let sut = createSut(service: CriminalExtractListStubTemplateService())
        let expectation = self.expectation(description: "load info template")
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
    
    func testOpenContextMenu() {
        // Given
        let sut = createSut()
        
        // When
        sut.openContextMenu()
        
        // Then
        XCTAssertTrue(view === contextMenuProvider.viewPassedInOpenContextMenu)
    }
    
    func testDidTapBackButtonNeedReplaceRoot() {
        // Given
        let mockFlowCoordinator = CriminalExtractCoordinatorMock()
        PackageConstants.ratingServiceOpener = RatingServiceOpenerMock()
        PackageConstants.urlOpener = URLOpenerStub()
        let sut = createSut(flowCoordinator: mockFlowCoordinator, needToReplaceRootWithList: true)
        
        // When
        sut.didTapBackButton()
        
        // Then
        XCTAssertTrue(mockFlowCoordinator.isReplaceRootCalled)
    }
    
    func testDidTapBackButtonJustCloseModule() {
        // Given
        let sut = createSut()
        
        // When
        sut.didTapBackButton()
        
        // Then
        XCTAssertTrue(view.isCloseModuleCalled)
    }
}

private extension CriminalExtractRequestStatusTests {
    func createSut(service: CriminalExtractApiClientProtocol = CriminalExtractStubService(),
                   flowCoordinator: CriminalExtractCoordinator? = nil,
                   needToReplaceRootWithList: Bool = false) -> CriminalExtractRequestStatusPresenter {
        view = CriminalExtractRequestStatusMockView()
        contextMenuProvider = ContextMenuProviderMock()
        let flowCoordinator = flowCoordinator ?? CriminalExtractCoordinatorImpl(rootView: view)
        return CriminalExtractRequestStatusPresenter(view: view,
                                                     contextMenuProvider: contextMenuProvider,
                                                     flowCoordinator: flowCoordinator,
                                                     screenType: .ready,
                                                     apiClient: service,
                                                     applicationId: Constants.applicationId,
                                                     documentDate: Constants.documentDate,
                                                     needToReplaceRootWithList: needToReplaceRootWithList,
                                                     networkingContext: .stub())
    }
}

private extension CriminalExtractRequestStatusTests {
    enum Constants {
        static let applicationId = "5123151"
        static let documentDate = "18.02.2023"
        static let expectedScreenTitle = R.Strings.criminal_certificate_request_home_title.localized()
    }
}
