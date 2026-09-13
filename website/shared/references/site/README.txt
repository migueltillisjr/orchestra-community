P.R.A.Y. MODERN WEBSITE REDESIGN
================================

Files
-----
index.html      Built single-page website (deployed artifact, do not hand-edit)
template.html   Page shell with @include markers, assembled into index.html
partials/       Individual page sections (header, hero, programs, team, etc.)
build_site.py   Assembles template.html + partials/*.html into index.html
images/         Locally hosted image assets
style.css       Responsive styling
script.js       Mobile navigation, reveal effects, demo contact form

How to edit
-----------
Edit the relevant file in partials/ (or template.html for the page shell), then run:
  python3 build_site.py
from inside the site/ directory to regenerate index.html. Do not edit index.html
directly — those changes will be overwritten on the next build.

How to preview
--------------
Open index.html in any modern browser.

How to deploy
-------------
This is a static site and can be deployed to Cloudflare Pages, Netlify, Vercel,
GitHub Pages, or any standard web host.

Images
------
All images are hosted locally in images/ (downloaded from the organization's original
site assets) so the site has no runtime dependency on external image hosts.

Contact form
------------
The form is visual only in this prototype. Connect it to your preferred backend or
form service (for example Formspree, Basin, Netlify Forms, or your own API endpoint)
before publishing.

Design decisions
----------------
- Consolidated the existing site into a clearer, modern one-page nonprofit experience.
- Preserved the P.R.A.Y. red / blue visual identity while making it more polished.
- Elevated Programs, Get Involved, Team, Mission, Values, and Contact.
- Rewrote portions of the copy for clarity while preserving the original meaning.
- Added responsive mobile navigation and accessible form labels.
- Added lightweight entrance animations with reduced-motion support.

Important
---------
Review all copy, participant/sponsor policies, safeguarding language, and contact details
before production launch. The Sponsor Youth Program in particular should have complete,
organization-approved child-safety and screening policies linked from the live site.
