# Conventions

### Asset, Resource, File naming conventions

**General rule**: Subject_Descriptor_Variant

- Example: Player_Idle_01.anim

***Always use 0 padding for variant numbers! (example above)***

| Asset Type | Convention | Example |
| --- | --- | --- |
| Models | Subject_Component_Variant | Player_Head_Transformed |
| Materials | Subject_Material | Wood_Damp |
| Textures | Subject_Texture_Suffix | Player_Shirt_Diffuse |
| Animations | Subject_Action_Variant | Player_Walk_Left |
| Audio | Subject_Action_Variant | Player_Sit_01 |
| UI | UI_Name_Action | UI_Button_Hover |
| Resources | Subject_DataType | Player_Data |
| Shaders | Name_Variant | Water_Bloody |
| Code | name_variant | player_controller.gd |

Edge cases handled differently of course, if something happens often enough, or we predict it will, we create a rule.

### Code Naming conventions

|  | Convention | Example |
| --- | --- | --- |
| Classes/Nodes | PascalCase | PlayerController |
| Functions | snake_case | calculate_damage() |
| Variables (public) | snake_case | current_health |
| Variables (private) | _snake_case | _some_calculation |
| Parameters | snake_case | damage_amount |
| Constants | UPPER_SNAKE_CASE | MAX_HEALTH |
| Enum names | PascalCase | AnimationState |
| Enum values | UPPER_SNAKE_CASE | WALKING |
| Booleans | is_/has_/can_ + snake_case | is_grounded |
| Signals | past tense snake_case | health_changed |

### Folder organization

Asset oriented as it is not too small to dump all files (e.g. textures) into a folder, and allows for scaling up.

Full folder organization found in Game Directory Structure markdown file.

### Branching/merging strategies

- No direct pushes to main, unless it is urgent or approved.
- Pull Requests (PRs) are required.
- All PRs are reviewed by Tech Lead (Gabe).
- Merge conflicts to main are resolved by Gabe.
- Merge conflicts on branches can be resolved by the individual owning the branch or with the help of others.
- Ensure branch is always up to date with main before submitting a PR.

**Branches:**

| Branch | Purpose | Lifetime |
| --- | --- | --- |
| main | Protected, always playable game is here | Permanent |
| feature | New functionality | < 1 week |
| fix | Bug fixes | < 1 day |
| refactor | Structural or code changes | < 1 week |
| art | Asset work | ~? Days |
| release | Near final release if needed by the end of our project | TBD |

Merging: Squash merge. All commits on branch gets squashed and merged into 1 commit on main branch. This allows for clean history on main branch.

### Git commit conventions

Lightweight conventional commits with prefixes.

| Prefix | Purpose | Example |
| --- | --- | --- |
| feat | New feature implemented | feat: add player crouch code |
| asset | New asset (model/texture/audio/etc.) added | asset: add player crouch animation |
| fix | Bug got fixed | fix: prevent camera getting stuck in walls |
| refactor | Code and/or files refactored | refactor: extract health system |
| docs | Documenting work (in code or in a file) | docs: save system |
| chore | Annoying thing done (e.g. changed 1 value) | chore: update crouch camera position |

**Do not commit builds. They will be automatically compiled on merge to main.**

Binary files can be merged thanks to AI, no clue how it works though, but can look into it. (i.e. Godot Scenes (equivalent to Unity Prefabs) are binary files, and it will get ugly to merge if two people are working on it at the same time). As of writing this, we have opted for avoiding AI conflict resolution and merges. If you don't know what this means, don't worry about it for now.

**Milestone tracking with Git Tags.** We can use a more interesting tagging than just v0.1, the idea is:

- p01, p02, etc. → Prototype versions
- vs01, vs02, etc. → Vertical slice versions
- a01, b01, etc. → Alpha and/or beta versions
- r01, r02, etc. → Release versions

**For GitHub releases, we can use regular versioning (v0.1.0), as long as we agree which version counts as what, otherwise we can discuss to just use the same versioning for tags or vice-versa throughout for easy of use.**

### Git workflow

1. Pull latest main
2. Create a branch: feature/art/etc. (e.g. feature/player-crouch)
3. Work locally
4. Make local commits: feat/fix/docs/etc. (e.g. fix: player crouch camera position)
5. Push branch
6. Pull latest main (resolving conflicts)
6. Open pull request
7. Wait for review and resolution by Gabe
12. Receive feedback on merge or issue
13. Once merged, return to main branch, pull, and start new task

### Code comment and documentation expectations

Everything should be self-explaining.

Function naming like `secret_calculation(a: int, b: char) → void` are not advised.

Comment things that are not obvious like `velocity += deltaTime * 0.8` why 0.8, comment on that. Even better if you set a descriptive variable for what 0.8 is, like `_relativeGravity = 0.8` and then `velocity += deltatime * _relativeGravity`

Comment things that can’t be self explanatory in purpose like `if jumpBuffer > 0.1 and is_wet()` , what is going on with that? Why are we checking that? Comment those things. 

Document public APIs. If we have a `func apply_damage(amount: int) -> bool` you could comment what it does so we can look it up if we want to use it, and why it would return a `bool` (e.g. returns true if it can verify that damage has been applied). You can also document requirements and limitations, such as amount having to be positive, and where it’s expected to be called.

Avoid commenting out old code. We can track history if we need it with Git, let’s keep code tidy and readable.

If you want to document how a specific mechanic or system works, what interactions happen within code/assets, use the **Docs** folder and add a file there (up to your preference what file you want to use). Depending on how many of these we get, we will organize it later.

### TODOs, and how to keep track

We can use GitHub Issues and GitHub Project, alongside code comments with `TODO` in there to track. Some IDEs/Editors can highlight TODOs in code comments (such as Godot's built-in editor).

All TODOs have to be explained, so if someone else joins in to help you code, they know what is expected to be done without having to ask you. (i.e. don’t do `# TODO: fix this`, instead do `# TODO: crouching input only changes animation but not camera angle, ensure camera is also moved` , that is much easier to go from).

### Issues, errors, bugs

GitHub Issues and GitHub Project. Everything will be there.

Submit an Issue and the more you describe it, the better, we can then figure out who gets to resolve it, how important it is, and other details. No template recommendation as it might be too much work for the small game.

Builds from main branch must be playable even if it has bugs. This way we will always have something to submit.
