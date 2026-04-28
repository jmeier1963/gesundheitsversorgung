# Gesundes Vertrauen

Research repository and public website for **Gesundes Vertrauen - Wie gute gesundheitliche Versorgung vor Ort die Demokratie stärken kann**.

The project documents research, synthesis, practice examples, and publication outputs. Public, non-personal catalogue data is published via GitHub Pages; internal interview, focus group, and working material stays out of the public site.

## Structure

- `_quarto.yml` configures the Quarto website.
- `*.qmd` pages contain the public research narrative and synthesis.
- `data/public/approaches.csv` contains the publishable catalogue of practice examples.
- `data/public/codebook.md` documents the public data fields.
- `data/internal/` is reserved for non-public working data and is ignored by git except for its README.
- `research/rechercheprotokoll.md` defines the research and screening workflow.
- `scripts/validate-public-data.ps1` validates the public catalogue.
- `.github/workflows/pages.yml` builds and publishes the Quarto site to GitHub Pages.

## Local checks

```powershell
pwsh scripts/validate-public-data.ps1
```

If Quarto is installed locally:

```powershell
quarto render
```

## Publishing

After the repository is pushed to GitHub, enable GitHub Pages with **GitHub Actions** as the source. The workflow validates the public data, renders the Quarto website, and publishes the static site.



