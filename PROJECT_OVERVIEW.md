# HangInThere Project Overview

## What This Project Is

`HangInThere` is a SwiftUI iOS word-guessing game inspired by Hangman.

The player:

- starts on a splash screen
- chooses a category
- chooses a difficulty level
- plays a hangman round
- earns XP and levels up
- uses power-ups to survive harder rounds

The project is already structured to support growth beyond a small prototype.

## Current Game Features

- 4 categories:
  - Animals
  - Geography
  - Foods
  - Objects
- 3 game modes:
  - Easy
  - Medium
  - Hard
- 100 items per category
- word pools separated by difficulty level
- hint system
- player progression with XP and levels
- 2 power-ups:
  - Reveal Letter
  - Free Guess
- round summary state for win/loss
- persistent player progress with `UserDefaults`
- deterministic setup for UI tests

## Core Gameplay Rules

- The player chooses one category and one difficulty level before starting a round.
- Each round loads one `HangmanWord` from the selected category and difficulty pool.
- The player guesses letters through an on-screen keyboard.
- The puzzle allows up to 6 mistakes.
- A correct guess reveals matching letters.
- A wrong guess removes one life unless the Free Guess shield is active.
- `Reveal Letter` reveals one hidden letter.
- `Free Guess` protects the next mistake from consuming a life.
- A round ends as:
  - `won` when all letters are revealed
  - `lost` when mistakes reach the maximum
- Winning grants XP.
- The player starts with no power charges.
- Reaching level 3 unlocks 1 `Reveal Letter` and 1 `Free Guess`.
- Later milestone levels grant capped refills:
  - mostly `Free Guess`
  - `Reveal Letter` only on bigger milestones
  - both powers capped at 2 stored charges

## Difficulty System

The app currently supports explicit difficulty-based content routing:

- `easy`
- `medium`
- `hard`

The repository loads words from a dedicated pool for the selected difficulty, not from a single shared list filtered in the UI layer.

The active difficulty is visually shown during gameplay through:

- a top badge/chip
- a dedicated color
- a dedicated symbol

## Architecture

The project follows a feature-oriented MVVM structure with additional domain and data separation.

### Architectural layers

- `View`
  - SwiftUI screens and reusable UI components
  - renders state
  - forwards user actions
- `ViewModel`
  - owns observable UI state
  - orchestrates feature behavior
  - maps domain state to view state
- `Domain`
  - entities
  - gameplay rules
  - use cases
- `Data`
  - repositories
  - persistence implementations
- `Shared`
  - design system
  - constants
  - support types

### Patterns currently in use

- MVVM
- feature-based folder organization
- repository pattern
- use case / application service pattern
- composition root / dependency injection
- view state mapping

## Folder Structure

### App

- `HangInThere/App`
  - `HangInThereApp.swift`
  - `MainView.swift`
  - `AppViewModel.swift`
  - `AppFlowUseCases.swift`

### Features

- `HangInThere/Features/Splash/Views`
- `HangInThere/Features/CategorySelection/Views`
- `HangInThere/Features/GameLevelSelection/Views`
- `HangInThere/Features/Game/ViewModels`
- `HangInThere/Features/Game/Views`
- `HangInThere/Features/Game/Presentation`
- `HangInThere/Features/Game/Domain`
- `HangInThere/Features/Game/Data`

### Shared

- `HangInThere/Shared/DesignSystem`
- `HangInThere/Shared/Resources`
- `HangInThere/Shared/Support`

### Tests

- `HangInThereTests/App`
- `HangInThereTests/Features/Game/Domain`
- `HangInThereTests/Features/Game/ViewModels`
- `HangInThereTests/Support`
- `HangInThereUITests/App`

## Main App Flow

The high-level app flow is:

1. `Splash`
2. `Category Selection`
3. `Game Level Selection`
4. `Game`
5. `Round Summary`
6. `Next Round` or `Back to Categories`

This flow is coordinated by `AppViewModel` and app-flow use cases.

## Main Types and Responsibilities

### App Layer

- `HangInThereApp`
  - application entry point
  - builds the concrete repositories
  - injects dependencies into the root view
- `MainView`
  - switches between app phases
- `AppViewModel`
  - owns app navigation state
  - coordinates transitions between splash, category selection, level selection, and game
- `AppFlowUseCases`
  - encapsulate navigation decisions

### Domain Layer

- `HangmanWord`
  - answer, hint, and difficulty value used for reward calculation
- `HangmanCategory`
  - game category metadata
- `GameLevel`
  - difficulty mode metadata
- `PlayerProgress`
  - level, experience, level-threshold progression, and capped power-up charge rewards
- `HangmanPuzzle`
  - current round state and game rules
- `StartRoundUseCase`
  - creates a new round from the repository
- `GuessLetterUseCase`
  - applies a letter guess
- `UsePowerUpUseCase`
  - applies power-up effects
- `ResolveRoundStateUseCase`
  - resolves win/loss/continue state
- `AwardProgressUseCase`
  - awards XP and computes gained levels
- `SpendPowerChargeUseCase`
  - consumes power-up charges

### Data Layer

- `WordRepository`
  - abstraction for fetching words by category and difficulty
- `InMemoryWordRepository`
  - current source for all game content
- `GameWordBank`
  - contains the word lists
- `ProgressRepository`
  - abstraction for player progress persistence
- `UserDefaultsProgressRepository`
  - current production persistence
- `InMemoryProgressRepository`
  - test and UI-test friendly persistence

### Presentation Layer

- `HangmanGameViewModel`
  - gameplay view model
  - owns progress, selected category, selected level, round state, and feedback message
  - exposes view state objects for screens
- `ViewStates.swift`
  - presentation-specific state models for rendering

## Current MVVM Application

The project applies MVVM in a practical, scalable way:

- Views do not own game logic.
- View models do not own raw persistence implementations.
- Domain logic is extracted into use cases instead of being embedded directly into the UI.
- Repositories abstract data sources.
- Screen rendering is driven through derived view state.

This is stricter than a small prototype but still lightweight enough for a solo project.

## Dependency Injection

Dependencies are created at the composition root in `HangInThereApp`.

Production mode:

- `InMemoryWordRepository.default`
- `UserDefaultsProgressRepository`

UI testing mode:

- deterministic `InMemoryWordRepository`
- `InMemoryProgressRepository`

This makes the app easier to test and easier to extend later.

## Design System

The app uses shared design-system components and theme values:

- `AppTheme`
- `AppCard`
- `AppButton`
- `AppStatBadge`
- `AppProgressBar`
- `AppPill`

This keeps the UI style more consistent and avoids repeated layout and styling code.

## Strings and Constants

Centralized constants live in:

- `HangInThere/Shared/Support/Strings.swift`
- `HangInThere/Shared/Support/AccessibilityIdentifiers.swift`

This reduces raw string duplication in the UI and tests.

## Testing Strategy

### Unit tests

The unit tests cover:

- app flow transitions
- game domain behavior
- view-model behavior
- repository-backed progress loading/saving behavior

### UI tests

The UI tests cover:

- splash to category flow
- category to level selection to game flow
- deterministic winning flow and summary actions

UI tests use a deterministic word source so they remain stable.

### UI testing notes

- UI tests in this project use `XCTest`, not `Testing`, because app-launch, tap, wait, and accessibility-tree APIs come from `XCTest`.
- Unit and domain tests can use `Testing`, because they instantiate and verify logic directly without launching the app.
- Accessibility identifiers are the main testing contract between the SwiftUI screens and the UI test target.

### SwiftUI accessibility lesson learned

One concrete issue appeared while testing the game difficulty badge:

- the badge had the identifier `game.modeBadge`
- the UI test originally searched for it with `app.otherElements["game.modeBadge"]`
- that failed even though the identifier existed

Why it failed:

- SwiftUI accessibility trees do not always expose custom composed views under the exact XCTest element bucket you expect
- a view built from `HStack`, `Image`, `Text`, and modifiers may not reliably appear as an `otherElement`

How it was fixed:

- the badge view was made into a single accessibility node using:
  - `.accessibilityElement(children: .ignore)`
  - `.accessibilityLabel(...)`
- the UI test was changed to search the full accessibility tree with:
  - `app.descendants(matching: .any)["game.modeBadge"]`

Practical rule for this project:

- use `app.buttons[...]` for real buttons
- use `app.staticTexts[...]` for plain text when stable
- use `app.descendants(matching: .any)[...]` for custom SwiftUI-composed views such as pills, badges, cards, and containers

## Scalability Notes

The current structure is suitable for expanding the app further.

It is already prepared for future features such as:

- ranking / leaderboard system
- player profiles
- additional categories
- more game modes
- remote repositories
- online progression sync

### Recommended future additions

If the app keeps growing, the next natural additions are:

- `PlayerProfile` entity
- `RankingEntry` / `LeaderboardEntry` entity
- `RankingRepository`
- a dedicated `Ranking` feature module
- separate local progression from competitive ranking score

## Current Strengths

- clear folder structure
- real MVVM separation
- extracted domain use cases
- repository abstraction
- testable composition root
- centralized UI constants
- reusable design system
- scalable app flow

## Current Limitations

- domain types still contain some UI-oriented metadata such as colors and symbols
- the word bank is local and static
- there is no player identity system yet
- there is no network layer yet
- progression is local-only

## Summary

At this stage, `HangInThere` is no longer just a basic hangman demo.

It is a structured SwiftUI game project with:

- feature-based MVVM architecture
- domain use cases
- repository abstraction
- progression system
- difficulty-based content selection
- automated tests

It is in a good state for adding bigger features next, especially ranking, profile, and richer game content.
