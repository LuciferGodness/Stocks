import Foundation
import SwiftData

protocol ManagedObject: PersistentModel {
    associatedtype DTO: Cacheable where DTO.ManagedModel == Self
    func toDTO() -> DTO
}

protocol Cacheable {
    associatedtype ManagedModel: ManagedObject where ManagedModel.DTO == Self
    func toManagedObject() -> ManagedModel
}
