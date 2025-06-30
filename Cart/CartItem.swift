import Foundation

struct CartItem: Identifiable, Codable, Hashable {
    let id = UUID()
    var productId: String
    var name: String
    var quantity: Int
    var isOverStock: Bool = false

    enum CodingKeys: String, CodingKey {
        case productId, name, quantity
    }
}
