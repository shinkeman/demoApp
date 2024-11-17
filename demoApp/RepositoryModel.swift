struct RepositoryModel: Codable {
    var id: Int
    var fullName: String?
    var language: String?
    var stargazersCount: Int?
}

struct RepositoryResponse: Codable {
    var totalCount: Int
    var items: [RepositoryModel]
}
