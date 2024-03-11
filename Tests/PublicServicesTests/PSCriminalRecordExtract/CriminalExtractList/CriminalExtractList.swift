import XCTest
import DiiaUIComponents
@testable import DiiaPublicServices

class CriminalExtractList: XCTestCase {
    
    var mockView: CriminalExtractListMockView!
    var contextMenuProvider: ContextMenuProviderMock!
    
    override func tearDown() {
        PackageConstants.ratingServiceOpener = nil
        PackageConstants.urlOpener = nil
        mockView = nil
        contextMenuProvider = nil
        super.tearDown()
    }
    
    func testCriminalExtractListIsEmpty() {
        // Given
        let sut = createSut(withPreselectedType: .done)
        
        // Then
        XCTAssertEqual(sut.numberOfRows, 0)
    }
    
    func testCriminalExtractDoneListIsNotEmpty() {
        // Given
        let sut = createSut(withPreselectedType: .done)
        
        // When
        sut.configureView()
        
        // Then
        XCTAssertEqual(sut.numberOfRows, Constants.expectedNumberOfDoneItems)
    }
    
    func testCriminalExtractApplicationProcessingListIsNotEmpty() {
        // Given
        let sut = createSut(withPreselectedType: .applicationProcessing)
        
        // When
        sut.configureView()
        
        // Then
        XCTAssertEqual(sut.numberOfRows, Constants.expectedNumberOfProcessingItems)
    }
    
    func testGetViewModelByExistingIndex() {
        // Given
        PackageConstants.ratingServiceOpener = RatingServiceOpenerMock()
        PackageConstants.urlOpener = URLOpenerStub()
        let sut = createSut(withPreselectedType: .done)
        
        // When
        sut.configureView()
        let viewModel = sut.getViewModelFor(index: Constants.existingIndex)
        viewModel.action.callback()
        
        // Then
        XCTAssertEqual(viewModel.applicationId, Constants.expectedVmByExistingIndex)
        XCTAssertTrue(mockView.isRequestStatusModuleCalled)
    }
    
    func testOpenContextMenu() {
        // Given
        let sut = createSut(withPreselectedType: .done)
        
        // When
        sut.openContextMenu()
        
        // Then
        XCTAssertTrue(mockView === contextMenuProvider.viewPassedInOpenContextMenu)
    }
    
    func testActionTapped() {
        // Given
        let mockFlowCoordinator = CriminalExtractCoordinatorMock()
        PackageConstants.ratingServiceOpener = RatingServiceOpenerMock()
        PackageConstants.urlOpener = URLOpenerStub()
        let sut = createSut(withPreselectedType: .done, flowCoordinator: mockFlowCoordinator)
        
        // When
        sut.actionTapped(animated: true)
        
        // Then
        XCTAssertTrue(mockFlowCoordinator.isReplaceRootCalled)
    }
    
    func testFetchCertificatesFailure() {
        // Given
        let sut = createSut(withPreselectedType: .done, service: CriminalExtractStubErrorService())
        let expectation = self.expectation(description: "fetch certificates failure")
        var isGeneralErrorShowing = false
        mockView.onGeneralErrorShow = { isGeneralErrorVisible in
            isGeneralErrorShowing = isGeneralErrorVisible
            expectation.fulfill()
        }
        
        // When
        sut.configureView()
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertTrue(isGeneralErrorShowing)
    }
    
    func testFetchCertificatesTemplate() {
        // Given
        let sut = createSut(withPreselectedType: .done, service: CriminalExtractListStubTemplateService())
        let expectation = self.expectation(description: "fetch certificates template")
        var isTemplateShowing = false
        mockView.onTemplateShow = { isTemplateVisible in
            isTemplateShowing = isTemplateVisible
            expectation.fulfill()
        }

        // When
        sut.configureView()

        // Then
        waitForExpectations(timeout: 2)
        XCTAssertEqual(sut.numberOfRows, 0)
        XCTAssertTrue(isTemplateShowing)
    }
    
    func testLoadCellsForApplicationProcessingStatus() {
        // Given
        let sut = createSut(withPreselectedType: .applicationProcessing)
        
        // When
        sut.loadCellsFor(category: .applicationProcessing)

        // Then
        XCTAssertTrue(mockView.isStubMessageConfigured)
        XCTAssertTrue(mockView.isTableViewShouldReloaded)
    }
    
    func testLoadCellsForDoneStatus() {
        // Given
        let sut = createSut(withPreselectedType: .done)
        
        // When
        sut.loadCellsFor(category: .done)

        // Then
        XCTAssertTrue(mockView.isStubMessageConfigured)
        XCTAssertTrue(mockView.isTableViewShouldReloaded)
    }
}

private extension CriminalExtractList {
    func createSut(withPreselectedType type: CertificateStatus,
                   service: CriminalExtractApiClientProtocol = CriminalExtractStubService(),
                   flowCoordinator: CriminalExtractCoordinator? = nil) -> CriminalExtractListPresenter {
        mockView = CriminalExtractListMockView()
        contextMenuProvider = ContextMenuProviderMock()
        let flowCoordinator = flowCoordinator ?? CriminalExtractCoordinatorImpl(rootView: mockView)
        return CriminalExtractListPresenter(
            view: mockView,
            contextMenuProvider: contextMenuProvider,
            flowCoordinator: flowCoordinator,
            preselectedType: type,
            apiClient: service,
            networkingContext: .stub()
        )
    }
}

private extension CriminalExtractList {
    enum Constants {
        static let expectedNumberOfDoneItems = 3
        static let expectedNumberOfProcessingItems = 1
        static let existingIndex = 1
        static let notExistingIndex = 4
        static let expectedVmByExistingIndex = "02"
    }
}
