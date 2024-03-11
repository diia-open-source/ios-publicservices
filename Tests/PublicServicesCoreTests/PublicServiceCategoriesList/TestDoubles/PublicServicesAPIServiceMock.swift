import ReactiveKit
import DiiaNetwork
import DiiaCommonTypes
@testable import DiiaPublicServicesCore

final class PublicServicesAPIServiceMock: PublicServicesAPIClient {
    override func getPublicServices() -> Signal<PublicServiceResponse, NetworkError> {
        return Signal(just: PublicServiceResponse(publicServicesCategories: [.init(code: "socialSupport",
                                                                                   icon: "😇",
                                                                                   name: "єПідтримка",
                                                                                   status: .active,
                                                                                   visibleSearch: false,
                                                                                   tabCodes: [.citizen],
                                                                                   publicServices: [.init(status: .active,
                                                                                                          name: "єПідтримка",
                                                                                                          code: "vaccinationAid",
                                                                                                          badgeNumber: nil,
                                                                                                          search: "єПідтримка",
                                                                                                          contextMenu: nil)]),
                                                                             .init(code: "office-workspace",
                                                                                   icon: "👨‍💻",
                                                                                   name: "Воркспейс",
                                                                                   status: .active,
                                                                                   visibleSearch: false,
                                                                                   tabCodes: [.office],
                                                                                   publicServices: [.init(status: .active,
                                                                                                          name: "Воркспейс",
                                                                                                          code: "officeOfficialWorkspace",
                                                                                                          badgeNumber: nil,
                                                                                                          search: "Воркспейс",
                                                                                                          contextMenu: nil)])],
                                                  tabs: [.init(name: "Citizen", code: .citizen),
                                                         .init(name: "Official", code: .office)]))
    }
    
    override func getPromo() -> Signal<AlertTemplateResponse, NetworkError> {
        let template = AlertTemplate(type: .middleCenterAlignAlert,
                                     isClosable: false,
                                     data: AlertTemplateData(icon: nil,
                                                             title: "Next",
                                                             description: nil,
                                                             mainButton: AlertButtonModel(title: "Exit",
                                                                                          icon: nil,
                                                                                          action: .close),
                                                             alternativeButton: nil))

        return Signal(just: AlertTemplateResponse(template: template, processCode: .zero))
    }
    
    override func subscribe(segmentId: Int) -> Signal<SuccessResponse, NetworkError> {
        return Signal(just: SuccessResponse(success: true, template: nil))
    }
}
