Comparison of different UI elements for interaction with photo galleries
--------

**Task description:**

The user needs to browse a series of multiple images in a high resolution on a mobile device.

**Action comparison:**

1. **Tap**:

user taps on a left side of a screen to see previous photo, or right side for next.

2. **Swipe**:

user swipes right to see previous photo, left to see the next one.

- *As a subset, we could measure optimal drag-position for navigation (15% off swipe, 30%, 50% swipe or more?)
Measure intentional and unintentional gestures (ie. when threshold is set too low (~5% swipe in left/right dimension), it can happen that user swiped unintentionall.y*

- *As a sub-test, we could also test two different galleries.
One with continuous photographs, allowing endless navigation in each direction versus photo gallery that stops at first/last photo.*

**Target group:**

The target group are smartphone owners (Android 3.0+ or iPhone iOS6+), reached out via **Facebook Ad Publishing** platform or **Google Ads**.

**The ad:**

We show targeted users an ad, inviting them with the tagline: “See the beautiful life of exotic animals”; once tapped, the gallery opens, which 
consist of seven (7) photos chosen from the National Geographics awarded photographs (TBA).

**Delivery:**

Since we are only comparing the performance of tap vs. swipe event, the first photo opens immediately, resized to fit browser size, letting users only to navigate left/right to see other photos from the gallery. The UI does not show wether swipe, click or any other interaction is required to navigate through the gallery. It is up to the user to figure that out. We also measure the first interaction user has with the gallery, which might serve as an information about users' prefered way for interaction.
The event (tap or swipe) is evenly distributed, as with A/B testing.

**Support:**

- iOS6+
- Android 3.0+

**Measurements:**
   - On-site:
We tend to collect as many useful data as possible, measuring (per user):
      - time spent on gallery,
      - time spent for each photo, 
      - nr. of photos views,
      - each gesture (tap, click, swipe, pinch, etc.) and their timestamp

   - Crowd-sourced direct question (on polar.com, jelly.com, TBA): "What action for mobile photo-gallery navigation? Tap or swipe? (TBA)"


**Hypothesis:**
   - Determine what event performs best; distinguish between desired events and undesired/unnecessary actions - the 
   - Try to find out whether there are any correspondence between action (swipe/tap) and time spent on gallery and number of photos watched.
   - Determine which action (swipe/tap) is more self-evident.
   - Compare crowd-sourced opinion with actual results.
   - Overall determine whether it is possible to chose which action works best, solely from event-logs?

**Additional:**

If the majority of intentional clicks are on the left/right side of a screen, why not make that clickable area wider, let’s say - making 70 %, instead of 50 %?

**TODO:**

Hybrid? What if tap triggers some sort of ’shake’ into the left/right side  - as an indicator that you need to swipe?
That would prevent accidental taps and also indicate the proper gesture in case of intentional taps.
