import XCTest
import ReactiveKit
import DiiaUIComponents
@testable import DiiaPublicServices

class CriminalExtractRequesterNameTests: XCTestCase {
    
    var view: CriminalExtractRequesterNameMockView!
    var apiClient: CriminalExtractStubService!
    var contextMenuProvider: ContextMenuProviderMock!
    
    override func tearDown() {
        contextMenuProvider = nil
        view = nil
        super.tearDown()
    }
    
    func testGetRequesterData() {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "loading requester data")
        expectation.expectedFulfillmentCount = 2
        
        var dataScreen: RequesterDataScreenModel?
        let apiExpectation = self.expectation(description: "loading api requester")
        
        getApiRequester { model in
            dataScreen = model
            apiExpectation.fulfill()
        }
        
        var state: DiiaUIComponents.LoadingState?
        view.onStateChange = { newState in
            state = newState
            expectation.fulfill()
        }
        
        // When
        sut.configureView()
        
        // Then
        waitForExpectations(timeout: 2) { [unowned sut] error in
            XCTAssertNil(error)
            XCTAssertNotNil(dataScreen)
            XCTAssertEqual(state, .ready)
            
            XCTAssertEqual(sut.title, dataScreen?.title)
            XCTAssertEqual(sut.fullName, dataScreen?.fullName)
            //XCTAssertEqual(sut.parametrizedMessage, dataScreen?.attentionMessage)
        }
    }
    
    func testGetRequesterDataTemplateShown() {
        // Given
        let sut = createSut(service: CriminalExtractListStubTemplateService())
        let expectation = self.expectation(description: "template alert")
        var istemplateShowing = false
        view.onTemplateShow = { isTemplateVisible in
            istemplateShowing = isTemplateVisible
            expectation.fulfill()
        }
        
        // When
        sut.configureView()
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertTrue(istemplateShowing)
    }
    
    func testGetViewEmptyModelByIndex() {
        // Given
        let sut = createSut()
        let viewModel = sut.viewModelForIndex(index: 1)
        
        // Then
        XCTAssert(viewModel.values.isEmpty)
    }
    
    func testViewModelEmptyValueAdded() {
        // Given
        let sut = createSut()
        let emptyViewModel = getEmptyViewModel(with: sut, index: 1)
        
        // When
        emptyViewModel.updateListAction?(.add)
        let updatedViewModel = sut.viewModelForIndex(index: 1)
        
        // Then
        XCTAssert(updatedViewModel.values.first?.0.isEmpty == true)
        XCTAssert(updatedViewModel.values.first?.1 == true)
    }
    
    func testViewModelEditValue() {
        // Given
        let sut = createSut()
        let emptyViewModel = getEmptyViewModel(with: sut, index: 1)
        
        // When
        emptyViewModel.updateListAction?(.add)
        emptyViewModel.updateListAction?(.editing(oldValue: "", newValue: Constants.userName))
        let updatedViewModel = sut.viewModelForIndex(index: 1)
        
        // Then
        XCTAssertEqual(updatedViewModel.values.first?.0, Constants.userName)
        XCTAssert(updatedViewModel.values.first?.1 == true)
    }
    
    func testViewModelDidEndEditing() {
        // Given
        let sut = createSut()
        let emptyViewModel = getEmptyViewModel(with: sut, index: 1)
        
        // When
        emptyViewModel.updateListAction?(.add)
        emptyViewModel.updateListAction?(.editing(oldValue: "", newValue: Constants.userName))
        let updatedViewModel = sut.viewModelForIndex(index: 1)
        
        // Then
        XCTAssertEqual(updatedViewModel.values.first?.0, Constants.userName)
        XCTAssert(updatedViewModel.values.first?.1 == true)
        XCTAssertEqual(view.updatedTableViewRowIndex, 1)
    }
    
    func testViewModelDidDeleteItem() {
        // Given
        let sut = createSut()
        let emptyViewModel = getEmptyViewModel(with: sut, index: 1)
        
        // WHen
        emptyViewModel.updateListAction?(.add)
        emptyViewModel.updateListAction?(.editing(oldValue: "", newValue: Constants.userName))
        var updatedViewModel = sut.viewModelForIndex(index: 1)
        
        // Then
        XCTAssertEqual(updatedViewModel.values.first?.0, Constants.userName)
        XCTAssert(updatedViewModel.values.first?.1 == true)
        
        updatedViewModel.updateListAction?(.remove(value: Constants.userName))
        updatedViewModel = sut.viewModelForIndex(index: 1)
        XCTAssertTrue(updatedViewModel.values.isEmpty)
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
        let sut = createSut(service: CriminalExtractStubService(), flowCoordinator: mockFlowCoordinator)
        
        // When
        sut.configureView()
        sut.actionTapped()
        
        // Then
        XCTAssertTrue(mockFlowCoordinator.isOpenNextScreenCalled)
    }
    
    func testGetRequesterFailure() {
        // Given
        let sut = createSut(service: CriminalExtractStubErrorService())
        let expectation = self.expectation(description: "get requester failure")
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

private extension CriminalExtractRequesterNameTests {
    func createSut(service: CriminalExtractApiClientProtocol = CriminalExtractStubService(),
                   flowCoordinator: CriminalExtractCoordinator? = nil) -> CriminalExtractRequesterNamePresenter {
        view = CriminalExtractRequesterNameMockView()
        contextMenuProvider = ContextMenuProviderMock()
        let flowCoordinator = flowCoordinator ?? CriminalExtractCoordinatorImpl(rootView: view)
        return CriminalExtractRequesterNamePresenter(view: view,
                                                     contextMenuProvider: contextMenuProvider,
                                                     flowCoordinator: flowCoordinator,
                                                     apiClient: service,
                                                     requestModel: CriminalExtractRequestModel(),
                                                     networkingContext: .stub())
    }
    
    func getApiRequester(apiClient: CriminalExtractApiClientProtocol = CriminalExtractStubService(),
                         callback: @escaping (RequesterDataScreenModel?) -> Void) {
        var disposable: Disposable?
        disposable = apiClient.getRequester().observeNext(with: { model in
            defer {
                disposable?.dispose()
            }
            guard let dataScreen = model.requesterDataScreen else {
                callback(nil)
                return
            }
            callback(dataScreen)
        })
    }
    
    func getEmptyViewModel(with sut: CriminalExtractRequesterNamePresenter, index: Int) -> CriminalExtractRequesterNamePresenter.ViewModel {
        let viewModel = sut.viewModelForIndex(index: index)
        return viewModel
    }
}

private extension CriminalExtractRequesterNameTests {
    enum Constants {
        static let userName = "Користувач"
    }
}
