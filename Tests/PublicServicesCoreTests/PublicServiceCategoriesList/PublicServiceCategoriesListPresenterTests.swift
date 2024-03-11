import XCTest
@testable import DiiaPublicServicesCore

class PublicServiceCategoriesListPresenterTests: XCTestCase {
    private var view: PublicServiceCategoriesListViewMock!
    private var apiService: PublicServicesAPIServiceMock!
    private var publicServiceOpener: PublicServiceOpenerMock!
    
    override func setUp() {
        super.setUp()
        
        view = PublicServiceCategoriesListViewMock()
        apiService = PublicServicesAPIServiceMock(context: .init(session: .default, host: "", headers: nil))
        publicServiceOpener = PublicServiceOpenerMock()
    }
    
    override func tearDown() {
        view = nil
        apiService = nil
        
        super.tearDown()
    }
    
    func test_presenter_numberOfItems_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        let expectedValue = 1
        
        // Act
        sut.updateServices()
        let actualValue = sut.numberOfItems()
        
        // Assert
        XCTAssertEqual(view.loadingState, .ready)
        XCTAssertEqual(actualValue, expectedValue)
    }
    
    func test_presenter_itemAtIndex_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        let expectedNameValue = "єПідтримка"
        
        // Act
        sut.updateServices()
        let actualValue = sut.itemAt(index: .zero)
        
        // Assert
        XCTAssertEqual(view.loadingState, .ready)
        XCTAssertEqual(actualValue?.name, expectedNameValue)
    }
    
    func test_presenter_itemSelected_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        
        // Act
        sut.updateServices()
        sut.itemSelected(index: .zero)
        
        // Assert
        XCTAssertEqual(view.loadingState, .ready)
        XCTAssertTrue(view.isPublicServiceOpened)
    }
    
    func test_presenter_searchClick_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        
        // Act
        sut.searchClick()
        
        // Assert
        XCTAssertTrue(view.isSearchOpened)
    }
    
    func test_presenter_getTabsViewModel_worksCorrect() {
        // Arrange
        let model = PublicServiceCategoriesModel(publicServiceTabsViewModel: TabSwitcherViewModelMock(), publicServiceOpener: publicServiceOpener)
        let sut = makeSUT(with: model)
        
        // Act
        let actualValue = sut.getTabsViewModel()
        
        // Assert
        XCTAssertTrue(actualValue is TabSwitcherViewModelMock)
    }
    
    func test_presenter_switchTab_worksCorrect() {
        // Arrange
        let model = PublicServiceCategoriesModel(publicServiceOpener: publicServiceOpener)
        let sut = makeSUT(with: model)
        
        // Act
        sut.updateServices()
        model.publicServiceTabsViewModel.action?(1)
        
        // Assert
        XCTAssertTrue(view.isViewReloadByTab)
        XCTAssertEqual(model.currentTab, .office)
    }
    
    func test_presenter_switchTab_isTabStateSaved_afterUpdateServices() {
        // Arrange
        let model = PublicServiceCategoriesModel(publicServiceOpener: publicServiceOpener)
        let sut = makeSUT(with: model)
        
        // Act
        sut.updateServices()
        model.publicServiceTabsViewModel.action?(1)
        XCTAssertEqual(model.currentTab, .office)
        sut.updateServices()
        
        // Assert
        XCTAssertTrue(view.isViewReloadByTab)
        XCTAssertEqual(model.currentTab, .office)
    }
}


private extension PublicServiceCategoriesListPresenterTests {
    func makeSUT(with model: PublicServiceCategoriesModel = .init(publicServiceTabsViewModel: TabSwitcherViewModelMock(), publicServiceOpener: PublicServiceOpenerMock() )) -> PublicServiceCategoriesListPresenter {
        return .init(view: view,
                     apiClient: apiService,
                     model: model,
                     storage: nil)
    }
}
