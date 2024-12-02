# Podcaster

A podcast streaming app showcasing iOS development skills. Includes reusable packages for network requests and storage using Swift Concurrency, Combine, and Closures. Features four projects demonstrating SwiftUI (MVVM, MVVM-C) and UIKit (MVC, VIPER) architectures. Fully tested with XCTest and Swift Testing.

## Requirements

- Xcode 16.1+
- Swift 6.0+

## Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/wolfej94/Podcaster.git
   cd Podcaster
   ```

2. **Run Configuration Sync**:
   To populate the configuration files with API keys and other sensitive information, run the following command in the terminal:
   ```bash
   ./ConfigurationSync
   ```
   This command syncs the configuration files into the app, which contain sensitive information like API keys. These files are not included in the public repository for security reasons.
   _note that you will need access to my private configuration repository_

## Architecture

The app demonstrates the following architectural patterns:

- **MVVM** (Model-View-ViewModel)
- **MVVM-C** (Model-View-ViewModel-Coordinator)
- **MVC** (Model-View-Controller)
- **VIPER** (View-Interactor-Presenter-Entity-Router)

## Features

- SwiftUI-based user interfaces
- UIKit-based user interfaces
- Network requests using Swift Concurrency and Combine
- Unit and UI tests with XCTest

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
