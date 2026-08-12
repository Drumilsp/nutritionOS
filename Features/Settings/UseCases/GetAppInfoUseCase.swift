import Foundation

struct GetAppInfoUseCase {
    private let configuration: AppConfiguration
    init(configuration: AppConfiguration = .founderDevelopment) { self.configuration = configuration }
    func execute() -> AppInfo {
        let bundle = Bundle.main
        return AppInfo(name: bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Nutrition OS", version: bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? configuration.appVersion, build: bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "—", environment: configuration.environment.rawValue)
    }
}
