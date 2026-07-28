<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <!-- Replace with your page title and meta description -->
  <title>[Company Name] | [Primary Funnel Promise]</title>
  <meta name="description" content="[Brief description of the offer, audience, and outcome.]" />

  <style>
    :root {
      --bg: #06101f;
      --bg-soft: #0b1729;
      --card: rgba(255,255,255,.075);
      --card-strong: rgba(255,255,255,.12);
      --text: #f8fbff;
      --muted: #b8c5d8;
      --line: rgba(255,255,255,.14);
      --blue: #7dd3fc;
      --green: #a7f3d0;
      --gold: #fde68a;
      --ink: #06101f;
      --shadow: 0 24px 90px rgba(0,0,0,.38);
      --radius: 24px;
      --max: 1160px;
    }

    * { box-sizing: border-box; }

    html { scroll-behavior: smooth; }

    body {
      margin: 0;
      font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      background:
        radial-gradient(circle at 8% 0%, rgba(125,211,252,.24), transparent 34rem),
        radial-gradient(circle at 92% 4%, rgba(167,243,208,.15), transparent 32rem),
        linear-gradient(180deg, #06101f 0%, #091628 46%, #06101f 100%);
      color: var(--text);
      line-height: 1.6;
    }

    a { color: inherit; text-decoration: none; }

    .page { overflow: hidden; }

    .nav {
      position: sticky;
      top: 0;
      z-index: 50;
      border-bottom: 1px solid var(--line);
      background: rgba(6,16,31,.82);
      backdrop-filter: blur(18px);
    }

    .nav-inner {
      max-width: var(--max);
      margin: 0 auto;
      padding: 15px 22px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 18px;
    }

    .brand {
      display: flex;
      align-items: center;
      gap: 12px;
      font-weight: 900;
      letter-spacing: -.02em;
    }

    .mark {
      width: 38px;
      height: 38px;
      border-radius: 14px;
      background: linear-gradient(135deg, var(--blue), var(--green));
      color: var(--ink);
      display: grid;
      place-items: center;
      box-shadow: 0 16px 42px rgba(125,211,252,.22);
    }

    .nav-links {
      display: flex;
      align-items: center;
      gap: 22px;
      color: var(--muted);
      font-size: 14px;
    }

    .nav-links a:hover { color: var(--text); }

    .btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      border: 0;
      border-radius: 999px;
      padding: 13px 20px;
      font-weight: 900;
      cursor: pointer;
      transition: .18s ease;
      white-space: nowrap;
      font-size: 15px;
      font-family: inherit;
    }

    .btn:hover { transform: translateY(-2px); }

    .btn-primary {
      background: linear-gradient(135deg, var(--blue), var(--green));
      color: var(--ink);
      box-shadow: 0 18px 48px rgba(125,211,252,.26);
    }

    .btn-gold {
      background: linear-gradient(135deg, #fde68a, #fbbf24);
      color: #171005;
      box-shadow: 0 18px 48px rgba(251,191,36,.22);
    }

    .btn-secondary {
      background: rgba(255,255,255,.09);
      color: var(--text);
      border: 1px solid var(--line);
    }

    section {
      max-width: var(--max);
      margin: 0 auto;
      padding: 62px 22px;
    }

    .hero {
      padding-top: 74px;
      display: grid;
      grid-template-columns: 1.03fr .97fr;
      align-items: center;
      gap: 42px;
    }

    .eyebrow {
      display: inline-flex;
      align-items: center;
      gap: 9px;
      padding: 8px 12px;
      margin-bottom: 18px;
      border: 1px solid rgba(125,211,252,.34);
      background: rgba(125,211,252,.09);
      color: #d7f4ff;
      border-radius: 999px;
      font-size: 13px;
      font-weight: 800;
    }

    .pulse {
      width: 9px;
      height: 9px;
      border-radius: 999px;
      background: var(--green);
      box-shadow: 0 0 0 7px rgba(167,243,208,.14);
    }

    h1 {
      margin: 0;
      font-size: clamp(42px, 7vw, 80px);
      line-height: .94;
      letter-spacing: -.065em;
    }

    h2 {
      margin: 0;
      font-size: clamp(31px, 4.5vw, 54px);
      line-height: 1.02;
      letter-spacing: -.05em;
    }

    h3 {
      margin: 0 0 8px;
      line-height: 1.2;
      letter-spacing: -.025em;
    }

    p { margin: 0; }

    .gradient {
      background: linear-gradient(135deg, #fff 5%, #bae6fd 54%, #bbf7d0 100%);
      -webkit-background-clip: text;
      background-clip: text;
      color: transparent;
    }

    .hero-copy,
    .section-copy {
      color: var(--muted);
      font-size: 19px;
      margin-top: 18px;
    }

    .hero-actions {
      display: flex;
      flex-wrap: wrap;
      gap: 14px;
      margin-top: 28px;
    }

    .proof-row {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      margin-top: 28px;
    }

    .pill {
      padding: 8px 11px;
      border: 1px solid var(--line);
      border-radius: 999px;
      background: rgba(255,255,255,.06);
      color: var(--muted);
      font-size: 13px;
      font-weight: 700;
    }

    .lead-card {
      position: relative;
      border: 1px solid var(--line);
      background: linear-gradient(180deg, rgba(255,255,255,.13), rgba(255,255,255,.055));
      border-radius: 28px;
      padding: 24px;
      box-shadow: var(--shadow);
    }

    .lead-card:before {
      content: "";
      position: absolute;
      inset: -1px;
      z-index: -1;
      border-radius: inherit;
      background: linear-gradient(135deg, rgba(125,211,252,.34), transparent, rgba(167,243,208,.24));
    }

    .label {
      color: var(--green);
      text-transform: uppercase;
      letter-spacing: .09em;
      font-size: 13px;
      font-weight: 900;
      margin-bottom: 9px;
    }

    .card-title {
      font-size: 30px;
      letter-spacing: -.04em;
      line-height: 1.05;
    }

    .value-box {
      margin: 18px 0;
      padding: 16px;
      border-radius: 18px;
      background: rgba(253,230,138,.1);
      border: 1px solid rgba(253,230,138,.28);
      color: var(--muted);
    }

    .value-box strong { color: var(--gold); }

    .form {
      margin-top: 18px;
      padding: 18px;
      border-radius: 20px;
      background: rgba(6,16,31,.58);
      border: 1px solid var(--line);
    }

    .field-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
      margin-top: 14px;
    }

    input, select, textarea {
      width: 100%;
      border: 1px solid rgba(255,255,255,.16);
      background: rgba(255,255,255,.08);
      color: var(--text);
      border-radius: 14px;
      padding: 13px;
      font: inherit;
      outline: none;
    }

    input::placeholder,
    textarea::placeholder {
      color: rgba(255,255,255,.48);
    }

    select { color: rgba(255,255,255,.78); }

    textarea {
      min-height: 96px;
      resize: vertical;
      grid-column: 1/-1;
    }

    .form .btn {
      width: 100%;
      margin-top: 12px;
    }

    .micro {
      color: rgba(255,255,255,.56);
      font-size: 12px;
      text-align: center;
      margin-top: 10px;
    }

    .grid-3 {
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 18px;
    }

    .grid-2 {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 18px;
    }

    .card {
      border: 1px solid var(--line);
      background: var(--card);
      border-radius: 22px;
      padding: 24px;
      box-shadow: 0 12px 42px rgba(0,0,0,.12);
    }

    .card p { color: var(--muted); }

    .icon {
      width: 44px;
      height: 44px;
      display: grid;
      place-items: center;
      border-radius: 15px;
      background: rgba(125,211,252,.13);
      color: var(--blue);
      font-size: 22px;
      margin-bottom: 15px;
    }

    .problem-strip {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 22px;
      align-items: stretch;
    }

    .panel {
      border: 1px solid var(--line);
      border-radius: 28px;
      padding: 32px;
      background: linear-gradient(135deg, rgba(125,211,252,.15), rgba(167,243,208,.08));
    }

    .belief-list {
      display: grid;
      gap: 14px;
    }

    .belief {
      border: 1px solid var(--line);
      background: rgba(255,255,255,.065);
      border-radius: 18px;
      padding: 18px;
      display: grid;
      grid-template-columns: 34px 1fr;
      gap: 14px;
    }

    .belief span {
      width: 34px;
      height: 34px;
      border-radius: 12px;
      display: grid;
      place-items: center;
      background: rgba(167,243,208,.12);
      color: var(--green);
      font-weight: 900;
    }

    .process {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 14px;
      counter-reset: process;
      margin-top: 28px;
    }

    .step {
      counter-increment: process;
      padding: 20px;
      border: 1px solid var(--line);
      border-radius: 20px;
      background: rgba(255,255,255,.07);
      min-height: 190px;
    }

    .step:before {
      content: "0" counter(process);
      display: inline-grid;
      place-items: center;
      width: 42px;
      height: 42px;
      border-radius: 14px;
      background: rgba(125,211,252,.13);
      color: var(--blue);
      font-weight: 900;
      margin-bottom: 16px;
    }

    .step p {
      color: var(--muted);
      font-size: 14px;
    }

    .offer-section {
      display: grid;
      grid-template-columns: .98fr 1.02fr;
      gap: 18px;
      align-items: stretch;
    }

    .offer-box {
      border: 1px solid rgba(125,211,252,.32);
      background: linear-gradient(180deg, rgba(125,211,252,.13), rgba(255,255,255,.055));
      border-radius: 28px;
      padding: 28px;
    }

    .price {
      font-size: 43px;
      font-weight: 950;
      letter-spacing: -.05em;
      line-height: 1;
      margin: 14px 0;
    }

    .list {
      list-style: none;
      margin: 20px 0 0;
      padding: 0;
      display: grid;
      gap: 11px;
    }

    .list li {
      color: var(--muted);
      display: flex;
      align-items: flex-start;
      gap: 10px;
    }

    .list li:before {
      content: "✓";
      color: var(--green);
      font-weight: 900;
    }

    .fit-box {
      border: 1px solid var(--line);
      border-radius: 28px;
      padding: 34px;
      background:
        radial-gradient(circle at top right, rgba(253,230,138,.12), transparent 22rem),
        rgba(255,255,255,.065);
    }

    .fit-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 18px;
      margin-top: 26px;
    }

    .fit-card {
      border-radius: 20px;
      border: 1px solid var(--line);
      padding: 22px;
      background: rgba(6,16,31,.46);
    }

    .fit-card h3 { color: var(--green); }

    .fit-card.not h3 { color: #fca5a5; }

    .cta-band {
      border: 1px solid var(--line);
      border-radius: 30px;
      padding: 38px;
      background: linear-gradient(135deg, rgba(125,211,252,.16), rgba(167,243,208,.08));
      display: grid;
      grid-template-columns: 1.08fr .92fr;
      gap: 26px;
      align-items: center;
    }

    .mini-form {
      padding: 18px;
      border: 1px solid var(--line);
      background: rgba(6,16,31,.55);
      border-radius: 20px;
    }

    .mini-form .field-grid {
      grid-template-columns: 1fr;
    }

    .footer {
      padding: 26px 22px;
      text-align: center;
      border-top: 1px solid var(--line);
      color: rgba(255,255,255,.55);
      font-size: 14px;
    }

    .modal {
      position: fixed;
      inset: 0;
      display: none;
      align-items: center;
      justify-content: center;
      padding: 22px;
      background: rgba(0,0,0,.62);
      backdrop-filter: blur(12px);
      z-index: 100;
    }

    .modal.active { display: flex; }

    .modal-card {
      width: min(760px, 100%);
      max-height: 92vh;
      overflow: auto;
      background: #0b1729;
      border: 1px solid var(--line);
      border-radius: 28px;
      padding: 26px;
      box-shadow: var(--shadow);
      position: relative;
    }

    .close {
      position: absolute;
      right: 18px;
      top: 18px;
      width: 38px;
      height: 38px;
      border-radius: 999px;
      border: 1px solid var(--line);
      background: rgba(255,255,255,.08);
      color: var(--text);
      cursor: pointer;
      font-size: 20px;
    }

    .score-question {
      padding: 16px;
      border: 1px solid var(--line);
      background: rgba(255,255,255,.06);
      border-radius: 16px;
      margin: 12px 0;
    }

    .score-question label {
      display: block;
      font-weight: 800;
      margin-bottom: 8px;
    }

    .range-wrap {
      display: grid;
      grid-template-columns: 1fr 42px;
      gap: 12px;
      align-items: center;
    }

    input[type=range] {
      accent-color: #7dd3fc;
      padding: 0;
    }

    .range-value {
      color: var(--green);
      font-weight: 900;
      text-align: right;
    }

    .result {
      display: none;
      margin-top: 18px;
      padding: 18px;
      border-radius: 18px;
      background: rgba(167,243,208,.1);
      border: 1px solid rgba(167,243,208,.24);
    }

    .result strong { color: var(--green); }

    @media (max-width: 980px) {
      .hero,
      .problem-strip,
      .offer-section,
      .cta-band {
        grid-template-columns: 1fr;
      }

      .grid-3,
      .grid-2,
      .fit-grid {
        grid-template-columns: 1fr 1fr;
      }

      .process {
        grid-template-columns: 1fr 1fr;
      }

      .nav-links { display: none; }
    }

    @media (max-width: 680px) {
      section { padding: 48px 18px; }
      .hero { padding-top: 52px; }
      .grid-3,
      .grid-2,
      .fit-grid,
      .field-grid,
      .process {
        grid-template-columns: 1fr;
      }

      .btn { width: 100%; }
      .hero-actions { width: 100%; }
      .lead-card { padding: 18px; }
      .cta-band { padding: 24px; }
    }
  </style>
</head>

<body>
  <div class="page">
    <nav class="nav">
      <div class="nav-inner">
        <a class="brand" href="#top" aria-label="[Company Name] home">
          <span class="mark">[L]</span>
          <span>[Company Name]</span>
        </a>

        <div class="nav-links">
          <a href="#lead-magnet">[Lead Magnet]</a>
          <a href="#problem">Problem</a>
          <a href="#offer">Offer</a>
          <a href="#fit">Fit</a>
        </div>

        <a class="btn btn-primary" href="#lead-magnet">[Primary CTA]</a>
      </div>
    </nav>

    <main id="top">
      <!-- HERO / PRIMARY CONVERSION SECTION -->
      <section class="hero">
        <div>
          <div class="eyebrow">
            <span class="pulse"></span>
            [Audience or category label]
          </div>

          <h1>
            <span class="gradient">[Primary pain-driven headline.]</span><br />
            [Outcome-focused supporting headline.]
          </h1>

          <p class="hero-copy">
            [Briefly explain who you help, what problem you solve, and what practical outcome the visitor can expect.]
          </p>

          <div class="hero-actions">
            <a class="btn btn-gold" href="#lead-magnet">[Primary CTA]</a>
            <a class="btn btn-secondary" href="#offer">[Secondary CTA]</a>
          </div>

          <div class="proof-row">
            <span class="pill">[Trust signal 1]</span>
            <span class="pill">[Trust signal 2]</span>
            <span class="pill">[Trust signal 3]</span>
            <span class="pill">[Trust signal 4]</span>
          </div>
        </div>

        <!-- LEAD MAGNET CARD -->
        <aside class="lead-card" id="lead-magnet">
          <div class="label">[Free resource / diagnostic label]</div>

          <h2 class="card-title">[Lead Magnet Name]</h2>

          <p class="section-copy" style="font-size:16px;margin-top:10px;">
            [Short explanation of what the visitor will learn, receive, or diagnose.]
          </p>

          <div class="value-box">
            <strong>[Visitor benefit label]:</strong>
            [Describe the specific insight, result, or useful next step the lead magnet provides.]
          </div>

          <form class="form" onsubmit="event.preventDefault(); openModal();">
            <h3>[Form headline]</h3>
            <p style="color:var(--muted);font-size:14px;">
              [Short reassurance about what happens after submission.]
            </p>

            <div class="field-grid">
              <input type="text" placeholder="[Name field]" required />
              <input type="email" placeholder="[Email field]" required />
              <input type="text" placeholder="[Business / organization field]" />

              <select aria-label="[Audience segment]">
                <option value="">[Audience segment]</option>
                <option>[Option 1]</option>
                <option>[Option 2]</option>
                <option>[Option 3]</option>
                <option>[Option 4]</option>
              </select>

              <select aria-label="[Main problem]">
                <option value="">[Main problem / need]</option>
                <option>[Problem option 1]</option>
                <option>[Problem option 2]</option>
                <option>[Problem option 3]</option>
                <option>[Problem option 4]</option>
              </select>

              <select aria-label="[Timeline]">
                <option value="">[Timeline]</option>
                <option>[Immediate]</option>
                <option>[Soon]</option>
                <option>[Later]</option>
                <option>[Exploring]</option>
              </select>

              <textarea placeholder="[Open-ended context question]"></textarea>
            </div>

            <button class="btn btn-gold" type="submit">[Submit CTA]</button>
            <div class="micro">[Short privacy, no-pressure, or value-first reassurance.]</div>
          </form>
        </aside>
      </section>

      <!-- PROBLEM / BELIEF SHIFT SECTION -->
      <section id="problem">
        <div class="problem-strip">
          <div class="panel">
            <div class="label">[Problem section label]</div>

            <h2>[Explain the hidden cost or urgency of the problem.]</h2>

            <p class="section-copy">
              [Describe what the audience is experiencing, why it matters, and what happens if the problem is not addressed.]
            </p>

            <div class="hero-actions">
              <a class="btn btn-primary" href="#lead-magnet">[Problem-section CTA]</a>
            </div>
          </div>

          <div class="belief-list">
            <div class="belief">
              <span>1</span>
              <div>
                <h3>[Old belief or common mistake 1]</h3>
                <p>[New belief or reframing statement 1.]</p>
              </div>
            </div>

            <div class="belief">
              <span>2</span>
              <div>
                <h3>[Old belief or common mistake 2]</h3>
                <p>[New belief or reframing statement 2.]</p>
              </div>
            </div>

            <div class="belief">
              <span>3</span>
              <div>
                <h3>[Old belief or common mistake 3]</h3>
                <p>[New belief or reframing statement 3.]</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- WHAT GETS FIXED / BENEFITS SECTION -->
      <section>
        <div class="label">[Benefits section label]</div>

        <h2>[Describe what improves when the problem is solved.]</h2>

        <p class="section-copy">
          [Briefly connect the solution to practical outcomes the audience wants.]
        </p>

        <div class="grid-3" style="margin-top:26px;">
          <div class="card">
            <div class="icon">[1]</div>
            <h3>[Benefit / pain point 1]</h3>
            <p>[Short explanation of benefit 1.]</p>
          </div>

          <div class="card">
            <div class="icon">[2]</div>
            <h3>[Benefit / pain point 2]</h3>
            <p>[Short explanation of benefit 2.]</p>
          </div>

          <div class="card">
            <div class="icon">[3]</div>
            <h3>[Benefit / pain point 3]</h3>
            <p>[Short explanation of benefit 3.]</p>
          </div>
        </div>
      </section>

      <!-- PROCESS SECTION -->
      <section>
        <div class="label">[Process section label]</div>

        <h2>[Explain the simple path from problem to outcome.]</h2>

        <div class="process">
          <div class="step">
            <h3>[Step 1]</h3>
            <p>[Short explanation of step 1.]</p>
          </div>

          <div class="step">
            <h3>[Step 2]</h3>
            <p>[Short explanation of step 2.]</p>
          </div>

          <div class="step">
            <h3>[Step 3]</h3>
            <p>[Short explanation of step 3.]</p>
          </div>

          <div class="step">
            <h3>[Step 4]</h3>
            <p>[Short explanation of step 4.]</p>
          </div>
        </div>
      </section>

      <!-- PAID OFFER SECTION -->
      <section id="offer" class="offer-section">
        <div class="offer-box">
          <div class="label">[Main offer label]</div>

          <h2>[Paid Offer Name]</h2>

          <p class="section-copy">
            [Short description of the paid offer and the problem it solves.]
          </p>

          <div class="price">[Price / starting price / range]</div>

          <p style="color:var(--muted);">
            [Clarify what affects scope, pricing, timing, or fit.]
          </p>

          <div class="hero-actions">
            <a class="btn btn-gold" href="#lead-magnet">[Start with lead magnet CTA]</a>
          </div>
        </div>

        <div class="card">
          <div class="label">[Offer stack label]</div>

          <h2 style="font-size:40px;">[What they receive headline]</h2>

          <ul class="list">
            <li>[Deliverable or value element 1]</li>
            <li>[Deliverable or value element 2]</li>
            <li>[Deliverable or value element 3]</li>
            <li>[Deliverable or value element 4]</li>
            <li>[Deliverable or value element 5]</li>
            <li>[Deliverable or value element 6]</li>
          </ul>
        </div>
      </section>

      <!-- FIT / QUALIFICATION SECTION -->
      <section id="fit">
        <div class="fit-box">
          <div class="label">[Fit section label]</div>

          <h2>[Clarify who should take the next step.]</h2>

          <p class="section-copy">
            [Explain why qualification matters and what makes the offer a good or poor fit.]
          </p>

          <div class="fit-grid">
            <div class="fit-card">
              <h3>[Good fit heading]</h3>
              <ul class="list">
                <li>[Good fit criterion 1]</li>
                <li>[Good fit criterion 2]</li>
                <li>[Good fit criterion 3]</li>
                <li>[Good fit criterion 4]</li>
                <li>[Good fit criterion 5]</li>
              </ul>
            </div>

            <div class="fit-card not">
              <h3>[Not a fit heading]</h3>
              <ul class="list">
                <li>[Poor fit criterion 1]</li>
                <li>[Poor fit criterion 2]</li>
                <li>[Poor fit criterion 3]</li>
                <li>[Poor fit criterion 4]</li>
                <li>[Poor fit criterion 5]</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      <!-- FINAL CTA SECTION -->
      <section>
        <div class="cta-band">
          <div>
            <div class="label">[Final CTA label]</div>

            <h2>[Final conversion headline.]</h2>

            <p class="section-copy">
              [Restate the value of taking the next step and reinforce that it is low-risk or useful.]
            </p>
          </div>

          <form class="mini-form" onsubmit="event.preventDefault(); openModal();">
            <h3>[Short final form headline]</h3>

            <div class="field-grid">
              <input type="text" placeholder="[Name field]" required />
              <input type="email" placeholder="[Email field]" required />

              <select aria-label="[Main need]">
                <option value="">[Main need]</option>
                <option>[Need option 1]</option>
                <option>[Need option 2]</option>
                <option>[Need option 3]</option>
                <option>[Need option 4]</option>
              </select>
            </div>

            <button class="btn btn-gold" type="submit">[Final CTA button]</button>
            <div class="micro">[Final reassurance statement.]</div>
          </form>
        </div>
      </section>
    </main>

    <footer class="footer">
      [Company Name] · [Short positioning statement] · [Location / service area]
    </footer>
  </div>

  <!-- OPTIONAL INTERACTIVE DIAGNOSTIC MODAL -->
  <div class="modal" id="scoreModal" aria-hidden="true">
    <div class="modal-card">
      <button class="close" onclick="closeModal()" aria-label="Close diagnostic">×</button>

      <div class="label">[Diagnostic / scorecard label]</div>

      <h2 style="font-size:38px;">[Diagnostic headline]</h2>

      <p class="section-copy">
        [Explain how to answer and what the result means.]
      </p>

      <div id="questions"></div>

      <button class="btn btn-gold" style="width:100%;margin-top:14px;" onclick="calculateScore()">[Calculate result CTA]</button>

      <div class="result" id="result">
        <h3 id="resultTitle" style="margin:0 0 8px;"></h3>
        <p id="resultText" style="margin:0;color:var(--muted);"></p>

        <div class="hero-actions">
          <a class="btn btn-primary" href="mailto:[email@example.com]?subject=[Next%20Step%20Request]">[Request next step CTA]</a>
          <button class="btn btn-secondary" onclick="closeModal()">[Secondary modal CTA]</button>
        </div>
      </div>
    </div>
  </div>

  <script>
    /*
      Replace these questions with diagnostic prompts specific to your funnel.
      The current scoring logic assumes:
      - 1 = low friction / low urgency
      - 5 = high friction / high urgency
    */
    const modal = document.getElementById("scoreModal");
    const questionsEl = document.getElementById("questions");

    const questions = [
      "[Diagnostic question 1]",
      "[Diagnostic question 2]",
      "[Diagnostic question 3]",
      "[Diagnostic question 4]",
      "[Diagnostic question 5]",
      "[Diagnostic question 6]",
      "[Diagnostic question 7]"
    ];

    questionsEl.innerHTML = questions.map((question, index) => `
      <div class="score-question">
        <label for="q${index}">${question}</label>
        <div class="range-wrap">
          <input type="range" id="q${index}" min="1" max="5" value="3" oninput="document.getElementById('v${index}').textContent=this.value" />
          <div class="range-value" id="v${index}">3</div>
        </div>
      </div>
    `).join("");

    function openModal() {
      modal.classList.add("active");
      modal.setAttribute("aria-hidden", "false");
    }

    function closeModal() {
      modal.classList.remove("active");
      modal.setAttribute("aria-hidden", "true");
    }

    function calculateScore() {
      const values = questions.map((_, index) => Number(document.getElementById(`q${index}`).value));
      const total = values.reduce((sum, value) => sum + value, 0);
      const max = questions.length * 5;
      const percent = Math.round((total / max) * 100);

      const title = document.getElementById("resultTitle");
      const text = document.getElementById("resultText");
      const result = document.getElementById("result");

      if (percent < 45) {
        title.innerHTML = `[Low result label]: <strong>${percent}%</strong>`;
        text.textContent = "[Low score result explanation and recommended next step.]";
      } else if (percent < 70) {
        title.innerHTML = `[Moderate result label]: <strong>${percent}%</strong>`;
        text.textContent = "[Moderate score result explanation and recommended next step.]";
      } else {
        title.innerHTML = `[High result label]: <strong>${percent}%</strong>`;
        text.textContent = "[High score result explanation and recommended next step.]";
      }

      result.style.display = "block";
      result.scrollIntoView({ behavior: "smooth", block: "nearest" });
    }

    modal.addEventListener("click", (event) => {
      if (event.target === modal) closeModal();
    });
  </script>
</body>
</html>
