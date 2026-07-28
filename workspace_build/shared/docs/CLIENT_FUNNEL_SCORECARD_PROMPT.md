# Prompt: Build a Single-Page Interactive Scorecard Application

Create a standalone single-page scorecard application based on the scorecard form and interaction pattern from the existing Info Pioneer HTML funnel.

The application should turn the scorecard into a guided, interactive experience that asks one question at a time, captures the user’s answers, identifies their main pain points, and gives them a final result showing whether their business has **low, medium, or high operational pain**.

## Goal

Build a clean, modern, responsive scorecard application that helps small and mid-sized business owners understand where work is getting stuck.

The scorecard should diagnose pain related to:

* Repeated work
* Messy daily operations
* Unclear handoffs
* Scattered documentation
* Tool confusion
* Lack of ownership
* Growth creating operational strain

At the end, the app should calculate a score and present the result as:

* **Low Pain**
* **Medium Pain**
* **High Pain**

The final result should also explain what the score means and recommend the next best step.

## Design Style

Use the same visual direction as the latest Info Pioneer funnel:

* Soft blue-white background
* Deep navy text
* Clear blue accent color
* Sky-blue secondary accent
* Clean sans-serif body font
* Editorial serif-style headings
* Thin cool-blue borders
* Calm, modern, professional layout
* Smooth transitions
* Responsive mobile-first design

Use this design feel:

```text
Modern blue editorial scorecard, calm business consulting style, soft blue-white background, deep navy text, clear blue CTA buttons, thin borders, clean cards, guided question flow, smooth transitions, professional but approachable.
```

## Source Form to Leverage

Use the existing scorecard form structure from the HTML funnel. The current funnel includes a lead form that collects:

* Name
* Email
* Business name
* Business size
* Biggest issue right now
* Timeline
* Open-ended description of what feels repetitive, messy, or confusing

It also includes an interactive scorecard modal with seven scored questions and a live score meter. Use that as the foundation, but turn it into a full single-page scorecard app instead of a modal-only interaction.

## Application Structure

The app should include these screens or sections:

### 1. Welcome Screen

Show a short intro:

```text
Find out where work is slowing your business down.
Answer a few quick questions and get a simple pain score based on your current operations.
```

Primary CTA:

```text
Start the Scorecard
```

### 2. Lead Capture Step

Before the diagnostic questions, collect basic information:

* Name
* Email
* Business name
* Business size
* Biggest issue right now
* Timeline
* Short answer: “What feels most repetitive, messy, or confusing?”

Keep this step simple and not too long.

### 3. Guided Question Flow

Ask one question per screen or card.

Each question should have a 1–5 rating scale:

```text
1 = Not a problem
2 = Small problem
3 = Moderate problem
4 = Serious problem
5 = Major problem
```

Add smooth transitions between questions.

Include a progress indicator such as:

```text
Question 3 of 10
```

Also include a progress bar.

### 4. Diagnostic Questions

Use 10 questions focused on operational pain.

Questions should be written in plain language for non-technical users.

Use these questions:

1. How often does your team repeat the same manual tasks?
2. How often do people ask the same questions because answers are hard to find?
3. How clear are the steps for common work your team does?
4. How often do handoffs between people or teams create confusion?
5. How much important knowledge lives in people’s heads instead of written down somewhere?
6. How often does your team use tools inconsistently?
7. How much time is lost searching for information, files, updates, or answers?
8. How clear is ownership when something needs to get done?
9. How often does growth create more confusion instead of smoother operations?
10. How much would fixing your daily operations help your business right now?

For questions where clarity is positive, reverse the score if needed so the final score always measures pain. For example, if the user says their steps are very clear, that should lower the pain score.

### 5. Capture Pain Details

After the rating questions, ask one or two short-answer questions:

```text
What is the biggest thing slowing your team down right now?
```

```text
If this problem were fixed, what would improve first?
```

Store these answers in the app state.

### 6. Scoring Logic

Calculate the total pain score.

Use this model:

* Each question is scored from 1 to 5.
* 10 questions total.
* Maximum score: 50.
* Minimum score: 10.

Convert the score into a percentage:

```javascript
painPercent = Math.round(((totalScore - 10) / 40) * 100);
```

Then assign a pain level:

```javascript
if (painPercent < 35) {
  level = "Low Pain";
} else if (painPercent < 70) {
  level = "Medium Pain";
} else {
  level = "High Pain";
}
```

### 7. Results Screen

Show:

* The final percentage score
* The pain level
* A short explanation
* The top pain category
* Recommended next step

Example result language:

#### Low Pain

```text
Your operations appear to be working reasonably well. There may still be small improvements that could save time, but your current pain level is low.
```

Recommended CTA:

```text
Review Your Answers
```

#### Medium Pain

```text
Your business is showing signs of operational drag. You may be losing time through repeated work, unclear handoffs, scattered information, or inconsistent tool use.
```

Recommended CTA:

```text
Request a Workflow Clarity Call
```

#### High Pain

```text
Your score suggests that daily operations may be creating serious drag for your team. Fixing the right process, documentation, handoff, or ownership issue could create meaningful relief.
```

Recommended CTA:

```text
Request a Workflow Clarity Call
```

### 8. Top Pain Category

Group questions into categories:

#### Repeated Work

* Manual repeated tasks
* Time lost searching
* Growth creating confusion

#### Documentation Gaps

* Repeated questions
* Knowledge living in people’s heads
* Hard-to-find information

#### Handoff Problems

* Confusing handoffs
* Unclear ownership
* Unclear steps

#### Tool Confusion

* Inconsistent tool usage
* Tools not supporting the way work gets done

At the end, identify which category has the highest average score and show it as the user’s top pain area.

Example:

```text
Your top pain area: Documentation Gaps
```

Then explain it:

```text
Your answers suggest that important knowledge may be too scattered or too dependent on specific people. Improving documentation could reduce repeated questions and make work easier to repeat.
```

## Required Interactivity

The application must include:

* Start screen
* Lead capture form
* One-question-at-a-time flow
* Back and next buttons
* Progress bar
* Smooth question transitions
* Live answer capture
* Final score calculation
* Pain level result
* Top pain category
* Final CTA
* Option to restart the scorecard
* Responsive mobile layout

## Technical Requirements

Build the application as a single-page HTML file using:

* HTML
* CSS
* Vanilla JavaScript

Do not require a backend.

All state can be stored in JavaScript objects.

Use clean, readable code with comments.

The final app should be easy to connect later to:

* Email capture
* CRM
* Google Sheets
* Airtable
* API endpoint
* Form submission service

Add a placeholder function for future submission:

```javascript
function submitScorecard(data) {
  console.log("Scorecard submission:", data);
}
```

The data object should include:

```javascript
{
  name,
  email,
  businessName,
  businessSize,
  biggestIssue,
  timeline,
  openEndedPain,
  answers,
  painDetails,
  totalScore,
  painPercent,
  painLevel,
  topPainCategory
}
```

## Copy Style

Use plain, non-technical language.

Avoid saying “workflow” too much. Prefer phrases like:

* Daily operations
* How work gets done
* Work process
* Handoffs
* Repeated work
* The way your team handles work

Keep the tone:

* Helpful
* Calm
* Practical
* Clear
* Professional
* Not overly salesy

## Final Deliverable

Return a complete standalone `scorecard.html` file.

The file should include all HTML, CSS, and JavaScript in one file.

The app should feel polished enough to use as a live lead magnet for Info Pioneer.
