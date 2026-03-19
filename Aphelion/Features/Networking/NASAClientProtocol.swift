protocol NASAClientProtocol {
    func fetchAPOD() async throws -> APOD
}
