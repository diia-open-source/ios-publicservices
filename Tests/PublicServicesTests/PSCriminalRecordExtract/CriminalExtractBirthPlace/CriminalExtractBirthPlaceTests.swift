import XCTest
import DiiaUIComponents
@testable import DiiaPublicServices

class CriminalExtractBirthPlaceTests: XCTestCase {
    
    var view: CriminalExtractBirthPlaceMockView!
    var contextMenuProvider: ContextMenuProviderMock!
    
    override func tearDown() {
        contextMenuProvider = nil
        view = nil
        super.tearDown()
    }
    
    func testBirthPlacesLoaded() {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "loading birth places")
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
    
    func testCurrentCountryIsUkraine() throws {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "loading birth places")
        expectation.expectedFulfillmentCount = 2
        view.onStateChange = { _ in expectation.fulfill() }
        
        // When
        sut.configureView()
        
        // Then
        waitForExpectations(timeout: 2)
        // in this case vm serves city, not country, so skipped
        if sut.isCountryProvided {
            throw XCTSkip("The vm is not suited for this test. The test will be skipped")
        } else {
            let viewModel = sut.viewModelForSection(section: Constants.countrySection)
            XCTAssertEqual(viewModel.text, Constants.expectingCurrentCountry)
        }
    }
    
    func testCurrentCityIsEmpty() throws {
        // Given
        let sut = createSut()
        let expectation = self.expectation(description: "loading birth places")
        expectation.expectedFulfillmentCount = 2
        view.onStateChange = { _ in expectation.fulfill() }
        
        // When
        sut.configureView()
        
        // Then
        waitForExpectations(timeout: 2)
        
        // in this case vm serves city, but doesnt take into account section, so skipped
        if sut.isCountryProvided {
            throw XCTSkip("The vm is not suited for this test. The test will be skipped")
        } else {
            let viewModel = sut.viewModelForSection(section: Constants.citySection)
            XCTAssertEqual(viewModel.text, .empty)
        }
    }
    
    func testViewModelCountryChange() {
        // Given
        let sut = createSut()
        let viewModel = sut.viewModelForSection(section: Constants.countrySection)
        
        // When
        viewModel.toggleAction?(true)
        viewModel.updateTextAction?(.editing(Constants.newCountry))
        let updatedViewModel = sut.viewModelForSection(section: Constants.countrySection)
        
        // Then
        XCTAssertEqual(updatedViewModel.text, Constants.newCountry)
    }
    
    func testViewModelCityChange() {
        // Given
        let sut = createSut()
        let viewModel = sut.viewModelForSection(section: Constants.citySection)
        
        // When
        viewModel.toggleAction?(true)
        viewModel.updateTextAction?(.editing(Constants.newCity))
        let updatedViewModel = sut.viewModelForSection(section: Constants.citySection)
        
        // Then
        XCTAssertEqual(updatedViewModel.text, Constants.newCity)
    }
    
    func testViewModelCityFinishedEditing() {
        // Given
        let sut = createSut()
        let viewModel = sut.viewModelForSection(section: Constants.citySection)
        
        // When
        viewModel.toggleAction?(true)
        viewModel.updateTextAction?(.finishedEdit(Constants.newCity))
        
        // Then
        XCTAssertEqual(view.updatedSectionIndex, Constants.citySection)
    }
    
    func testViewModelCountryFinishedEditing() {
        // Given
        let sut = createSut()
        let viewModel = sut.viewModelForSection(section: Constants.countrySection)
        
        // When
        viewModel.toggleAction?(true)
        viewModel.updateTextAction?(.finishedEdit(Constants.newCountry))
        
        // Then
        XCTAssertEqual(view.updatedSectionIndex, Constants.countrySection)
    }
    
    func testViewModelCountryOpenCoutryList() {
        // Given
        let sut = createSut()
        let viewModel = sut.viewModelForSection(section: Constants.countrySection)
        
        // When
        viewModel.toggleAction?(false)
        viewModel.updateTextAction?(.finishedEdit(nil))
        
        // Then
        XCTAssertTrue(view.isBaseSearchModuleCalled)
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
    
    func testFetchCountriesFailure() {
        // Given
        let sut = createSut(service: CriminalExtractStubErrorService())
        let expectation = self.expectation(description: "fetch countries failure")
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
    
    func testFetchCountriesTemplate() {
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
}

private extension CriminalExtractBirthPlaceTests {
    func createSut(service: CriminalExtractApiClientProtocol = CriminalExtractStubService(),
                   flowCoordinator: CriminalExtractCoordinator? = nil) -> CriminalExtractBirthPlacePresenter {
        view = CriminalExtractBirthPlaceMockView()
        contextMenuProvider = ContextMenuProviderMock()
        let flowCoordinator = flowCoordinator ?? CriminalExtractCoordinatorImpl(rootView: view)
        return CriminalExtractBirthPlacePresenter(view: view,
                                                  contextMenuProvider: contextMenuProvider,
                                                  flowCoordinator: flowCoordinator,
                                                  apiClient: service,
                                                  requestModel: CriminalExtractRequestModel(),
                                                  networkingContext: .stub())
    }
}

private extension CriminalExtractBirthPlaceTests {
    enum Constants {
        static let expectingCurrentCountry = "УКРАЇНА"
        static let newCountry = "АВСТРАЛІЯ"
        static let newCity = "КИЇВ"
        static let countrySection = 0
        static let citySection = 1
    }
}
