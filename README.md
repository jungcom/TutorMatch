# *UTutor*

**UTutor** is a tutor matching app using a Firebase backend.

## User Stories

The following functionalities are complete:

- [O] User can compose and send chat messages to tutors!!!! (Most difficult)
- [O] User can sign up and sign in to the login screen and sees alerts for login exceptions, i.e. "account already exists", "wrong credentials"
- [O] User can view a list of open classes/sessions in chronological order
- [O] User can post a class/session
- [O] User has a profile page that shows the list of classes they are taking (+2pt)
- [O] Persist Logged in User (+1pt)

The following functionalities should be implemented:

- [ ] More user friendly UI/UX (Most important)
- [ ] Different constraints for different IPhones
- [ ] Debug messaging errors

## Video Walkthrough/ScreenShots

Here's a walkthrough of the app:

<img src='https://i.imgur.com/Rd8bzVw.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

<img src='https://i.imgur.com/xvHBBIw.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.

The hardest part of building this app was the chat messaging implementation. Tracking all the user messages and saving it to the database was quite challenging, and it was even harder when retrieving that information based on the user or sender.

## License

    Copyright [2018] [Anthony Lee]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
