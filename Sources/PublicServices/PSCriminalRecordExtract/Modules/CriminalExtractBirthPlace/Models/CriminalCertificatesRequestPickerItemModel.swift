import Foundation

public struct CriminalCertificatesRequestPickerItemModel {
    public var code: String
    public var title: String
    public var description: String?
    
    public init(code: String, title: String, description: String? = nil) {
        self.code = code
        self.title = title
        self.description = description
    }
}
