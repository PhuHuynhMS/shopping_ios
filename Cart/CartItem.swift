struct CartItem: Identifiable, Codable {
    let id: String // same as product.id
    let product: Product
    var quantity: Int
}
