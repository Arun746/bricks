# My Bricks

Custom Mason bricks for Flutter projects.

## bricks

### directories
Initializes an existing Flutter project with:
- Full `lib/core/` folder structure with all utilities, services, widgets, etc.
- Empty `lib/features/` folder
- Assets folders (images, icons)
- Minimal `pubspec.yaml`, then installs **only the dependencies the templates actually use** at their **latest compatible versions** (via `flutter pub add`)

### feature
Creates a new feature module under `lib/features/{feature_name}/`:
- `widget/`
- `providers/`
- `repositories/`
- `models/`

The package name is auto-detected from your app's `pubspec.yaml`, so all generated imports (`package:your_app/...`) are correct — no prompts needed.

---

## How to Use

### Option 1: Use from GitHub

Add bricks from GitHub in your project's `mason.yaml`:

```yaml
bricks:
  directories:
    git:
      url: https://github.com/github_USERNAME/my_bricks.git
      path: bricks/directories
  feature:
    git:
      url: https://github.com/github_USERNAME/my_bricks.git
      path: bricks/feature
```

Then run:
```bash
mason get
```

### Option 2: Use Locally

If working on bricks locally, add path to local bricks:

```bash
cd your_flutter_project
mason add directories --path /Users/...../my_bricks/bricks/directories
mason add feature --path /Users/...../my_bricks/bricks/feature
```

---

## Commands

### Initialize a New Project

```bash
# 1. Create new Flutter project and cd into it
flutter create my_tv_app
cd my_tv_app

# 2. Initialize mason
mason init

# 3. Add and run directories brick
mason add directories --path /path/to/my_bricks/bricks/directories
# OR after adding to mason.yaml with git:
mason get
mason make directories
# Enter project name when prompted (e.g., my_tv_app)
# -> Dependencies are installed automatically with latest versions

# 4. Follow printed instructions:
dart run build_runner build -d
```

> Requires Flutter on your PATH (the hook runs `flutter pub add`).
>
> If `dart run build_runner build` fails with `'dart compile' does not support build hooks`
> (a Dart 3.10 issue triggered by firebase's native hooks), use
> `dart run build_runner build -d --force-jit` instead — fixed in Dart 3.11+.

### Add a New Feature

```bash
# After directories is set up (run from the app root)
mason make feature
# Enter feature name when prompted (e.g., settings, profile, home)

dart run build_runner build -d
```

---

## Directory Structure After Use

```
my_tv_app/
├── lib/
│   ├── core/
│   │   ├── configs/
│   │   ├── enums/
│   │   ├── exceptions/
│   │   ├── models/
│   │   ├── services/
│   │   ├── styles/
│   │   ├── utils/
│   │   └── widgets/
│   └── features/
│       └── {feature_name}/
│           ├── widget/
│           ├── providers/
│           ├── repositories/
│           └── models/
├── assets/
│   ├── images/
│   └── icons/snackbar/
└── pubspec.yaml
```

---

## Notes

- All internal imports use `package:{project_name}/...` style
- Dependency versions are never hardcoded — `flutter pub add` resolves the latest compatible release every time you generate
- Run `dart run build_runner build -d` after generating to produce freezed/riverpod code
- After first use with git URL, just run `mason get` to update bricks
