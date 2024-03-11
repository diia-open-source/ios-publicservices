import Foundation
import ReactiveKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

public class PublicServiceOpener: PublicServiceOpenerProtocol {

    private let bag = DisposeBag()
    private var publicServiceResponse: PublicServiceResponse?
    private var isUpdating = false
    private let apiClient: PublicServicesAPIClientProtocol
    private let serviceRouteManager: PublicServiceRouteManager

    /**
     Main actor that is able to handle user's intention to open specific Public service.
    - parameter apiClient - api client for running requests for updating list of public services
    */
    public init(apiClient: PublicServicesAPIClientProtocol, routeManager: PublicServiceRouteManager) {
        self.apiClient = apiClient
        self.serviceRouteManager = routeManager
    }
    
    // MARK: - PublicServiceOpenerProtocol
    public func openPublicService(type: String, contextMenu: [ContextMenuItem] = [], in view: BaseView) {
        guard let serviceRoute = serviceRouteManager.routeFor(serviceType: type,
                                                              contextMenuItems: contextMenu) else {
            return
        }

        serviceRoute.route(in: view)
    }
    
    public func canOpenPublicService(type: String) -> Bool {
        return serviceRouteManager.routeFor(serviceType: type, contextMenuItems: []) != nil
    }
    
    public func openCategory(code: String, in view: BaseView) {
        if isUpdating { return }
        if let publicServiceResponse = publicServiceResponse {
            if let category = publicServiceResponse.publicServicesCategories
                .first(where: { $0.code == code }) {
                let validatorTask: PublicServiceCodeValidator = { code in
                    self.canOpenPublicService(type: code)
                }
                view.open(module: PublicServiceCategoryModule(category: PublicServiceCategoryViewModel(model: category, typeValidator: validatorTask), opener: self))
            }
        } else {
            updatePublicServices(completion: { [weak self, weak view] in
                guard let view = view else { return }
                self?.openCategory(code: code, in: view)
            }, in: view)
        }
    }
    
    // MARK: - Private helper methods
    private func updatePublicServices(completion: Callback? = nil, in view: BaseView) {
        guard !self.isUpdating else { return }
        self.isUpdating = true
        view.showProgress()
        apiClient
            .getPublicServices()
            .observe { [weak self, weak view] event in
                guard let self = self else { return }
                self.isUpdating = false
                switch event {
                case .next(let response):
                    view?.hideProgress()
                    self.publicServiceResponse = response
                    completion?()
                case .failed:
                    view?.hideProgress()
                case .completed:
                    return
                }
            }.dispose(in: bag)
    }
}
