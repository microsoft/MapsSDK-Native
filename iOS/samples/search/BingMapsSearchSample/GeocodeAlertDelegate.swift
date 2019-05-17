protocol GeocodeAlertDelegate: class {
    func searchButtonTapped(query: String, culture: String, region: String, useLocation: Bool, useBoundingBox: Bool)
}
