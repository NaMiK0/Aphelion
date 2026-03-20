protocol NASAClientProtocol {
    func fetchAPOD(date: String) async throws -> APOD
}
