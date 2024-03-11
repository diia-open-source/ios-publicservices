import XCTest
import DiiaCommonServices
@testable import DiiaPublicServices

class CriminalExtractContactHandlerTests: XCTestCase {
    
    func testFetchContactsInputInfo() {
        // Given
        let sut = createSut()
        let view = CriminalExtractContactsInputMockView()
        
        // When
        sut.fetchContactsInputInfo(in: view)
        
        // Then
        XCTAssertTrue(view.isSetContactsCalled)
    }
    
    func testFetchContactsInputInfoFailure() {
        // Given
        let sut = createSut(service: CriminalExtractStubErrorService())
        let view = CriminalExtractContactsInputMockView()
        let expectation = self.expectation(description: "fetch contacts input info failure")
        var isGeneralErrorShowing = false
        view.onGeneralErrorShow = { isGeneralErrorVisible in
            isGeneralErrorShowing = isGeneralErrorVisible
            expectation.fulfill()
        }
        
        // When
        sut.fetchContactsInputInfo(in: view)
        
        // Then
        waitForExpectations(timeout: 2)
        XCTAssertTrue(isGeneralErrorShowing)
    }
    
    func testSendContacts() {
        // Given
        let sut = createSut()
        let view = CriminalExtractContactsInputMockView()
        let inputContactsValue: [ContactInputType : String] = [:]
        
        // When
        sut.sendContacts(contacts: inputContactsValue, in: view)
        
        // Then
        XCTAssert(view.isRequestResultModuleCalled)
    }
}

// MARK: - Private Methods
private extension CriminalExtractContactHandlerTests {
    func createSut(service: CriminalExtractApiClientProtocol = CriminalExtractStubService()) -> CriminalExtractContactHandler {
        return CriminalExtractContactHandler(contextMenuProvider: ContextMenuProviderMock(),
                                             apiService: service,
                                             flowCoordinator: CriminalExtractCoordinatorMock(),
                                             requestModel: CriminalExtractRequestModel(),
                                             networkingContext: .stub())
    }
}
