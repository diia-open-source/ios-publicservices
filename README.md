# DiiaPublicServices

Public services core functionality and Criminal Record Extract public service

## Description

- Public services core is presented by `PublicServiceCategoriesListModule`, it presents list of public services that are passed into it
- Criminal Record Extract public service is presented by `CriminalExtractListModule`

## Useful Links

|Topic|Link|Description|
|--|--|--|
|Ministry of Digital Transformation of Ukraine|https://thedigital.gov.ua/|The Official homepage of the Ministry of Digital Transformation of Ukraine| 
|Diia App|https://diia.gov.ua/|The Official website for the Diia application

## Getting Started

### Installing

To install DiiaPublicServices using [Swift Package Manager](https://github.com/apple/swift-package-manager) you can follow the [tutorial published by Apple](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) using the URL for this repo with the current version:

1. In Xcode, select “File” → “Add Packages...”
2. Enter `https://github.com/diia-open-source/ios-publicservices.git`

or you can add the following dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/diia-open-source/ios-publicservices.git", from: "1.0.0")
```

## Usage

### `PublicServiceCategoriesListModule`

Entry point for `DiiaPublicServicesCore` that depends on `PublicServicesCoreContext`.

```swift
import MVPModule
import DiiaNetwork
import DiiaPublicServicesCore

struct PublicServiceCategoriesListModuleFactory {
    static func create() -> BaseModule {
        let network: PublicServiceCoreNetworkContext = .create()
        let publicServiceRouteManager: PublicServiceRouteManager = .init(routeCreateHandlers: .publicServiceRouteCreateHandlers)
        let storage: PublicServicesStorage = PublicServicesStorageImpl.init(storage: StoreHelper.instance)
        let imageNameProvider: DSImageNameProvider = DSImageNameProviderImpl()
        
        PublicServiceCategoriesListModule(context: PublicServicesCoreContext(network: network,
                                                                             publicServiceRouteManager: publicServiceRouteManager,
                                                                             storage: storage, 
                                                                             imageNameProvider: imageNameProvider))
    }
}

extension PublicServiceCoreNetworkContext {
    static func create() -> PublicServiceCoreNetworkContext {
        // Retrieve preconfigured default session from DiiaNetwork.NetworkConfiguration
        let session = NetworkConfiguration.default.session
        let host = "localhost:443"
        // Define base headers for public services API endpoint
        let headers = ["App-Version": "1.0.0",
                       "User-Agent": "user-agent-value"]
                       
        return .init(session: session,
                     host: host,
                     headers: headers)
    }
}

private extension Dictionary {
    // Returns a specific public service router by type code to provide instructions to PublicServiceOpener how to open the service when called
    static var publicServiceRouteCreateHandlers: [ServiceTypeCode: PublicServiceRouteCreateHandler] {
        let criminalRecordCode = PublicServiceType.criminalRecordCertificate.rawValue
        return [
            criminalRecordCode: { items in
                // Return an instance that conforms to RouterProtocol
                return PSCriminalRecordExtractRoute(contextMenuItems: items)
            }
        ]
    }
}
```

### `CriminalExtractListModule`

Entry point for `DiiaPublicServices.PSCriminalRecordExtract` that depends on `PSCriminalRecordExtractConfiguration`.
It should be called in `PSCriminalRecordExtractRoute` that conforms to `RouterProtocol` and is required for the dictionary above.

```swift
import DiiaCommonTypes
import DiiaMVPModule
import DiiaNetwork
import DiiaPublicServices

struct PSCriminalRecordExtractRoute: RouterProtocol {
    private let contextMenuItems: [ContextMenuItem]
    
    init(contextMenuItems: [ContextMenuItem]) {
        self.contextMenuItems = contextMenuItems
    }
    
    func route(in view: BaseView) {
        let ratingServiceOpener: RateServiceProtocol = RatingServiceOpenerImpl()
        let urlHandler: URLOpenerProtocol = URLOpenerImpl()
        
        let session = NetworkConfiguration.default.session
        let host = "localhost:443"
        let headers = ["App-Version": "1.0.0",
                       "User-Agent": "user-agent-value"]
        
        // Make an instance that conforms to ContextMenuProviderProtocol
        let baseCMP: ContextMenuProviderProtocol = BaseContextMenuProvider(publicService: .criminalRecordCertificate, items: contextMenuItems)
        
        let config = PSCriminalRecordExtractConfiguration(ratingServiceOpener: ratingServiceOpener,
                                                          networkingContext: .init(session: session,
                                                                                   host: host,
                                                                                   headers: headers),
                                                          urlOpener: URLOpenerImpl())
        
        view.open(module: CriminalExtractListModule(contextMenuProvider: baseCMP, packageConfig: config))
    }
}
```

## Adding a new public service module to the package

Adding a new Public Services module to DiiaPublicServices involves several steps to ensure proper integration and functionality. 
Here is the guideline:

1. _Project Structure:_
Create a new directory in `Sources/PublicServices` for your public service module. For example, if your functionality is called `SomePublicService`, create a directory like `Sources/PublicServices/SomePublicService`.

2. _Swift Files:_
Add the Swift files for your public service module to the newly created directory. These files should contain the implementation of your service, including service-specific classes, structures, functions, or protocols.

3. _Dependencies:_
If the public service module depends on external dependencies, list them in the Package.swift file under the dependencies section for `DiiaPublicServices` target.
Use the Swift Package Manager (SPM) to manage dependencies.

4. _Public Interfaces:_
Define which entities (classes, structures, functions, etc.) from your public service module should be accessible outside the module. 
Declare them as available in their respective Swift files. 
Define an `entry point module` to which you will pass the `context` with the required dependencies for service-wide injection.

5. _Testing:_
Write unit tests for your public service module. Place these tests in a special directory: `Tests/PublicServicesTests/SomePublicService`, and make sure they cover the functionality of your new service module. 
Note: We do not cover View, ViewController, Module, Model and similar ones that contain UI or non-logical files with tests. Need to exclude them by updating the `Scripts/.xcovignore` file.

6. _Documentation:_
Document your public service module using comments if possible. Clear and concise documentation makes it easier for users to understand and integrate your module. 
Update the README.md file with information about the new public service.

7. _Integration and Usage:_
Integrate the updated Swift package into projects that require the new public service module as described in the `Installation` section above. Use the Swift Package Manager to make sure everything compiles and works properly.
Define `SomePublicServiceRoute` that conforms to `RouterProtocol`, where in `func route(in view: BaseView)` you need to create a service entry point module with the context and open it in the passed `view`. 
Then this route with its typeCode should be added as a key-value pair to the `publicServiceRouteCreateHandlers: [ServiceTypeCode: PublicServiceRouteCreateHandler]` dict.

## Code Verification

### Testing

In order to run tests and check coverage please follow next steps
We use [xcov](https://github.com/fastlane-community/xcov) in order to run
This guidline provides step-by-step instructions on running xcove locally through a shell script. Discover the process and locate the results conveniently in .html format.

1. Install [xcov](https://github.com/fastlane-community/xcov)
2. go to folder ./Scripts then run `sh xcove_runner.sh`
3. In order to check coverage report find the file `index.html` in the folder `../../xcove_output`.

We use `Scripts/.xcovignore` xcov configuration file in order to exclude files that are not going to be covered by unit tests (views, models and so on) from coverage result.

### Swiftlint

It is used [SwiftLint](https://github.com/realm/SwiftLint) to enforce Swift style and conventions. The app should build and work without it, but if you plan to write code, you are encouraged to install SwiftLint.

You can run SwiftLint manully by running 
```bash
swiftlint Sources --quiet --reporter html > Scripts/swiftlint_report.html.
```
You can also set up a Git [pre-commit hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) to run SwiftLint automatically by copy Scripts/githooks into .git/hooks

## How to contribute

The Diia project welcomes contributions into this solution; please refer to the [CONTRIBUTING.md](./CONTRIBUTING.md) file for details

## Licensing

Copyright (C) Diia and all other contributors.

Licensed under the  **EUPL**  (the "License"); you may not use this file except in compliance with the License. Re-use is permitted, although not encouraged, under the EUPL, with the exception of source files that contain a different license.

You may obtain a copy of the License at  [https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12).

Questions regarding the Diia project, the License and any re-use should be directed to [modt.opensource@thedigital.gov.ua](mailto:modt.opensource@thedigital.gov.ua).
