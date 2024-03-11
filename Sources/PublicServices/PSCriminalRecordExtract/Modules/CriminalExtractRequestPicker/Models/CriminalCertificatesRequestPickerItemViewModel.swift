import Foundation

struct CriminalCertificatesRequestPickerItemViewModel {
    var code: String
    var title: String
    var subtitle: String?
    
    init(code: String, title: String, subtitle: String? = nil) {
        self.code = code
        self.title = title
        self.subtitle = subtitle
    }
}

struct CriminalCertificatesRequestPickerViewModel {
    var typeText: String
    var typeSubtitle: String
    var items: [CriminalCertificatesRequestPickerItemModel]
    
    init(typeText: String, typeSubtitle: String, items: [CriminalCertificatesRequestPickerItemModel]) {
        self.typeText = typeText
        self.typeSubtitle = typeSubtitle
        self.items = items
    }
}
