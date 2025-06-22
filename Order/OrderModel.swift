import Foundation

enum OrderStatus: String, Codable {
    case pending = "Chờ xác nhận"
    case shipped = "Đang giao"
    case delivered = "Đã giao"
    case canceled = "Đã hủy"
}

struct Order: Identifiable, Codable {
    let id: UUID
    let createdAt: Date
    let total: Double
    let status: OrderStatus
}
