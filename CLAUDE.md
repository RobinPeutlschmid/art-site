# art-site — Robin Peutlschmid's personal site

## What this is
A Hugo static site using the Blowfish theme, deployed to GitHub Pages via GitHub Actions.
Live at: https://www.robinpeutlschmid.cz

## Project structure
- `config/_default/` — all site configuration (hugo.toml, languages.en.toml, menus.en.toml, params.toml, markup.toml)
- `content/journal/` — art journal entries as page bundles (symlinked from Obsidian vault on E: drive, synced via sync-journal.sh)
- `content/portfolio/` — portfolio entries divided into films/, vfx/, blender/, gamedev/ (symlinked from Obsidian vault on E: drive, synced via sync-portfolio.sh)
- `content/about.md` — about page
- `assets/img/` — site-level images (profile photo etc.)
- `layouts/` — custom template overrides and shortcodes
- `static/` — favicon and other verbatim-copied files
- `themes/blowfish/` — git submodule, never edit directly
- `.github/workflows/hugo.yaml` — GitHub Actions deploy workflow

## Hugo version
Extended edition, currently 0.163.3. Must be Extended for WebP image processing.

## Theme
Blowfish (https://blowfish.page). Installed as git submodule at themes/blowfish.
- Never edit files inside themes/blowfish/ — changes get wiped on theme updates
- Override theme behavior via config/_default/ or layouts/ only
- Theme config docs: https://blowfish.page/docs/configuration/

## Key config facts
- baseURL: https://www.robinpeutlschmid.cz/
- defaultContentLanguage: en
- colorScheme: slate, defaultAppearance: dark
- Homepage layout: profile
- Taxonomies: tags, categories, series, worlds (custom, for Onen Svět worldbuilding)
- JSON output on home required for Blowfish search to work

## Content conventions
- Journal entries: page bundles (folder + index.md + images co-located)
- Front matter format: YAML (---), not TOML (+++) — Obsidian compatibility
- Images must be in the page bundle or assets/, NOT static/ — static/ skips Hugo's image pipeline
- draft: true = local preview only, draft: false = published on next push
- featureimage field sets the card thumbnail on list pages

## Portfolio layout
- Custom templates (not theme default): `layouts/portfolio/list.html` (root — 4 category cards) and `layouts/portfolio/category.html` (per-category — large entry cards), sharing `layouts/partials/portfolio/{featured-card,grid}.html`
- `content/portfolio/_index.md` is the root; `content/portfolio/{films,vfx,blender,gamedev}/_index.md` are category pages
- Each category `_index.md` needs `layout: category` in front matter to pick up category.html (type stays "portfolio" for all descendants, so `layout:` is what selects the template)
- Category order on the root page is controlled by `weight` on each category's `_index.md` (films=10, vfx=20, blender=30, gamedev=40)
- Case study entries (e.g. `content/portfolio/films/odraz/`) are plain page bundles with no layout override — they use the theme's default `_default/single.html`
- Entry order within a category is controlled by `weight` on each entry (lower = shown first) — use this to put strongest work up top
- `description` front matter is used for the card blurb (root cards and category entry cards); falls back to `.Summary` if omitted
- Video embeds go inline in the entry body via theme shortcodes, not front matter: `{{< youtubeLite id="VIDEO_ID" label="..." >}}` for YouTube, `{{< video src="clip.mp4" >}}` for self-hosted files. The `_Templates/portfolio_entry.md` Obsidian template already includes a placeholder `youtubeLite` line (id="VIDEO_ID") to fill in or delete per entry
- Pinning: any portfolio page (root `_index.md` or a category `_index.md`) can pin arbitrary pages to the top of its grid via a `pinned` front-matter list of page refs, e.g. `pinned: ["/journal/TheGardenBath", "/journal/AnotherFishInTheSea"]`. Pinned cards render first (in list order), then normal children by weight; a pin that is also a real child is de-duped. Resolved by `layouts/partials/portfolio/resolve-pinned.html` — unresolvable refs are skipped with a build warning, not a failure. Since edits to category `_index.md` are done in the repo (not synced from Obsidian), pins live in git. Note: page refs with spaces work (e.g. `- /portfolio/blender/The Return`).
- Card feature images are resolved by `layouts/partials/portfolio/feature-image.html`, in order: `featureimage` front matter → a bundle image named `*feature*`/`*cover*`/`*thumbnail*` → the first image in the bundle. Journal posts (no `featureimage`) therefore show their first bundle image.
- Category cards on the root have no image of their own (a category `_index.md` is a branch bundle whose folder holds no images), so they **borrow** the image of their top entry — first pinned entry if any, else top entry by weight. To give a category a dedicated cover instead, drop a `cover.jpg` into the category folder (matched by the `*cover*` rule) — do NOT set `featureimage: cover.jpg` without the file present, that was the original bug. gamedev currently has no entries, so its card stays imageless until it gets an entry or a `cover.jpg`.

## Workflow
1. Write journal entries in Obsidian on Windows (E:\Dokumenty\PersonalProjects\Obsidian\Robin\Art Journal)
2. Run ./sync-journal.sh to sync, commit, and push — GitHub Actions deploys automatically
3. Write portfolio entries in Obsidian on Windows (E:\Dokumenty\PersonalProjects\Obsidian\Robin\Portfolio), one folder per entry inside films/, vfx/, blender/, or gamedev/ — use the _Templates/portfolio_entry.md template (title, description, featureimage, weight, draft)
4. Run ./sync-portfolio.sh to sync, commit, and push
5. For config/layout changes, or editing category framing text (content/portfolio/*/_index.md): edit directly in WSL, git add/commit/push manually

## Git
- Remote: https://github.com/RobinPeutlschmid/art-site
- Default branch: master
- themes/blowfish is a git submodule — stage with care, never edit inside it
- public/ and resources/_gen/ are gitignored (build output)
- content/.obsidian/ is gitignored

## Known gotchas
- Hugo TOML is case-sensitive and fails silently on typos — always run hugo server to validate
- Images in static/ are NOT processed (no WebP, no resize) — use assets/ or page bundles
- Theme updates via: git submodule update --remote --merge
- Do not run apt install hugo — the apt version is outdated and not Extended
- The sync-journal.sh script excludes _Templates/ and .obsidian/ from rsync
- The sync-portfolio.sh script additionally excludes _index.md from rsync, so it never deletes the category index pages (content/portfolio/*/_index.md) — those are edited directly in the repo, not from Obsidian
