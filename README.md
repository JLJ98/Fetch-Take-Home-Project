# Fetch-Take-Home-Project


# Steps to Run the App

Clone this repository to your local machine using git clone.
Open the project in Xcode by double-clicking the .xcodeproj file or .xcworkspace file (if applicable).
Ensure your system meets the following requirements:
Xcode version: 14.0 or later.
iOS Deployment Target: iOS 13.0 or later.
Select a simulator or connected device in Xcode.
Build and run the app using the Run button (Cmd+R).
The app will display a list of recipes fetched from the API endpoint. Tap a recipe to view its details.

#Focus Areas

Scalability and Maintainability (MVVM Pattern): I focused on structuring the app using the MVVM (Model-View-ViewModel) architecture to ensure that the code is modular, testable, and scalable. This separation of concerns makes the code easier to maintain and extend.
Image Caching: Implemented a custom caching mechanism to optimize network usage and improve performance by caching images to disk and memory.
Error Handling and Resilience: Ensured that the app gracefully handles malformed data, empty responses, and network errors. Users are informed through visual cues like placeholders and alerts.
User Interface: Prioritized a visually appealing and intuitive design. Added random background colors to recipe rows to make the UI more engaging.
Performance Optimization: Images are loaded on-demand to reduce unnecessary network calls, aligning with the requirement for efficient network usage.


#Why These Areas?

These areas directly address the project requirements, such as efficient network usage, resilience to errors, and caching images for better performance.
I wanted to demonstrate a balance of technical expertise (e.g., MVVM, caching) and user-centric design (e.g., engaging UI, clear error states).

#Time Spent

Total Time: Approximately 4–5 hours.
Breakdown:
Setting up the project structure and architecture: 1 hour.
Implementing API integration and error handling: 1 hour.
Image caching and optimization: 1 hour.
UI design and enhancements: 1 hour.
Debugging, testing, and polishing: 1 hour.

#Trade-offs and Decisions

Custom Image Caching vs. Libraries: I initially tried Kingfisher and SDWebImage but ultimately implemented a custom caching solution to meet specific requirements (e.g., avoiding reliance on HTTP caching). This decision added complexity but ensured fine-grained control.
Focus on Core Requirements: I focused on achieving the core functionality instead of adding advanced features like search or filtering to prioritize stability and clarity.
UI Simplicity vs. Customization: The UI is clean but not overly complex. Some advanced animations or transitions were skipped to keep the focus on functionality.
#Weakest Part of the Project

UI Consistency: While visually appealing, the random background colors on recipe rows might make the UI feel inconsistent. Additionally, some text on lighter backgrounds could still be hard to read despite efforts to adjust the colors.
Caching Robustness: The custom caching mechanism works but might not handle edge cases (e.g., cache eviction policies or disk space constraints) as robustly as mature libraries like Kingfisher or SDWebImage.
Testing: While I included unit tests for key components, I could add more comprehensive tests, especially UI and integration tests.

#External Code and Dependencies

Kingfisher (attempted but not used): Initially explored for image caching but decided to implement a custom solution to meet project requirements.
Custom Utilities:
ImageFetcher for fetching and caching images.
ImageCacheManager for managing in-memory and disk-based caching.

#Additional Information
Error Scenarios: Tested the app with the provided API endpoints for malformed and empty data. The app gracefully handles these cases by displaying appropriate messages to the user.
Interview Preparedness: Throughout the project, I ensured that every decision is well-documented and defensible for an interview scenario.
Future Improvements:
Add support for offline mode using local storage (if permitted).
Improve the color scheme to ensure better text readability across all themes.
Enhance test coverage, especially for integration and edge cases.

