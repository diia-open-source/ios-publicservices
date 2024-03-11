import XCTest
@testable import DiiaPublicServicesCore

class PublicServiceCategoryPresenterTests: XCTestCase {
    private var view: PublicServiceCategoryMockView!
    private var publicServiceOpener: PublicServiceOpenerMock!
    
    override func tearDown() {
        view = nil
        publicServiceOpener = nil
        
        super.tearDown()
    }
    
    func test_presenter_configureView_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        
        // Act
        sut.configureView()
        
        // Assert
        XCTAssertTrue(view.isSearchVisible)
        XCTAssertTrue(view.isTitleConfigured)
        XCTAssertTrue(view.isListAdded)
    }
    
    func test_presenter_itemSelected_worksCorrect() {
        // Arrange
        let sut = makeSUT()
        
        // Act
        sut.configureView()
        sut.itemSelected(.init(model: PublicServiceCategoryStub.responseData.publicServices[.zero],
                               validator: PublicServiceCategoryStub.publicServiceValidatorTask))
        
        // Assert
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
}

private extension PublicServiceCategoryPresenterTests {
    func makeSUT() -> PublicServiceCategoryPresenter {
        view = PublicServiceCategoryMockView()
        publicServiceOpener = PublicServiceOpenerMock()
        let model: PublicServiceCategoryViewModel = .init(model: PublicServiceCategoryStub.responseData, typeValidator: PublicServiceCategoryStub.publicServiceValidatorTask)
        return .init(view: view,
                     category: model,
                     opener: publicServiceOpener)
    }
}
