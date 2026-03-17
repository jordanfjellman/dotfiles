---
name: blog-to-video-script
description: >
  Generate a two-column video script from an existing blog post. Use this skill
  when asked to "turn a blog post into a video," "generate a video script,"
  "adapt this post for Loom," "write a script from this blog," or "create a
  Loom script."
---

## Required Parameters

Before generating the script, confirm these with me. Do not assume defaults.

- **Blog post**: The full text of the blog post (or a link/file path I'll provide)
- **Video format**: talking head / screen recording / hybrid / animation
- **Platform**: YouTube (public) / internal (Loom) / LinkedIn
- **Target length**: in minutes
- **Audience**: who is watching (e.g., "Lifeway engineering team" or "developers interested in AI tooling")

## Format-Specific Rules

### YouTube (public)

Produce a fully scripted two-column layout:

| VISUAL | AUDIO |
|--------|-------|
| Visual direction for this line | What I say |

Structure the script as:

1. **Hook** (5-15 sec) -- a question, a surprising claim, or a specific problem the viewer has. Never start with "In this video, we'll discuss..." or any variation of that.
2. **Problem** (30-60 sec) -- make it specific and relatable.
3. **Solution** (bulk of video) -- broken into clear sections with verbal transitions between them.
4. **CTA** (15-30 sec) -- one clear action.

Additional rules:
- Write as spoken English, not written English. Use contractions. Use sentence fragments where they sound natural. If a sentence would feel awkward to say out loud, rewrite it.
- Never use "furthermore," "it is important to note," "as mentioned above," or other written-English constructs.
- Include delivery cues where they matter: `[pause]`, `[slower]`, `[lean in]`, `[energy up]`. Don't overuse them -- only at genuine shift points.
- Include bridge sentences at every format transition (e.g., talking head to screen recording): "Let me show you what I mean..." or "Here's what that looks like in practice."
- Cut 30-50% of the blog content. A 1,500-word blog is ~10 minutes at 150 wpm. Not every section of the blog needs to be in the video. Ask me which sections to prioritize if it's not obvious.
- Replace blog paragraphs that describe a UI or code workflow with a screen recording note. The screen recording replaces the words, not supplements them.
- Remove hyperlinks, "as mentioned above" references, and anything that only works in written form.

### Internal (Loom-style)

Produce a two-column layout, but looser than YouTube. The script should sound like I'm talking to a teammate, not performing.

| VISUAL | AUDIO |
|--------|-------|
| What's on screen | What I say |

Structure:
1. **Context** (10-20 sec) -- why I'm recording this. No hook. Just "a few people asked about X, so I'm recording a quick walkthrough."
2. **Walkthrough** (bulk of video) -- show the thing, explain as I go.
3. **Close** (10-15 sec) -- where to find more info, who to ask, or "ping me on Slack."

Additional rules:
- Jargon and internal terms are fine. Don't explain things the team already knows.
- Shorter than YouTube. If the YouTube version would be 5-7 minutes, the internal version is 3-5.
- No CTA. End with something functional: where to find the doc, where to ask questions.
- Tone is peer-to-peer. Sharing what's worked, not presenting as an authority.
- One take is fine. Don't optimize for editing.

### Hybrid Format (talking head + screen recording)

When the video mixes formats, map each blog section to a visual format before writing the script:

| Content type | Best visual format |
|-------------|-------------------|
| Opinion, context, "why" | Talking head |
| Code walkthrough | Screen recording |
| Architecture / system design | Animated diagram or diagram on screen |
| Comparison of options | Side-by-side graphics |
| Story / anecdote | Talking head |
| Demo / result | Screen recording |

Include this mapping as a table before the script so I can review and adjust it.

## Writing Tone

- Written from a place of humility. Confidence is fine, but arrogance is not.
- No purple prose, even when being humble.
- Don't use "---". It reads as LLM-generated.
- The script should sound like me explaining something to a peer. Not lecturing, not selling.
- Keep personality. If the blog post has a specific voice or phrasing that sounds natural, keep it in the script.

## What You Should Flag for Me

After generating the script, include a short section at the end called **"Needs your hand"** that flags:

- The hook (I should always rewrite or at least review the hook myself)
- Any place where you wrote a generic visual cue like "show relevant graphic" -- I need to make those specific
- Sections where you cut significant content from the blog -- so I can confirm those cuts
- Any spot where the tone drifted toward formal or generic

## What Not to Do

- Don't produce a final script with no review step. This is always a draft.
- Don't keep all the blog content. Cutting is the point.
- Don't write visual cues that require assets I don't have. If you're unsure whether I have a diagram or B-roll, describe what would go there and flag it.
- Don't summarize sections at the end of the script. If I've said it, the viewer heard it.
