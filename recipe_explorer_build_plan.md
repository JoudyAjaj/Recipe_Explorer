# Recipe Explorer App - Implementation Plan

This plan is designed for learning by building. It follows your project rules:
- Real API integration with TheMealDB
- Provider state management
- Clean architecture separation (`service + model + ui`)
- GoRouter with shell routes
- Skeletonizer loading (except Surprise)
- Strong error, empty, and offline handling
- Beautiful UI with meaningful animations

---

## 1) Project Goal

Build a production-style Flutter app with 4 tabs:
1. Home (categories)
2. Search
3. Surprise
4. Favourites

Nested navigation inside Home:
- Category Meals List
- Meal Details

Core learning outcomes:
- API -> model mapping
- State management with GetX
- Cross-screen favourites sync
- Debounced search
- Reliable UI states (loading/error/empty/offline)
- AnimationController-driven UI animation

---

## 2) Recommended Folder Structure

```text
lib/
  app/
    app.dart
    router.dart
    theme.dart

  core/
    constants/
      api_endpoints.dart
    errors/
      app_exceptions.dart
      failure_types.dart
    network/
      connectivity_service.dart
      network_client.dart
    utils/
      debounce.dart
      result.dart

  data/
    models/
      category_model.dart
      meal_summary_model.dart
      meal_detail_model.dart
    services/
      meal_api_service.dart
      favourites_local_service.dart
    mappers/
      meal_mapper.dart

  features/
    home/
      providers/
        categories_provider.dart
        category_meals_provider.dart
      screens/
        home_screen.dart
        category_meals_screen.dart
      widgets/
        category_card.dart
        meal_tile.dart
        home_skeleton.dart
        category_meals_skeleton.dart

    meal_detail/
      providers/
        meal_detail_provider.dart
      screens/
        meal_detail_screen.dart
      widgets/
        ingredient_chip.dart

    search/
      providers/
        search_provider.dart
      screens/
        search_screen.dart
      widgets/
        search_result_tile.dart
        search_skeleton.dart

    surprise/
      providers/
        surprise_provider.dart
      screens/
        surprise_screen.dart
      widgets/
        surprise_card.dart

    favourites/
      providers/
        favourites_provider.dart
      screens/
        favourites_screen.dart
      widgets/
        favourite_meal_tile.dart

  shared/
    widgets/
      app_error_state.dart
      app_empty_state.dart
      retry_button.dart
      network_banner.dart
```

---

## 3) Package Setup

Add these dependencies in `pubspec.yaml`:
- `http`
- `go_router`
- `provider`
- `shared_preferences`
- `skeletonizer`
- `connectivity_plus`
- `cached_network_image`
- `share_plus`

Optional nice UI helpers:
- `google_fonts`
- `flutter_animate`

---

## 4) Architecture Rules (Clean and Practical)

### Models
- Parse API JSON only in model classes.
- Keep models immutable when possible.
- Never guess fields; use saved raw JSON samples first.

### Services
- `meal_api_service.dart`: all HTTP calls to TheMealDB.
- `favourites_local_service.dart`: all `shared_preferences` read/write logic.
- Services return data or typed failures, not UI widgets.

### Providers
- Own screen state and business flow (loading, data, error).
- Call services and expose simple properties for UI.
- Notify listeners only when state truly changes.

### UI
- Screens read provider state.
- Widgets are reusable and mostly presentation only.
- Keep UI resilient for all states: loading, success, empty, error, offline.

---

## 5) Data Contracts to Build First

From TheMealDB endpoints:
1. `categories.php`
2. `filter.php?c=...`
3. `lookup.php?i=...`
4. `search.php?s=...`
5. `random.php`

Create these core models:
1. `CategoryModel`
2. `MealSummaryModel` (id, name, thumb)
3. `MealDetailModel` (name, image, category, area, instructions, ingredients list)

Ingredient parsing strategy for detail model:
- Loop `strIngredient1..20` and `strMeasure1..20`
- Ignore blank/null ingredients
- Build a clean list of pairs `(ingredient, measure)`

---

## 6) State Management Plan (Provider)

### Global Provider
`FavouritesProvider`
- Source of truth for favourite IDs and optional cached meal summaries
- Methods:
  - `loadFavourites()`
  - `toggleFavourite(MealSummaryModel meal)`
  - `isFavourite(String mealId)`
  - `removeFavourite(String mealId)`
- Persist after each change via `favourites_local_service`

### Feature Providers
- `CategoriesProvider`
- `CategoryMealsProvider`
- `MealDetailProvider`
- `SearchProvider` (includes debounce)
- `SurpriseProvider`

Each provider should expose:
- `isLoading`
- `errorMessage` (nullable)
- `items` or `meal` data
- `retry()` method for failed requests

---

## 7) Routing Plan (GoRouter + Shell)

Use `ShellRoute` for bottom tabs:
- `/home`
- `/search`
- `/surprise`
- `/favourites`

Nested inside Home branch:
- `/home/category/:categoryName`
- `/home/meal/:mealId`

Recommended navigation behavior:
- Keep tab state while switching tabs
- Use route params for ids/names
- Pass small objects via `extra` only when useful

---

## 8) UI and Animation Plan

### Visual Direction
- Fairy-tale inspired palette: moonlight blue, forest green, parchment cream, rose gold accents
- Use layered backgrounds (soft gradients, subtle sparkles, hand-drawn texture overlays)
- Card style: storybook panels with rounded corners, delicate borders, and gentle shadows
- Typography mood: elegant serif for headings + clean sans for body text for readability
- Icon and shape language: stars, leaves, lanterns, and curved decorative dividers
- Image treatment: soft vignette or glow frame to make meal photos feel magical
- Keep contrast and spacing accessible so theme remains beautiful and usable

### Fairy-Tale Design Guidelines
- Home tab should feel like entering a magical cookbook (hero header + enchanted category cards)
- Search tab should resemble a spell lookup desk (ornamental input field + animated result reveal)
- Surprise tab should be the most playful screen (mystery chest / magic reveal visual metaphor)
- Favourites tab should feel like a royal recipe archive (saved cards with golden highlight states)
- Use consistent design tokens across tabs (same radius, shadow, glow intensity, and spacing scale)

### Required Animations
1. Home: staggered category cards on first load
2. Category meals: list fade/slide entries
3. Meal detail: Hero transition on meal image
4. Surprise: AnimationController-driven reveal (scale + rotate + fade)
5. Search: subtle result transition when new results arrive

### Skeletonizer Usage
Use skeletons on:
- Home categories grid
- Category meals list
- Search results

Do not use skeleton on:
- Surprise screen

---

## 9) Screen-by-Screen Build Tasks

### Home (Categories)
- Fetch categories from API
- 2-column image grid
- Tap category -> category meals route
- Loading: skeleton grid
- Error: retry card/button

### Category Meals
- Fetch by category
- Show meal thumb + title + favourite action
- Client-side search input on loaded list
- Animated list item entry
- Loading/error/empty states

### Meal Detail
- Fetch by meal ID
- SliverAppBar + hero image
- Title, cuisine, category
- Ingredients and instructions sections
- Share button
- Favourite toggle should stay in sync

### Search
- Text field with 400ms debounce
- API search by name
- Loading skeleton while searching
- Empty result state when no matches
- Error + retry

### Favourites
- Load favourites from local storage on app start
- Show saved meals list
- Remove item and sync everywhere
- Empty state with call to action

### Surprise
- Fetch random meal from API
- Animated reveal with AnimationController
- Try Again button
- Error + retry
- No skeleton

---

## 10) Offline and Error Handling Strategy

Network-aware behavior:
- Detect connectivity via `connectivity_plus`
- If offline:
  - show banner/message
  - keep usable cached or existing local data when available

Error UX rules:
- Human-readable error messages
- Always include a retry action
- Avoid blocking whole app for partial feature errors

---

## 11) Debounce Implementation Plan (Search)

Use a reusable debounce utility (`Timer` based):
- Delay: 400ms after user stops typing
- Cancel previous timer on each keystroke
- Trigger API only for latest query
- If query is empty: clear results and stop loading

---

## 12) Favourites Persistence Plan

Storage design in `shared_preferences`:
- Store meal IDs in `StringList`
- Optional: store minimal serialized summaries for fast favourites UI

Sync strategy:
- `FavouritesProvider` initialized at app boot
- All screens read same provider instance
- Any toggle immediately updates provider + storage + visible UI

---

## 13) Suggested Build Timeline

### Milestone A - Foundation (Day 1-3)
- Add packages
- Save raw API JSON samples in `json/`
- Build models and API service
- Create reusable Result/Failure types

### Milestone B - Navigation Skeleton (Day 4-6)
- Setup GoRouter + ShellRoute tabs
- Add placeholder screens
- Wire nested home routes

### Milestone C - Core Data Screens (Day 7-11)
- Home categories
- Category meals
- Meal detail
- Skeleton states and error states

### Milestone D - State and Persistence (Day 12-14)
- Implement FavouritesProvider
- Connect shared_preferences
- Ensure cross-screen sync

### Milestone E - Search and Debounce (Day 15-17)
- Search provider with 400ms debounce
- Empty/error/loading handling

### Milestone F - Surprise and Polish (Day 18-20)
- Random meal + custom animation
- UI polish and transitions
- Offline UX improvements

### Milestone G - Review and Hardening (Day 21)
- Manual test checklist
- Refactor and clean code
- Complete docs writeups

---

## 14) Documentation Checklist (`docs/`)

For each concept, write in your own words with real snippet:
1. `provider_pattern.md`
2. `gorouter_shell_routes.md`
3. `debounce_timer.md`
4. `skeletonizer_usage.md`
5. `animation_controller.md`

Also add:
- `error_and_retry_pattern.md`
- `offline_handling.md`
- `json_to_model_mapping.md`

---

## 15) Definition of Done

You are done when all are true:
1. All required screens and routes work.
2. Every async screen handles loading, error, and empty states correctly.
3. Search is debounced to 400ms and stable.
4. Favourites persist after app restart.
5. Favourites update instantly across Home, Detail, Search, and Favourites tabs.
6. Surprise screen uses AnimationController and has retry flow.
7. Offline behavior is graceful and user-friendly.
8. `docs/` explanations and `json/` raw API samples are completed.
9. Code is organized by service/model/ui and easy to explain.

---

## 16) Practical Daily Workflow

For each feature:
1. Save raw JSON sample (`json/`)
2. Build or update model
3. Add service method
4. Add/extend provider
5. Build UI states (loading/success/error/empty)
6. Connect navigation
7. Add animation if needed
8. Write docs note in your own words
9. Manually test online/offline and retry behavior

This keeps implementation clean and makes mentoring/demo easy.