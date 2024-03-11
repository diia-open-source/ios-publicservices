import Foundation

struct PublicServiceCategoryViewModel {
    let name: String
    let visibleSearch: Bool
    let status: PublicServiceStatus
    let tabCodes: [PublicServiceTabType]
    let publicServices: [PublicServiceShortViewModel]
    
    // Set a local image from assets if emoji is not supported or don't exist.
    var imageName: String
    
    init(model: PublicServiceCategory, typeValidator: PublicServiceCodeValidator) {
        self.name = model.name
        self.visibleSearch = model.visibleSearch
        self.status = model.status
        self.tabCodes = model.tabCodes
        self.publicServices = model
            .publicServices
            .map { PublicServiceShortViewModel(model: $0, validator: typeValidator) }
        
        self.imageName = model.code
    }
}
