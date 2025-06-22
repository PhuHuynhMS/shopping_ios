struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var avatarURL: String?    // có thể là URL ảnh hoặc tên file nội bộ
}