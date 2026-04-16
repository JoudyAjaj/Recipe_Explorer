# Project 2 brief — Recipe Explorer App

**Real HTTP calls · Multi-screen navigation · Animated UI · Skeletonizer loading · 3 weeks · Free public API, no key needed**

---

## Why this app

The Habit Tracker was self-contained — all data lived on the device, created by the user. This app is the opposite: data comes from a real REST API over the internet, she doesn't control it, and she must handle loading states, errors, and empty results gracefully.

The UI is also richer — animated transitions, debounced search, hero images, and a random meal feature. Navigation is deeper: tabs + nested stack + passing objects.

---

## The API

**TheMealDB — `themealdb.com/api.php`**

Free, no API key. Returns:
- Name
- Category
- Cuisine
- Instructions
- Ingredients
- Image

### Endpoints

- `categories.php` — list categories  
- `filter.php?c=Seafood` — meals by category  
- `lookup.php?i=52772` — meal detail  
- `search.php?s=chicken` — search  
- `random.php` — random meal  

---

## Project folder structure

```
recipe_explorer/
  lib/
  docs/
    gorouter_shell_routes.md
    provider_pattern.md
    debounce_timer.md
    skeletonizer_usage.md
    animation_controller.md
  json/
    categories.json
    filter_by_category.json
    meal_detail.json
    search_results.json
    random_meal.json
```

### Rules

**docs/**
- Write explanation for every new concept
- Use your own words
- Include real code snippet

**json/**
- Save raw API responses first
- Then build models
- Never guess API structure

---

## Screens to build

### 1. Home — category grid
- Fetch categories
- 2-column grid
- Skeleton loading
- Error + retry

---

### 2. Category detail — meal list
- List meals
- Thumbnail + name + bookmark
- Client-side search
- Animated list
- Skeleton loading

---

### 3. Meal detail
- Hero image (SliverAppBar)
- Name, cuisine, category
- Ingredients + quantities
- Instructions
- Share button

---

### 4. Search
- Debounced input (400ms)
- API search
- Empty state
- Skeleton loading

---

### 5. Favourites
- Stored with `shared_preferences`
- Sync across screens
- Empty state

---

### 6. Surprise Meal (Fun)
- Random meal
- Creative animation
- "Try again" button
- No Skeletonizer

---

## Navigation structure

Tabs:
- Home
- Search
- Surprise
- Favourites

Stack:
- Home → Category → Meal Detail

Use:
```
GoRouter + Shell Routes
```

---

## Loading states — Skeletonizer

Wrap real UI:
```
Skeletonizer(
  enabled: isLoading,
  child: ...
)
```

Use on:
- Home
- Category
- Search

Not used on:
- Surprise screen

---

## Build phases

### Phase 1 (Days 1–3)
- Save JSON responses
- Build API service
- Create models

---

### Phase 2 (Days 4–6)
- Setup navigation
- Shell routes
- Placeholder screens

---

### Phase 3 (Days 7–10)
- Connect API to UI
- Add Skeletonizer
- Handle errors

---

### Phase 4 (Days 11–13)
- Favourites system
- GetX controller pattern
- Local storage

---

### Phase 5 (Days 14–15)
- Search feature
- Debounce with Timer

---

### Phase 6 (Days 16–17)
- Surprise screen
- Custom animations

---

### Phase 7 (Days 18–20)
- Animations
- UI polish

---

### Phase 8 (Day 21)
- Review code
- Test offline
- Clean project

---

## AI usage rules

### Allowed
- Explain concepts
- Review your code
- Help understand JSON
- Suggest animation ideas

### Not allowed
- Generate core logic
- Setup router
- Fix bugs directly
- Skip docs/ or json/

---

## Mentor checklist

- Explain search flow (debounce → API → UI)
- Why favourites sync works
- Show error handling
- Explain shell routes
- Show offline mode
- Demo surprise screen
- Map JSON → model

---

## Final note

Two hard parts:
- GoRouter shell routes
- Cross-screen state sync

Key habit:
> Document everything you learn in your own words.
