# Group Project - *Insert Dreams Here*

**Insert Dreams Here** is a dream sharing app. Don't forget your dreams after you wake up. Record them, and see what people around the world dreamt last night, too.


Time spent: **X** hours spent in total


## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of their account
- [x] The current signed in user is persisted across app restarts
- [x] User can write a title, compose a dream, and post the dream.
- [x] User can select a location tag using Google Maps API, and post the dream
- [x] User can view the last 20 dreams posted on a Google Map as pins
- [x] User can tap on a pin on the map and see dream
- [x] User can tap on a dream to read it fully


The following **stretch** features are implemented:
- [x] User sees app logo on launch screen
- [x] User sees alerts for login exceptions, i.e. "account already exists", "wrong credentials", etc.
- [ ] User sees an activity indicator while waiting for authentication
- [x] User sees an activity indicator while waiting for the map of dreams to load
- [ ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [ ] Add an "Adorable Avatar" for each user by requesting an avatar from the [Adorable Avatars API](https://github.com/adorableio/avatars-api)
- [x] User can use a tab bar to switch between world map and user profile
- [x] User can see a tableview of their own dreams (a title, date, and preview of dream)
- [x] User can tap on a table cell to view their full dream, as well as edit and update their post
- [x] Allow the logged in user to add a profile photo
- [x] Display the profile photo with each post
- [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] User can comment on a post and see all comments for each post in the post details screen
- [ ] User can like a post and see number of likes for each post in the post details screen
- [ ] User can rate their post by movie standards so viewers can restrict their content
- [ ] Filter visualization by time posted
- [ ] User tag their own dreams by emotions: Positive, Neutral, Negative

- [ ]  === Nice to haves: ===
Record by voice
Record by voice, transposes into text (Using speech recognition API such as https://cloud.google.com/speech/)
Add a drawing or visual
Personal analytics on the dream content (word sentiment or dream/nightmare evaluation?)
Someone on the other side of the world dreamt something similar to you. Want to read it?
Ask artists to draw or animate people’s dreams

## Video Walkthrough

Here's a walkthrough of implemented user stories:

First, setting up the Parse server to enable user to sign up, login, logout, with input validation and user persistence if app is closed.
<img src='https://image.ibb.co/kjqw47/milestone1.gif' title='Video Walkthrough' width='500px' alt='Video Walkthrough' />

Then, posting a dream to the map.
<img src='https://i.imgur.com/CbAQqxU.gif' title='Video Walkthrough' width='500px' alt='Video Walkthrough' />




GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Trianglify.io](https://trianglify.io/) - wallpaper generator
- <div>Icons made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
- <div>Icons made by <a href="https://www.flaticon.com/authors/spovv" title="spovv">spovv</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>

## Notes

Describe any challenges encountered while building the app.

## License

    Copyright [2018] [Mavey Ma, Miguel Fletes, Yang Jing]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
