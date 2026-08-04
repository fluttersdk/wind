#!/usr/bin/env python3
"""Offline consistency gate for wind's markdown reference.

fluttersdk.com ingests `doc/` verbatim and validates nothing: `DocLinkExtension`
strips the `.md` suffix off internal links without checking the target exists,
`DocsScaffolder` upserts every page it finds, and the `<x-preview>` component
builds its iframe and GitHub URLs from raw attribute values. A typo therefore
survives the sync and ships as a dead link on the docs site.

This script closes that gap from the repo side. It needs no network and no
Flutter toolchain, so it runs identically in CI and on a developer machine:

    python3 tool/check-docs.py

Surfaces checked:

1. Page structure: exactly one H1, and it is the page's opening line, which is
   the file shape `.claude/rules/docs.md` documents.
2. Relative `.md` links resolve to a file that exists.
3. Fragments (`#section`, both same-file and cross-file) resolve to an explicit
   `<a name>` anchor or a heading slug in the target page.
4. Explicit anchors are reachable from the page's own Table of Contents.
5. `<x-preview source="...">` points at a real repository file.
6. `<x-preview path="...">` matches a route registered in the demo gallery,
   because the iframe URL is the preview base plus that path.
7. Absolute `https://fluttersdk.com/wind/....md` URLs (the raw-markdown route)
   map to a doc page that exists.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path
from typing import Iterator, NamedTuple
from urllib.parse import unquote, urlsplit

# The docs site serves this repository under /wind, the demo gallery routes live
# in the example app, and every preview source sits under one directory. All of
# it is wind-specific by design; a sibling package copying this script changes
# these constants and nothing else.
PACKAGE_SLUG = 'wind'
SITE_ORIGIN = 'https://fluttersdk.com'
DOC_URL_PREFIX = f'/{PACKAGE_SLUG}/'
ROUTES_FILE = Path('example/lib/routes.dart')
PREVIEW_SOURCE_ROOT = Path('example/lib/pages')

DOC_ROOT = Path('doc')

# Extra files that carry links into the docs without following the doc/ page
# shape, so they join the link checks but not the structure checks.
EXTRA_LINK_FILES = (
    Path('README.md'),
    Path('ARCHITECTURE.md'),
    Path('CONTRIBUTING.md'),
    Path('llms.txt'),
)

# Mirrors VersionedDocRoutes::VERSION_PATTERN on the site, so /wind/1.3.0/<page>
# resolves against the same doc tree as /wind/<page>.
VERSION_SEGMENT = re.compile(r'^v?\d+(?:\.\d+)*(?:-[A-Za-z0-9.]+)?$')

FENCE = re.compile(r'^\s*(```|~~~)')
HEADING = re.compile(r'^(#{1,6})\s+(.+?)\s*$', re.MULTILINE)
ANCHOR = re.compile(r'<a\s+name="([^"]+)"')
INLINE_LINK = re.compile(r'\]\(\s*([^)\s]+)')
REFERENCE_LINK = re.compile(r'^\[[^\]]+\]:\s*(\S+)')
PREVIEW_TAG = re.compile(r'<x-preview\b[^>]*>')
ATTRIBUTE = re.compile(r'(\w+)="([^"]*)"')
SITE_URL = re.compile(re.escape(SITE_ORIGIN) + r'/[^\s)>"\']+')


class Issue(NamedTuple):
    """A single failed expectation, addressed to one line of one file."""

    file: Path
    line: int
    message: str

    def as_annotation(self) -> str:
        """Render the issue as a GitHub Actions error annotation."""
        return f'::error file={self.file},line={self.line}::{self.message}'


def blank_code(text: str) -> str:
    """Blank out fenced and inline code, preserving line and column offsets.

    Doc pages illustrate anchors, links and preview tags inside code samples.
    Those are documentation about the syntax, not uses of it, so they must not
    be validated. Blanking instead of deleting keeps reported line numbers
    pointing at the real source line.
    """
    lines: list[str] = []
    in_fence = False

    for line in text.splitlines():
        fence = FENCE.match(line)
        if fence:
            in_fence = not in_fence
            lines.append('')
            continue
        if in_fence:
            lines.append('')
            continue
        lines.append(re.sub(r'`[^`\n]*`', lambda match: ' ' * len(match.group(0)), line))

    return '\n'.join(lines)


def slugify(heading: str) -> str:
    """Slugify heading text the way GitHub and the docs site both do.

    Verified against the rendered page: `## Date + Time Selection` yields
    `date--time-selection` on fluttersdk.com, so punctuation is dropped and each
    surviving space becomes one hyphen. Whitespace is never collapsed.
    """
    text = re.sub(r'`([^`]*)`', r'\1', heading)
    text = re.sub(r'\[([^\]]*)\]\([^)]*\)', r'\1', text)
    text = re.sub(r'<[^>]+>', '', text)
    text = re.sub(r'[^\w\s-]', '', text.strip().lower(), flags=re.UNICODE)

    return text.replace(' ', '-')


def collect_fragments(path: Path) -> set[str]:
    """Collect every fragment a link can target on the given page.

    The union of explicit `<a name>` anchors and heading slugs. Repeated heading
    text gets the `-1`, `-2` suffixes both renderers append.
    """
    body = blank_code(path.read_text(encoding='utf-8'))
    fragments = set(ANCHOR.findall(body))
    seen: dict[str, int] = {}

    for _, heading in HEADING.findall(body):
        slug = slugify(heading)
        count = seen.get(slug, 0)
        seen[slug] = count + 1
        fragments.add(slug if count == 0 else f'{slug}-{count}')

    return fragments


def load_demo_routes() -> set[str]:
    """Read the demo gallery's registered route keys from the example app."""
    if not ROUTES_FILE.is_file():
        raise SystemExit(f'{ROUTES_FILE} is missing; cannot validate x-preview paths.')

    return set(re.findall(r"^\s*'(/[^']*)':", ROUTES_FILE.read_text(encoding='utf-8'), re.MULTILINE))


def iter_links(body: str) -> Iterator[tuple[int, str]]:
    """Yield every link target in the body as a (line number, target) pair."""
    for number, line in enumerate(body.splitlines(), 1):
        for target in INLINE_LINK.findall(line):
            yield number, target.strip('<>')
        for target in REFERENCE_LINK.findall(line):
            yield number, target.strip('<>')


def site_url_to_doc(url: str) -> Path | None:
    """Map a raw-markdown docs URL to its source file, or None when not one.

    Only `.md` URLs are mapped. An extensionless URL such as `/wind/layout` may
    be a section landing page the site generates without a backing file, so it
    is out of scope here.

    The `.md` test runs against the parsed path rather than the whole URL, so a
    link carrying a fragment or a query (`page.md#section`, `page.md?x=1`) is
    still validated instead of slipping through.
    """
    parts = urlsplit(url)
    if f'{parts.scheme}://{parts.netloc}' != SITE_ORIGIN:
        return None

    path = unquote(parts.path)
    if not path.startswith(DOC_URL_PREFIX) or not path.endswith('.md'):
        return None

    segments = path[len(DOC_URL_PREFIX):].split('/')
    if segments and VERSION_SEGMENT.match(segments[0]):
        segments = segments[1:]

    return DOC_ROOT.joinpath(*segments) if segments else None


def check_structure(path: Path, raw: str, body: str) -> list[Issue]:
    """Require the page to open with its H1, and to carry exactly one.

    The opening line is measured against the raw text, so anything ahead of the
    title counts as a violation, a lead paragraph and a code fence alike. The H1
    count runs over the code-blanked body instead, so an illustrative `# Title`
    inside a fenced sample is not mistaken for a second title.

    `DocsScaffolder` reads the page title from the first H1 wherever it sits, so
    this is the file shape in `.claude/rules/docs.md` talking, not a site
    requirement: the title is the first line, and the lead paragraph follows it.
    """
    titles = [
        number
        for number, line in enumerate(body.splitlines(), 1)
        if (match := HEADING.match(line)) and len(match.group(1)) == 1
    ]

    if not titles:
        return [Issue(path, 1, 'no H1 title; the docs site derives the page title from the first H1')]

    issues = [Issue(path, number, 'second H1 on the page; doc pages carry exactly one') for number in titles[1:]]

    opening = next((number for number, line in enumerate(raw.splitlines(), 1) if line.strip()), 1)
    if titles[0] != opening:
        issues.append(Issue(path, opening, 'page does not open with its H1 title'))

    return issues


def check_links(path: Path, body: str, fragments: dict[Path, set[str]]) -> list[Issue]:
    """Resolve relative `.md` targets and every fragment they carry."""
    issues: list[Issue] = []

    for number, target in iter_links(body):
        if target.startswith('#'):
            fragment = target[1:]
            if fragment and fragment not in fragments[path]:
                issues.append(Issue(path, number, f'fragment #{fragment} has no anchor or heading on this page'))
            continue

        if '://' in target or target.startswith(('mailto:', '//')):
            continue

        route, _, fragment = target.partition('#')
        if not route.endswith('.md'):
            continue

        resolved = (path.parent / route).resolve()
        if not resolved.is_file():
            issues.append(Issue(path, number, f'link target {route} does not exist'))
            continue

        # Only doc/ is synced, so the boundary depends on where the link starts.
        # A doc page linking out of doc/ resolves for a GitHub reader and 404s on
        # the site, where that target was never published. README and llms.txt
        # are read on GitHub, so for them the repository is the boundary.
        if path.is_relative_to(DOC_ROOT):
            boundary, label = DOC_ROOT.resolve(), f'{DOC_ROOT}/, which is the only directory the site publishes'
        else:
            boundary, label = Path.cwd(), 'the repository'

        if not resolved.is_relative_to(boundary):
            issues.append(Issue(path, number, f'link target {route} escapes {label}'))
            continue

        relative = resolved.relative_to(Path.cwd())
        if relative not in fragments:
            fragments[relative] = collect_fragments(relative)
        if fragment and fragment not in fragments[relative]:
            issues.append(Issue(path, number, f'fragment #{fragment} does not exist in {route}'))

    return issues


def check_anchor_reachability(path: Path, body: str) -> list[Issue]:
    """Require every explicit anchor to be reachable from the page's own ToC."""
    linked = {target[1:] for _, target in iter_links(body) if target.startswith('#')}

    return [
        Issue(path, number, f'anchor #{name} is not linked from the Table of Contents')
        for number, line in enumerate(body.splitlines(), 1)
        for name in ANCHOR.findall(line)
        if name not in linked
    ]


def check_previews(path: Path, body: str, routes: set[str]) -> list[Issue]:
    """Validate both halves of every `<x-preview>` tag, and that they agree.

    `source` becomes a GitHub blob link, `path` becomes the demo iframe URL.
    The site renders a broken link and an empty iframe respectively, without
    logging anything, so both are checked here. They also have to describe the
    same example: a tag whose halves drift shows one file's code next to another
    file's demo, and every check passes while the page misleads the reader.
    """
    issues: list[Issue] = []

    for number, line in enumerate(body.splitlines(), 1):
        for tag in PREVIEW_TAG.findall(line):
            attributes = dict(ATTRIBUTE.findall(tag))
            source = attributes.get('source')

            if source is None:
                issues.append(Issue(path, number, 'x-preview has no source attribute'))
            else:
                issues += check_preview_source(path, number, source)

            if 'src' in attributes:
                continue

            preview_path = attributes.get('path')
            if preview_path is None:
                issues.append(Issue(path, number, 'x-preview has neither a path nor a src attribute'))
                continue

            normalized = preview_path.strip('/')
            if f'/{normalized}' not in routes:
                issues.append(
                    Issue(path, number, f'x-preview path {preview_path} is not a route in {ROUTES_FILE}'),
                )

            # An empty path is the demo's `/` route, which serves the installation
            # example, so it is the one pair that cannot line up by name.
            expected = PREVIEW_SOURCE_ROOT / f'{normalized}.dart'
            if normalized and source is not None and Path(source) != expected:
                issues.append(
                    Issue(path, number, f'x-preview path {preview_path} does not match its source; expected {expected}'),
                )

    return issues


def check_preview_source(path: Path, number: int, source: str) -> list[Issue]:
    """Require a preview source to be an existing file under the pages directory.

    Containment is checked before existence: an absolute path or one climbing out
    with `..` can name a real file and still be wrong, because the site turns the
    value into a GitHub blob URL inside this repository.
    """
    candidate = Path(source)
    if candidate.is_absolute() or not (Path.cwd() / candidate).resolve().is_relative_to(PREVIEW_SOURCE_ROOT.resolve()):
        return [Issue(path, number, f'x-preview source {source} is outside {PREVIEW_SOURCE_ROOT}/')]

    if not candidate.is_file():
        return [Issue(path, number, f'x-preview source {source} does not exist')]

    return []


def check_site_urls(path: Path, body: str) -> list[Issue]:
    """Resolve absolute raw-markdown docs URLs against the doc tree."""
    issues: list[Issue] = []

    for number, line in enumerate(body.splitlines(), 1):
        for url in SITE_URL.findall(line):
            target = site_url_to_doc(url.rstrip('.,);'))
            if target is not None and not target.is_file():
                issues.append(Issue(path, number, f'{url} has no source page ({target} is missing)'))

    return issues


def main() -> int:
    """Run every surface over the doc tree and report the combined result."""
    # 1. Page structure and anchor conventions apply to doc/ only; README and
    #    llms.txt legitimately use a different shape.
    doc_pages = sorted(DOC_ROOT.rglob('*.md'))
    if not doc_pages:
        raise SystemExit(f'no markdown found under {DOC_ROOT}/; run this from the repository root.')

    link_files = doc_pages + [path for path in EXTRA_LINK_FILES if path.is_file()]
    routes = load_demo_routes()
    fragments: dict[Path, set[str]] = {path: collect_fragments(path) for path in doc_pages}
    issues: list[Issue] = []

    # 2. Link and fragment resolution spans every file that links into the docs.
    for path in link_files:
        body = blank_code(path.read_text(encoding='utf-8'))
        if path not in fragments:
            fragments[path] = collect_fragments(path)
        issues += check_links(path, body, fragments)
        issues += check_site_urls(path, body)

    # 3. The doc-only surfaces: title shape, anchor reachability, previews.
    for path in doc_pages:
        raw = path.read_text(encoding='utf-8')
        body = blank_code(raw)
        issues += check_structure(path, raw, body)
        issues += check_anchor_reachability(path, body)
        issues += check_previews(path, body, routes)

    for issue in sorted(issues):
        print(issue.as_annotation())

    print(
        f'checked {len(doc_pages)} doc pages + {len(link_files) - len(doc_pages)} linking files '
        f'against {len(routes)} demo routes: {len(issues)} issue(s)',
    )

    return 1 if issues else 0


if __name__ == '__main__':
    sys.exit(main())
