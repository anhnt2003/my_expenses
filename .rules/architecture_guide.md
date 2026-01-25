# Architecture Guide

## Architecture Pattern

**Clean Architecture + Feature-First Organization**

```
Presentation (features/) → Domain (domain/) → Data (data/)
```

## Key Rules

### 1. Layer Dependencies
- ✅ `features/` can import from `domain/` only
- ✅ `data/` implements interfaces from `domain/`
- ❌ Never import `data/` directly in `features/`

### 2. Feature Structure
Each feature in `features/` must contain:
```
feature_name/
├── screens/      # Full pages
├── widgets/      # UI components  
└── providers/    # Riverpod state
```

### 3. Domain Structure
```
domain/
├── entities/     # Pure business objects
├── repositories/ # Abstract interfaces
└── usecases/     # Single business actions
```

### 4. Data Structure
```
data/
├── models/       # Hive models with toEntity/fromEntity
├── datasources/  # Local database (Hive)
└── repositories/ # Implements domain interfaces
```

## Stack Reference

| Purpose | Technology |
|---------|------------|
| State | Riverpod |
| Storage | Hive |
| Routing | GoRouter |
| DI | GetIt |
| Errors | fpdart (Either) |
