# Cinemadora
Cinemadora is an easy to use movie information app for iOS. It uses the TMDB movie database REST API to get information about popular movies and TV shows. The purpose of this project is to show how to leverage the latest development tools &amp; techniques to successfully create a modern iOS app.

<video src="https://github.com/user-attachments/assets/4e114189-2df2-47e3-a155-dc6ac2cd8d13" width="480" controls></video>

The code showcases how to use the following techniques &amp; technologies:
* Swift UI
* Swift actors, async and await to implement data race-free concurrency
* URLSession to concurrently download images
* How to use a xcconfig file to isolate API keys and Team IDs and how to keep them away from the git repository
* View models and repositories to implement a single source of truth
* How to implement a LRU image download cache

## Getting Started

Check out the project to your disk. Then create a text file with the name `Local.xcconfig` and place it inside the `Cinemadora` project folder (put it next to the `Info.plist` file). Add the following text to this file:

```
API_KEY = <your TBMD API key here>
DEVELOPMENT_TEAM = <your Apple development team ID here>
```

Replace the angle brackets above with your API key and Apple development team ID, respectively. Do not add quotes around your API key and team IDs. 

The `Local.xcconfig` file is listed in the project's `.gitignore` file. This ensures that your API key and development team ID won't get committed to the GIT repository. It is possible to use the app without a API key. However some future features may not work in this case.

Now you're ready to build the app in Xcode and run it.

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

## Contact

Dietmar Planitzer - [@linkedin](https://www.linkedin.com/in/dplanitzer)

Project link: [https://github.com/dplanitzer/Cinemadora](https://github.com/dplanitzer/Cinemadora)
