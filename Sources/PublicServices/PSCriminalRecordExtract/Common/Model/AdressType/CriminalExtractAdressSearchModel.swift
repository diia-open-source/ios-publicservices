import Foundation
import DiiaCommonTypes

struct CriminalExtractAdressSearchModel: Codable, Equatable {
    let id: String
    let name: String
    
    init(_ model: SearchModel) {
        self.id = model.code
        self.name = model.title
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension CriminalExtractAdressSearchModel {
    static let Ukraine = CriminalExtractAdressSearchModel(id: "804", name: "УКРАЇНА")
}
