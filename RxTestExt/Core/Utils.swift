extension Optional {
    var stringify: String {
        switch self {
        case .none:
            return ""
        case .some(let value):
            return "\(value)"
        }
    }
}
