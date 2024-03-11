import XCTest
import DiiaUIComponents
@testable import DiiaPublicServices

class CriminalExtractNationalitiesTests: XCTestCase {
    
    var view: CriminalExtractNationalitiesMockView!
    var contextMenuProvider: ContextMenuProviderMock!
    
    override func tearDown() {
        contextMenuProvider = nil
        view = nil
        super.tearDown()
    }
    
    func testNationalitiesLoaded() {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "loading nationalities")
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
    }
    
    func testAddNewEmptyNationality() {
        // Given
        let sut = createSut()
        let viewModel = sut.viewModelForСell()
        
        // When
        viewModel.action?(.add)
        let updatedViewModel = sut.viewModelForСell()
        
        // Then
        XCTAssertEqual(updatedViewModel.nationalities.count, Constants.expectedEmptyNationalitiesCount)
    }
    
    func testNationalityEdit() {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "loading nationalities")
        expectation.expectedFulfillmentCount = 2
        
        // When
        view.onStateChange = { _ in expectation.fulfill() }
        sut.configureView()
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
        }
        
        let viewModel = sut.viewModelForСell()
        viewModel.action?(.edit(index: 0))
        let updatedViewModel = sut.viewModelForСell()
        
        // Then
        XCTAssertEqual(updatedViewModel.nationalities[0], Constants.expectedEditedNationality)
    }
    
    func testNationalityRemoved() {
        // Given
        let sut = createSut()
        let viewModel = sut.viewModelForСell()
        
        XCTAssertNil(viewModel.nationalities[0])
        
        // When
        viewModel.action?(.remove(index: 0))
        let updatedViewModel = sut.viewModelForСell()
        
        // Then
        XCTAssert(updatedViewModel.nationalities.isEmpty)
    }
    
    func testOpenContextMenu() {
        // Given
        let sut = createSut()
        
        // When
        sut.openContextMenu()
        
        // Then
        XCTAssertTrue(view === contextMenuProvider.viewPassedInOpenContextMenu)
    }
    
    func testActionTapped() {
        // Given
        let mockFlowCoordinator = CriminalExtractCoordinatorMock()
        let sut = createSut(flowCoordinator: mockFlowCoordinator)
        
        // When
        sut.configureView()
        sut.actionTapped()
        
        // Then
        XCTAssertTrue(mockFlowCoordinator.isOpenNextScreenCalled)
    }
    
    func testFetchNationaliesFailure() {
        // Given
        let sut = createSut(service: CriminalExtractStubErrorService())
        let expectation = self.expectation(description: "fetch nationalities failure")
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
    
    func testFetchNationaliesTemplate() {
        // Given
        let sut = createSut(service: CriminalExtractListStubTemplateService())
        let expectation = self.expectation(description: "fetch nationalities template")
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
}

private extension CriminalExtractNationalitiesTests {
    func createSut(service: CriminalExtractApiClientProtocol = CriminalExtractStubService(),
                   flowCoordinator: CriminalExtractCoordinator? = nil) -> CriminalExtractNationalitiesPresenter {
        view = CriminalExtractNationalitiesMockView()
        contextMenuProvider = ContextMenuProviderMock()
        let flowCoordinator = flowCoordinator ?? CriminalExtractCoordinatorImpl(rootView: view)
        return CriminalExtractNationalitiesPresenter(view: view,
                                                     contextMenuProvider: contextMenuProvider,
                                                     flowCoordinator: flowCoordinator,
                                                     apiClient: service,
                                                     requestModel: CriminalExtractRequestModel(),
                                                     networkingContext: .stub())
    }
}

private extension CriminalExtractNationalitiesTests {
    enum Constants {
        static let expectedEmptyNationalitiesCount = 2
        static let expectedEditedNationality = "Австрія"
    }
}
