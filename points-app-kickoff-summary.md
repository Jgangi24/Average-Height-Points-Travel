# Points & Travel App: Project Reference Summary

*Created September 10, 2026. Updated September 16, 2026 after the v7 mockup (final splash animation, banner logo, working scroll behavior, bill-due-date field) and the move from design into the build phase. Keep this in Project Files as the starting reference for every chat.*

## What we're building

A private app for Jess and his wife Abby to track their credit card points, decide how to use them, and plan vacations with them. Working title: **Average Height Points & Travel** — the name comes from Jess being tall and Abby being short, so together they're "average height."

Division of labor is the same as on the Fieldston league site. Jess handles design, decisions, and publishing. Claude handles the code and walks Jess through any setup.

**Design phase is complete.** v7 is the final, approved mockup. We're now moving into the build phase (see "How we'll work" below).

## Decisions so far

**Platform**
- **A web app, not a native iPhone app.** This is a website designed to look and feel like an app. It gets installed on each iPhone through Safari (Share button → Add to Home Screen), where it gets its own icon and opens full screen.
- **It works on computers too.** It runs in any web browser. The design is phone-first, with layouts that adjust to bigger screens, which gives a roomier view for things like trip planning.
- **A private login plus a small online database: Supabase, confirmed.** Both phones see the same data, so a balance updated on one phone shows up on the other. Nothing is public.
- **Balances are updated by hand.** Banks and airlines don't let personal apps pull points balances automatically. Updating them should take a few minutes a month.
- **Award flight searches stay in existing tools** such as point.me and seats.aero. The app plans around them and links out to them. A later version could pull automatic prices from the seats.aero API (a paid Pro feature, and not guaranteed to include API access), but that's a "maybe later," not a plan.
- **Refresh approach, confirmed manual for both:**
  - **Trip prices:** Jess checks point.me/seats.aero herself and enters the real price into the app when she finds one. No automation planned for v1.
  - **Program alerts** (transfer ratio changes, limited-time bonuses): once a month, during her balance update, Jess asks Claude to check for anything new, and Claude searches and reports back. No single reliable feed exists for this across Chase/Amex/Capital One, so full automation isn't a near-term option.
- **Never stored in the app:** card numbers, bank logins, or loyalty program logins. The app only holds card nicknames, points programs, and balances.

A native iPhone app was considered and set aside for now. It would need a Mac with Apple's Xcode software, a new programming language (Swift), and a paid Apple developer account (about $99/year) to keep it on both phones long-term. We could revisit this later.

**Cards on file**
- Abby: AMEX Hilton Honors, AMEX Marriott Bonvoy, AMEX Platinum, Chase Ink Business Preferred, Chase Ink Business Unlimited, Chase Sapphire Preferred
- Jess: Capital One Venture X, Chase Ink Business Preferred, Chase Ink Business Unlimited, Chase Sapphire Preferred
- Shared: Amex Gold (pools into the same points pot as Abby's Platinum)
- **Bill due date (new, added in v7):** each card can also track the day of the month its statement bill is due (separate from the once-a-year annual fee). Shown on the Cards tab on the same line as the annual fee, separated by "||", with the due date in bold so it stands out without adding row height.

**Trips being planned around**
- Disney World, Japan, and London
- Family of 4 flying from Boston: Jess, Abby, and two kids (ages 10 and 14). Trip plans should account for all 4 travelers.
- **Trip editing (agreed):** there are always exactly 3 trip slots (no add/remove yet), but each slot becomes fully editable — destination, nights, traveler notes, flight/hotel needs — so a trip can be swapped out entirely (e.g., London to Italy) without needing a code change.

## The plan and feature list

1. **Design first.** Done — see "Mockups built" below.
2. **Version 1: balances and cards.**
   - Household points dashboard, one total per program, with each person's share shown underneath. Balances are tracked as shared "points pots" so a program that pools across multiple cards (like Amex) does the math correctly.
   - Card list showing each card's owner (Jess, Abby, or shared) and which pot it feeds. Nicknames only, never card numbers.
   - Adding, editing, closing, and deleting cards. Closing a card checks whether points on it still need to be moved first. Closed cards move to a "closed cards" record rather than disappearing, since past cards can affect future sign-up bonus eligibility. Downgrades are edits to the same card, not a delete-and-add.
   - Adding standalone airline or hotel accounts that don't have a card attached (e.g., points already transferred to British Airways).
   - Monthly balance update screen, with a nudge when it's been over a month.
   - Annual fee tracking per card: fee amount, the month it posts, a "coming up" list, the household's total yearly fees, and a keep/downgrade/cancel note per card. Bill due date (day of month) tracked alongside it. An "add to calendar" action for fee due dates is planned; phone notifications are possible later but need more setup.
   - **Alerts: notification bell**, visible on all 4 tabs, with a badge when there's something unread. Tapping it opens an alert detail view (what changed, which cards it affects, when it disappears). Refreshed manually — see refresh approach above.
   - **Perks tracker — redesigned around usage tracking.** Perks are grouped by **status**, not cadence: **Redeem soon** (open and unused), **Redeemed** (open and already used), **Upcoming redeemables** (window hasn't opened yet, dimmed/reference-only). Each perk row shows its cadence (Monthly/Quarterly/etc.) as a small tag. All three sections are collapsible and collapsed by default, with a count in each header. Perks with a longer window get a "closes in X days" note near the end of their period. Checking off a perk stamps it with an exact date (defaults to today, editable for backdating), feeding two running totals: "Redeemed this month" and "Redeemed [year]." Each card's own Perks section keeps the "captured toward the annual fee" comparison (e.g. "$650 of $895 captured this year"). Adding a *new* perk is still a placeholder (shows a message rather than a real form).
   - Adding and editing a perk needs a real form, not just a placeholder message — both the perk name and its dollar value must be editable fields, for both new perks and existing ones.
3. **Version 2: trip planner.**
   - A trip card for each dream trip, points needed vs. points on hand, split into flights and hotel.
   - "Ways to pay" — for each trip, which of your points can reach which airlines and hotels, filtered to your actual cards.
   - Family notes relevant to a 10- and 14-year-old (room sizing, ages where pricing changes, etc.).
   - Entering a real, dated point price (from seats.aero, point.me, or an airline/hotel site) to replace the placeholder estimate for a given flight or hotel.
   - Editing a trip's destination and details in place (see "Trip editing" above).
   - Setting points aside for one trip, so two trips don't count the same points (not yet built).
   - Link-outs to point.me and seats.aero for real seat searches.
4. **Extras later:** free night certificate tracker, sign-up bonus deadlines, passport expiration dates for all four travelers (dates only, never passport numbers). Rough dollar values for points is built (see below). Transfer bonus alerts was discussed and clarified — it's effectively already covered by the existing alerts/notification bell (Jess asks, Claude searches, adds via SQL); Jess is fine keeping that manual, so no separate feature was built.

## Mockups built

- **v1–v3:** early structure, alerts, annual fee tracking, card CRUD, and the original cadence-based Perks tab. Superseded.
- **v4:** self-contained rebuild (own fonts, colors, icons) with the redesigned status-based Perks tab, notification bell, editable trip slots, and a placeholder splash animation (code-drawn silhouettes, structure/timing approved).
- **v5:** bug fixes plus a first contrast pass (white panels on a sand background).
- **v6:** full visual pass — cream + terracotta palette, serif headlines, selected pills that don't blend into the background, merged fee/yearly-total panel on Cards, plain color dots (Capital One recolored to gold), fixed die-cut notch on trip cards. Approved.
- **v7 (current, final):** replaced the placeholder splash animation with Jess's real reference art — 4 vector silhouette poses (hug → turning → apart, side view → back to back) with the "Average Height" wordmark baked directly into the artwork, fading in at 25% → 50% → 75% → 100% opacity across the 4 frames, and precisely positioned so the wordmark holds still even though the source files' canvas sizes differ. Also added: a banner logo (icon + "Average Height" wordmark + "Points & Travel") in the header replacing the earlier placeholder mark; real scrolling behavior (the phone frame is now a fixed height, ~844px, with the header and bottom tab bar staying fixed while the middle content scrolls — previously the mockup just grew taller to fit content, with no scrolling at all); and the new bill-due-date field on the Cards tab. **v7 is the file to keep in Project Files, replacing v6.**

**Now that we're in Claude Code, there's no separate reference copy to maintain** — Claude reads the mockup directly from the `Prototypes` folder on Jess's computer, live. This doc just needs to say which version is current (see above).

**Workflow note:** starting with v4, mockups are fully self-contained (own fonts/colors/icons baked in), so Jess can open the HTML file directly in any browser with no ongoing cost or need for Claude to re-render it in chat.

## How we'll work

- **Design phase: complete**, as of v7.
- **Build phase: starting now, in a fresh chat.** Claude Code in the Claude desktop app — Claude works directly inside the project folder on Jess's computer, no downloading/copying files between folders. Claude will walk Jess through setup step by step.
  - Order of operations: (1) set up Claude Code, (2) stand up the Supabase database, (3) build the real app screen by screen using v7 as the spec, starting with Version 1 scope (balances and cards).
- **Publishing:** Jess keeps using GitHub Desktop.
- **Usage-conscious mockup habit (design-phase habit, carries forward for any future mockup work):** gather all edits in plain-text discussion first, agree on the full list, and have Claude build/render the updated mockup once at the end. Quick concept sketches/demos are a cheaper way to align on a direction before a full mockup rebuild. Small, targeted edits to an already-built file (like the v7 tweaks this session — banner swap, scroll fix, bill-due field) are cheap and don't need this batching treatment; it's specifically full mockup *rebuilds* that are expensive.
- **Start a new chat when a chat gets long**, rather than continuing indefinitely. This summary doc and the app files in the project folder (which Claude Code reads directly, live — no upload step) are what carry context forward between chats.

Habits carried over from the league site:
- Use plain-language, step-by-step explanations, and explain any jargon.
- Show a mockup before building anything that involves a design decision, and ask before making design decisions.
- Prefer simpler designs over complex ones when both achieve the same goal.
- Flag anything unverified or possibly out of date. Card programs and transfer partners change often, so double-check those.
- Keep project folders out of iCloud Drive. When copying files, always choose Replace, not Keep Both.
- End each major session with a handoff summary and a ready-to-paste prompt for the next session.
- Keep this summary doc updated after each session, rather than creating new dated files, so there's one current reference.
- **No longer applies now that we're in Claude Code:** there's no "Project Files" upload area to manage — Claude reads files directly from the project folder on Jess's computer, always live, with no copy/replace step. Old mockup versions can just stay in `Prototypes/` for history; this doc simply names which one is current.

## Open items heading into the build phase

- **App icon:** done — Jess has the icon ready. Hand it to Claude during the build so it can generate the iOS-required sizes.
- **Claude Code setup:** done — this build is happening inside Claude Code in the Claude desktop app.
- **Supabase account/project:** done. Project created (`average-height-points-travel`), Version 1 schema built and seeded — 6 tables (`programs`, `points_pots`, `cards`, `perks`, `perk_redemptions`, `alerts`), Row Level Security on every table, the 5 real reward programs seeded, and all 11 real cards pre-loaded with their owner/program/pot (balances and fees filled in live through the app now). SQL lives in `supabase/migrations/` in the project folder.
- **Version 1 (balances and cards): complete and tested.** Working file is `index.html` at the project root (not a mockup — the actual app, styled to match v7). Login is Supabase Auth (email + password, autofills via iPhone Keychain), with Jess and Abby each having their own account and full access to everything once signed in.
  - **Built and confirmed working:** login screen; points dashboard; full card management (add, edit, close-vs-delete, standalone accounts without a card); monthly balance update screen (grouped by program); annual fee tracking including the bill-due-date field; Perks tracker (Redeem soon / Redeemed / Upcoming, collapsible, auto-resets each new period, redemption history with backdating, the "captured toward annual fee" bar on each card, a real add/edit form for perk name and dollar value); Alerts (notification bell badge, dismissible alert cards linking to the affected program) — no in-app "add alert" form by design, since new alerts come from Claude's monthly web search per the refresh approach above, added directly via SQL.
- **Version 2 (trip planner): built and confirmed working.** Ported from the v7 mockup's editable-slot design into `index.html`.
  - **Data:** new `trips` and `trip_legs` Supabase tables, migration `supabase/migrations/0007_trips.sql` (already run). Seeded with the 3 real trips already being planned (Disney World, Japan, London), including Japan's real seats.aero flight price (312,000 points, checked Sept 8) carried over from the mockup. Transfer-partner data (which airlines/hotels each program reaches) is a static JS reference table (`PARTNERS` in `index.html`), same pattern as the existing `HUES`/`PROGRAM_ORDER` constants — not worth a database table since it rarely changes.
  - **Built and confirmed working:** trip list with per-leg (flights/hotel) coverage bars, pulling live from real points balances (all show 0% until balances are entered on the Points tab — expected, not a bug); trip detail screen with travelers, ways-to-pay breakdown (derived automatically from the programs picked for each leg), family notes, and link-outs to point.me/seats.aero; full edit form per trip (destination, subtitle, notes, and both legs' description/points-needed/paying-programs — always exactly 3 slots, no add/remove, so swapping a destination is just an edit); a real/estimated price toggle per leg (enter a dated real price from seats.aero/point.me, or clear it to fall back to the estimate).
  - **Decided against building:** a way to set points aside for one trip specifically, so two trips don't both count the same balance. Discussed and intentionally dropped — Jess plans around one trip at a time anyway, so each trip's bar is meant to answer "what could I cover if I went all-in on this trip," not "what's left after the other two." The Trips tab's disclaimer text was reworded to make that framing explicit instead of reading like an unfinished feature.
- **Splash screen: ported and confirmed working.** The v7 mockup's approved splash animation (4-frame vector silhouette fade-in with the wordmark, from Jess's reference art) had been designed but never carried into the real app during the Version 1 build — caught and fixed in this session. Plays for ~2.6s while checking for a saved login session in the background (whichever takes longer decides when it advances), then goes to sign-in or straight into the app; tapping the splash skips ahead immediately.
- **Desktop/wide-screen layout: built and confirmed working with real data and a real login.** The app always ran in any browser, but on a computer it previously just widened the same phone-style column up to 600px, with no real use of the extra space. Kicks in above 880px window width; below that, phone layout is completely untouched. Implemented as a CSS media query scoped to an `app-shell` class the app only adds once actually signed in, so the login/splash screens keep their original narrow centered look regardless of window size.
  - **Went through a few rounds before landing:** started from two quick concept options (`desktop_layout_concepts.html`, a throwaway demo file kept at the project root — not linked from the real app): a left sidebar, or a top nav bar with a grid. Built the sidebar hybrid first; Jess felt it looked too sparse/disconnected (dead space, seam between sidebar and header), so it was revised to a full-width header over the sidebar; then Jess reconsidered and preferred the top-nav option after all. Once that landed, Jess flagged that the header/nav spanning the full browser width while the content stayed capped narrower felt disjointed — fixed by making the whole app shell a bounded, bordered, rounded, shadowed card that floats on the page background (more like a wide phone screen than an edge-to-edge site), with the page itself scrolling instead of the old fixed-height internal-scroll phone frame. **Final layout: contained card (max 1100px wide, auto height), full-width header inside it, horizontal pill nav in its own row underneath, content in a centered 860px column, Trips tab in a side-by-side grid (3 across at typical widths).**
  - **Round after the contained-card fix, from a real screenshot with real data:** two more things fixed. (1) The nav pills were clustered centered in the middle of the wide card, reading as squished; now the nav row shares the same 860px max-width as the content column and spreads the 4 items across it, so it lines up with and spans the content the same way on every tab. (2) "Your points" and "Trips" titles sat flush at the top while "Your cards" and "Perks" sat about 10px lower — because those two build their own title markup directly while the other two go through the shared `hd()` title helper, which adds a small top spacer. Fixed by routing all four tab-root screens through `hd()`, so the spacing is guaranteed consistent by construction rather than patched per-pixel.
- **Banner logo:** briefly swapped to a new logo file Jess provided (`Assets/SVG/Banner logo_2.svg`, icon + "Points & Travel" only, no "Average Height" lettering), then Jess decided he preferred the original v7 logo after seeing it live — reverted back to the original (icon + "Average Height" wordmark + "Points & Travel"), pulled directly from the v7 mockup file rather than needing Jess to re-send it. Only `index.html` was ever touched either way — the v7 mockup and other historical files in `Prototypes/` were left alone throughout, since those are frozen design references.
- **"Add to calendar" for card dates: built and confirmed working end-to-end** (Jess tapped both buttons for real — they open Google Calendar correctly). This finishes a Version 1 item that was left as a placeholder toast. Both Jess and Abby are on Google Calendar, so it links directly to Google's "create event" screen (`calendar.google.com/calendar/render`) rather than downloading a universal `.ics` file — simpler for a two-person household on the same calendar provider, at the cost of not working for a different provider if that ever changes.
  - **Two separate buttons on each card's detail page:** "Add fee to calendar" (annual fee, recurs yearly, only shown if a fee amount and month are entered) and "Add due date to calendar" (monthly bill due day, recurs monthly, only shown if a due day is entered) — Jess asked to see both even though he's not sure he'll use the monthly one. The fee only has a month on file (no exact day), so that event lands on the 1st of the month as a reminder, not a promise the charge posts that exact day.
- **Cards tab polish, from real-data feedback:** section labels ("Fees in the next 3 months," "Open cards," etc.) bumped from a barely-there caption weight to real bold subheader styling — this is the shared `.sec` class, so the fix applies everywhere it's used, not just Cards. Added breathing room above the fee/due-date line in each card row. Reworded "Due on the 12th" to "Monthly statement balance due on the 12th," since standing next to the annual fee it read ambiguously (due date of what?).
- **Rough dollar values for points: built and confirmed working.** Points tab now shows an "≈$X" estimate under each program's balance, plus a household total near the top. Values are cents-per-point estimates (`POINT_VALUES` in `index.html`, same static-reference-table pattern as `PARTNERS`) — Chase 2.05¢, Amex 2.0¢, Capital One 1.8¢, Hilton 0.8¢, Marriott 0.8¢, checked against current published valuations (e.g. The Points Guy) via web search in September 2026. Framed clearly as a rough estimate, not accounting — disclaimer text notes actual value depends a lot on how you redeem. Deliberately left off the Trips tab, since a flat dollar figure there could undersell a good transfer. These rates will drift over time and are worth refreshing occasionally, similar cadence to the transfer-bonus check.
  - **Verified:** the date math (rolls to the correct next occurrence — this year or next, this month or next), and the generated Google Calendar URL is correctly formatted and encoded. **Not verified:** an actual tap creating a real event, since that needs a signed-in Google session, which is Jess's own account — not something to test from here. Worth Jess trying it once for real.
