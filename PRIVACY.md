# DevDeck privacy policy

*Last updated: October 23, 2026 · DevDeck by VR Dev Tools*

DevDeck is a desktop app that helps developers manage their own computer: running servers, services, tools, projects and local test deployments. It runs on your computer and **doesn't collect, send or sell information about you**.

## The short version

- No account and no sign-up.
- No analytics, tracking, ads or crash reports.
- What DevDeck finds on your computer, and what you type into it, stays on your computer.
- DevDeck only contacts the internet to check for updates, or when you start a feature that needs it.

## What stays on your computer

DevDeck reads information on your computer to show it to you: running programs and ports, installed tools, project folders, Git repositories, Docker containers, disk usage and similar details. It keeps its settings and history in its own folder on your computer (`%APPDATA%\DevDeck` on Windows, `~/Library/Application Support/DevDeck` on macOS).

Passwords and tokens you save in DevDeck, such as database connections or API keys, are encrypted with your operating system's protection (Windows Data Protection or the macOS Keychain). They are never shown without your action and never sent anywhere by DevDeck.

## When DevDeck connects to the internet

| When | Where | What is sent |
|---|---|---|
| Checking for DevDeck updates (automatic, every few hours; Microsoft Store copies are updated by the Store instead) | GitHub (`github.com`) | Your current version, as part of a normal download request |
| You use Git, pull request or GitHub features | GitHub, through your own GitHub sign-in | What the feature asks for, for example listing your pull requests |
| You run a project security check | OSV (`api.osv.dev`), npm, PyPI | Names and versions of your project's packages, to look up known problems |
| You run a network test | `ipinfo.io`, Cloudflare (`1.1.1.1`) | A request to learn your public IP address and test speed and DNS |
| You check a website | That website, and public domain records (`rdap.org`, Cloudflare DNS) | Normal requests a browser would make to that site |
| You view AI tool costs in a currency other than US dollars | `open.er-api.com` | A request for today's exchange rates |
| You install a tool, or browse skills and add-ons | The tool's official site, GitHub, npm or the package manager you choose | Normal download requests |
| You create a public share link for a local project | Cloudflare (quick tunnel) | Your local app is reachable at the link until you stop it (it always stops when DevDeck quits) |
| You download Docker images (Local lab and Local Cloud) | Docker Hub and the image's registry | Normal download requests |

These services have their own privacy policies. DevDeck sends them only what's described above, never your files or saved secrets.

## Things you control

- Apart from the update check, every feature that sends something starts only when you press its button. *Settings → DevDeck updates* lets you choose whether updates download and install by themselves.
- Removing DevDeck: the Windows uninstaller asks whether to delete DevDeck's settings and data as well. On macOS, delete the folder above.

## Children

DevDeck is a tool for software developers and is not directed at children.

## Changes

If this policy changes, the new version is published here with a new date.

## Contact

Questions or concerns: open an issue at [github.com/vikram-capsitech/devdeck-releases/issues](https://github.com/vikram-capsitech/devdeck-releases/issues).
