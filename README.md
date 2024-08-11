# Medcheck

According to Public Health Reports, "seventy-five percent of Americans have trouble taking their medicine as directed. This lack of adherence is costing many people their good health and the health-care system billions of dollars"(Benjamin, 2012). Medcheck is a ruby on rails app that aims to help users keep track of important medication information. This includes, when to take the medications, what dose to take, how many you have left, and when you next need to pick up medications. I need to take medications every day, and I always forget important details. I wanted to make something for myself and everyone else that goes through the same struggles. There's an api endpoint for taking medications that is compatible with nfc tags.


References:
Benjamin RM. Medication adherence: helping patients take their medicines as directed. Public Health Rep. 2012 Jan-Feb;127(1):2-3. doi: 10.1177/003335491212700102. PMID: 22298918; PMCID: PMC3234383.


## Demo

https://med-check-7129cd9e51ba.herokuapp.com/


## Features

- Fullscreen mode
- Progressive Web App
- Mobile & Desktop View
- Google Oauth authentication
- postgreSQL database
- Users can create, edit, and delete medications & schedules
- Keeps track of how many of your medication is left
- Users can "take" their medications in the app to auto update the number of medications, and mark the medication schedule as taken
- Keeps track of your last pickup date, and estimate when to next pick up your medications
- Users can assign icons and colors to medications to better differentiate between them
- Calendar view to see medication taking history

## API Reference

#### Take Medication
Marks the closest schedule for a medication taken, and adjusts the amount left. Your history of taken and not taken medication schedules is in the history page. 
```http
  PATCH /users/${user_id}/${medication_name}/take_closest_schedule
```

#### Set Up NFC tag
- Requires: iphone, ios 13 and later, nfc tag
- Create a new automation in the shortcuts app on your phone
- choose nfc
- click scan and hold the nfc tag to the top of your phone
- Name the tag after the medication it controls
- Choose run immediately or run after confirmation
- optionally require the automation to notify you when it's run
- Click next
- Choose New Blank automation
- Add an action and choose Get Contents of URL
- click the toggle to see further settings for the action
- Choose PATCH for the method
- Grab your customized nfc link from the settings page of the app
- use the link and click done
- Now, by tapping your phone to the nfc tag, you can take your medications


## Installation

To install medcheck on your phone, go to the demo link below in safari, click the share button, and select Add to Home Screen. 

```bash
  https://med-check-da59da84c5e7.herokuapp.com/
```
