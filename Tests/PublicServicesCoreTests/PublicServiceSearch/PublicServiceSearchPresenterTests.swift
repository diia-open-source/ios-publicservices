import XCTest
@testable import DiiaPublicServicesCore

class PublicServiceSearchPresenterTests: XCTestCase {
    private var view: PublicServiceSearchMockView!
    private var publicServiceOpener: PublicServiceOpenerMock!
    
    override func tearDown() {
        view = nil
        publicServiceOpener = nil
        
        super.tearDown()
    }
    
    func test_presenter_configureViews_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        
        // Act
        sut.configureView()
        
        // Assert
        XCTAssertTrue(view.isTableConfigured)
        XCTAssertTrue(view.isViewUpdateCalled)
    }
    
    func test_presenter_numberOfItems_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        let expectedValue = 2
        
        // Act
        sut.setSearch(search: "publicService")
        let actualValue = sut.numberOfItems()
        
        // Assert
        XCTAssertEqual(actualValue, expectedValue)
        XCTAssertTrue(view.isViewUpdateCalled)
    }
    
    func test_presenter_itemSelected_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        
        // Act
        sut.setSearch(search: "publicService")
        sut.itemSelected(item: .init(categoryName: PublicServiceCategoryStub.responseData.name,
                                     publicService: .init(model: PublicServiceCategoryStub.responseData.publicServices[.zero],
                                                          validator: PublicServiceCategoryStub.publicServiceValidatorTask)))
        
        // Assert
        XCTAssertTrue(view.isPublicServiceOpened)
    }
    
    func test_presenter_setSearch_asResetSearch() {
        // Arrange
        let sut = makeSUT()
        
        // Act
        sut.configureView()
        sut.setSearch(search: nil)
        
        // Assert
        XCTAssertEqual(sut.numberOfItems(), .zero)
        XCTAssertTrue(view.isViewUpdateCalled)
    }
}

private extension PublicServiceSearchPresenterTests {
    func makeSUT() -> PublicServiceSearchPresenter {
        view = PublicServiceSearchMockView()
        publicServiceOpener = PublicServiceOpenerMock()
        let model: PublicServiceCategoryViewModel = .init(model: PublicServiceCategoryStub.responseData, typeValidator: PublicServiceCategoryStub.publicServiceValidatorTask)
        return .init(view: view,
                     publicServicesCategories: [model],
                     opener: publicServiceOpener)
    }
}
