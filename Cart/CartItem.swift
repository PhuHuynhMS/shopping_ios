struct CartItem: Identifiable {
    let id: String
    let name: String
    var quantity: Int
}

struct StockError: Identifiable, Decodable {
    let id: String
    let quantity: Int
    let stock: Int
    
    var errorMessage: String {
        "Bạn chọn \(quantity), nhưng tồn kho chỉ còn \(stock)"
    }
}
